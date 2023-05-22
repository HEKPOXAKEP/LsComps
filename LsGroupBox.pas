(***************************************************
  LsGroupBox visual component

  LAGODROM Solutions components library

  (c) LAGODROM Solutions Ltd. All rights reserved.
****************************************************)

unit LsGroupBox;

interface

uses
  Windows,Classes,Graphics,Controls,StdCtrls,ExtCtrls;

type
  tBorderStyle=(
    bsNormal,
    bsRound
  );

type
  TLsGroupBox=class(TCustomGroupBox)
  private
    FBevelInner:tPanelBevel;    { set the both to bvNone }
    FBevelOuter:tPanelBevel;    { to remove the bevel    }
    FBorderWidth:integer;       // 0 - no border at all
    FBorderVertOfs:integer;
    FBorderHorzOfs:integer;
    FBorderColor:tColor;
    FBorderVertRound:integer;
    FBorderHorzRound:integer;
  protected
    procedure SetBevelInner(Value:tPanelBevel);
    procedure SetBevelOuter(Value:tPanelBevel);
    procedure SetBorderWidth(Value:integer);
    procedure SetBorderVertOfs(Value:integer);
    procedure SetBorderHorzOfs(Value:integer);
    procedure SetBorderColor(Value:tColor);
    procedure SetBorderVertRound(Value:integer);
    procedure SetBorderHorzRound(Value:integer);
    // native methods
    procedure AdjustClientRect(var Rect:tRect); override;
    procedure Paint; override;
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
  published
    // TLsGroupBox props
    property BevelInner:tPanelBevel read FBevelInner write SetBevelInner;
    property BevelOuter:tPanelBevel read FBevelOuter write SetBevelOuter;
    property BorderWidth:integer read FBorderWidth write SetBorderWidth;
    property BorderVertOfs:integer read FBorderVertOfs write SetBorderVertOfs;
    property BorderHorzOfs:integer read FBorderHorzOfs write SetBorderHorzOfs;
    property BorderColor:tColor read FBorderColor write SetBorderColor;
    property BorderVertRound:integer read FBorderVertRound write SetBorderVertRound;
    property BorderHorzRound:integer read FBorderHorzRound write SetBorderHorzRound;
    // native tGroupBox props
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDockDrop;
    property OnDockOver;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

procedure Register;

implementation

{$R LsGroupBox.res}

procedure Register;
begin
  RegisterComponents('LAGODROM components',[TLsGroupBox]);
end;

constructor TLsGroupBox.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);

  FBevelInner:=bvNone;
  FBevelOuter:=bvRaised;
  FBorderWidth:=1;
  FBorderVertOfs:=2;
  FBorderHorzOfs:=2;
  FBorderColor:=clNavy;
  FBorderVertRound:=1;
  FBorderHorzRound:=1;
end;

destructor TLsGroupBox.Destroy;
begin
  inherited Destroy;
end;

procedure TLsGroupBox.AdjustClientRect(var Rect:tRect);
begin
  //tCustomControl.AdjustClientRect(Rect);

  if Ctl3D then begin
    if FBevelOuter <>bvNone then InflateRect(Rect,-1,-1);
    if FBevelOuter <>bvNone then InflateRect(Rect,-1,-1);
  end;

  if FBorderWidth >0 then
    InflateRect(Rect,-(FBorderWidth+FBorderHorzOfs),-(FBorderWidth+FBorderVertOfs));

  if Caption <>'' then begin
    Canvas.Font:=Font;
    Inc(Rect.Top,Canvas.TextHeight('W'));
  end;
end;

procedure TLsGroupBox.Paint;
var
  H:integer;
  R:tRect;
  i:integer;
  Flags:longint;

begin
  H:=0;

  with Canvas do begin
    R:=Rect(0,0,pred(Width),pred(Height));

    if Ctl3D then begin
      if FBevelOuter <>bvNone then begin
        case FBevelOuter of
          bvLowered: DrawEdge(Handle,R,bdr_SunkenOuter,bf_Rect);
          bvRaised: DrawEdge(Handle,R,bdr_RaisedOuter,bf_Rect);
        end;
        InflateRect(R,-1,-1);
      end;

     if FBevelInner <>bvNone then begin
       case FBevelInner of
         bvLowered: DrawEdge(Handle,R,bdr_SunkenOuter,bf_Rect);
         bvRaised: DrawEdge(Handle,R,bdr_RaisedOuter,bf_Rect);
       end;
       InflateRect(R,-1,-1);
      end;
    end; (*IF Ctl3D*)

    if FBorderWidth >0 then begin
      InflateRect(R,-FBorderHorzOfs,-FBorderVertOfs);

      if Text <>'' then begin
        Font:=Self.Font;
        H:=TextHeight('W');
        Inc(R.Top,H div 2 -1);
      end;

      Pen.Color:=FBorderColor;
      Brush.Color:=Color;
      for i:=1 to FBorderWidth do begin
        RoundRect(R.Left,R.Top,R.Right,R.Bottom,FBorderHorzRound,FBorderVertRound);
        InflateRect(R,-1,-1);
      end;

      if Text <>'' then begin
        if not UseRightToLeftAlignment then
          R:=Rect(8+FBorderHorzRound,R.Top -(H div 2),0,0)
        else
          R:=Rect(R.Right-Canvas.TextWidth(Text)-(8+FBorderHorzRound),R.Top -(H div 2),0,0);

        R.Bottom:=R.Top+H;
        Flags:=DrawTextBiDiModeFlags(DT_SINGLELINE);
        DrawText(Handle,pChar(Text),Length(Text),R,Flags or DT_CALCRECT);
        DrawText(Handle,pChar(Text),Length(Text),R,Flags);
      end;
    end; (*IF BoderWidth>0*)
  end; (*WITH Canvas*)
end;

procedure TLsGroupBox.SetBevelInner(Value:tPanelBevel);
begin
  if FBevelInner =Value then exit;
  FBevelInner:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBevelOuter(Value:tPanelBevel);
begin
  if FBevelOuter =Value then exit;
  FBevelOuter:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBorderWidth(Value:integer);
begin
  if FBorderWidth =Value then exit;
  FBorderWidth:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBorderVertOfs(Value:integer);
begin
  if (FBorderVertOfs =Value) or
     (Value <0) or
     (Value >=(Height div 2)) then exit;

  FBorderVertOfs:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBorderHorzOfs(Value:integer);
begin
  if (FBorderHorzOfs =Value) or
     (Value <0) or
     (Value >=(Width div 2)) then exit;

  FBorderHorzOfs:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBorderColor(Value:tColor);
begin
  if (FBorderColor =Value) then exit;
  FBorderColor:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBorderVertRound(Value:integer);
begin
  if (FBorderVertRound =Value) or
     (Value <0) then exit;

  FBorderVertRound:=Value;
  Invalidate;
end;

procedure TLsGroupBox.SetBorderHorzRound(Value:integer);
begin
  if (FBorderHorzRound =Value) or
     (Value <0) then exit;

  FBorderHorzRound:=Value;
  Invalidate;
end;

end.

