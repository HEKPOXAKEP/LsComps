
unit LsClrBtn;

INTERFACE

uses
  Windows,Messages,Classes,Controls,Graphics,Buttons,Forms,Dialogs,
  SysUtils;

type
  tBorderWidth=1..10;

  TLsColorButton=class(TGraphicControl)
  private
    FModified:boolean;
    FBorderWidth:tBorderWidth;
    FOnColorChanged:tNotifyEvent;
    procedure CMEnabledChanged(var Message:tMessage); message CM_EnabledChanged;
    procedure CMColorChanged(var Message:tMessage); message CM_ColorChanged;
    procedure SetBorderWidth(Value:tBorderWidth);
  protected
    FState:tButtonState;
    FDragging:boolean;
    procedure MouseDown(Button:tMouseButton; Shift:tShiftState; X,Y:integer); override;
    procedure MouseMove(Shift:tShiftState; X,Y:integer); override;
    procedure MouseUp(Button:tMouseButton; Shift:tShiftState; X,Y:integer); override;
    procedure Paint; override;
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    procedure _SetColor(clr:tColor);
    property Modified:boolean read FModified write FModified;
  published
    property Enabled;
    property Color;
    property BorderWidth:tBorderWidth read FBorderWidth write SetBorderWidth default 2;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property OnColorChanged:tNotifyEvent read FOnColorChanged write FOnColorChanged;
    {property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;}
  end;

procedure Register;

IMPLEMENTATION

{$R LsClrBtn.res}

procedure Register;
begin
  RegisterComponents('LAGODROM components', [TLsColorButton]);
end;

(*** *** ***)

constructor TLsColorButton.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);
  SetBounds(0,0,54,28);
  ControlStyle:=[csCaptureMouse,csOpaque,csDoubleClicks];
  FBorderWidth:=2;
  ParentColor:=false;
  {Color:=clNone;}
  FState:=bsUp;
  FDragging:=false;
  FModified:=false;
end;

destructor TLsColorButton.Destroy;
begin
  inherited Destroy;
end;

procedure TLsColorButton.Paint;
var
  PaintRect:tRect;

begin
  if not Enabled and not (csDesigning in ComponentState) then
    FState:=bsDisabled;

  PaintRect:=DrawButtonFace(Canvas,Rect(0,0,Width,Height),1,bsNew,
             false,FState =bsDown,false);

  InflateRect(PaintRect,-FBorderWidth,-FBorderWidth);

  Canvas.Brush.Color:=Color;
  Canvas.Pen.Color:=clBlack;
  Canvas.Rectangle(PaintRect.Left,PaintRect.Top,PaintRect.Right,PaintRect.Bottom);
end;

procedure TLsColorButton.MouseDown(Button:tMouseButton; Shift:tShiftState; X,Y:integer);
begin
 inherited MouseDown(Button,Shift,X,Y);

 if (Button =mbLeft) and Enabled then begin
   if FState <>bsDown then begin
     FDragging:=true;
     FState:=bsDown;
     Repaint;
   end;
 end;
end;

procedure TLsColorButton.MouseMove(Shift:tShiftState; X,Y:integer);
var
  NewState:tButtonState;

begin
  inherited MouseMove(Shift,X,Y);

  if FDragging then begin
    if (X >=0) and (X <ClientWidth) and (Y >=0) and (Y <=ClientHeight) then
      NewState:=bsDown
    else
      NewState:=bsUp;

    if NewState <>FState then begin
      FState:=NewState;
      Repaint;
    end;
  end;
end;

procedure TLsColorButton.MouseUp(Button:tMouseButton; Shift:tShiftState;
  X,Y:integer);
begin
  inherited MouseUp(Button,Shift,X,Y);

  if FDragging then begin
    FDragging:=false;
    FState:=bsUp;
    Repaint;

    if (X >=0) and (X <ClientWidth) and (Y >=0) and (Y <=ClientHeight) then
      Click;
  end;
end;

procedure TLsColorButton.Click;
var
  ClrDlg:tColorDialog;

begin
  {inherited Click;}
  {---}
  ClrDlg:=tColorDialog.Create(Application);
  try
    ClrDlg.Color:=Color;
    if ClrDlg.Execute then begin
      if Color <>ClrDlg.Color then FModified:=true;
      Color:=ClrDlg.Color;
    end;
  finally
    ClrDlg.Free;
  end;
end;

procedure TLsColorButton._SetColor(clr:tColor);
var
  tmp:tNotifyEvent;

begin
  FModified:=false;
  if Color =clr then exit;
  tmp:=FOnColorChanged;
  FOnColorChanged:=nil;
  Color:=clr;
  FOnColorChanged:=tmp;
end;

procedure TLsColorButton.CMEnabledChanged(var Message:tMessage);
begin
  Invalidate;
end;

procedure TLsColorButton.CMColorChanged(var Message:tMessage);
begin
  if Assigned(FOnColorChanged) then FOnColorChanged(Self);
  Invalidate;
end;

procedure TLsColorButton.SetBorderWidth(Value:tBorderWidth);
begin
  if FBorderWidth =Value then exit;
  FBorderWidth:=Value;
  Invalidate;
end;

end.
