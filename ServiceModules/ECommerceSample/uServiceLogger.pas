unit uServiceLogger;

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
    System.Classes
  , System.SyncObjs
  ;

type
  TLogLevel =
    (
      llNone,
      llMinimal,
      llNormal,
      llVerbose
    );

  TLogger = class(TPersistent)
  private
    FBuffer               : TStringList;
    FLogBufferSize        : Integer;
    FSettingsINIFile      : string;
    FLogLevel             : TLogLevel;
    FLogRetentionCount    : Integer;
    FActive               : Boolean;
    FLogFileDir           : string;
    FAppName              : string;
    FLogCS                : TCriticalSection;
  private

  protected

    //Internal Methods
    Procedure LogBufferContents;
    Procedure ReadINIFile;virtual;
    function GetLogFileName( ADate : TDateTime = 0 ) : string;

    //Internal Properties
    Property Buffer: TStringList read FBuffer write FBuffer;

  public
    //Instance Methods
    Constructor Create;
    Destructor Destroy; override;

    //Required - Set in StartLogSession...
    Property AppName: string read FAppName;
    Property SettingsINIFile: string read FSettingsINIFile;
    Property LogFileDir: string read FLogFileDir;
    Property Active: Boolean read FActive;

    //Should come from ini file but can be specified manually.
    Property LogLevel: TLogLevel read FLogLevel write FLogLevel;
    Property LogRetentionCount:Integer read FLogRetentionCount write FLogRetentionCount;
    property LogBufferSize: Integer read FLogBufferSize write FLogBufferSize;

    //Logging Methods
    Procedure StartLogSession(AAppName: string; ALogFileDir: String; AINIFile: string = '');virtual;
    procedure LogStartupInfo;
    procedure Log(Level: TLogLevel; Msg: string); overload;
    Procedure StopLogSession;virtual;
    Procedure FlushBuffer;

    //Log Maintance Methods
    Procedure TruncateLogs( ANumToPreserve : Integer );virtual;
    Procedure ClearLogs;virtual;
  end;

var
  Logger: TLogger;

implementation

uses
    System.SysUtils
  , System.IniFiles
  , Winapi.Windows
  ;

var
  LastLogDate     : TDatetime = 0;
  LastLogFilename : String = '';

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  TLogger
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// ######################################################################################################################################
//  Internal Methods
// ######################################################################################################################################

procedure TLogger.ReadINIFile;
Var
  tmpLogLevel: Integer;
  INIFile: TIniFile;
begin
  FLogLevel := llNone;
  FLogRetentionCount := -1;
  FLogBufferSize := 50;

  if FSettingsINIFile <> '' then
    begin
      if FileExists(FSettingsINIFile) then
        begin
          INIFile := TIniFile.Create( FSettingsINIFile );
          try
            if INIFile.SectionExists( 'LOG' ) then
              begin
                tmpLogLevel            := INIFile.ReadInteger( 'LOG', 'LogLevel', Ord( LogLevel ) );
                FLogRetentionCount     := INIFile.ReadInteger( 'LOG', 'RetentionCount', -1 );
                FLogBufferSize         := INIFile.ReadInteger( 'LOG', 'BufferSize', 0 );

                if ( tmpLogLevel < Ord( Low( TLogLevel ) ) ) then
                  tmpLogLevel := Ord( Low( TLogLevel ) )
                else if ( tmpLogLevel > Ord( High( TLogLevel ) ) ) then
                  tmpLogLevel := Ord( High( TLogLevel ) );

                FLogLevel := TLogLevel( tmpLogLevel );
              end;
          finally
            INIFile.Free;
          end;
        end;
    end;
end;

function TLogger.GetLogFileName(ADate: TDateTime): string;
Var
  ID: string;
begin

  if ( ADate = 0 ) then
    ADate := trunc( Now );

  if ( ADate = LastLogDate ) then
    Result := LastLogFilename
  else
    begin
      ID := FAppName + '_';
      Result := IncludeTrailingPathDelimiter(FLogFileDir) + ID + FormatDateTime('yymmdd', ADate) + '.log';
      LastLogDate := ADate;
      LastLogFilename := result;
    end;
end;

procedure TLogger.LogBufferContents;
var
  FileStream     : TFileStream;
  Line           : string;
  Str            : UTF8String;
  Counter        : Integer;
  tmpLogFileName : String;
