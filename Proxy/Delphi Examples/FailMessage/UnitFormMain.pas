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
  ;

type
  TFormFail = class(TForm)
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
        var AHeader: string;
        var AParams: string;
        var APayload: string;
        AContentType: string;
        Var ACanContinue: Boolean
      );
    Procedure ProcessShutdown(Sender: TObject);

    //Helper Methods
    Procedure SetUp;
  public
  end;

var
  FormFail: TFormFail;

implementation

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

procedure TFormFail.SetUp;
begin
  ProxyLink.Name            := 'FailMessage';
  ProxyLink.Version         := '1.0.0';
  ProxyLink.DeveloperID     := '000';
  ProxyLink.CustomizationID := '003';

  ProxyLink.OnShutdownNotification  := ProcessShutdown;
  ProxyLink.OnEvent                 := ProcessEvent;

  ProxyLink.Subscriptions.AddSubscription('AF_AddItem',dFromClient,False,False,True,False,'document/item','mpRR',True,True);

  ProxyLink.StartListener;
end;

// ==================================================================================================================
//  Callbacks
// ==================================================================================================================

procedure TFormFail.ProcessEvent(ADirection: string; var AStatusCode: Integer; AHTTPVerb, AResourceName, AURL: string; var AHeader: string; var AParams, APayload: string; AContentType: string; var ACanContinue: Boolean);
begin
  //Force a fail here...
  ACanContinue := False;
  AStatusCode := 555;
  APayload := 'This is a fail message sent back by a <B>Retail Pro Prism</B> <I>Proxy Plugin</I><BR>Have a nice day!';
end;

procedure TFormFail.ProcessShutdown(Sender: TObject);
begin
  Close;
end;

// ######################################################################################################################################
//  Public
// ######################################################################################################################################

// ==================================================================================================================
//  Instance Methods
// ==================================================================================================================

procedure TFormFail.FormCreate(Sender: TObject);
begin
  ProxyLink := TCustomizationInterface.Create('127.0.0.1',3456);
  SetUp;
end;

procedure TFormFail.FormDestroy(Sender: TObject);
begin
  if ProxyLink.Listening then
    ProxyLink.StopListener;
  ProxyLink.Free;
end;

end.
