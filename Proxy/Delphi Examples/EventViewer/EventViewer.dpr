program EventViewer;

(*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*)

uses
  Vcl.Forms,
  UnitFormMain in 'UnitFormMain.pas' {FormEventLogger};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormEventLogger, FormEventLogger);
  Application.Run;
end.
