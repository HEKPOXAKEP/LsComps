(*************************************************
**                                              **
**  Extended select database dialog component   **
**             Version 1.01.01/g0523            **
**  Copyright 2000-2023 LAGADROM Solutions Ltd  **
**              All rights reserved             **
**                                              **
*************************************************)

unit LsDbSelectEx;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  IB_Session,
  uConnectEx,
  Placemnt,
  IniFiles;

const
  { config sections/keys names }
  secDatabase='Database';
    keyServerCount='ServerCount';
    keyServerName='ServerName';

    keyDatabaseCount='DatabaseCount';
    keyDatabaseName='DatabaseName';

    keyLastProtocol='LastProtocol';
    keyLastServerName='LastServerName';
    keyLastDatabaseName='LastDatabaseName';
    keyLastUserName='LastUserName';
    keyLastDialect='LastDialect';

    keyDescription='Description';

type
  TLsDbSelectEx=class(TComponent)
  private
    FShowInRussian:boolean;
    // ---
    FPath:string;
    FServer:string;
    FProtocol:tIB_Protocol;
    FUserName:string;
    FPassword:string;
    FDialect:integer;
    // --- published props
    FIniFileName:string;
    FIniSection:string;
    FUseRegistry:boolean;
    FRegistryRoot:tPlacementRegRoot;
    FCaption:string;
    FFont:tFont;
  protected
    procedure SetShowInRussian(Value:boolean);
    procedure SetPath(Value:string);
    procedure SetServer(Value:string);
    procedure SetProtocol(Value:tIB_Protocol);
    procedure SetServerAndPath(Value:string);
    function GetServerAndPath:string;
    procedure SetIniFileName(Value:string);
    procedure SetIniSection(Value:string);
    procedure SetUseRegistry(Value:boolean);
    procedure SetRegistryRoot(Value:tPlacementRegRoot);
    procedure SetCaption(Value:string);
    procedure SetFont(Value:tFont);
    procedure LoadCBoxes(aDlg:TfmConnectEx);
    procedure SaveCBoxes(aDlg:TfmConnectEx);
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    // --- public methods
    function Execute:boolean;
    // --- public properties
    property Path:string read FPath write SetPath;
    property Server:string read FServer write SetServer;
    property Protocol:tIB_Protocol read FProtocol write SetProtocol;
    property ServerAndPath:string read GetServerAndPath write SetServerAndPath;
    property UserName:string read FUserName write FUserName;
    property Password:string read FPassword write FPassword;
    property Dialect:integer read FDialect write FDialect;
  published
    property ShowInRussian:boolean read FShowInRussian write SetShowInRussian;
    // ---
    property IniFileName:string read FIniFileName write SetIniFileName;
    property IniSection:string read FIniSection write SetIniSection;
    property UseRegistry:boolean read FUseRegistry write SetUseRegistry;
    property RegistryRoot:tPlacementRegRoot read FRegistryRoot write SetRegistryRoot;
    property Caption:string read FCaption write SetCaption;
    property Font:tFont read FFont write SetFont;
  end;

procedure Register;

implementation

uses
  RxStrUtils,
  LsStrings,
  LsDbSelectEx_Const;

{$R LsDbSelectEx.res}
{$R LsDbSelectEx_Str.res}

procedure Register;
begin
  RegisterComponents('LAGODROM components',[TLsDbSelectEx]);
end;

(*** ****************************** ***)

procedure TLsDbSelectEx.SetShowInRussian(Value:boolean);
begin
  if FShowInRussian <>Value then
    FShowInRussian:=Value;
end;

constructor TLsDbSelectEx.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);
  FFont:=tFont.Create;
  if Owner is tForm then
    FFont.Assign(tForm(Owner).Font);
  FIniSection:=secDatabase;
end;

destructor TLsDbSelectEx.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TLsDbSelectEx.SetPath(Value:string);
begin
  if FPath <>Value then FPath:=Value;
