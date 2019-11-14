unit uCustomizationClient;

(*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*)

interface

uses
    //VCL
    System.Classes
    //Indy
  , IdHTTP
  , IdSSLOpenSSL
  , IdHeaderList
  ;

const
  ciHttpsPort          = 443;

  csHttpsPort          = '443';
  csHttps              = 'https';
  csCurrentRestVersion = 'v1';
  csCurrentRPCVersion  = 'v1';
  csRESTMoniker        = 'rest';
  csRPCMoniker         = 'rpc';

  csAuthHeader         = 'Auth-Session';

type

  TSSLHTTPClient = class(TIdHTTP)
  private
    FIOHandler : TIdSSLIOHandlerSocketOpenSSL;
    function GetCertFile: String;
    function GetKeyFile: String;
    procedure SetCertFile(const Value: String);
    procedure SetKeyFile(const Value: String);
  public
    constructor Create; reintroduce; overload;
    destructor Destroy; override;
    procedure Delete(AURL : string; AResponse : TStream); overload;
    property CertFile : String read GetCertFile write SetCertFile;
    property KeyFile : String read GetKeyFile write SetKeyFile;
    property SSLIOHandler : TIdSSLIOHandlerSocketOpenSSL read FIOHandler;
  end;


  TPayloadFormat = (pfXML, pfJSON);
  TRestMethod = (rmUnknown, rmGET, rmPOST, rmPUT, rmDelete );

  TPrismHTTPClient = class(TPersistent)
    private
      HTTP: TSSLHTTPClient;
      FLastResponseCode: Integer;
      FLastResponseMessage: String;
      FLastResponseBody: string;
      FLastCommDuration: double;
      FLastServerCommDuration: double;
      FPayloadFormat: TPayloadFormat;
      FServer: String;
      FPort: Integer;
      FAuthToken: String;
    protected
      function GetRESTPrefix: string;
      function GetRPCPrefix: string;
      procedure SetPayloadFormat(const Value: TPayloadFormat);
      procedure SetAuthToken(const Value: String);

      procedure GotHeader(Sender: TObject; AHeaders: TIdHeaderList; var VContinue: Boolean);virtual;

      function CheckResponse: Boolean;

      procedure PerformRequest(Method : TRestMethod; URI : String; Response : TStringStream; Request : TStringStream = nil); virtual;

    public
      constructor create;
      destructor destroy; override;

      function IsATeapot: Boolean;

      function GetServiceList:String;  virtual;

      function GetMeta(Resource:String): String; virtual;
      function GetRPCIntrospection(MethodName:string):String; virtual;

      function Ping: Boolean; virtual;

      function Get(URI: String):String; virtual;
      function Save(URI, Body: string; New: Boolean = False):string; virtual;
      function Post(URI, Body: string):string; virtual;
      function Put(URI, Body: string):string; virtual;
      function Delete(URI: String):Boolean; virtual;
      function MakeRPCCall(Payload: String):string; virtual;

      property RESTPrefix: string read GetRESTPrefix;
      property RPCPrefix: string read GetRPCPrefix;
      Property PayloadFormat: TPayloadFormat read FPayloadFormat write SetPayloadFormat;

      property AuthToken: String read FAuthToken write SetAuthToken;
      Property Server: String read FServer write FServer;
      Property Port: Integer read FPort write FPort;

      Property LastResponseCode: Integer read FLastResponseCode;
      Property LastResponseMessage: String read FLastResponseMessage;
      Property LastResponseBody: string read FLastResponseBody;
      Property LastCommDuration: double read FLastCommDuration;
      Property LastServerCommDuration: double read FLastServerCommDuration;

  end;




implementation

uses
    //VCL
    System.SysUtils
  , Winapi.Windows
    //Indy
  , IdStack
  , IdURI
  ;


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TSSLHTTPClient
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// ######################################################################################################################################
//  Private Methods
// ######################################################################################################################################

