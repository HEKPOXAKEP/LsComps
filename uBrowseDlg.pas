(*************************************************
**                                              **
**        Remote database select dialog         **
**          for LsDbSelect component            **
**  Copyright 2003-2023 Lagodrom Solutions Ltd  **
**            All rights reserved               **
**                                              **
*************************************************)

unit uBrowseDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ImgList, RXCtrls, ExtCtrls;

type
  TfmBrowseDlg = class(TForm)
    panTop: TPanel;
    Label1: TLabel;
    lboxDBs: TTextListBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure lboxDBsClick(Sender: TObject);
    procedure lboxDBsDblClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses uConnect;

{$R *.DFM}

procedure TfmBrowseDlg.FormShow(Sender: TObject);
begin
  ActiveControl:=lboxDBs;
  lboxDBsClick(nil);
end;

procedure TfmBrowseDlg.lboxDBsClick(Sender: TObject);
begin
  btnOk.Enabled:=lboxDBs.ItemIndex >=0;
end;

procedure TfmBrowseDlg.lboxDBsDblClick(Sender: TObject);
begin
  if btnOk.Enabled then
    ModalResult:=mrOk;
end;

procedure TfmBrowseDlg.btnOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmBrowseDlg.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
