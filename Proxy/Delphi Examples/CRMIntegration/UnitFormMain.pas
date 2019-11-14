unit UnitFormMain;

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
    Winapi.Windows
  , Winapi.Messages
  , System.SysUtils
  , System.Variants
  , System.Classes
  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.StdCtrls
  , Vcl.Grids
  , Vcl.ExtCtrls
  , uCustomizationInterface
  , uCustomizationClient
  ;

type
  TFormCRM = class(TForm)
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

    //Reference
    ProxyLink: TCustomizationInterface;

    //Callbacks
    Procedure ProcessEvent(
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
      );

    Procedure ProcessClientToken(Sender: TObject);

    Procedure ProcessShutdown(Sender: TObject);

    //Helper Methods
    Procedure SetUp;
  public
    Client: TPrismHTTPClient;
    function DirtyJSONParser(Payload, AttributeName: String): String;
  end;

var
  FormCRM: TFormCRM;

implementation

Uses
    idheaderlist
  , SampleData
  , system.json
  ;

{$R *.dfm}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TFormEventLogger
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// ######################################################################################################################################
//  Private
// ######################################################################################################################################

// ==================================================================================================================
//  Utility Methods
// ==================================================================================================================

procedure TFormCRM.SetUp;
begin
  ProxyLink.Name            := 'CRMIntegration';
  ProxyLink.Version         := '1.0.0';
  ProxyLink.DeveloperID     := '000';
  ProxyLink.CustomizationID := '004';

  ProxyLink.OnShutdownNotification  := ProcessShutdown;
  ProxyLink.OnEvent                 := ProcessEvent;

  ProxyLink.Subscriptions.AddSubscription('CRM_Customer',dFromClient,True,False,False,False,'customer','mpRR',True,True);
  ProxyLink.Subscriptions.AddSubscription('CRM_Document',dFromClient,False,True,False,False,'document','mpRR',True,False);

  ProxyLink.StartListener;
end;

function TFormCRM.DirtyJSONParser(Payload, AttributeName: String): String;
var
  vJSONBytes: TBytes;
  vJSONPayload: TJSONValue;
  vJSONArray: TJSONArray;
  vJSONValue: TJSONValue;
  vJSONObject: TJSONObject;
  vJSONPair: TJSONPair;
  vJSONSIDEntry: TJSONString;
  vJSONSIDValue: TJSONValue;
begin
  vJSONBytes := BytesOf(Payload);

  vJSONPayload := TJSONObject.ParseJSONValue(vJSONBytes, 0);
  if vJSONPayload <> nil then
  try
    vJSONArray := vJSONPayload as TJSONArray;
    for vJSONValue in vJSONArray do
    begin
      vJSONObject := vJSONValue as TJSONObject;
      vJSONPair := vJSONObject.Get(AttributeName);
      vJSONSIDEntry := vJSONPair.JsonString;
      vJSONSIDValue := vJSONPair.JsonValue;
      Result := vJSONSIDValue.ToString;
    end;
  finally
    vJSONPayload.Free;
  end;
end;

// ==================================================================================================================
//  Callbacks
// ==================================================================================================================

procedure TFormCRM.ProcessClientToken(Sender: TObject);
begin
  Client.Server := ProxyLink.PrismServer;
  Client.Port := ProxyLink.PrismServerPort;
  Client.AuthToken := ProxyLink.UserToken;
  Client.PayloadFormat := pfJSON;
end;

procedure TFormCRM.ProcessEvent(
    Direction: string;
    var StatusCode: Integer;
    HTTPVerb: string;
    ResourceName: string;
    URL: string;
    var Headers: string;
    var Params: string;
    var Payload: string;
    ContentType: string;
    var CanContinue: Boolean);
var
  TmpPayload: string;
  HeadersList: TStringList;
  SID: String;
  ClientResponse: String;
  PSID: String;
begin
  TmpPayload := Payload;
  HeadersList := TStringList.Create;
  try
    HeadersList.StrictDelimiter := True;
    HeadersList.DelimitedText := Headers;
    If ContentType.Contains('json') then
      begin //JSON
        //Customer Lookup
        if (HTTPVerb.ToUpper = 'GET') and (ResourceName.ToUpper = 'CUSTOMER') then
          begin
            //Here is where you would take the AParams and use it to query your CRM solution
            //Get the data from your CRM solution and format it into Retail Pro Prism Format

            //Set the response payload
            TmpPayload := cCustList;
            //Because is it not coming from a real apache server we need to provide some headers.
            HeadersList.Add('ContentType: text/json; charset=utf-8');
            HeadersList.Add('ContentRange: 1-3/3');
            //For success
            StatusCode := 200;
            //Tell the proxy to just return this to the client and don't go to the server
            CanContinue := False;
          end;
      end;
      //Let everything finish.
      Payload := TmpPayload;
      Headers := HeadersList.DelimitedText;
  finally
    HeadersList.Free;
  end;
end;

procedure TFormCRM.ProcessShutdown(Sender: TObject);
begin
  Close;
end;

// ######################################################################################################################################
//  Public
// ######################################################################################################################################

// ==================================================================================================================
//  Instance Methods
// ==================================================================================================================


procedure TFormCRM.FormCreate(Sender: TObject);
begin
  ProxyLink := TCustomizationInterface.Create('127.0.0.1',5454);
  SetUp;
  Client := TPrismHTTPClient.Create;
end;

procedure TFormCRM.FormDestroy(Sender: TObject);
begin
  if ProxyLink.Listening then
    ProxyLink.StopListener;
  ProxyLink.Free;
  Client.Free;
end;

end.
