unit uCustomizationInterface;

(*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*)

interface

Uses
    System.SysUtils
  , System.Classes
  , System.Generics.Collections

  , zmqapi          // This can be downloaded from https://github.com/bvarga/delphizmq
  ;

type
  EConfiguration = class(Exception);

  TCustomizationInterface = class;

  TZMQClientThread = class(TThread)
    Private
      FOwner: TCustomizationInterface;

      FPort: String;
      FAddress: String;

      FIOBuffer: String;

      FContext : TZMQContext;
      FResponder : TZMQSocket;
    Protected
    Public
      Constructor Create(CreateSuspended:Boolean; AOwner: TCustomizationInterface); overload; virtual;
      Destructor Destroy; override;

      Procedure Execute(); override;

      Property Address: String read FAddress write FAddress;
      Property Port: String read FPort write FPort;

      Property IOBuffer: String read FIOBuffer write FIOBuffer;
    end;

  EDirection = ( dFromClient , dToClient );

  TSubscription = class(TObject)
    Private
      FName: string;
      FDirection: EDirection;
      FPattern: string;
      FResource: String;
      FPost: Boolean;
      FPut: Boolean;
      FRedirected: Boolean;
      FGet: Boolean;
      FDelete: Boolean;
      FPayload: Boolean;
    Public
      // Names used for logging.
      Property Name       : string read FName write FName;

      // This is the direction of the traffic you are interested in.
      Property Direction  : EDirection read FDirection write FDirection;

      // This Boolean flag indicates if you are interested in GET operations.
      Property GET        : Boolean read FGet write FGet;

      // This Boolean flag indicates if you are interested in PUT operations.
      Property PUT        : Boolean read FPut write FPut;

      // This Boolean flag indicates if you are interested in POST operations.
      Property POST       : Boolean read FPost write FPost;

      // This Boolean flag indicates if you are interested in DELETE operations.
      Property DELETE     : Boolean read FDelete write FDelete;

      // This is the resource you are interested in. sub resources are separated with a / (forward slash or stroke) e.g. customer/address
      Property Resource   : String read FResource write FResource;

      // The 0MQ message pattern to use for communication. Currently only “mpRR” is supported.
      Property Pattern    : string read FPattern write FPattern;

      // This Boolean flag indicates that you want the payload passed in with the notification.
      Property Payload    : Boolean read FPayload write FPayload;

      // Should always be FALSE. See Documentation.
      Property Redirected : Boolean read FRedirected write FRedirected;
  end;

  TSubscriptionList = class(TObjectList<TSubscription>)
    public
      Procedure AddSubscription(
        AName        : string;
        ADirection   : EDirection;
        AGet         : Boolean;
        APut         : Boolean;
        APost        : Boolean;
        ADelete      : Boolean;
        AResource    : string;
        APattern     : string;
        APayload     : Boolean;
        ARedirected  : Boolean
      );
  end;

  TProxyEventNotification = procedure (
        Direction: string;
        var StatusCode: Integer;
        HTTPVerb: string;
        ResourceName: string;
        URL: string;
        var Headers: string;
        var Params: string;
        var Payload: string;
        ContentType: string;
        Var CanContinue: Boolean
      ) of object;

  TAbstractCustomizationInterface = class(TObject)
    private
      FListening: Boolean;
      //From Server
      FProxyConfigurationData: string;
      FGlobalConfigurationData: String;
      FUserToken: String;
      //To Server
      FVersion: String;
      FName: String;
      FCustomizationID: String;
      FDeveloperID: String;
      FSubscriptions: TSubscriptionList;
      //Events
      FOnEvent: TProxyEventNotification;
      FOnConfigDataSet: TNotifyEvent;
      FOnShutdownNotification: TNotifyEvent;
      FOnTokenSet: TNotifyEvent;
      FPrismServer: string;
      FPrismServerPort: Integer;
      FOnGetInfo: TNotifyEvent;
      FProxySID: string;
    Protected
      //Message Handlers
      Function HandleGetInfo(Data:string):string;virtual;
      Function HandleGetSubscriptions:string;virtual;
      Function HandleSetConfig(Data:string):string;virtual;
      Function HandleSetUserToken(Data:string):string;virtual;
      Function HandleEvent(Data: string):string;virtual;
      function HandleShutdown:string;virtual;
      //Message Router
      Function RouteMessage(Data: string):string;virtual;

      function DecodePayload(Source: string):string;
      function EncodePayload(Source: string):string;
    public
      constructor Create(AAddress: string; APort: Integer);
      destructor Destroy; override;

      Procedure StartListener; virtual; abstract;
      procedure StopListener; virtual; abstract;
      Property Listening: Boolean read FListening;

      Procedure ProcessData; virtual; abstract;

      Property GlobalConfigurationData: String read FGlobalConfigurationData;
      Property ProxyConfigurationData: string read FProxyConfigurationData;

      property ProxySID: string read FProxySID;
      Property UserToken: String read FUserToken;
      Property PrismServer: string read FPrismServer;
      Property PrismServerPort: Integer read FPrismServerPort;

      Property OnGetInfo: TNotifyEvent read FOnGetInfo write FOnGetInfo;
      Property OnEvent: TProxyEventNotification read FOnEvent write FOnEvent;
      Property OnConfigDataSet: TNotifyEvent read FOnConfigDataSet write FOnConfigDataSet;
      Property OnShutdownNotification: TNotifyEvent read FOnShutdownNotification write FOnShutdownNotification;
      Property OnTokenSet: TNotifyEvent read FOnTokenSet write FOnTokenSet;

      Property Name: String read FName write FName;
      Property Version: String read FVersion write FVersion;
      Property DeveloperID: String read FDeveloperID write FDeveloperID;
      Property CustomizationID: String read FCustomizationID write FCustomizationID;

      Property Subscriptions: TSubscriptionList read FSubscriptions write FSubscriptions;
  end;

  TCustomizationInterface = class(TAbstractCustomizationInterface)
    protected
      Client: TZMQClientThread;
      procedure ProcessData; override;
    public
      constructor Create(AAddress: string; APort: Integer);
      destructor Destroy; override;
      procedure StartListener; override;
      procedure StopListener; override;
  end;

  TUnsynchedCustomizationInterface = class(TAbstractCustomizationInterface)
    protected
      FPort: String;
      FAddress: String;
      FIOBuffer: String;
      FShutdown: Boolean;
      FContext : TZMQContext;
      FResponder : TZMQSocket;
      procedure ProcessData; override;
    public
      constructor Create(AAddress: string; APort: Integer);
      destructor Destroy; override;
      procedure StartListener; override;
      procedure StopListener; override;

      property Address: String read FAddress write FAddress;
      property Port: String read FPort write FPort;

