using System;
using System.Threading;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using NetMQ;
using NetMQ.Sockets;

public class EConfiguration: Exception
{
    public EConfiguration(string Message) { }
};


public class CZMQClient
{
    private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public CZMQClient(CCustomizationInterface AOwner)
	{
        Responder = new ResponseSocket();
        owner = AOwner;
        clientThread = new Thread(Execute);
    }

    public CCustomizationInterface owner { get; set; }
    public string Port     { get; set; }
    public string Address  { get; set; }
    public string IOBuffer { get; set; }
    public ResponseSocket Responder { get; set; }
    public Thread clientThread { get; set; }    

    public void Execute()
    {
        string receivedData;
        //var timeout = new TimeSpan(60000);
        var timeout = new TimeSpan(600000); //>> DEBUG - longer timeout

        Responder.Bind("tcp://" + Address + ":" + Port);
        while (true) //>> while not terminated...
        {
            if (Responder.TryReceiveFrameString(timeout, Encoding.Unicode, out receivedData))
            {
                IOBuffer = receivedData;
                log.Info(receivedData);
                if (IOBuffer != "")
                {
                    lock (owner)
                    { 
                        owner.ProcessData();
                        Responder.SendFrame(System.Text.Encoding.Unicode.GetBytes(IOBuffer), false);
                    }
                }
            }
        }

        //Responder.unbind("tcp://" + Address + ":" + Port);  

    }
}

public enum Direction { dFromClient, dToClient };

public class CSubscription
{
    // Names used for logging.
    public string Name { get; set; }

    // This is the direction of the traffic you are interested in.
    public Direction Direction { get; set; }

    // This Boolean flag indicates if you are interested in GET operations.
    public bool Get { get; set; }

    // This Boolean flag indicates if you are interested in PUT operations.
    public bool Put { get; set; }

    // This Boolean flag indicates if you are interested in POST operations.
    public bool Post { get; set; }

    // This Boolean flag indicates if you are interested in DELETE operations.
    public bool Delete { get; set; }

    // This is the resource you are interested in. sub resources are separated with a / (forward slash or stroke) e.g. customer/address
    public string Resource { get; set; }

    // The 0MQ message pattern to use for communication. Currently only “mpRR” is supported.
    public string Pattern { get; set; }

    // This Boolean flag indicates that you want the payload passed in with the notification.
    public bool Payload { get; set; }

    // Should always be FALSE. See Documentation.
    public bool Redirected { get; set; }
}


public class CSubscriptionList : List<CSubscription>
{
    public void AddSubscription(
      string AName,
      Direction ADirection,
      Boolean AGet,
      Boolean APut,
      Boolean APost,
      Boolean ADelete,
      string AResource,
      string APattern,
      Boolean APayload,
      Boolean ARedirected
    )
    {
        CSubscription subscription = new CSubscription();
        subscription.Name        = AName;
        subscription.Direction   = ADirection;
        subscription.Get         = AGet;
        subscription.Put         = APut;
        subscription.Post        = APost;
        subscription.Delete      = ADelete;
        subscription.Resource    = AResource;
        subscription.Pattern     = APattern;
        subscription.Payload     = APayload;
        subscription.Redirected  = ARedirected;
        Add(subscription);
    }
}

public delegate void NotifyEvent();

public delegate void ProxyEventNotification
(
      string Direction,
  ref int    StatusCode,
      string HTTPVerb,
      string ResourceName,
      string URL,
  ref string Headers,
  ref string Params,
  ref string Payload,
      string ContentType,
  ref bool   CanContinue
);

public abstract class CAbstractCustomizationInterface
{
    const string cxGetInfo          = "GetInfo";
    const string cxSetConfig        = "SetConfig";
    const string cxGetSubscriptions = "GetSubscriptions";
    const string cxSetUserToken     = "SetUserToken";
    const string cxShutdown         = "Shutdown";

    const string cxACK = "<ACK/>";
    const string cxNAQ = "<NAQ/>";

    private string proxySID;

    //Message Handlers
    protected virtual string HandleGetInfo(string Data)
    {
        string result =
               "<CONTROL>" +
               "  <NAME>"            + Name            + "</NAME>" +
               "  <VERSION>"         + Version         + "</VERSION>" +
               "  <DEVELOPERID>"     + DeveloperID     + "</DEVELOPERID>" +
               "  <CUSTOMIZATIONID>" + CustomizationID + "</CUSTOMIZATIONID>" +
               "</CONTROL>";
        var XDoc = new XmlDocument();
        XDoc.LoadXml(Data);
        
        XmlNode root = XDoc.FirstChild;
        foreach (XmlNode nextNode in root.ChildNodes)
        {
            if (nextNode.Name == "PROXYSID")
            {
                proxySID = nextNode.InnerText;
                break;
            }
        }
        
        OnGetInfo?.Invoke();
        return result;
    }

