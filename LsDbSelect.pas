(*************************************************
**                                              **
**       Select database dialog component       **
**             Version 1.02.03/g0523            **
**  Copyright 2000-2023 Lagadrom Solutions Ltd  **
**              All rights reserved             **
**                                              **
*************************************************)

unit LsDbSelect;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  IB_Session,
  uConnect,
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

    keyDescription='Description';

type
  TLsDbSelect=class(TComponent)
  private
    FShowInRussian:boolean;
    // ---
    FPath:string;
    FServer:string;
    FProtocol:tIB_Protocol;
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
    procedure LoadCBoxes(aDlg:TfmConnect);
    procedure SaveCBoxes(aDlg:TfmConnect);
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
  LsStrings,
  RxStrUtils;

{$R LsDbSelect.res}

procedure Register;
begin
  RegisterComponents('LAGODROM components',[TLsDbSelect]);
end;

(*** ****************************** ***)

procedure TLsDbSelect.SetShowInRussian(Value:boolean);
begin
  if FShowInRussian <>Value then
    FShowInRussian:=Value;
end;

constructor TLsDbSelect.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);
  FFont:=tFont.Create;
  if Owner is tForm then
    FFont.Assign(tForm(Owner).Font);
  FIniSection:=secDatabase;
end;

destructor TLsDbSelect.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TLsDbSelect.SetPath(Value:string);
begin
  if FPath <>Value then FPath:=Value;
end;

procedure TLsDbSelect.SetServer(Value:string);
begin
  if FServer <>Value then FServer:=Value;
end;

procedure TLsDbSelect.SetProtocol(Value:tIB_Protocol);
begin
  if FProtocol <>Value then FProtocol:=Value;
end;

procedure TLsDbSelect.SetServerAndPath(Value:string);
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
  end;***)
end;

function TLsDbSelect.GetServerAndPath:string;
begin
  if FProtocol =cpLocal then begin
    Result:=FPath;
  end
  else begin
    (*Result:='\\'+FServer+'\'+FPath;*)
    Result:=FServer+':'+FPath;
  end;
end;

procedure TLsDbSelect.SetIniFileName(Value:string);
begin
  if FIniFileName <>Value then FIniFileName:=Value;
end;

procedure TLsDbSelect.SetIniSection(Value:string);
begin
  if FIniSection <>Value then FIniSection:=Value;
end;

procedure TLsDbSelect.SetUseRegistry(Value:boolean);
begin
  if FUseRegistry <>Value then FUseRegistry:=Value;
end;

procedure TLsDbSelect.SetRegistryRoot(Value:tPlacementRegRoot);
begin
  if FRegistryRoot <>Value then FRegistryRoot:=Value;
end;

procedure TLsDbSelect.SetCaption(Value:string);
begin
  if FCaption <>Value then FCaption:=Value;
end;

procedure TLsDbSelect.SetFont(Value:tFont);
begin
  FFont.Assign(Value);
end;

function TLsDbSelect.Execute:boolean;
var
  f:TfmConnect;

begin
  f:=TfmConnect.Create(Application);
  try
    { инициализация пропертей формы }
    if FShowInRussian then begin
      f.rgrpProtocol.Items[0]:='Локальный';
      f.rgrpProtocol.Items[1]:='Сетевой';
      f.rgrpProtocol.Hint:='Тип соединения';

      f.lblServer.Caption:='Сервер';
      f.cboxServer.Hint:='Сервер баз данных';

      f.btnServer.Hint:='Выбор сервера из списка доступных серверов';

      f.lblPath.Caption:='Имя БД';
      f.cboxPath.Hint:='Путь и имя БД';

      f.btnPath.Hint:='Выбор файла базы данных';

      f.btnCancel.Caption:='Отмена';
    end;

    f.Caption:=FCaption;
    f.Server:=FServer;
    f.Path:=FPath;
    f.Protocol:=FProtocol;
    f.Font:=FFont;
    LoadCBoxes(f);
    Result:=f.ShowModal =mrOk;

    if Result then begin
      FProtocol:=f.Protocol;
      FServer:=f.Server;
      FPath:=f.Path;
      SaveCBoxes(f);
    end;
  finally
    f.Free;
  end;
end;

procedure TLsDbSelect.LoadCBoxes(aDlg:TfmConnect);
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
    with aDlg do begin
      rgrpProtocol.ItemIndex:=fIni.ReadInteger(FIniSection,keyLastProtocol,0);
      if rgrpProtocol.ItemIndex <>0 then
        cboxServer.Text:=fIni.ReadString(FIniSection,keyLastServerName,'');
      cboxPath.Text:=fIni.ReadString(FIniSection,keyLastDatabaseName,'');
    end;
  finally
    fIni.Free;
  end;
end;

procedure TLsDbSelect.SaveCBoxes(aDlg:TfmConnect);
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
    fIni.WriteString(FIniSection,keyLastServerName,aDlg.cboxServer.Text);
    fIni.WriteString(FIniSection,keyLastDatabaseName,aDlg.cboxPath.Text);
  finally
    fIni.Free;
  end;
end;

end.
