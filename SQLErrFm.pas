unit SQLErrFm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TSQLErrFm = class(TForm)
    pgcSQLErr: TPageControl;
    btnOk: TButton;
    tsGeneral: TTabSheet;
    imgError: TImage;
    lblGeneral: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    panErrCode: TPanel;
    panSQLCode: TPanel;
    tsError: TTabSheet;
    tsSQLMsg: TTabSheet;
    grpErrorMsg: TGroupBox;
    grpErrorCodes: TGroupBox;
    grpSQLMsg: TGroupBox;
    grpSQL: TGroupBox;
    Bevel2: TBevel;
    memErrorMsg: TMemo;
    memErrorCodes: TMemo;
    memSQLMsg: TMemo;
    memSQL: TMemo;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TSQLErrFm.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TSQLErrFm.FormCreate(Sender: TObject);
begin
  pgcSQLErr.ActivePage:=tsGeneral;
end;

end.
