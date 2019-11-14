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
  , System.Generics.Collections

  , uCustomizationInterface
  ;

type
  TMessage = class(TObject)
    Direction: String;
    Verb: String;
    Resource: String;
    QueryString: String;
    Payload: String;
  end;

  TMessageList = TObjectList<TMessage>;


  TFormEventLogger = class(TForm)
    Panel_Top: TPanel;
    Button_Start: TButton;
    Button_Stop: TButton;
    Button_Token: TButton;
    Button_GlobalConfig: TButton;
    Button_WSConfig: TButton;
    StringGrid_Data: TStringGrid;
    Panel_Details: TPanel;
    Label_Direction: TLabel;
    Label_Verb: TLabel;
    Label_Resource: TLabel;
    Label_Querystring: TLabel;
    Label_Payload: TLabel;
    Label_DirectionData: TLabel;
    Label_VerbData: TLabel;
    Label_ResourceData: TLabel;
    Splitter1: TSplitter;
    MemoParams: TMemo;
    MemoPayload: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button_StartClick(Sender: TObject);
    procedure Button_StopClick(Sender: TObject);
    procedure Button_TokenClick(Sender: TObject);
    procedure Button_GlobalConfigClick(Sender: TObject);
    procedure Button_WSConfigClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid_DataClick(Sender: TObject);
  private
    GlobalConfigData: TStringList;
    WSConfigData: TStringList;
    TokenData: TStringList;

    //Reference
    ProxyLink: TCustomizationInterface;

    //Callbacks
    Procedure ProcessConfigData(Sender: TObject);
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
    Procedure ProcessClientToken(Sender: TObject);

    //Helper Methods
    Procedure SetUp;
    Procedure InitializeGrid;
    Procedure PopulateDetails(Msg: TMessage);
    Procedure AddToGrid(Msg: TMessage);
  public
    FLogging: Boolean;
    Messages: TMessageList;
  end;

var
  FormEventLogger: TFormEventLogger;

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

procedure TFormEventLogger.SetUp;
begin
  ProxyLink.Name            := 'EventLogger';
  ProxyLink.Version         := '1.0.0';
  ProxyLink.DeveloperID     := '000';
  ProxyLink.CustomizationID := '000';

  ProxyLink.OnConfigDataSet         := ProcessConfigData;
  ProxyLink.OnTokenSet              := ProcessClientToken;
  ProxyLink.OnShutdownNotification  := ProcessShutdown;
  ProxyLink.OnEvent                 := ProcessEvent;

  ProxyLink.Subscriptions.AddSubscription('EV_DocRequest',dFromClient,True,True,True,True,'document','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_DocResponse',dToClient,True,True,True,True,'document','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_ItemsRequest',dFromClient,True,True,True,True,'document/item','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_ItemsResponse',dToClient,True,True,True,True,'document/item','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_TenderRequest',dFromClient,True,True,True,True,'document/tender','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_TenderResponse',dToClient,True,True,True,True,'document/tender','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerRequest',dFromClient,True,True,True,True,'customer','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerResponse',dToClient,True,True,True,True,'customer','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerEmailRequest',dFromClient,True,True,True,True,'customer/email','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerEmailResponse',dToClient,True,True,True,True,'customer/email','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerAddressRequest',dFromClient,True,True,True,True,'customer/address','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerAddressResponse',dToClient,True,True,True,True,'customer/address','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerPhoneRequest',dFromClient,True,True,True,True,'customer/phone','mpRR',True,False);
  ProxyLink.Subscriptions.AddSubscription('EV_CustomerPhoneResponse',dToClient,True,True,True,True,'customer/phone','mpRR',True,False);

  ProxyLink.StartListener;
end;


procedure TFormEventLogger.InitializeGrid;
begin
  StringGrid_Data.ColCount := 3;
  StringGrid_Data.RowCount := 2;
  StringGrid_Data.FixedRows := 1;
  StringGrid_Data.Cells[0,0] := '#';
  StringGrid_Data.Cells[1,0] := 'Verb';
  StringGrid_Data.Cells[2,0] := 'Resource';
  StringGrid_Data.ColWidths[0] := 20;
  StringGrid_Data.ColWidths[1] := 150;
  StringGrid_Data.ColWidths[2] := StringGrid_Data.ClientWidth - (StringGrid_Data.ColWidths[0] + StringGrid_Data.ColWidths[1]);
end;

procedure TFormEventLogger.PopulateDetails(Msg: TMessage);
begin
  Label_DirectionData.Caption := Msg.Direction;
  Label_VerbData.Caption := Msg.Verb;
  Label_ResourceData.Caption := Msg.Resource;
  MemoParams.Lines.Clear;
  MemoParams.Lines.Text := Msg.QueryString;
  MemoPayload.Lines.Clear;
  MemoPayload.Lines.Text := Msg.Payload;