// ==================================================================================================================
//  Getters and Setters
// ==================================================================================================================

function TSSLHTTPClient.GetCertFile: String;
begin
  Result := FIOHandler.SSLOptions.CertFile;
end;

function TSSLHTTPClient.GetKeyFile: String;
begin
  Result := FIOHandler.SSLOptions.KeyFile;
end;

procedure TSSLHTTPClient.SetCertFile(const Value: String);
begin
  FIOHandler.SSLOptions.CertFile := Value;
end;

procedure TSSLHTTPClient.SetKeyFile(const Value: String);
begin
  FIOHandler.SSLOptions.KeyFile := Value;
end;

// ######################################################################################################################################
//  Public Methods
// ######################################################################################################################################

// ==================================================================================================================
//  Instance methods
// ==================================================================================================================

constructor TSSLHTTPClient.Create;
begin
  inherited Create(nil);
  FIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(self);
  FIOHandler.SSLOptions.SSLVersions := [sslvTLSv1, sslvSSLv2, sslvSSLv23, sslvSSLv3];
  FIOHandler.SSLOptions.Method := sslvTLSv1;
  IOHandler := FIOHandler;
  Port := ciHttpsPort;
end;

destructor TSSLHTTPClient.Destroy;
begin
  if Assigned(FIOHandler) then
    FreeAndNil(FIOHandler);
  inherited;
end;

// ==================================================================================================================
//  Overloaded
// ==================================================================================================================

procedure TSSLHTTPClient.Delete(AURL: string; AResponse: TStream);
begin
  DoRequest(Id_HTTPMethodDelete, AURL, nil, AResponse, []);
end;


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TPrismHTTPClient
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// ######################################################################################################################################
//  Private Methods
// ######################################################################################################################################

// ==================================================================================================================
//  Getters and Setters
// ==================================================================================================================

function TPrismHTTPClient.GetRESTPrefix: string;
begin
  Result :=  csHttps + '://' + FServer;
  if (FPort <> ciHttpsPort) and (FPort <> 0) then
    Result := Result + ':' + IntToStr(FPort);
  Result := Result + '/' + csCurrentRestVersion + '/'+ csRESTMoniker+'/';
end;


function TPrismHTTPClient.GetRPCPrefix: string;
begin
  Result := csHttps + '://' + FServer;
  if (FPort <> ciHttpsPort) and (FPort <> 0) then
    Result := Result + ':' + IntToStr(FPort);
  Result := Result + '/' + csCurrentRPCVersion + '/' + csRPCMoniker + '/';
end;

procedure TPrismHTTPClient.SetPayloadFormat(const Value: TPayloadFormat);
begin
  FPayloadFormat := Value;
  Case FPayloadFormat of
    pfXML:
      begin
        HTTP.Request.ContentType := 'text/xml';
        HTTP.Request.Accept := 'text/xml';
      end;
    pfJSON:
      begin
        HTTP.Request.ContentType := 'text/json';
        HTTP.Request.Accept := 'text/json';
      end;
  End;
end;

procedure TPrismHTTPClient.SetAuthToken(const Value: String);
Var
  Idx: Integer;
begin
  FAuthToken := Value;
  Idx := HTTP.Request.CustomHeaders.IndexOfName(csAuthHeader);
  if Idx = -1 then
    HTTP.Request.CustomHeaders.AddValue(csAuthHeader, FAuthToken)
  else
    HTTP.Request.CustomHeaders.Values[csAuthHeader] := FAuthToken;
end;


// ==================================================================================================================
//  Event Handlers
// ==================================================================================================================

procedure TPrismHTTPClient.GotHeader(Sender: TObject; AHeaders: TIdHeaderList; var VContinue: Boolean);
Var
  Idx: Integer;
  DVal: Double;
