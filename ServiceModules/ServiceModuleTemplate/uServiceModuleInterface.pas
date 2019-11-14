unit uServiceModuleInterface;

(*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*)

interface

//Exposes the module to the Prism framework.
Procedure DISCOVER(var ADescription : PChar;var AVersion : PChar;var ARESTful : WordBool;var AURIVersion : Integer;var AServices : PPCharArray;var AMethods : PPCharArray); stdcall;

//Exposes the module to the API
Function DESCRIBE(AWillAccept: PChar) : PChar; stdcall;

//Internal call to prepare and needed resources.
Function PREPARE( AExePath : PChar ) : Integer; stdcall;

//API call for configuring the module
// https://{SERVER}/v1/rest/modules/RPSServiceModule
Function CONFIGURE(AMethod: PChar;Accepts: PChar;var AConfig: PChar): Integer; stdcall;

//Internal call to allow the module to perform any cleanup needed
Function CLEANUP: Integer; stdcall;

//API call for responding to Resource based requests
Function DISPATCHREST(
  AHTTPVerb: PChar;
  AServiceName: PChar;
  AQualifiers: PChar;
  AParams: PPCharArray;
  ARequestHeaders: PPCharArray;
  ARequestCookies: PPCharArray;
  ARequestContentType: PChar;
  ARequestContentLength: Integer;
  ARequestContent: PChar;
  AWillAccept: PChar;
  AResponseContentHandle: THandle;
  AResponseHeaders: PChar;
  AResponseCookies: PChar
): Integer; stdcall;

//API call for responding to RPC based requests
Function DISPATCHRPC(
  ARequestHeaders        : PPCharArray;
  ARequestCookies        : PPCharArray;
  ARequestContentType    : PChar;
  ARequestContentLength  : Integer;
  ARequestContent        : PChar;
  AWillAccept            : PChar;
  AResponseContentHandle : THandle;
  AResponseHeaders       : PChar;
  AResponseCookies       : PChar
): Integer; stdcall;

implementation

uses
    System.Classes
  , System.SysUtils
  , NativeXML
  , uDescriptionData
  , uServiceLogger
  ;


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  Library  Methods
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Function ExtractPCharArrayFromNodes(ARoot: TXmlNode; AExtractNodeName: string):PPCharArray;
Var
  NodeList      : TsdNodeList;
  NodeCounter   : Integer;
  SList         : TStringList;
  tmpArray      : PPCharArray;
  tmpStr        : String;
begin
  tmpArray := nil;
  NodeList := TsdNodeList.Create;
  SList := TStringList.Create;
  try
    //Get all the resource names in a string list
    ARoot.FindNodes(AExtractNodeName.ToUpper, NodeList);
    for NodeCounter := 0 to pred( NodeList.Count ) do
      Begin
        tmpStr := NodeList.Items[ NodeCounter ].ReadString('NAME','');
        if tmpStr <> '' then
          SList.Add( tmpStr );
      end;
    tmpStr := '';

    //Iterate the string list and add the items to the array
    if ( tmpArray <> nil ) then
      freemem( tmpArray );
    if ( SList.Count = 0 ) then
      tmpArray := nil
    else
      begin
        getmem( tmpArray, sizeof( pchar ) * ( SList.Count + 1 ) );
        fillchar( tmpArray^, sizeof( pchar ) * ( SList.Count + 1 ), 0 );
        for NodeCounter := 0 to pred( SList.Count ) do
        begin
          tmpStr := SList[NodeCounter];
          tmpArray[ NodeCounter ] := @SList[NodeCounter][1];
        end;
      end;
  finally
    NodeList.Free;
    SList.Free;
  end;
  Result := tmpArray;
end;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  Exported Methods
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// ######################################################################################################################################
//  Discover - No Changes Needed
// ######################################################################################################################################

Procedure DISCOVER(var ADescription : PChar;var AVersion : PChar;var ARESTful : WordBool;var AURIVersion : Integer;var AServices : PPCharArray;var AMethods : PPCharArray); stdcall;
Var
  ModuleVersion     : string;
  ModuleDescription : string;
  ServicesXML       : TNativeXml;
  ResourceList      : PPCharArray;
  MethodList        : PPCharArray;