//      Property IOBuffer: String read FIOBuffer write FIOBuffer;
  end;

Const
  cxGetInfo           = 'GetInfo';
  cxSetConfig         = 'SetConfig';
  cxGetSubscriptions  = 'GetSubscriptions';
  cxSetUserToken      = 'SetUserToken';
  cxShutdown          = 'Shutdown';

  cxACK               = '<ACK/>';
  cxNAQ               = '<NAQ/>';

implementation

Uses
    System.TypInfo
  , NativeXML       // This can be downloaded from https://code.google.com/p/simdesign/
  , IdURI           // Part of the Indy code library provided with Delphi
  ;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TZMQClientThread
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constructor TZMQClientThread.Create(CreateSuspended:Boolean; AOwner: TCustomizationInterface);
begin
  Create(CreateSuspended);
  FOwner := AOwner;
  Self.FreeOnTerminate := False;
  FContext := TZMQContext.create;
  FResponder := FContext.Socket( stRep );
end;

destructor TZMQClientThread.Destroy;
begin
  FResponder.Free;
  FContext.Free;
  inherited;
end;

procedure TZMQClientThread.Execute;
var
  AStream: TStringStream;
begin
  FResponder.bind( 'tcp://'+FAddress+':'+FPort );
  while not Terminated do
    begin
      AStream := TStringStream.Create('',TEncoding.Unicode);
      Try
        FResponder.recv( AStream );
        FIOBuffer := AStream.DataString;
      Finally
        AStream.Free;
      End;
      if FIOBuffer <> '' then
        Begin
          Synchronize(FOwner.ProcessData);
          AStream := TStringStream.Create(FIOBuffer,TEncoding.Unicode);
          Try
            FResponder.send( AStream, AStream.Size );
          Finally
            AStream.Free;
          End;
        End;
    end;
  FResponder.unbind( 'tcp://'+FAddress+':'+FPort );
end;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TSubscriptionList
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure TSubscriptionList.AddSubscription(
        AName        : string;
        ADirection   : EDirection;
        AGet         : Boolean;
        APut         : Boolean;
        APost        : Boolean;
        ADelete      : Boolean;
        AResource    : string;
        APattern     : string;
        APayload     : Boolean;
        ARedirected  : Boolean
      );