end;

procedure TFormEventLogger.AddToGrid(Msg: TMessage);
Var
  LastRow: Integer;
begin
  if StringGrid_Data.Cells[0,1] <> '' then
    begin
      StringGrid_Data.RowCount := StringGrid_Data.RowCount + 1;
      LastRow := StringGrid_Data.RowCount - 1;
    end
  else
    LastRow := StringGrid_Data.RowCount-1;

  if Msg.Direction = 'ToClient' then
    StringGrid_Data.Cells[0,LastRow] := 'v'
  else
    StringGrid_Data.Cells[0,LastRow] := '^';

  StringGrid_Data.Cells[1,LastRow] := Msg.Verb;
  StringGrid_Data.Cells[2,LastRow] := Msg.Resource;

  StringGrid_Data.Selection := TGridRect(Rect(0,LastRow,1,LastRow));

  if Panel_Details.Height < 200 then
    Panel_Details.Height := 200;

  PopulateDetails(Msg);
end;


// ==================================================================================================================
//  Callbacks
// ==================================================================================================================

procedure TFormEventLogger.ProcessClientToken(Sender: TObject);
begin
  TokenData.Add('Server='+ProxyLink.PrismServer);
  TokenData.Add('Port='+IntToStr(ProxyLink.PrismServerPort));
  TokenData.Add('Token='+ProxyLink.UserToken);
  Button_Token.Enabled := True;
end;

procedure TFormEventLogger.ProcessConfigData(Sender: TObject);
begin
  GlobalConfigData.Text := ProxyLink.GlobalConfigurationData;
  WSConfigData.Text := ProxyLink.ProxyConfigurationData;
  Button_GlobalConfig.Enabled := True;
  Button_WSConfig.Enabled := True;
end;

procedure TFormEventLogger.ProcessEvent(ADirection: string; var AStatusCode: Integer; AHTTPVerb, AResourceName, AURL: string; var AHeaders: string; var AParams, APayload: string; AContentType: string; var ACanContinue: Boolean);
Var
  NewMessage: TMessage;
begin
  if FLogging then
    Begin
      NewMessage := Messages.Items[Messages.Add(TMessage.Create)];
      NewMessage.Direction := ADirection;
      NewMessage.Verb := AHTTPVerb;
      NewMessage.Resource := AResourceName;
      NewMessage.QueryString := AParams;
      NewMessage.Payload := APayload;
      AddToGrid(NewMessage);
    End;
end;

procedure TFormEventLogger.ProcessShutdown(Sender: TObject);
begin
  MessageDlg('Proxy is closing. '+#13+#10+'Exiting Event Logger.', mtInformation, [mbOK], 0);
  Close;
end;

// ######################################################################################################################################
//  Public
// ######################################################################################################################################

// ==================================================================================================================
//  Instance Methods
// ==================================================================================================================

procedure TFormEventLogger.FormCreate(Sender: TObject);
var
  Msg: TMessage;
begin
  Messages := TMessageList.Create;
  GlobalConfigData := TStringList.Create;
  WSConfigData := TStringList.Create;
  TokenData  := TStringList.Create;
  ProxyLink := TCustomizationInterface.Create('127.0.0.1',5678);
  SetUp;
  InitializeGrid;
  Msg := TMessage.Create;
  try
    PopulateDetails(Msg);
  finally
    Msg.Free;
  end;
end;

procedure TFormEventLogger.FormDestroy(Sender: TObject);
begin
  GlobalConfigData.Free;
  WSConfigData.Free;
  TokenData.Free;
  if ProxyLink.Listening then
    ProxyLink.StopListener;
  ProxyLink.Free;
  Messages.Free;
end;

// ==================================================================================================================
//  UI Event Handlers
// ==================================================================================================================

procedure TFormEventLogger.FormShow(Sender: TObject);
begin
  Panel_Details.Height := 1;
end;

procedure TFormEventLogger.Button_StartClick(Sender: TObject);
begin
  FLogging := True;
  Button_Stop.Enabled := True;
  Button_Start.Enabled := False;
end;

procedure TFormEventLogger.Button_StopClick(Sender: TObject);
begin
  FLogging := False;
  Button_Stop.Enabled := False;
  Button_Start.Enabled := True;
end;

procedure TFormEventLogger.Button_TokenClick(Sender: TObject);
begin
  ShowMessage(TokenData.Text);
end;

procedure TFormEventLogger.Button_WSConfigClick(Sender: TObject);
begin
  ShowMessage(WSConfigData.Text);
end;

procedure TFormEventLogger.Button_GlobalConfigClick(Sender: TObject);
begin
  ShowMessage(GlobalConfigData.Text);
end;

procedure TFormEventLogger.StringGrid_DataClick(Sender: TObject);
begin
  PopulateDetails(Messages.Items[StringGrid_Data.Row -1]);
end;

end.