    protected virtual string HandleGetSubscriptions()
    {
        string result;
        if (Subscriptions.Count == 0)
            result = "<SUBSCRIPTIONS/>";
        else
        {
            string details = "";
            foreach (CSubscription sub in Subscriptions)
            {
                details = details +                                            
                    "<SUBSCRIPTION>" +
                        "<NAME>"       + sub.Name                  + "</NAME>" +
                        "<DIRECTION>"  + sub.Direction.ToString()  + "</DIRECTION>" +
                        "<HTTPGET>"    + sub.Get.ToString()        + "</HTTPGET>" +
                        "<HTTPPUT>"    + sub.Put.ToString()        + "</HTTPPUT>" +
                        "<HTTPPOST>"   + sub.Post.ToString()       + "</HTTPPOST>" +
                        "<HTTPDELETE>" + sub.Delete.ToString()     + "</HTTPDELETE>" +
                        "<RESOURCE>"   + sub.Resource              + "</RESOURCE>" +
                        "<PATTERN>"    + sub.Pattern               + "</PATTERN>" +
                        "<PAYLOAD>"    + sub.Payload.ToString()    + "</PAYLOAD>" +
                        "<REDIRECTED>" + sub.Redirected.ToString() + "</REDIRECTED>" +
                    "</SUBSCRIPTION>";
                        
            }
            result = "<SUBSCRIPTIONS>" + details + "</SUBSCRIPTIONS>";
        }

        return result;
    }
    protected virtual string HandleSetConfig(string Data)
    {
        string result = cxACK;
        var XDoc = new XmlDocument();
        XDoc.LoadXml(Data);

        XmlNode root = XDoc.FirstChild;
        foreach (XmlNode nextNode in root.ChildNodes)
        {
            if      (nextNode.Name == "BASECONFIG")
                GlobalConfigurationData = nextNode.InnerText;
            else if (nextNode.Name == "PROXYCONFIG")
                ProxyConfigurationData = nextNode.InnerText;
        }

        OnConfigDataSet?.Invoke();

        return result;
    }
    protected virtual string HandleSetUserToken(string Data)
    {
        string result = cxACK;
        var XDoc = new XmlDocument();
        XDoc.LoadXml(Data);

        XmlNode root = XDoc.FirstChild;
        foreach (XmlNode nextNode in root.ChildNodes)
        {
            if      (nextNode.Name == "TOKEN")
                UserToken = nextNode.InnerText;
            else if (nextNode.Name == "PRISMSERVER")
                PrismServer = nextNode.InnerText;
            else if (nextNode.Name == "PRISMSERVERPORT")
                PrismServerPort = int.Parse(nextNode.InnerText);
            else if (nextNode.Name == "WORKSTATION")
                WorkstationName = nextNode.InnerText;
        }

        OnTokenSet?.Invoke();

        return result;
    }
    protected virtual string HandleEvent(string Data)
    {

          // Decode Message
        bool CanContinue = true;
        var XDoc = new XmlDocument();
        XDoc.LoadXml(Data);

        string Direction    = "";
        int    StatusCode   = 0;
        string HTTPVerb     = "";
        string ResourceName = "";
        string URI          = "";
        string Headers      = "";
        string Params       = "";
        string Payload      = "";
        string ContentType  = "";

        XmlNode root = XDoc.FirstChild;
        foreach (XmlNode nextNode in root.ChildNodes)
        {
            if (nextNode.Name == "DIRECTION")
                Direction = nextNode.InnerText;
            else if (nextNode.Name == "STATUSCODE")
                StatusCode = int.Parse(nextNode.InnerText);
            else if (nextNode.Name == "HTTPVERB")
                HTTPVerb = nextNode.InnerText;
            else if (nextNode.Name == "RESOURCENAME")
                ResourceName = nextNode.InnerText;
            else if (nextNode.Name == "URI")
                URI = nextNode.InnerText;
            else if (nextNode.Name == "HEADERS")
                Headers = nextNode.InnerText;
            else if (nextNode.Name == "PARAMS")
                Params = nextNode.InnerText;
            else if (nextNode.Name == "PAYLOAD")
                Payload = DecodePayload(nextNode.InnerText);
            else if (nextNode.Name == "CONTENTTYPE")
                ContentType = nextNode.InnerText;
        }

        OnEvent?.Invoke(Direction, ref StatusCode, HTTPVerb, ResourceName, URI, 
                        ref Headers, ref Params, ref Payload, ContentType, ref CanContinue); 

        //Package Reply
        string result =
           "<EVENT>" +
             "<HEADERS>"    + Headers                + "</HEADERS>" +
             "<PARAMS>"     + Params                 + "</PARAMS>" +
             "<PAYLOAD>"    + EncodePayload(Payload) + "</PAYLOAD>" +
             "<CONTINUE>"   + CanContinue.ToString() + "</CONTINUE>" +
             "<STATUSCODE>" + StatusCode.ToString()  + "</STATUSCODE>" +
           "</EVENT>";

        return result;
    }
    protected virtual string HandleShutdown()
    {

        string result = cxACK;
        OnShutdownNotification?.Invoke();

        return result;
    }
    //Message Router
    protected virtual string RouteMessage(string Data)
    {
        string result;
        var XDoc = new XmlDocument();
        XDoc.LoadXml(Data);
        XmlNode root = XDoc.FirstChild;

        if (root.Name == "EVENT")
            result = HandleEvent(Data);
        else
        {
            XmlNode XCommandNode = null;
            foreach (XmlNode nextNode in root.ChildNodes)
            {
                if (nextNode.Name == "COMMAND")
                {
                    XCommandNode = nextNode;
                    break;
                }
            }
            if (XCommandNode != null)
            {
                if      (XCommandNode.InnerText == cxGetInfo)
                    result = HandleGetInfo(Data);
                else if (XCommandNode.InnerText == cxSetConfig)
                    result = HandleSetConfig(Data);
                else if (XCommandNode.InnerText == cxGetSubscriptions)
                    result = HandleGetSubscriptions();
                else if (XCommandNode.InnerText == cxSetUserToken)
                    result = HandleSetUserToken(Data);
                else if (XCommandNode.InnerText == cxShutdown)
                    result = HandleShutdown();
                else
                    result = cxNAQ;
            }
            else
                result = cxNAQ;
        }
        return result;
    }

