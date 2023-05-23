(*************************************************
**                                              **
**            Select Database dialog            **
**           for LsDbSelect component           **
**  Copyright 2000-2023 Lagodrom Solutions Ltd  **
**     Portion copyright 1999-2000 OLIS jsc     **
**             All rights reserved              **
**                                              **
*************************************************)

unit uConnect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, IB_Session, FileUtil, ScktComp, ComCtrls,
  ExtCtrls;

type
  TfmConnect = class(TForm)
    cboxPath: TComboBox;
    lblPath: TLabel;
    lblServer: TLabel;
    cboxServer: TComboBox;
    btnServer: TButton;
    btnPath: TButton;
    OpenDialog: TOpenDialog;
    Socket: TClientSocket;
    rgrpProtocol: TRadioGroup;
    Bevel1: TBevel;
    Image1: TImage;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rgrpProtocolClick(Sender: TObject);
    procedure btnServerClick(Sender: TObject);
    procedure btnPathClick(Sender: TObject);
    procedure SocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    Path,Server,Buf:string;
    Protocol:TIB_Protocol;
  end;

implementation

uses
 uBrowseDlg;

{$R *.DFM}

procedure TfmConnect.btnOkClick(Sender: TObject);
begin
  if (Trim(cboxServer.Text) ='') and
     (rgrpProtocol.ItemIndex =1) then begin
    Application.MessageBox('Не выбран сервер','Ошибка',MB_OK+MB_ICONERROR);
    ModalResult:=mrNone;
    exit;
  end
  else
    Server:=cboxServer.Text;

  if Trim(cboxPath.Text) ='' then begin
    Application.MessageBox('Не выбрана база данных','Ошибка',MB_OK+MB_ICONERROR);
    ModalResult:=mrNone;
    exit;
  end
  else
    Path:=cboxPath.Text;

  if rgrpProtocol.ItemIndex =0 then Protocol:=cpLocal
  else Protocol:=cpTCP_IP;

  if (cboxPath.Text <>'') and
     (cboxPath.Items.IndexOf(cboxPath.Text) =-1) then
    cboxPath.Items.Insert(0,cboxPath.Text);

  if (cboxServer.Text <>'') and
     (cboxServer.Items.IndexOf(cboxServer.Text) =-1) then
    cboxServer.Items.Insert(0,cboxServer.Text);

  ModalResult:=mrOk;
end;

procedure TfmConnect.FormActivate(Sender: TObject);
begin
  rgrpProtocol.Enabled:=True;
  if Protocol=cpLocal then
    rgrpProtocol.ItemIndex:=0
  else
    if rgrpProtocol.Enabled then
      rgrpProtocol.ItemIndex:=1
    else
      rgrpProtocol.ItemIndex:=0;

  rgrpProtocolClick(nil);
  Buf:='';
end;

procedure TfmConnect.btnServerClick(Sender: TObject);
var
  s:string;

begin
  s:=cboxServer.Text;
  if BrowseComputer(s,'Выберите сервер:',0) then cboxServer.Text:=s;
  cboxServer.SetFocus;
end;

procedure TfmConnect.rgrpProtocolClick(Sender: TObject);
begin
  cboxServer.Enabled:=rgrpProtocol.ItemIndex <>0;
  lblServer.Enabled:=rgrpProtocol.ItemIndex <>0;
  btnServer.Enabled:=rgrpProtocol.ItemIndex <>0;
end;

procedure TfmConnect.btnPathClick(Sender: TObject);
begin
  if rgrpProtocol.ItemIndex =0 then begin
    // browse local computer
    OpenDialog.InitialDir:=ExtractFileDir(cboxPath.Text);
    if OpenDialog.Execute then cboxPath.Text:=OpenDialog.FileName;
    cboxPath.SetFocus;
  end
  else begin
    // get database list from selected remote machine
    if Trim(cboxServer.Text) ='' then
      Application.MessageBox('Не выбран сервер','Ошибка',MB_OK+MB_ICONERROR)
    else begin
      Enabled:=false;
      if Socket.Socket.LookupService(Socket.Service) =0 then begin
        Application.MessageBox(PChar('Сервис '+Socket.Service+' не найден'),'Ошибка',MB_OK+MB_ICONERROR);
        Enabled:=true;
        exit;
      end;
      Socket.Host:=cboxServer.Text;
      if Socket.Socket.LookupName(Socket.Host).S_addr =0 then begin
        Application.MessageBox(PChar('Сервер '+Socket.Host+' недоступен по протоколу TCP/IP'),'Ошибка',MB_OK+MB_ICONERROR);
        Enabled:=true;
        exit;
      end;
      Socket.Open;
    end;
  end;
end;

procedure TfmConnect.SocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if ErrorEvent=eeConnect then
    Application.MessageBox('Сервер не поддерживает просмотр списка баз данных','Внимание',MB_OK+MB_ICONWARNING)
  else
    Application.MessageBox('Ошибка чтения списка баз данных','Ошибка',MB_OK+MB_ICONERROR);

  ErrorCode:=0;
  Socket.Close;
  Buf:='';
  Enabled:=true;
end;

procedure TfmConnect.SocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  l,p:integer;
  cn,n:integer;

begin
  if not Socket.Connected then exit;

  with TfmBrowseDlg.Create(Self) do
    try
      lboxDBs.Items.BeginUpdate;
      lboxDBs.Items.Clear;
      l:=1;
      cn:=-1;

      for p:=1 to Length(Buf) do
        if Buf[p]=#13 then begin
          n:=lboxDBs.Items.Add(Copy(buf,l,p-l));
          if AnsiCompareText(lboxDBs.Items[n],cboxPath.Text) =0 then
            cn:=n;
          l:=p+1;
        end;

      Buf:='';
      lboxDBs.Items.EndUpdate;
      lboxDBs.ItemIndex:=cn;

      if (ShowModal =mrOK) and (lboxDBs.ItemIndex >=0) then
        cboxPath.Text:=lboxDBs.Items[lboxDBs.ItemIndex];
    finally
      Free;
      Self.Enabled:=true;
      cboxPath.SetFocus;
    end; // TRY
end;

procedure TfmConnect.SocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  Buf:=Buf+Socket.ReceiveText;
end;

procedure TfmConnect.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
