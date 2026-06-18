#define MyAppName "Gob"
#ifndef MyAppVersion
  #define MyAppVersion "0.0.1"
#endif
#define MyAppPublisher "Luqadda Gob"
#define MyAppURL "https://github.com/Luqadda-Gob/gob"
#define MyAppExeName "gob.exe"

[Setup]
AppId={{E781AB52-1350-4B5A-B0AA-96015B895447}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={localappdata}\Programs\Gob
DisableProgramGroupPage=yes
LicenseFile=..\..\LICENSE
OutputDir=..\..\target\installer
OutputBaseFilename=gob-{#MyAppVersion}-windows-setup
SetupIconFile=..\..\assets\windows\gob.ico
WizardSmallImageFile=..\..\assets\windows\gob-wizard-small.bmp
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesAssociations=yes
ChangesEnvironment=yes
UninstallDisplayIcon={app}\gob.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
SetupWindowTitle=Dejinta %1
WelcomeLabel1=Kusoo dhawoow Gob
WelcomeLabel2=Dejintu waxay ku daji doontaa [name] [ver] kombiyuutarkaaga.%n%nXidho barnaamijyada kale ka hor inta aadan sii wadin.
LicenseLabel=Fadlan akhriso license-ka.
LicenseLabel3=Akhriso shuruudaha si aad u dejisato [name].
LicenseAccepted=Waan &aqbalay
LicenseNotAccepted=&Ma aqbalin
SelectDirDesc=Xulo halka lagu dajinayo
SelectDirLabel3=Fadlan xulo halka lagu dajinayo.
SelectDirBrowseLabel=Si aad u sii wadato, riix Xiga. Haddaad rabto gal kale, riix Raadso.
SelectTasksDesc=Xulo hawlaha dheeraadka ah
SelectTasksLabel2=Xulo hawlaha dheeraadka ah, kadibna riix Xiga.
ReadyLabel1=Diyaar
ReadyLabel2a=Riix Deji si aad usii socoto.
ReadyMemoTasks=Hawlaha dheeraadka ah:
InstallingLabel=Lagu guda jiraa...
FinishedHeadingLabel=Dhammaynta Dejinta [name]
FinishedLabel=[name] si guul leh ayaa lagu dajiyay kombiyuutarkaaga.
FinishedRestartLabel=Si aad u dhammaystirto rakibidda [name], kombiyuutarkaagu waa inuu dib u bilaabmaa. Ma rabtaa inaad hadda dib u bilaabato?
ButtonBack=< &Dib
ButtonNext=&Xiga >
ButtonInstall=&Deji
ButtonFinish=&Dhammee
ButtonCancel=Jooji
ButtonBrowse=&Raadso...
ButtonYes=&Haa
ButtonNo=&Maya
ConfirmUninstall=Ma hubta inaad rabto misixitaanka %1?
UninstallStatusLabel=Laga saari jiraa %1...
UninstalledAll=%1 si guul leh ayaa looga saaray.
UninstalledMost=Saarista %1 waa la dhammaystay. Qaar ka mid ah walxaha lama saari karin si toos ah.

[Tasks]
Name: "desktopicon"; Description: "Ku dar shortcut-ka Gob Desktop-ka"; GroupDescription: "Shortcut-yo dheeraad ah:"; Flags: unchecked
Name: "fileassociation"; Description: "Ku fur files-ka ku dhamaada .gob"; GroupDescription: "Faylasha:"

[Files]
Source: "..\..\target\native\gob.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\assets\windows\gob.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\Gob Prompt"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--qor"; WorkingDir: "{userdocs}"; IconFilename: "{app}\gob.ico"
Name: "{autodesktop}\Gob Prompt"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--qor"; WorkingDir: "{userdocs}"; IconFilename: "{app}\gob.ico"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Software\Classes\.gob"; ValueType: string; ValueName: ""; ValueData: "Gob.Source"; Flags: uninsdeletevalue; Tasks: fileassociation
Root: HKCU; Subkey: "Software\Classes\Gob.Source"; ValueType: string; ValueName: ""; ValueData: "Gob source file"; Flags: uninsdeletekey; Tasks: fileassociation
Root: HKCU; Subkey: "Software\Classes\Gob.Source\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\gob.ico"; Tasks: fileassociation
Root: HKCU; Subkey: "Software\Classes\Gob.Source\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" --file ""%1"""; Tasks: fileassociation

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "--qor"; Description: "Fur Gob"; Flags: nowait postinstall skipifsilent unchecked

[Code]
procedure AddToPath(AppDir: string);
var
  Path: string;
begin
  if not RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Path) then
    Path := '';
  if Pos(Lowercase(AppDir), Lowercase(Path)) > 0 then Exit;
  if (Length(Path) > 0) and (Path[Length(Path)] <> ';') then
    Path := Path + ';';
  RegWriteExpandStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Path + AppDir);
end;

procedure RemoveFromPath(AppDir: string);
var
  Path: string;
  P: Integer;
begin
  if not RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Path) then Exit;
  P := Pos(Lowercase(AppDir), Lowercase(Path));
  if P = 0 then Exit;
  Delete(Path, P, Length(AppDir));
  StringChangeEx(Path, ';;', ';', True);
  if (Length(Path) > 0) and (Path[1] = ';') then Delete(Path, 1, 1);
  if (Length(Path) > 0) and (Path[Length(Path)] = ';') then Delete(Path, Length(Path), 1);
  RegWriteExpandStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Path);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    AddToPath(ExpandConstant('{app}'));
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RemoveFromPath(ExpandConstant('{app}'));
end;