begin
  Idx := AHeaders.IndexOfName('Duration_ms');
  if Idx <> -1 then
    begin
      DVal := StrToFloatDef(AHeaders.ValueFromIndex[Idx],0.0);
      if DVal <> 0.0 then
        begin
          FLastServerCommDuration := DVal / 1000;
        end
      else
        begin
          FLastServerCommDuration := 0;
        end;
    end;
  VContinue := True;
end;


// ==================================================================================================================
//  Internal Methods
// ==================================================================================================================

function TPrismHTTPClient.CheckResponse: Boolean;
begin
  Result := (HTTP.ResponseCode >= 200) and (HTTP.ResponseCode <= 207);
  FLastResponseCode := HTTP.ResponseCode;
  FLastResponseMessage := HTTP.ResponseText;
end;

procedure TPrismHTTPClient.PerformRequest(Method: TRestMethod; URI: String; Response, Request: TStringStream);
begin
  try
    case Method of
      rmGET : HTTP.Get(Trim(URI), Response);
      rmPOST : HTTP.Post(Trim(URI), Request, Response);
      rmPUT: Http.Put(Trim(URI), Request, Response);
      rmDelete: HTTP.Delete(Trim(URI), Response);
    end;
  except
    on E:EIdHTTPProtocolException do
      begin
        Response.WriteString( E.ErrorMessage );
      end;
  end;
end;



// ######################################################################################################################################
//  Public Methods
// ######################################################################################################################################

// ==================================================================================================================
//  Instance methods
// ==================================================================================================================

constructor TPrismHTTPClient.create;
begin
  FServer := '';
  FPort := ciHttpsPort;
  HTTP := TSSLHTTPClient.Create;
  HTTP.OnHeadersAvailable := GotHeader;
  HTTP.ProtocolVersion := pv1_1;
  PayloadFormat := pfXML;
end;

destructor TPrismHTTPClient.destroy;
begin
  if HTTP.Connected then
    HTTP.Disconnect;
  HTTP.Free;
  inherited;
end;


// ==================================================================================================================
//  Worker Methods
// ==================================================================================================================

function TPrismHTTPClient.IsATeapot: Boolean;
Var
  Response: TStringStream;
begin
  Response := TStringStream.Create;
  Try
    Try
      HTTP.Get(GetRestPrefix + 'coffee',Response,[200,406,418]);
      Result := (HTTP.ResponseCode = 200) or (HTTP.ResponseCode = 406) or (HTTP.ResponseCode = 418) or ((HTTP.ResponseCode >= 700) and (HTTP.ResponseCode <= 799));
      FLastResponseBody := Response.DataString;
    Except
      On E:EIDSocketError do
        begin
          Result := False;
        end;
    end;
  Finally
    Response.Free;
  End;
end;

function TPrismHTTPClient.GetServiceList: String;
Var
  Response: TStringStream;
begin
  Response := TStringStream.Create('', TEncoding.UTF8, False);
  Try
    Try
      HTTP.Get(RestPrefix + 'services',Response);
    except
      on E:EIdHTTPProtocolException do
        Response.WriteString( E.ErrorMessage );
    End;
    FLastResponseBody := Response.DataString;
    Result := FLastResponseBody;
    CheckResponse;
  Finally
    Response.Free;
    HTTP.Request.Accept := '*';
  End;
end;

function TPrismHTTPClient.GetMeta(Resource: String): String;
begin
  Try
    Result := Get(GetRestPrefix + Resource + 'meta');
  except
    on E:EIdHTTPProtocolException do
      FLastResponseBody := E.ErrorMessage;
  End;
end;

function TPrismHTTPClient.GetRPCIntrospection(MethodName: string): String;
Var
  Body: string;
begin
  if FPayloadFormat = pfXML then
    Body := '<xml-rpc><methodCall name="'+MethodName+'" introspection="True" /></xml-rpc>'
  else
    Body := '{"methodcalls":[{"methodcall":{"name":"'+MethodName+'","introspection":"true","params":[]}}]}';
  Try
    Result := MakeRPCCall(Body);
  except
    on E:EIdHTTPProtocolException do
      FLastResponseBody := E.ErrorMessage;
  End;
  CheckResponse;
