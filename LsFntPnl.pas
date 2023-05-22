
unit LsFntPnl;

INTERFACE

uses
 Windows,Messages,Classes,SysUtils,VCLUtils,Controls,
 StdCtrls,Graphics,ExtCtrls,Forms,Dialogs;

type
  TLsFontPanel=class(tCustomPanel)
  private
    FModified:boolean;
    hFontName:tEdit;
    hFontSize:tEdit;
    hFontStyle:tPaintBox;
    hButton:tButton;
    {---}
    bmpBold:tBitmap;
    bmpItalic:tBitmap;
    bmpUnderline:tBitmap;
    bmpStrikeout:tBitmap;
    {---}
    FOnFontChanged:tNotifyEvent;
    procedure CMFontChanged(var Message:tMessage); message CM_FontChanged;
    procedure CMTextChanged(var Message:tMessage); message CM_TextChanged;
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    procedure _SetFont(fnt:tFont);
    procedure RefreshView;
    {=events=}
    procedure ButtonClick(Sender:tObject);
    procedure EditEnter(Sender:tObject);
    procedure DrawStyleBox(Sender:tObject);
  published
    property Color;
    property Enabled;
    property Visible;
    property Font;
    property ShowHint;
    property ParentShowHint;
    property TabOrder;
    property OnEnter;
    property OnExit;
    // ---
    property OnFontChanged:tNotifyEvent read FOnFontChanged write FOnFontChanged;
 end;

procedure Register;

IMPLEMENTATION

{$R LsFntPnl.res}

procedure Register;
begin
 RegisterComponents('LAGODROM components',[TLsFontPanel]);
end;

(*** *** *** *** *** *** *** *** *** ***)

constructor TLsFontPanel.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);
  SetBounds(0,0,264,31);
  BevelInner:=bvRaised;
  BevelOuter:=bvLowered;
  ParentFont:=false;
  TabStop:=true;
  Caption:='';
  {---}
  bmpBold:=MakeModuleBitmap(hInstance,'bmp_Bold');
  bmpItalic:=MakeModuleBitmap(hInstance,'bmp_Italic');
  bmpUnderline:=MakeModuleBitmap(hInstance,'bmp_Underline');
  bmpStrikeout:=MakeModuleBitmap(hInstance,'bmp_Strikeout');
  (*===*)
  hFontName:=tEdit.Create(Self);
  hFontName.SetBounds(4,4,145,22);
  hFontName.Parent:=Self;
  hFontName.ReadOnly:=true;
  hFontName.Text:=Font.Name;
  hFontName.TabStop:=false;
  hFontName.ParentFont:=false;
  hFontName.OnEnter:=EditEnter;
  {-}
  hFontSize:=tEdit.Create(Self);
  hFontSize.SetBounds(149,4,25,22);
  hFontSize.Parent:=Self;
  hFontSize.ReadOnly:=true;
  hFontSize.Text:=IntToStr(Font.Size);
  hFontSize.TabStop:=false;
  hFontSize.ParentFont:=false;
  hFontSize.OnEnter:=EditEnter;
  {-}
  hFontStyle:=tPaintBox.Create(Self);
  hFontStyle.SetBounds(174,4,86,22);
  hFontStyle.Parent:=Self;
  hFontStyle.OnPaint:=DrawStyleBox;
  {-}
  hButton:=tButton.Create(Self);
  hButton.SetBounds(240,6,18,18);
  hButton.Caption:=#183#183#183;
  hButton.Parent:=Self;
  hButton.ParentFont:=false;
  hButton.OnClick:=ButtonClick;
end;

destructor TLsFontPanel.Destroy;
begin
  bmpBold.Free;
  bmpItalic.Free;
  bmpUnderline.Free;
  bmpStrikeout.Free;
  inherited Destroy;
end;

procedure TLsFontPanel._SetFont(fnt:tFont);
var
  tmp:tNotifyEvent;

begin
  tmp:=FOnFontChanged;
  FOnFontChanged:=nil;
  Font.Assign(fnt);
  FOnFontChanged:=tmp;
  FModified:=false;
end;

procedure TLsFontPanel.RefreshView;
begin
  hFontName.Text:=Font.Name;
  hFontSize.Text:=IntToStr(Font.Size);
  //
  Invalidate;
end;

procedure TLsFontPanel.CMFontChanged(var Message:tMessage);
begin
  inherited;
  RefreshView;
  if Assigned(FOnFontChanged) then FOnFontChanged(Self);
end;

procedure TLsFontPanel.CMTextChanged(var Message:tMessage);
begin
   //Caption:='';
end;

procedure TLsFontPanel.ButtonClick(Sender:tObject);
var
  FntDlg:tFontDialog;

begin
  FntDlg:=tFontDialog.Create(Application);
  try
    FntDlg.Font.Assign(Font);
    if FntDlg.Execute then
      if (Font.Name <>FntDlg.Font.Name) or
         (Font.Size <>FntDlg.Font.Size) or
         (Font.Style <>FntDlg.Font.Style) then begin
        Font.Assign(FntDlg.Font);
        hFontName.Text:=Font.Name;
        hFontSize.Text:=IntToStr(Font.Size);
        FModified:=true;
      end;
  finally
    FntDlg.Free;
  end;
end;

procedure TLsFontPanel.EditEnter(Sender:tObject);
begin
  hButton.SetFocus;
end;

procedure TLsFontPanel.DrawStyleBox(Sender:tObject);
var
  r:tRect;
  x:integer;

procedure DrawStyleBmp(var bmp:tBitmap);
begin
  hFontStyle.Canvas.Draw(x,4,bmp);
  Inc(x,15);
end;

begin
  r:=Rect(0,0,hFontStyle.Width,hFontStyle.Height);
  DrawEdge(hFontStyle.Canvas.Handle,
           r,
           {EDGE_BUMP} Bdr_SunkenOuter or Bdr_SunkenInner,
           BF_Rect);
  x:=4;
  if fsBold in Font.Style then
    DrawStyleBmp(bmpBold);
  if fsItalic in Font.Style then
    DrawStyleBmp(bmpItalic);
  if fsUnderline in Font.Style then
    DrawStyleBmp(bmpUnderline);
  if fsStrikeOut in Font.Style then
    DrawStyleBmp(bmpStrikeout);
end;

end.