begin
  FileStream  := NIL;
  if ( FActive ) then
  begin
    FLogCS.Enter;
    try
      try
        try
          tmpLogFileName := GetLogFilename;
          if ( FileExists( tmpLogFileName ) ) then
            FileStream := TFileStream.Create( tmpLogFileName, fmOpenReadWrite or fmShareDenyNone)
          else
            begin
              Line := 'Timestamp                Thread  Message' + #13#10 +
                      '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+ #13#10;
              Str := UTF8Encode(Line);
              FileStream := TFileStream.Create(tmpLogFileName, fmCreate or fmShareDenyNone);
              FileStream.Write(Pointer(Str)^, Length(Line));
            end;

          for Counter := 0 to Pred(FBuffer.Count) do
          begin
            Line := FBuffer[Counter];
            Str := UTF8Encode(Line);
            FileStream.Seek(0,soFromEnd);
            FileStream.Write(Pointer(Str)^, Length(Line));
          end;
          FBuffer.Clear;

        finally
          if ( FileStream <> NIL ) then
            FileStream.Free;
        end;

      except
        on E:Exception do
        begin
          FActive := ( not ( not FActive ) );
        end;
      end;
    finally
      FLogCS.Leave;
    end;
  end;
end;



// ######################################################################################################################################
//  Instance Methods
// ######################################################################################################################################

constructor TLogger.Create;
begin
  FActive := FALSE;
  FLogRetentionCount := 0;
  FLogLevel := llNone;
  FBuffer := TStringList.Create;
  FLogCS := TCriticalSection.Create;
end;

destructor TLogger.Destroy;
begin
  FBuffer.Free;
  FLogCS.Free;
  inherited;
end;


// ######################################################################################################################################
//  Logging Methods
// ######################################################################################################################################

procedure TLogger.StartLogSession(AAppName, ALogFileDir, AINIFile: string);
var
  tmpLogFilename : String;
  FileHeader     : string;
begin
  //Check for minimal requirements...
  if ( ( AAppName <> '') and ( ALogFileDir <> '' ) and ( not FActive ) ) then
    begin
      //Assign the internal fields.
      FAppName := AAppName;
      FLogFileDir := IncludeTrailingPathDelimiter( ALogFileDir );
      FSettingsINIFile := AINIFile;

      //Read persistent values
      ReadINIFile;
      if ( LogLevel > llNone ) then
        begin

          //Create the diectory if needed
          ForceDirectories( FLogFileDir );

          //Everything is ok start the logging...
          FActive := TRUE;
          Log(llMinimal,AAppName + ' Log Session Started ################################################################################');
          LogStartupInfo;
        end;
    end;
end;

procedure TLogger.LogStartupInfo;
var
  tmpStr: string;
  tmpProcessID: DWORD;
begin
  tmpStr := GetModuleName(0);
  if tmpStr <> '' then
    Log(llMinimal, 'Process: ' + tmpStr);

  tmpProcessID := GetCurrentProcessId;
  Log(llMinimal, 'ProcessID: ' + IntToStr(tmpProcessID));
end;

procedure TLogger.Log(Level: TLogLevel; Msg: string);
var
  tmpLogLine      : string;
  tmpLogFileName  : string;
  tmpThreadId     : DWORD;
begin
  tmpThreadId := GetCurrentThreadId;
  if ( ( FActive ) and ( Level <= FLogLevel ) ) then
    begin
      Msg := StringReplace(Msg,#13#10,'[CR][LF]',[rfReplaceAll]);

      tmpLogLine := FormatDateTime('YYYY.MM.DD.HH.NN.SS.ZZZ',Now);
      tmpLogLine := tmpLogLine + '  ' + IntToStr(tmpThreadId) + '    ';
      FBuffer.Add( tmpLogLine + Msg + #13#10 );

      if (FBuffer.Count >= FLogBufferSize) then
      begin
        FLogCS.Leave;
        try
          LogBufferContents;
        finally
          FLogCS.Enter;
        end;
      end;
    end;
end;

procedure TLogger.StopLogSession;
begin
  Sleep( 250 );
  Log( llMinimal,FAppName + ' Log Session Stopped ================================================================================' );
  LogBufferContents;
  FLogLevel := llNone;
  FActive := FALSE;
  if FLogRetentionCount <> -1 then
    TruncateLogs(FLogRetentionCount);
end;

procedure TLogger.FlushBuffer;
begin
  Log( llMinimal,'Force writing log buffer.' );
  LogBufferContents;
end;


// ######################################################################################################################################
//  Log Maintance Methods
// ######################################################################################################################################

procedure TLogger.TruncateLogs(ANumToPreserve: Integer);
var
  List   : TStringList;
  SR     : TSearchRec;
  rstat  : Integer;
  x      : Integer;
  LogDir : String;
begin
  List := TStringList.Create;
  try
    List.Sorted := TRUE;
    LogDir := FLogFileDir;
    rstat := FindFirst( LogDir + FAppName + '*.log', $3F, SR );
    while ( rstat = 0 ) do
    begin
      List.Add( SR.Name );
      rstat := FindNext( SR );
    end;
    System.SysUtils.FindClose(SR);
    for x := 0 to ( List.Count-ANumToPreserve-1 ) do
      try System.SysUtils.DeleteFile( LogDir + List[ x ] ); except end;
  finally
    FreeAndNIL( List );
  end;
end;

procedure TLogger.ClearLogs;
begin
  TruncateLogs( 0 );
end;


end.
