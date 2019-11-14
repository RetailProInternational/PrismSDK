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
        ADirection: string;
        var AStatusCode: Integer;
        AHTTPVerb: string;
        AResourceName: string;
        AURL: string;
        var AHeaders: string;
        var AParams: string;
        var APayload: string;
        AContentType: string;
        Var ACanContinue: Boolean
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
  , IdGlobalProtocols
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
  ProxyLink.Name            := 'Fiscal';
  ProxyLink.Version         := '1.0.0';
  ProxyLink.DeveloperID     := '000';
  ProxyLink.CustomizationID := '006';

  ProxyLink.OnShutdownNotification  := ProcessShutdown;
  ProxyLink.OnEvent                 := ProcessEvent;

  ProxyLink.Subscriptions.AddSubscription('Fiscal_Document',dFromClient,False,False,True,True,'document','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('Fiscal_DocumentItems',dFromClient,False,True,True,True,'document/item','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('Fiscal_DocumentTender',dFromClient,False,True,True,True,'document/tender','mpRR',True,False);

  ProxyLink.Subscriptions.AddSubscription('Fiscal_CustomMethod',dFromClient,True,False,False,False,'fiscalcustom','mpRR',True,True);

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
  ADirection: string;
  var AStatusCode: Integer;
  AHTTPVerb: string;
  AResourceName: string;
  AURL: string;
  var AHeaders: string;
  var AParams: String;
  var APayload:string;
  AContentType: string;
  var ACanContinue: Boolean);
var
  TmpPayload: string;
  HeadersList: TStringList;

  Fiscal_ID: String;

//  ClientResponse: String;
begin
  TmpPayload := APayload;
  HeadersList := TStringList.Create;
  try
    HeadersList.StrictDelimiter := True;
    HeadersList.DelimitedText := AHeaders;
    If AContentType.Contains('xml') then
      begin //XML

      end
    else
      begin //JSON
        if (AResourceName.ToUpper = 'DOCUMENT') then
          Begin
            if (AHTTPVerb.ToUpper = 'POST') then
              Begin
                //Get this from your fiscal solution
                Fiscal_ID := '1234';
                //Attach the fiscal ID to the document
                TmpPayload := Copy(APayload,1,Length(APayload)-2);
                TmpPayload := TmpPayload + ',"info2":"'+Fiscal_ID+'"}]';
                //Notification of the new document to the fiscal solution
              End
            else
            if (AHTTPVerb.ToUpper = 'DELETE') then
              Begin
                //Get the fiscal ID from the document
                Fiscal_ID := DirtyJSONParser(TmpPayload,'info2');
                //Notification of the delete to the fiscal solution
              End;
            //Could also watch for a post with a bt_cuid to look for a customer that was added
          End
        else
        if (AResourceName.ToUpper = 'ITEM') then
          Begin
            if (AHTTPVerb.ToUpper = 'POST') then
              Begin
                //Send notification of a new item on the doucment to the fiscal solution

              End
            else
            if (AHTTPVerb.ToUpper = 'PUT') then
              Begin
                //Send notification of the changed item on the doucment to the fiscal solution
                // look for different quantity and price information on the item.
              End
            else
            if (AHTTPVerb.ToUpper = 'DELETE') then
              Begin
                //Send notification of the deleted item on the doucment to the fiscal solution

              End;
          End
        else
        if (AResourceName.ToUpper = 'TENDER') then
          Begin
            if (AHTTPVerb.ToUpper = 'POST') then
              Begin
                //Send notification of a new tender on the doucment to the fiscal solution
              End
            else
            if (AHTTPVerb.ToUpper = 'PUT') then
              Begin
                //Send notification of a changed tender on the doucment to the fiscal solution
              End
            else
            if (AHTTPVerb.ToUpper = 'DELETE') then
              Begin
                //Send notification of a deleted tender on the doucment to the fiscal solution
              End;
          End
        else
        if (AResourceName.ToUpper = 'FISCALCUSTOM') then
          Begin
            // Parse the AParams for Action=Verb
            // Perform out of band fiscal fiscal tasks using these actions...

            // e.g. A Client Side Fiscal Sudit button can call fiscalcustom?Action=Audit
            // and code here can compare Prism Prism Transaction Count and totals with
            // fiscal solution transaction count and totals.

            if AParams.ToUpper.Contains('ACTION=AUDIT') then
              Begin
                //In this case we will respond to the client with some data that it can show to compare
                //with retail pro. This data would come from your fiscal solution.
                HeadersList.Add('ContentType: text/json; charset=utf-8');
                HeadersList.Add('ContentRange: 1-1/1');
                TmpPayload := '[{"transactioncount":"50"}]';
                ACanContinue := False;
                AStatusCode := 200;
              End
            else
              Begin
                ACanContinue := False;
                AStatusCode := 555;
                TmpPayload := 'Action was not recognized.';
              End;
          End;
      end;
      //Let everything finish.
      APayload := TmpPayload;
      AHeaders := HeadersList.DelimitedText;
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
  ProxyLink := TCustomizationInterface.Create('127.0.0.1',5666);
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