var
  Idx: Integer;
begin
  Idx := Self.Add(TSubscription.Create);
  Self.Items[Idx].Name        := AName;
  Self.Items[Idx].Direction   := ADirection;
  Self.Items[Idx].GET         := AGet;
  Self.Items[Idx].PUT         := APut;
  Self.Items[Idx].POST        := APost;
  Self.Items[Idx].DELETE      := ADelete;
  Self.Items[Idx].Resource    := AResource;
  Self.Items[Idx].Pattern     := APattern;
  Self.Items[Idx].Payload     := APayload;
  Self.Items[Idx].Redirected  := ARedirected;
end;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TAbstractCustomizationInterface
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constructor TAbstractCustomizationInterface.Create(AAddress: string; APort: Integer);
begin
  inherited Create;
  FSubscriptions := TSubscriptionList.Create(True);
  FListening := False;
end;

destructor TAbstractCustomizationInterface.Destroy;
begin
  FSubscriptions.Free;
  StopListener;
  inherited;
end;

function TAbstractCustomizationInterface.RouteMessage(Data: string): string;
Var
  XDoc: TNativeXml;
  XCommandNode: TXmlNode;
begin
  XDoc := TNativeXml.Create(Nil);
  try
    XDoc.ReadFromString(Data);
    if XDoc.Root.Name = 'EVENT' then
      begin
        Result := HandleEvent(Data);
      end
    else
      begin
        XCommandNode := XDoc.Root.NodeByName('COMMAND');
        if XCommandNode <> Nil then
          begin
            if XCommandNode.Value = cxGetInfo then
              Result := HandleGetInfo(Data)
            else
            if XCommandNode.Value = cxSetConfig then
              Result := HandleSetConfig(Data)
            else
            if XCommandNode.Value = cxGetSubscriptions then
              Result := HandleGetSubscriptions
            else
            if XCommandNode.Value = cxSetUserToken then
              Result := HandleSetUserToken(Data)
            else
            if XCommandNode.Value = cxShutdown then
              Result := HandleShutdown;
          end
        else
          Result := cxNAQ;
      end;
  finally
    XDoc.Free;
  end;
end;

function TAbstractCustomizationInterface.HandleGetInfo(Data:string): string;
Var
  XDoc: TNativeXml;
begin
  Result :=
    '<CONTROL>'+
    '  <NAME>'+FName+'</NAME>'+
    '  <VERSION>'+FVersion+'</VERSION>'+
    '  <DEVELOPERID>'+FDeveloperID+'</DEVELOPERID>'+
    '  <CUSTOMIZATIONID>'+FCustomizationID+'</CUSTOMIZATIONID>'+
    '</CONTROL>';
  XDoc := TNativeXml.Create(Nil);
  try
    XDoc.ReadFromString(Data);
    FProxySID := XDoc.Root.ReadString('PROXYSID','');
  finally
    XDoc.Free;
  end;
  if Assigned(FOnGetInfo) then
    FOnGetInfo(Self);
end;

function TAbstractCustomizationInterface.HandleGetSubscriptions: string;
var
  sCounter : Integer;
  Details  : string;
  Sub      : TSubscription;
begin
  if FSubscriptions.Count = 0 then
    Result := '<SUBSCRIPTIONS/>'
  else
    begin
      Details := '';
      for sCounter := 0 to Pred(FSubscriptions.Count) do
        begin
          Sub := FSubscriptions.Items[sCounter];
          Details := Details +
            '<SUBSCRIPTION>'+
              '<NAME>'       + Sub.Name                                               +'</NAME>'+
              '<DIRECTION>'  + GetEnumName(TypeInfo(EDirection), Ord(Sub.Direction))  +'</DIRECTION>'+
              '<HTTPGET>'    + BoolToStr(Sub.GET,True)                                +'</HTTPGET>'+
              '<HTTPPUT>'    + BoolToStr(Sub.PUT,True)                                +'</HTTPPUT>'+
              '<HTTPPOST>'   + BoolToStr(Sub.POST,True)                               +'</HTTPPOST>'+
              '<HTTPDELETE>' + BoolToStr(Sub.DELETE,True)                             +'</HTTPDELETE>'+
              '<RESOURCE>'   + Sub.Resource                                           +'</RESOURCE>'+
              '<PATTERN>'    + Sub.Pattern                                            +'</PATTERN>'+
              '<PAYLOAD>'    + BoolToStr(Sub.Payload,True)                            +'</PAYLOAD>'+
              '<REDIRECTED>' + BoolToStr(Sub.Redirected,True)                         +'</REDIRECTED>'+
            '</SUBSCRIPTION>';
        end;
      Result := '<SUBSCRIPTIONS>' + Details + '</SUBSCRIPTIONS>'
    end;
