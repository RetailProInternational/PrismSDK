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
  end;

var
  FormCRM: TFormCRM;

implementation

Uses
    idheaderlist
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
  ProxyLink.Name            := 'CustomResource';
  ProxyLink.Version         := '1.0.0';
  ProxyLink.DeveloperID     := '000';
  ProxyLink.CustomizationID := '006';

  ProxyLink.OnShutdownNotification  := ProcessShutdown;
  ProxyLink.OnEvent                 := ProcessEvent;

  ProxyLink.Subscriptions.AddSubscription('Test_Custom_Trigger',dFromClient,False,False,True,False,'CustomTrigger','mpRR',True,True);//Post
  ProxyLink.Subscriptions.AddSubscription('Test_Custom_Data',dFromClient,True,False,False,False,'CustomData','mpRR',True,True);//Get

  ProxyLink.StartListener;
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
begin
  TmpPayload := Payload;
  if (HTTPVerb.ToUpper = 'GET') and (ResourceName.ToUpper = 'CUSTOMDATA') then
    begin
      TmpPayload := '[{"Property1":"Prop1Value","Property2":"Prop2Value","Property3":"Prop3Value","Property4":"Prop4Value"}]';
      StatusCode := 200;
      CanContinue := False;
    end;
  if (HTTPVerb.ToUpper = 'POST') and (ResourceName.ToUpper = 'CUSTOMTRIGGER') then
    begin
      TmpPayload := '[{"PostResult1":"PostResultValue1","PostResult2":"PostResultValue2","PostResult3":"PostResultValue3","PostResult4":"PostResultValue4"}]';
      StatusCode := 200;
      CanContinue := False;
    end;
  Payload := TmpPayload;
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
  ProxyLink := TCustomizationInterface.Create('127.0.0.1',3131);
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
