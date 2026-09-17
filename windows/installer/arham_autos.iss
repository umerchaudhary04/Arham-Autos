[Setup]
AppName=Arham Autos Desktop Suite
AppVersion=1.0.0
AppPublisher=Arham Autos
DefaultDirName={autopf}\Arham Autos Desktop Suite
DefaultGroupName=Arham Autos
OutputDir=..\..\build\windows\installer
OutputBaseFilename=ArhamAutosSetup
Compression=lzma2/ultra64
SolidCompression=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
UninstallDisplayIcon={app}\arham_autos.exe

[Dirs]
; Create APPDATA directory explicitly to ensure it exists for the app database and logs
Name: "{userappdata}\ArhamAutos"; Permissions: users-modify

[Files]
; Core application binaries
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; PowerShell script for legacy migration wizard
Source: "..\..\scripts\extract_accdb.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion

[Icons]
Name: "{group}\Arham Autos"; Filename: "{app}\arham_autos.exe"
Name: "{commondesktop}\Arham Autos"; Filename: "{app}\arham_autos.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  Result := True;
  
  // Check if ACE OLEDB (Access Database Engine 2016 64-bit) is installed.
  // The registry key is used to detect its presence.
  if not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Office\16.0\Access Connectivity Engine\InstallRoot') then
  begin
    if MsgBox('The Microsoft Access Database Engine 2016 Redistributable (64-bit) is required for the Legacy Import Wizard but is not installed. Do you want to download and install it now?', mbConfirmation, MB_YESNO) = idYes then
    begin
      // ShellExecute to launch the download page.
      ShellExec('open', 'https://www.microsoft.com/en-us/download/details.aspx?id=54920', '', '', SW_SHOW, ewNoWait, ResultCode);
      MsgBox('Please install the Access Database Engine and then run this setup again.', mbInformation, MB_OK);
      Result := False;
    end
    else
    begin
      MsgBox('The Legacy Import Wizard will fail without the Access Database Engine. You can still use the core application.', mbInformation, MB_OK);
      Result := True;
    end;
  end;
end;