Begin
  ServicesXML := TNativeXml.Create(Nil);
  Try
    ServicesXML.ReadFromString(cServiceXML);
    ModuleDescription  := ServicesXML.Root.ReadString('DESCRIPTION','');
    ModuleVersion      := ServicesXML.Root.ReadString('VERSION','');
    ResourceList       := ExtractPCharArrayFromNodes(ServicesXML.Root, 'RESOURCE');
    MethodList         := ExtractPCharArrayFromNodes(ServicesXML.Root, 'METHOD');
  Finally
    ServicesXML.Free;
  End;

  ADescription  := @ModuleDescription[1];
  AVersion      := @ModuleVersion[1];
  ARESTful      := True;
  AURIVersion   := 1;
  AServices     := ResourceList;
  AMethods      := MethodList;
End;

// ######################################################################################################################################
//  Describe - No Changes Needed
// ######################################################################################################################################

Function DESCRIBE(AWillAccept: PChar) : PChar; stdcall;
var
  AcceptsHeader : String;
begin
  Logger.Log(llMinimal, cAppName + ' DESCRIBE');
  AcceptsHeader := AWillAccept;
  if AcceptsHeader.Contains('xml') then
    begin
      Result := PChar(cServiceXML);
    end
  else
    begin
      Result := PChar(cServiceJSON);
    end;
End;

// ######################################################################################################################################
//  Prepare - Change As Needed
// ######################################################################################################################################

Function PREPARE( AExePath : PChar ) : Integer; stdcall;
Var
  RootPath    : String;
  LogFilePath : string;
  IniFile     : string;
Begin
  // Note AExePath return the path to the server root for Prism "C:\ProgramData\RetailPro\" by default.

  LogFilePath := AExePath + 'Server\Logs\';
  IniFile     := AExePath + 'Server\conf\' + cAppName + '.ini';

  Logger := TLogger.Create;
  Logger.StartLogSession(cAppName,LogFilePath,IniFile);
  Logger.Log(llMinimal, cAppName + ' PREPARE');


  Result := 0; //0=Success | -1=Failure
End;

// ######################################################################################################################################
//  Change - Change As Needed
// ######################################################################################################################################

Function CONFIGURE(AMethod: PChar;Accepts: PChar;var AConfig: PChar): Integer; stdcall;
Begin
  Logger.Log(llMinimal, cAppName + ' CONFIGURE');
{
  AMethod - GET or PUT (GUT should return AConfig|PUT should update config with AConfig)
  Accepts - Payload format
  AConfig - Payload
}
  Result := 200; //HTTP Result Codes
End;

// ######################################################################################################################################
//  Cleanup - Change As Needed
// ######################################################################################################################################

Function CLEANUP : Integer; stdcall;
Begin
  Logger.Log(llMinimal, cAppName + ' CLEANUP');
  Logger.StopLogSession;
  Logger.Free;
  Result := -1; //-1=Success | 0=Failure
End;

// ######################################################################################################################################
//  DispatchRest - Change As Needed
// ######################################################################################################################################

Function DISPATCHREST(
  AHTTPVerb: PChar;
  AServiceName: PChar;
  AQualifiers: PChar;
  AParams: PPCharArray;
  ARequestHeaders: PPCharArray;
  ARequestCookies: PPCharArray;
  ARequestContentType: PChar;
  ARequestContentLength: Integer;
  ARequestContent: PChar;
  AWillAccept: PChar;
  AResponseContentHandle: THandle;
  AResponseHeaders: PChar;
  AResponseCookies: PChar
): Integer; stdcall;
Begin
  Logger.Log(llMinimal, cAppName + ' DISPATCHREST');
  Logger.Log(llNormal, 'Request: ' + AHTTPVerb + ' on ' + AServiceName);
End;

// ######################################################################################################################################
//  DispatchRPC - Change As Needed
// ######################################################################################################################################

Function DISPATCHRPC(
  ARequestHeaders        : PPCharArray;
  ARequestCookies        : PPCharArray;
  ARequestContentType    : PChar;
  ARequestContentLength  : Integer;
  ARequestContent        : PChar;
  AWillAccept            : PChar;
  AResponseContentHandle : THandle;
  AResponseHeaders       : PChar;
  AResponseCookies       : PChar
): Integer; stdcall;
Begin
  Logger.Log(llMinimal, cAppName + ' DISPATCHRPC');
  Logger.Log(llNormal, 'RPC Request: ' + ARequestContent);
End;


end.