end;

function TAbstractCustomizationInterface.HandleSetConfig(Data: string): string;
Var
  XDoc: TNativeXml;
begin
  Result := cxACK;
  XDoc := TNativeXml.Create(Nil);
  try
    XDoc.ReadFromString(Data);
    FGlobalConfigurationData  := XDoc.Root.ReadString('BASECONFIG','');
    FProxyConfigurationData   := XDoc.Root.ReadString('PROXYCONFIG','');
  finally
    XDoc.Free;
  end;
  if Assigned(FOnConfigDataSet) then
    FOnConfigDataSet(Self);
end;

function TAbstractCustomizationInterface.HandleSetUserToken(Data: string): string;
Var
  XDoc: TNativeXml;
begin
  Result := cxACK;
  XDoc := TNativeXml.Create(Nil);
  try
    XDoc.ReadFromString(Data);
    FUserToken := XDoc.Root.ReadString('TOKEN','');
    FPrismServer := XDoc.Root.ReadString('PRISMSERVER','');
    FPrismServerPort := XDoc.Root.ReadInteger('PRISMSERVERPORT',443);
  finally
    XDoc.Free;
  end;
  if Assigned(FOnTokenSet) then
    FOnTokenSet(Self);
end;

function TAbstractCustomizationInterface.HandleEvent(Data: string): string;
Var
  Direction: string;
  StatusCode: Integer;
  HTTPVerb: string;
  ResourceName: string;
  URI: string;
  Headers: string;
  Params: string;
  Payload: string;
  ContentType: string;
  CanContinue: Boolean;

  XDoc: TNativeXml;

begin
  //Decode Message
  CanContinue := True;
  XDoc := TNativeXml.Create(Nil);
  try
    XDoc.ReadFromString(Data);
    Direction     := XDoc.Root.ReadString('DIRECTION','');
    StatusCode    := XDoc.Root.ReadInteger('STATUSCODE',0);
    HTTPVerb      := XDoc.Root.ReadString('HTTPVERB','');
    ResourceName  := XDoc.Root.ReadString('RESOURCENAME','');
    URI           := XDoc.Root.ReadString('URI','');
    Headers       := XDoc.Root.ReadString('HEADERS','');
    Params        := XDoc.Root.ReadString('PARAMS','');
    Payload       := DecodePayload(XDoc.Root.ReadString('PAYLOAD',''));
    ContentType   := XDoc.Root.ReadString('CONTENTTYPE','');
  finally
    XDoc.Free;
  end;


  //Trigger Event Hook
  if Assigned(FOnEvent) then
    FOnEvent(Direction, StatusCode, HTTPVerb, ResourceName, URI, Headers, Params, Payload, ContentType, CanContinue);

  //Package Reply
  Result :=
    '<EVENT>' +
      '<HEADERS>'+Headers+'</HEADERS>'+
      '<PARAMS>'+Params+'</PARAMS>'+
      '<PAYLOAD>'+EncodePayload(Payload)+'</PAYLOAD>'+
      '<CONTINUE>'+BoolToStr(CanContinue,True)+'</CONTINUE>'+
      '<STATUSCODE>'+IntToStr(StatusCode)+'</STATUSCODE>'+
    '</EVENT>';
end;

function TAbstractCustomizationInterface.HandleShutdown: string;
begin
  Result := cxACK;
  if Assigned(FOnShutdownNotification) then
    FOnShutdownNotification(Self);
end;

function TAbstractCustomizationInterface.EncodePayload(Source: string): string;
Var
  PhraseCounter: Integer;
  EncodedString: UTF8String;
  DecodedString: UTF8String;
begin
  Result := Trim(Source);
  if Result <> '' then
    Begin
      for PhraseCounter := 0 to cEscapePhraseCount - 1 do
        begin
          EncodedString := cXmlReplacePhrases[PhraseCounter];
          DecodedString := cXmlEscapePhrases[PhraseCounter];
          Result := StringReplace(Result,DecodedString,EncodedString,[rfReplaceAll]);
        end;
    End;
