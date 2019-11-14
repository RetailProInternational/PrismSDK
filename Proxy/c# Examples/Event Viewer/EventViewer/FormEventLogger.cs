using log4net;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace EventLoggerNS
{    
    public partial class FrmMain : Form
    {
        private CCustomizationInterface ProxyLink;
        private List<string>            TokenData;
        private List<CCustMessage>      Messages = new List<CCustMessage>(); //>> Need this?
        //private List<string>            GlobalConfigData;
        //private List<string>            WSConfigData;
        private string GlobalConfigData;
        private string    WSConfigData;
        private bool Logging;

        private readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        //Callbacks
        private void ProcessConfigData()
        {
            GlobalConfigData = ProxyLink.GlobalConfigurationData;
            WSConfigData     = ProxyLink.ProxyConfigurationData;
            BtnGlobalConfigData.Enabled = true;
            BtnWSConfigData.Enabled = true;
        }
        private void ProcessEvent(
                string ADirection,
            ref int AStatusCode,
                string AHTTPVerb,
                string AResourceName,
                string AURL,
            ref string AHeaders,
            ref string AParams,
            ref string APayload,
                string AContentType,
            ref bool ACanContinue
          )
        {
            if (Logging)
            {
                CCustMessage NewMessage = new CCustMessage(ADirection,AURL,AContentType,AHTTPVerb,AResourceName,AParams,APayload);
                this.BeginInvoke((MethodInvoker)delegate ()
                {
                    Messages.Add(NewMessage);
                    eventViewerGrid.Rows.Add(ADirection,AHTTPVerb,AResourceName);
                });
                PopulateDetails(NewMessage);
            }
        }

        private void ProcessShutdown()
        {
            MessageBox.Show("Proxy is closing. Exiting Event Logger.");
            Application.Exit();
            log.Info("--------------Event Viewer logging stopped----------------");
            ProxyLink.StopListener();
            Close();
            /*
            this.BeginInvoke((MethodInvoker) delegate ()
            {
                Close();
            });
            */
        }

        private void ProcessClientToken()
        {
            TokenData.Add("Server=" + ProxyLink.PrismServer);
            TokenData.Add("Port="   + ProxyLink.PrismServerPort.ToString());
            TokenData.Add("Token="  + ProxyLink.UserToken);
            this.BeginInvoke((MethodInvoker) delegate ()
            {
                BtnToken.Enabled = true;
            }); 
        }


        public FrmMain()
        {
            log4net.Config.XmlConfigurator.Configure();
            InitializeComponent();

            Messages = new List<CCustMessage>();
            //var GlobalConfigData = new List<string>();
            //var WSConfigData = new List<string>();
            TokenData = new List<string>();
            ProxyLink = new CCustomizationInterface("127.0.0.1", 32000);
            SetUp();
            InitializeGrid();
            BtnToken.Enabled = false;
            PanelDetails.Visible = false;
            log.Info("--------------Event Viewer logging started----------------");
        }

        public void SetUp()
        {
            ProxyLink.Name            = "EventLogger";
            ProxyLink.Version         = "1.0.0";
            ProxyLink.DeveloperID     = "000";
            ProxyLink.CustomizationID = "000";

            ProxyLink.OnConfigDataSet         = ProcessConfigData;
            ProxyLink.OnTokenSet              = ProcessClientToken;
            ProxyLink.OnShutdownNotification  = ProcessShutdown;
            ProxyLink.OnEvent                 = ProcessEvent;

            ProxyLink.Subscriptions.AddSubscription("EV_DocRequest",              Direction.dFromClient, true, true, true, true, "document",         "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_DocResponse",             Direction.dToClient,   true, true, true, true, "document",         "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_ItemsRequest",            Direction.dFromClient, true, true, true, true, "document/item",    "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_ItemsResponse",           Direction.dToClient,   true, true, true, true, "document/item",    "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_TenderRequest",           Direction.dFromClient, true, true, true, true, "document/tender",  "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_TenderResponse",          Direction.dToClient,   true, true, true, true, "document/tender",  "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerRequest",         Direction.dFromClient, true, true, true, true, "customer",         "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerResponse",        Direction.dToClient,   true, true, true, true, "customer",         "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerEmailRequest",    Direction.dFromClient, true, true, true, true, "customer/email",   "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerEmailResponse",   Direction.dToClient,   true, true, true, true, "customer/email",   "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerAddressRequest",  Direction.dFromClient, true, true, true, true, "customer/address", "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerAddressResponse", Direction.dToClient,   true, true, true, true, "customer/address", "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerPhoneRequest",    Direction.dFromClient, true, true, true, true, "customer/phone",   "mpRR", true, false);
            ProxyLink.Subscriptions.AddSubscription("EV_CustomerPhoneResponse",   Direction.dToClient,   true, true, true, true, "customer/phone",   "mpRR", true, false);

            ProxyLink.StartListener();
        }
    
        public void InitializeGrid() { }
        public void PopulateDetails(CCustMessage Msg) {
            this.BeginInvoke((MethodInvoker)delegate ()
            {
                LabelDirectionData.Text = Msg.ApiDirection;
                URIData.Text = Msg.URI;
                ContentData.Text = Msg.ContentType;
                LabelVerbData.Text = Msg.Verb;
                LabelResourceData.Text = Msg.Resource;
                RtbParams.Text = Msg.QueryString;
                RtbPayload.Text = Msg.Payload;                
                if (PanelDetails.Visible == false)
                {
                    PanelDetails.Visible = true;
                }
            });
        }

        private void BtnToken_Click(object sender, EventArgs e)
        {
            MessageBox.Show(string.Join("\r\n", TokenData.ToArray()));
        }

        private void BtnStart_Click(object sender, EventArgs e)
        {
            Logging = true;
            BtnStop.Enabled = true;
            BtnStart.Enabled = false;
        }

        private void BtnStop_Click(object sender, EventArgs e)
        {
            Logging = false;
            BtnStop.Enabled = false;
            BtnStart.Enabled = true;
        }

        private void EventViewerGrid_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            if (Messages.Count > 0 && e.RowIndex < Messages.Count)
            {
                PopulateDetails(Messages[e.RowIndex]);
            }
        }
    }

    public class CCustMessage
    {
        public string ApiDirection;
        public string URI;
        public string ContentType;
        public string Verb;
        public string Resource;
        public string QueryString;
        public string Payload;
        public CCustMessage(string Direction, string URI, string ContentType, string Verb, string Resource, string QueryString, string Payload)
        {
            this.ApiDirection = Direction;
            this.URI = URI;
            this.ContentType = ContentType;
            this.Verb = Verb;
            this.Resource = Resource;
            this.QueryString = QueryString;
            this.Payload = Payload;
        }
    }

}