end;


function TPrismHTTPClient.Ping: Boolean;
begin
  Result := IsATeapot;
end;

function TPrismHTTPClient.Get(URI: String): String;
Var
  Response: TStringStream;
  Frequency,Count1,Count2:Int64;
begin
  FLastResponseBody := '';
  Response := TStringStream.Create('', TEncoding.UTF8, False);
  try
    URI := TIdURI.URLEncode(URI);
    QueryPerformanceCounter(Count1);

    PerformRequest(rmGET, URI, Response);

    QueryPerformanceCounter(Count2);
    QueryPerformanceFrequency(Frequency);

    FLastCommDuration := 1000 * ((Count2 - Count1) / Frequency);
    FLastResponseBody := Response.DataString;
    Result := FLastResponseBody;

    CheckResponse;
  finally
    Response.Free;
  end;
end;

function TPrismHTTPClient.Save(URI, Body: string; New: Boolean): string;
Var
  Response: TStringStream;
  Request: TStringStream;
  Frequency,Count1,Count2:Int64;
begin
  Response := TStringStream.Create('', TEncoding.UTF8, False);
  Request := TStringStream.Create(Body, TEncoding.UTF8, False);
  URI := TIdURI.URLEncode(URI);
  try
    QueryPerformanceCounter(Count1);
    if New then
      PerformRequest(rmPost, URI, Response, Request)
    else
      PerformRequest(rmPut, URI, Response, Request);
    QueryPerformanceCounter(Count2);
    QueryPerformanceFrequency(Frequency);
    FLastCommDuration := 1000 * ((Count2 - Count1) / Frequency);
    FLastResponseBody := Response.DataString;
    Result := FLastResponseBody;
    CheckResponse;
  Finally
    Response.Free;
    Request.Free;
  End;
end;

function TPrismHTTPClient.Post(URI, Body: string): string;
begin
  Result := Save(URI, Body, True);
end;

function TPrismHTTPClient.Put(URI, Body: string): string;
begin
  Result := Save(URI, Body, False);
end;

function TPrismHTTPClient.Delete(URI: String): Boolean;
Var
  Frequency,Count1,Count2:Int64;
  Response : TStringStream;
begin
  Result := False;
  FLastResponseBody := '';
  URI := TIdURI.URLEncode(URI);
  QueryPerformanceCounter(Count1);
  Response := TStringStream.Create;

  try
    PerformRequest(rmDelete, URI, Response);
    FLastResponseBody := Response.DataString;
  finally
    Response.Free;
  end;

  QueryPerformanceCounter(Count2);
  QueryPerformanceFrequency(Frequency);
  FLastCommDuration := 1000 * ((Count2 - Count1) / Frequency);
  if CheckResponse then
    Result := True;
end;

function TPrismHTTPClient.MakeRPCCall(Payload: String): string;
Var
  Response: TStringStream;
  Request: TStringStream;
  Frequency,Count1,Count2:Int64;
  URI: string;
begin
  Response := TStringStream.Create('', TEncoding.UTF8, False);
  Request := TStringStream.Create(Payload, TEncoding.UTF8, False);
  URI := GetRPCPrefix;
  URI := TIdURI.URLEncode(URI);
  Try
    QueryPerformanceCounter(Count1);
    Try
      HTTP.Post(URI,Request,Response)
    except
      on E:EIdHTTPProtocolException do
        Response.WriteString( E.ErrorMessage );
    End;
    QueryPerformanceCounter(Count2);
    QueryPerformanceFrequency(Frequency);
    FLastCommDuration := 1000 * ((Count2 - Count1) / Frequency);
    FLastResponseBody := Response.DataString;
    Result := FLastResponseBody;
    CheckResponse;
  Finally
    Response.Free;
    Request.Free;
  End;
end;

end.