end;

procedure TLsDbSelectEx.SetServer(Value:string);
begin
  if FServer <>Value then FServer:=Value;
end;

procedure TLsDbSelectEx.SetProtocol(Value:tIB_Protocol);
begin
  if FProtocol <>Value then FProtocol:=Value;
end;

procedure TLsDbSelectEx.SetServerAndPath(Value:string);
begin
  if Value <>'' then begin
    if NPos(':',Value,2) <>0 then begin
      FProtocol:=cpTCP_IP;
      FServer:=ExtractWord(1,Value,[':']);
      FPath:=copy(Value,Pos(':',Value)+1,666);
    end
    else begin
      FProtocol:=cpLocal;
      FServer:='';
      FPath:=Value;
    end;
  end
  else begin
    FProtocol:=cpLocal;
    FServer:='';
    FPath:='';
  end;
  (***
  if Value <>'' then begin
   if copy(Value,1,2) ='\\' then begin
    FProtocol:=cpTCP_IP;
    FServer:=ExtractWord(1,Value,['\']);
    FPath:=copy(Value,NPos('\',Value,3)+1,666);
   end
   else begin
    FProtocol:=cpLocal;
    FServer:='';
    FPath:=Value;
   end;
  end
  else begin
   FProtocol:=cpLocal;
   FServer:='';
   FPath:='';
  end;
  ***)
end;

function TLsDbSelectEx.GetServerAndPath:string;
begin
  if FProtocol =cpLocal then begin
    Result:=FPath;
  end
  else begin
    (*Result:='\\'+FServer+'\'+FPath;*)
    Result:=FServer+':'+FPath;
  end;
end;

procedure TLsDbSelectEx.SetIniFileName(Value:string);
begin
  if FIniFileName <>Value then FIniFileName:=Value;
end;

procedure TLsDbSelectEx.SetIniSection(Value:string);
begin
  if FIniSection <>Value then FIniSection:=Value;
end;

procedure TLsDbSelectEx.SetUseRegistry(Value:boolean);
begin
  if FUseRegistry <>Value then FUseRegistry:=Value;
end;

procedure TLsDbSelectEx.SetRegistryRoot(Value:tPlacementRegRoot);
begin
  if FRegistryRoot <>Value then FRegistryRoot:=Value;
end;

procedure TLsDbSelectEx.SetCaption(Value:string);
begin
  if FCaption <>Value then FCaption:=Value;
end;

procedure TLsDbSelectEx.SetFont(Value:tFont);
begin
  FFont.Assign(Value);
end;

function TLsDbSelectEx.Execute:boolean;
var
  f:TfmConnectEx;

begin
  f:=TfmConnectEx.Create(Application);
  try
    { инициализация пропертей формы }
    if FShowInRussian then begin
      f.rgrpProtocol.Items[0]:=LoadStr(SrgrpProtocol0);
      f.rgrpProtocol.Items[1]:=LoadStr(SrgrpProtocol1);
      f.rgrpProtocol.Hint:=LoadStr(SrgrpProtocol_Hint);

      f.lblServer.Caption:=LoadStr(SlblServer);
      f.cboxServer.Hint:=LoadStr(ScboxServer_Hint);

      f.btnServer.Hint:=LoadStr(SbtnServer_Hint);

      f.lblPath.Caption:=LoadStr(SlblPath);
      f.cboxPath.Hint:=LoadStr(ScboxPath_Hint);

      f.btnPath.Hint:=LoadStr(SbtnPath_Hint);

      f.edUser.Hint:=LoadStr(SedUser_Hint);

      f.edPassword.Hint:=LoadStr(SedPassword_Hint);

      f.lblDialect.Caption:=LoadStr(SlblDialect);
      f.cboxDialect.Hint:=LoadStr(ScboxDialect_Hint);

      f.btnCancel.Caption:=LoadStr(SbtnCancel);
    end; (*IF ShowInRussian*)

    LoadCBoxes(f);
    f.Caption:=FCaption;
    f.Font:=FFont;

    Result:=f.ShowModal =mrOk;

    if Result then begin
      FProtocol:=f.Protocol;
      FServer:=f.Server;
      FPath:=f.Path;
      FUsername:=f.Username;
      FPassword:=f.Password;
      SaveCBoxes(f);
    end;
  finally
    f.Free;
  end;
end;

procedure TLsDbSelectEx.LoadCBoxes(aDlg:TfmConnectEx);
var
  fIni:tIniFile;
  i,z:integer;
  s:string;

begin
  if (FIniFileName ='') or (FIniSection ='') then exit;

  fIni:=tIniFile.Create(FIniFileName);
  try
    { загружаем список серверов }
    z:=fIni.ReadInteger(FIniSection,keyServerCount,0);
    for i:=1 to z do begin
      s:=fIni.ReadString(FIniSection,keyServerName+IntToStr(i-1),'');
      if (s <>'') and (aDlg.cboxServer.Items.IndexOf(s) =-1) then
        aDlg.cboxServer.Items.Add(s);
    end;

    { загружаем список баз данных }
    z:=fIni.ReadInteger(FIniSection,keyDatabaseCount,0);
    for i:=1 to z do begin
      s:=fIni.ReadString(FIniSection,keyDatabaseName+IntToStr(i-1),'');
      if (s <>'') and (aDlg.cboxPath.Items.IndexOf(s) =-1) then
        aDlg.cboxPath.Items.Add(s);
    end;

    i:=fIni.ReadInteger(FIniSection,keyLastProtocol,0);
    if i <>0 then begin
      aDlg.Protocol:=cpTCP_IP;
      aDlg.Server:=fIni.ReadString(FIniSection,keyLastServerName,'');
    end
    else
      aDlg.Protocol:=cpLocal;

    aDlg.Path:=fIni.ReadString(FIniSection,keyLastDatabaseName,'');

    aDlg.Username:=fIni.ReadString(FIniSection,keyLastUserName,'');

    aDlg.Dialect:=fIni.ReadInteger(FIniSection,keyLastDialect,0);
  finally
    fIni.Free;
  end; (*TRY*)
end;

procedure TLsDbSelectEx.SaveCBoxes(aDlg:TfmConnectEx);
var
  fIni:tIniFile;
  i:integer;

begin
  if (FIniFileName ='') or (FIniSection ='') then exit;
  fIni:=tIniFile.Create(FIniFileName);

  try
    fIni.EraseSection(FIniSection);

    { записываем список серверов }
    fIni.WriteInteger(FIniSection,keyServerCount,aDlg.cboxServer.Items.Count);
    for i:=0 to aDlg.cboxServer.Items.Count-1 do
      fIni.WriteString(FIniSection,keyServerName+IntToStr(i),aDlg.cboxServer.Items[i]);

    { записываем список баз данных }
    fIni.WriteInteger(FIniSection,keyDatabaseCount,aDlg.cboxPath.Items.Count);
    for i:=0 to aDlg.cboxPath.Items.Count-1 do
      fIni.WriteString(FIniSection,keyDatabaseName+IntToStr(i),aDlg.cboxPath.Items[i]);

    { записываем параметры последнего соединения }
    fIni.WriteInteger(FIniSection,keyLastProtocol,aDlg.rgrpProtocol.ItemIndex);
    fIni.WriteString(FIniSection,keyLastServerName,aDlg.Server);
    fIni.WriteString(FIniSection,keyLastDatabaseName,aDlg.Path);
    fIni.WriteString(FIniSection,keyLastUserName,aDlg.Username);
    fIni.WriteInteger(FIniSection,keyLastDialect,aDlg.cboxDialect.ItemIndex);
  finally
    fIni.Free;
  end; (*TRY*)
end;

end.