    protected string EncodePayload(string source)
    {
        string result = source.Trim();
        if (result != "")
        {
            result = result.Replace("&", "&amp;");
            result = result.Replace("<", "&lt;");
            result = result.Replace(">", "&gt;");
            result = result.Replace("'", "&apos;");
            result = result.Replace("\"", "&quot;");
        }
        return result;
    }

    protected string DecodePayload(string source)
    {
        string result = source.Trim();
        if (result != "")
        {
            result = result.Replace("&amp;", "&");
            result = result.Replace("&lt;", "<");
            result = result.Replace("&gt;", ">");
            result = result.Replace("&apos;", "'");
            result = result.Replace("&quot;", "\"");
        }
        return result;
    }

    public CAbstractCustomizationInterface()
    {
        Subscriptions = new CSubscriptionList();
        Listening = false;
    }

    public abstract void StartListener();
    public abstract void StopListener();
    public bool Listening { get; set; }

    public abstract void ProcessData();

    public string GlobalConfigurationData { get; set; }
    public string ProxyConfigurationData { get; set; }

    public string ProxySID { get; }
    public string UserToken { get; set; }
    public string PrismServer { get; set; }
    public int PrismServerPort { get; set; }
    public string WorkstationName { get; set; }

    public NotifyEvent OnGetInfo { get; set; }
    public ProxyEventNotification OnEvent { get; set; }
    public NotifyEvent OnConfigDataSet { get; set; }
    public NotifyEvent OnShutdownNotification { get; set; }
    public NotifyEvent OnTokenSet { get; set; }

    public string Name { get; set; }
    public string Version { get; set; }
    public string DeveloperID { get; set; }
    public string CustomizationID { get; set; }

    public CSubscriptionList Subscriptions { get; set; }
  };


  public class CCustomizationInterface: CAbstractCustomizationInterface
  { 
    protected CZMQClient Client;
    private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public CCustomizationInterface(string AAddress, int APort)
    {
        Client = new CZMQClient(this); //>> Do we need 'this' param?
        Client.Address = AAddress;
        Client.Port = APort.ToString();
    }
    public override void ProcessData()
    {
      string ReqBuffer = Client.IOBuffer;
      string RespBuffer = RouteMessage(ReqBuffer);
      Client.IOBuffer = RespBuffer;
    }
    public override void StartListener()
    {
        if ((Client.Address != "") && (Client.Port != ""))
        {
            Client.clientThread.Start();
            Listening = true;
        }
        else
          throw new EConfiguration("There is no Address or Port information for the listener.");
    }
    public override void StopListener()
    {
        log.Info("About to kill the thread");
        try
        {
            Client.clientThread.Abort();
        }
        catch(ThreadAbortException ex)
        {
            log.Info("Killed the thread");
            log.Info(ex);
        }
    }
  }

