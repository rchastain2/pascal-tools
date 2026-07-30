
program Uploader;

uses
  SysUtils, Classes, ftpsend, ssl_openssl3, Configuration, SimpleLog;

const
  CDelay = 500;

var
  LConfigFilePath: string;
  LHost, LUserName, LPassword, LLocalDir: string;
  LFileListPath, LLocalFile, LRemoteFile: string;
  LFileList: TStringList;
  LFileIndex: integer;
  LFTPSend: TFTPSend;
  LLog: TSimpleLog;

begin
  LLog := TSimpleLog.Console;
  
  LConfigFilePath := GetUserDir + ChangeFileExt({$I %FILE%}, '.cfg');
  
  LLog.Debug('LConfigFilePath %s', [LConfigFilePath]);
  
  if FileExists(LConfigFilePath) then
  begin
    LoadConfiguration(LConfigFilePath, LHost, LUserName, LPassword, LLocalDir);
  end else
  begin
    LLog.Warning('Cannot find configuration file');
    SaveConfiguration(LConfigFilePath, 'msegui.net', 'pmwevymq', 'xxxx', '/home/roland/Documents/site');
    LLog.Info('Created configuration file %s', [LConfigFilePath]);
    LLog.Info('Please edit file and restart program');
    Exit;
  end;
  
  LLog.Debug('LHost %s', [LHost]);
  LLog.Debug('LUserName %s', [LUserName]);
  LLog.Debug('LPassword %s', [StringOfChar('*', Length(LPassword))]);
  LLog.Debug('LLocalDir %s', [LLocalDir]);
  
  LFileListPath := ParamStr(1);
  
  if not FileExists(LFileListPath) then
  begin
    LLog.Error('Cannot find file "%s"', [LFileListPath]);
    Exit;
  end;
  
  LFileList := TStringList.Create;
  LFileList.LoadFromFile(LFileListPath);
  
  LFTPSend := TFTPSend.Create;
  try
    LFTPSend.TargetHost := LHost;
    LFTPSend.TargetPort := CFtpProtocol;
    LFTPSend.UserName := LUserName;
    LFTPSend.Password := LPassword;
    LFTPSend.AutoTLS := TRUE;
    if LFTPSend.Login then
    begin
      LFileIndex := 0;
      
      while LFileIndex < LFileList.Count do
      begin
        LLocalFile := LFileList[LFileIndex];
        Inc(LFileIndex);
        
        if not FileExists(LLocalFile) then
        begin
          LLog.Warning('Cannot find file "%s"', [LLocalFile]);
          Continue;
        end;
        
        if Pos(LLocalDir, LLocalFile) = 0 then
        begin
          LLog.Warning('Cannot upload file "%s" (must be located in the mirror folder)', [LLocalFile]);
          Continue;
        end;
        
        LLog.Debug('LLocalFile "%s"', [LLocalFile]);
        
        LRemoteFile := Copy(LLocalFile, Succ(Length(LLocalDir)), Length(LLocalFile));
        
        LLog.Debug('LRemoteFile "%s"', [LRemoteFile]);
        
        LFTPSend.DirectFile := TRUE;
        LFTPSend.DirectFileName := LLocalFile;
        
        if LFTPSend.StoreFile(LRemoteFile, FALSE) then
        begin
          Sleep(CDelay);
        end else
        begin
          LLog.Error('Cannot upload file "%s"', [LLocalFile]);
          LLog.Error('ResultCode %d', [LFTPSend.ResultCode]);
          LLog.Error('ResultString "%s"', [LFTPSend.ResultString]);
          LFileIndex := LFileList.Count;
        end;
      end;
      
      LLog.Debug('Logout %d', [Ord(LFTPSend.Logout)]);
    end else
    begin
      LLog.Error('Cannot log in');
      LLog.Error('ResultCode %d', [LFTPSend.ResultCode]);
      LLog.Error('ResultString "%s"', [LFTPSend.ResultString]);
    end;
  finally
    LFTPSend.Free;
  end;
end.
