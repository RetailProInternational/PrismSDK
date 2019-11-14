unit UnitMain;

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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls

  , IdIOHandler
  , IdIOHandlerSocket
  , IdIOHandlerStack
  , IdSSL
  , IdSSLOpenSSL, IdHeaderList

  ;

type
  TFormLoginSample = class(TForm)
    Button1: TButton;
    HTTP: TIdHTTP;
    Memo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure HTTPHeadersAvailable(Sender: TObject; AHeaders: TIdHeaderList; var VContinue: Boolean);
  private
    procedure Login(AUserName, APassword, AWorkstationName: String);
    { Private declarations }
  public
    FNonce: String;
    FAuthToken: String;

  end;

var
  FormLoginSample: TFormLoginSample;

implementation

{$R *.dfm}

procedure TFormLoginSample.HTTPHeadersAvailable(Sender: TObject; AHeaders: TIdHeaderList; var VContinue: Boolean);
begin
  FNonce     := AHeaders.Values[ 'Auth-Nonce' ];
  FAuthToken := AHeaders.Values[ 'Auth-Session' ];
end;

Procedure TFormLoginSample.Login(AUserName: String; APassword: String; AWorkstationName: String);
Var
  IntNonce : Int64;
  ResponseData: TStringStream;
Begin
  //Start the login
  HTTP.Get('https://XDN-WIN764-EM64/v1/rest/auth');
  if HTTP.ResponseCode = 200 then
    Begin
      //Send back the initial handshake Value
      HTTP.Request.CustomHeaders.Add( 'Auth-Nonce: ' + FNonce );
      //Compute the handshake reply
      IntNonce := StrToInt64Def( FNonce, -1 );
      FNonce := IntToStr(((IntNONCE div 13) mod 99999) * 17);
      //Add the reply to th header
      HTTP.Request.CustomHeaders.Add( 'Auth-Nonce-Response: ' + FNonce );
      //Make the login request
      HTTP.Get('https://XDN-WIN764-EM64/v1/rest/auth?usr=' + AUsername + '&pwd=' + APassword);
      if HTTP.ResponseCode = 200 then
        Begin
          //Clear the unused headers
          HTTP.Request.CustomHeaders.Clear;
          //Add the token needed for all requests
          HTTP.Request.CustomHeaders.Add( 'Auth-Session: ' + FAuthToken );
          //Sit to complete the generation of the user session
          HTTP.Get('https://XDN-WIN764-EM64/v1/rest/sit?ws=' + AWorkstationName);
          if HTTP.ResponseCode = 200 then
            Begin
              //Now Logged in We can make requests.
              ResponseData := TStringStream.Create('', TEncoding.UTF8, False);
              Try
                HTTP.Get('https://XDN-WIN764-EM64/v1/rest/customer',ResponseData);
                Memo.Lines.Text := ResponseData.DataString;
              Finally
                ResponseData.Free;
              End;
              //Don't forget to logout when we are done
              HTTP.Get('https://XDN-WIN764-EM64/v1/rest/stand');
            End;
        End;
    End;
End;


procedure TFormLoginSample.Button1Click(Sender: TObject);
begin
  Login('sysadmin','sysadmin','Awsomestation');
end;

end.
