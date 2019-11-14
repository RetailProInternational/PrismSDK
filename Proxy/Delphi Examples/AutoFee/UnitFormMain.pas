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
  TFormAutoFee = class(TForm)
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
    Procedure ProcessShutdown(Sender: TObject);

    //Helper Methods
    Procedure SetUp;
  public
  end;

var
  FormAutoFee: TFormAutoFee;

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

procedure TFormAutoFee.SetUp;
begin
  ProxyLink.Name            := 'AutoFee';
  ProxyLink.Version         := '1.0.0';
  ProxyLink.DeveloperID     := '000';
  ProxyLink.CustomizationID := '002';

  ProxyLink.OnShutdownNotification  := ProcessShutdown;
  ProxyLink.OnEvent                 := ProcessEvent;

  ProxyLink.Subscriptions.AddSubscription('AF_DocRequest',dFromClient,False,False,True,False,'document','mpRR',True,False);

  ProxyLink.StartListener;
end;

// ==================================================================================================================
//  Callbacks
// ==================================================================================================================

procedure TFormAutoFee.ProcessEvent(ADirection: string; var AStatusCode: Integer; AHTTPVerb, AResourceName, AURL: string;var AHeaders: String; var AParams, APayload: string; AContentType: string; var ACanContinue: Boolean);
var
  TmpPayload: string;
begin
  TmpPayload := APayload;

  If AContentType.Contains('xml') then
    begin //XML

    end
  else
    begin //JSON
      TmpPayload := Copy(APayload,1,Length(APayload)-2);
      TmpPayload := TmpPayload + ',"fee_amt1":"10.00","fee_type1_sid":"363940100000182248"}]';
      APayload := TmpPayload;
    end;
end;

procedure TFormAutoFee.ProcessShutdown(Sender: TObject);
begin
  Close;
end;

// ######################################################################################################################################
//  Public
// ######################################################################################################################################

// ==================================================================================================================
//  Instance Methods
// ==================================================================================================================

procedure TFormAutoFee.FormCreate(Sender: TObject);
begin
  ProxyLink := TCustomizationInterface.Create('127.0.0.1',2345);
  SetUp;
end;

procedure TFormAutoFee.FormDestroy(Sender: TObject);
begin
  if ProxyLink.Listening then
    ProxyLink.StopListener;
  ProxyLink.Free;
end;

end.
