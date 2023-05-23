(***************************************************
**                                                **
**               SQL Error Dialog                 **
**             Version 0.02.02/g0523              **
**   Copyright 2002-2023 LAGODROM Solutions Ltd   **
**              All rights reserved               **
**                                                **
***************************************************)

unit LsSQLErrDlg;

interface

uses
  SysUtils,
  Classes,
  Forms,
  Graphics,
  VclUtils,
  SQLErrFm;

type
  TLsSQLErrDlg=class(TComponent)
  private
    FDlg: tSQLErrFm;
    FCaption: string;
    FFont: tFont;
    FErrCode: integer;
    FSQLCode: integer;
    FErrorMsg: tStringList;
    FErrorCodes: tStringList;
    FSQLMsg: tStringList;
    FSQL: tStringList;
    FUserMsg: string;
  protected
    procedure SetFont(Value: tFont);
    procedure SetCaption(Value: string);
    procedure SetErrorMsg(Value: tStringList);
    procedure SetErrorCodes(Value: tStringList);
    procedure SetSQLMsg(Value: tStringList);
    procedure SetSQL(Value: tStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;
  published
    property Caption: string read FCaption write SetCaption;
    property Font: TFont read FFont write SetFont;
    property ErrCode: integer read FErrCode write FErrCode;
    property SQLCode: integer read FSQLCode write FSQLCode;
    property ErrorMsg: TStringList read FErrorMsg write SetErrorMsg;
    property ErrorCodes: TStringList read FErrorCodes write SetErrorCodes;
    property SQLMsg: TStringList read FSQLMsg write SetSQLMsg;
    property SQL: TStringList read FSQL write SetSQL;
    property UserMsg: string read FUserMsg write FUserMsg;
  end;

procedure Register;

implementation

{$R LsSQLErrDlg.res}

(* ********************** регистрация компонента ********************** *)

procedure Register;
begin
  RegisterComponents('LAGODROM components',[TLsSQLErrDlg]);
end;

(* ********************  T a d S Q L E r r D l g  ********************* *)

constructor TLsSQLErrDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont:=tFont.Create;
  if Owner is tForm then FFont.Assign(TForm(Owner).Font);

  // создаем стринг-листы
  FErrorMsg:=TStringList.Create;
  FErrorCodes:=TStringList.Create;
  FSQLMsg:=TStringList.Create;
  FSQL:=TStringList.Create;
end;

destructor TLsSQLErrDlg.Destroy;
begin
  FErrorMsg.Free;
  FErrorCodes.Free;
  FSQLMsg.Free;
  FSQL.Free;
  FFont.Free;
  if FDlg <>nil then FreeAndNil(FDlg);
  inherited Destroy;
end;

procedure TLsSQLErrDlg.Execute;
begin
  FDlg:=TSQLErrFm.Create(Application);
  try
    with FDlg do begin
      Font:=FFont;
      if FCaption <>'' then Caption:=FCaption;
      if FUserMsg <>'' then lblGeneral.Caption:=FUserMsg;
      panErrCode.Caption:=IntToStr(FErrCode);
      panSQLCode.Caption:=IntToStr(FSQLCode);
      memErrorMsg.Lines.Assign(FErrorMsg);
      memErrorCodes.Lines.Assign(FErrorCodes);
      memSQLMsg.Lines.Assign(FSQLMsg);
      memSQL.Lines.Assign(FSQL);
      ShowModal;
    end;
  finally
    FreeAndNil(FDlg);
  end;
end;

procedure TLsSQLErrDlg.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TLsSQLErrDlg.SetCaption(Value: string);
begin
  if FCaption <>Value then FCaption:=Value;
end;

procedure TLsSQLErrDlg.SetErrorMsg(Value: TStringList);
begin
  FErrorMsg.Assign(Value);
end;

procedure TLsSQLErrDlg.SetErrorCodes(Value: TStringList);
begin
  FErrorCodes.Assign(Value);
end;

procedure TLsSQLErrDlg.SetSQLMsg(Value: TStringList);
begin
  FSQLMsg.Assign(Value);
end;

procedure TLsSQLErrDlg.SetSQL(Value: TStringList);
begin
  FSQL.Assign(Value);
end;

end.
