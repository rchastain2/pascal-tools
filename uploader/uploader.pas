
program Uploader;

uses
  SysUtils, Classes, ftpsend, ssl_openssl3, Configuration;

var
  LConfigFilePath: string;
  LHost, LUserName, LPassword, LLocalDir: string;
  LFileListPath, LLocalFile{, LRemoteDir}, LRemoteFile: string;
  LFileList: TStringList;
  LFileIndex: integer;
  LFTPSend: TFTPSend;

begin
  LConfigFilePath := GetUserDir + ChangeFileExt({$I %FILE%}, '.cfg');
  
  WriteLn('[DEBUG] LConfigFilePath ', LConfigFilePath);
  
  if FileExists(LConfigFilePath) then
  begin
    LoadConfiguration(LConfigFilePath, LHost, LUserName, LPassword, LLocalDir);
  end else
  begin
    WriteLn('[WARNING] Cannot find configuration file');
    SaveConfiguration(LConfigFilePath, 'msegui.net', 'pmwevymq', 'xxxx', '/home/roland/Documents/site');
    WriteLn('[INFO] Created configuration file ', LConfigFilePath);
    WriteLn('[INFO] Please edit file and restart program');
    Exit;
  end;
  
  WriteLn('[DEBUG] LHost ', LHost);
  WriteLn('[DEBUG] LUserName ', LUserName);
  WriteLn('[DEBUG] LPassword ', StringOfChar('*', Length(LPassword)));
  WriteLn('[DEBUG] LLocalDir ', LLocalDir);
  
  LFileListPath := ParamStr(1);
  
  if not FileExists(LFileListPath) then
  begin
    WriteLn('[ERROR] Cannot find file "', LFileListPath, '"');
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
          WriteLn('[WARNING] Cannot find file "', LLocalFile, '"');
          Continue;
        end;
        
        if Pos(LLocalDir, LLocalFile) = 0 then
        begin
          WriteLn('[WARNING] Cannot upload file "', LLocalFile, '" (must be located in the mirror folder)');
          Continue;
        end;
        
        WriteLn('[DEBUG] LLocalFile "', LLocalFile, '"');
        
        //LRemoteDir := ExtractFileDir(LLocalFile);
        //Delete(LRemoteDir, 1, Length(LLocalDir));
        //
        //WriteLn('[DEBUG] LRemoteDir ', LRemoteDir);
        
        LRemoteFile := Copy(LLocalFile, Succ(Length(LLocalDir)), Length(LLocalFile));
        
        WriteLn('[DEBUG] LRemoteFile "', LRemoteFile, '"');
        
        //if LFTPSend.ChangeWorkingDir(LRemoteDir) then
        //begin
        //  WriteLn('[DEBUG] Current directory ', LFTPSend.GetCurrentDir);
          
          LFTPSend.DirectFile := TRUE;
          LFTPSend.DirectFileName := LLocalFile;
          
          if not LFTPSend.StoreFile({ExtractFileName(LLocalFile)}LRemoteFile, FALSE) then
          begin
            WriteLn('[ERROR] Cannot upload file "', LLocalFile, '"');
            WriteLn('[ERROR] ResultCode ', LFTPSend.ResultCode);
            WriteLn('[ERROR] ResultString "', LFTPSend.ResultString, '"');
            LFileIndex := LFileList.Count;
          end;
        //end else
        //begin
        //  WriteLn('[ERROR] Cannot change directory to "', LRemoteDir, '"');
        //  WriteLn('[ERROR] ResultCode ', LFTPSend.ResultCode);
        //  WriteLn('[ERROR] ResultString "', LFTPSend.ResultString, '"');
        //  LFileIndex := LFileList.Count;
        //end;
      end;
      
      WriteLn('[DEBUG] Logout ', LFTPSend.Logout);
    end else
    begin
      WriteLn('[ERROR] Cannot log in');
      WriteLn('[ERROR] ResultCode ', LFTPSend.ResultCode);
      WriteLn('[ERROR] ResultString "', LFTPSend.ResultString, '"');
    end;
  finally
    LFTPSend.Free;
  end;
end.
