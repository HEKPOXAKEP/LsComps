unit LsAniLabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TLsAniLabel=class;

  TLsAniThread=class(tThread)
  private
    FOwnerLabel:TLsAniLabel;
    // ---
    procedure DoDraw;
  protected
    procedure Execute; override;
  public
    constructor Create(aOwnerLabel:TLsAniLabel);
    destructor Destroy; override;
  end;

  TLsAniLabel = class(TGraphicControl)
  private
    FAnimate:boolean;
    FCurText:tCaption;       // current caption holder
    FAniThread:TLsAniThread;
    FInterval:cardinal;      // im msecs
    FCharTable:tBitmap;      // matrix 32/7 : #32..#255
    FCharWidth:integer;
    FCharHeight:integer;
    FOnChange:tNotifyEvent;
    // ---
    procedure CalcCharSize;
    // ---
    procedure CMTextChanged(var Message:tMessage); message cm_TextChanged;
  protected
    procedure SetAnimate(Value:boolean);
    procedure SetCharTable(Value:tBitmap);
    procedure SetInterval(Value:cardinal);
    // ---
    procedure Loaded; override;
    procedure Paint; override;
    procedure Change;
    procedure ThreadTerminate(Sender:tObject);
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    // ---
    property Animate:boolean read FAnimate write SetAnimate;
    property CurText:tCaption read FCurText;
    property CharWidth:integer read FCharWidth;
    property CharHeight:integer read FCharHeight;
  published
    property CharTable:tBitmap read FCharTable write SetCharTable;
    property Interval:cardinal read FInterval write SetInterval;
    property OnChange:tNotifyEvent read FOnChange write FOnChange;
    // --- inherited props
    property Align;
    property Anchors;
    property Caption;
    //property DragCursor;
    //property DragKind;
    //property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    // ---
    property OnClick;
    property OnDblClick;
    //property OnDragDrop;
    //property OnDragOver;
    //property OnEndDock;
    //property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    //property OnStartDock;
    //property OnStartDrag;
  end;

procedure Register;

implementation

{$R LsAniLabel.res}

const
 SIncorrectCharTableWidth='Incorrect CharTable width';
 SIncorrectCharTableHeight='Inorrect CharTable height';

procedure Register;
begin
  RegisterComponents('LAGODROM components', [TLsAniLabel]);
end;

(* ============ TLsAniThread class ============== *)

constructor TLsAniThread.Create(aOwnerLabel:TLsAniLabel);
begin
 inherited Create(true);   // suspended;
 FreeOnTerminate:=true;
 FOwnerLabel:=aOwnerLabel;
end;

destructor TLsAniThread.Destroy;
begin
 inherited Destroy;
end;

procedure TLsAniThread.Execute;
var
 i:integer;
 s:string;

begin
 while not Terminated do begin
  Synchronize(DoDraw);
  s:=FOwnerLabel.Caption;
  if s =FOwnerLabel.FCurText then
   Terminate
  else with FOwnerLabel do begin
   for i:=1 to Length(FCurText) do
    if s[i] <>FCurText[i] then
     if FCurText[i] =#255 then FCurText[i]:=#32
     else FCurText[i]:=char(ord(FCurText[i])+1);

   Sleep(FInterval);
  end;
 end;
end;

procedure TLsAniThread.DoDraw;
begin
 FOwnerLabel.Change;
end;

(* ============ TLsAniLabel class ============= *)

constructor TLsAniLabel.Create(aOwner:tComponent);
begin
 inherited Create(aOwner);
 Randomize;
 FAnimate:=false;
 Width:=65;
 Height:=17;
 FInterval:=25;  // msec
 FCharTable:=tBitmap.Create;
end;

destructor TLsAniLabel.Destroy;
begin
 Animate:=false;
 FCharTable.Free;
 inherited Destroy;
end;

procedure TLsAniLabel.CalcCharSize;
var
 w,h:integer;

begin
 FCharWidth:=0; FCharHeight:=0;

 if Assigned(FCharTable) then begin
  w:=FCharTable.Width div 32; h:=FCharTable.Height div 7;

  if w*32 <>FCharTable.Width then
   raise Exception.Create(SIncorrectCharTableWidth);
  if h*7 <>FCharTable.Height then
   raise Exception.Create(SIncorrectCharTableHeight);

  FCharWidth:=w; FCharHeight:=h;
 end;

end;

procedure TLsAniLabel.CMTextChanged(var Message:tMessage);
begin
 inherited;
 Animate:=false;
 Invalidate;
end;

procedure TLsAniLabel.Loaded;
begin
 inherited Loaded;
 CalcCharSize;
end;

procedure TLsAniLabel.Paint;
var
 i,l:integer;
 s:string;
 bmp:tBitmap;

begin
 with Canvas do begin
  Brush.Style:=bsClear;

  if not Assigned(FCharTable) or
     (FCharWidth <1) or (FCharHeight <1) or
     (csDesigning in ComponentState) then begin
   Pen.Style:=psDot;
   Rectangle(0,0,Width,Height);
   if not Assigned(FCharTable) or
      (FCharWidth <1) or (FCharHeight <1) then exit;
  end;
 end; (*WITH Canvas*)

  if (csDesigning in ComponentState) or not FAnimate then
   s:=Caption
  else
   s:=CurText;

 l:=Length(s);

 if l =0 then exit;

 bmp:=tBitmap.Create;
 try
  bmp.Width:=l*FCharWidth;
  bmp.Height:=Height;
  bmp.Transparent:=true;
  for i:=1 to l do
   bmp.Canvas.CopyRect(Bounds(pred(i)*FCharWidth,0,FCharWidth,Height),
                       FCharTable.Canvas,
                       Bounds(((ord(s[i])-32) mod 32)*FCharWidth,
                              ((ord(s[i])-32) div 32)*FCharHeight,
                              FCharWidth,FCharHeight));
  //bmp.TransparentColor:=FCharTable.TransparentColor;
  Canvas.Draw(0,0,bmp);
 finally
  bmp.Free;
 end;
 (*
 for i:=1 to Length(s) do
  BrushCopy(Bounds(pred(i)*FCharWidth,0,FCharWidth,Height),
            FCharTable,
            Bounds(((ord(s[i])-32) mod 32)*FCharWidth,
                   ((ord(s[i])-32) div 32)*FCharHeight,
                   FCharWidth,FCharHeight),
            FCharTable.TransparentColor);*)
end;

procedure TLsAniLabel.Change;
begin
 Invalidate;
 if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TLsAniLabel.ThreadTerminate(Sender:tObject);
begin
 FAniThread:=nil;
 Animate:=false;
end;

procedure TLsAniLabel.SetAnimate(Value:boolean);
var
 i:integer;

begin
 if FAnimate =Value then exit;

 if FAnimate and Assigned(FAniThread) then
  FAniThread.Free;

 FAnimate:=Value;

 if FAnimate then begin
  FAniThread:=TLsAniThread.Create(Self);
  FAniThread.OnTerminate:=ThreadTerminate;
  SetLength(FCurText,Length(Caption));
  // fill temporary caption with a random chars
  for i:=1 to Length(FCurText) do
   FCurText[i]:=char(Random(224)+32);    // #32..#255
  FAniThread.Resume;
 end;
end;

procedure TLsAniLabel.SetCharTable(Value:tBitmap);
begin
 Animate:=false;
 FCharTable.Assign(Value);
 CalcCharSize;
 Invalidate;
end;

procedure TLsAniLabel.SetInterval(Value:cardinal);
begin
 if FInterval =Value then exit;

 Animate:=false;
 FInterval:=Value;
end;

end.