end;

function TAbstractCustomizationInterface.DecodePayload(Source: string): string;
Var
  PhraseCounter: Integer;
  EncodedString: UTF8String;
  DecodedString: UTF8String;
begin
  Result := Trim(Source);
  if Result <> '' then
    Begin
      for PhraseCounter := 0 to cEscapePhraseCount - 1 do
        begin
          EncodedString := cXmlReplacePhrases[PhraseCounter];
          DecodedString := cXmlEscapePhrases[PhraseCounter];
          Result := StringReplace(Result,EncodedString,DecodedString,[rfReplaceAll]);
        end;
    End;
end;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TCustomizationInterface
//  Instance Methods
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constructor TCustomizationInterface.Create(AAddress: string; APort: Integer);
begin
  inherited Create(AAddress, APort);
  Client := TZMQClientThread.Create(True,Self);
  Client.Address := AAddress;
  Client.Port := IntToStr(APort);
  FSubscriptions := TSubscriptionList.Create(True);
  FListening := False;
end;

destructor TCustomizationInterface.Destroy;
begin
  FSubscriptions.Free;
  StopListener;
  Client.Free;
  inherited;
end;

// ######################################################################################################################################
//  TCustomizationInterface
//  Public Methods
// ######################################################################################################################################

procedure TCustomizationInterface.ProcessData;
Var
  ReqBuffer: String;
  RespBuffer: string;
begin
  ReqBuffer := Client.IOBuffer;
  RespBuffer := RouteMessage(ReqBuffer);
  Client.IOBuffer := RespBuffer;
end;

procedure TCustomizationInterface.StartListener;
begin
  if (Client.Address <> '') AND (Client.Port <> '') then
    Begin
      Client.Resume;
      FListening := True;
    End
  else
    raise EConfiguration.Create('There is no Address or Port information for the listener.');
end;

procedure TCustomizationInterface.StopListener;
begin
  if FListening then
    Begin
      Client.Terminate;
      FListening := False;
    End;
end;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TUnsynchedCustomizationInterface
//  Instance Methods
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constructor TUnsynchedCustomizationInterface.Create(AAddress: string; APort: Integer);
begin
  inherited Create(AAddress, APort);
  FContext := TZMQContext.create;
  FResponder := FContext.Socket( stRep );
  FAddress := AAddress;
  FPort := IntToStr(APort);
  FShutdown := False;
end;

destructor TUnsynchedCustomizationInterface.Destroy;
begin
  StopListener;
  FResponder.Free;
  FContext.Free;
  inherited;
end;

// ######################################################################################################################################
//  TUnsynchedCustomizationInterface
//  Public Methods
// ######################################################################################################################################

procedure TUnsynchedCustomizationInterface.ProcessData;
const
  ShutdownRequest = '<CONTROL><COMMAND>Shutdown</COMMAND></CONTROL>';
  Acknowledge     = '<ACK/>';
var
  ReqBuffer: String;
  RespBuffer: string;
begin
  ReqBuffer := FIOBuffer;
  RespBuffer := RouteMessage(ReqBuffer);
  FIOBuffer := RespBuffer;
  if (ReqBuffer = ShutdownRequest) and
     (RespBuffer = Acknowledge) then
    FShutdown := True
end;

procedure TUnsynchedCustomizationInterface.StartListener;
var
  AStream: TStringStream;
begin
  if (FAddress <> '') and (FPort <> '') then
  begin
    FResponder.bind( 'tcp://' + FAddress + ':' + FPort );
    while not FShutdown do
    begin
      AStream := TStringStream.Create('', TEncoding.Unicode);
      try
        FResponder.recv( AStream );
        FIOBuffer := AStream.DataString;
      finally
        AStream.Free;
      end;
      if FIOBuffer <> '' then
      begin
        ProcessData;
        AStream := TStringStream.Create(FIOBuffer, TEncoding.Unicode);
        try
          FResponder.send( AStream, AStream.Size );
        finally
          AStream.Free;
        end;
      end;
      FListening := True;
    end;
    FResponder.unbind( 'tcp://' + FAddress + ':' + FPort );
  end
  else
    raise EConfiguration.Create('There is no Address or Port information for the listener.');
end;

procedure TUnsynchedCustomizationInterface.StopListener;
begin
  if FListening then
    FListening := False;
end;

end.



