(*************************************************)
(*                                               *)
(*               TGradientBox                    *)
(*           Version 0.01.03/g0527               *)
(*  Copyright 2000-2023  LAGODROM Solutions Ltd  *)
(*            All rights reserved                *)
(*                                               *)
(*************************************************)

unit GrdBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, VCLUtils, RxGif, GifCtrl;

type
  (* GradientBox *)
  TGradientBox = class(TGraphicControl)
  private {---Private declarations}
    FStartColor:tColor;
    FEndColor:tColor;
    FFillDirection:tFillDirection;
    FGradientSteps:byte;
    FAlignment:tAlignment;
    FPicture:tPicture;
    FGifAnimator:tRxGifAnimator;
    FUsePicture:boolean;         // use Picture instead of GifAnimator
    FVertical:boolean;
    // ---
    FOnMouseDown:tMouseEvent;
    FOnMouseMove:tMouseMoveEvent;
    FOnMouseUp:tMouseEvent;
    {---}
    procedure cmFontChanged(var Message:TMessage); message cm_FontChanged;
    procedure cmTextChanged(var Message:TMessage); message cm_TextChanged;
    // ---
    procedure wmLButtonDown(var Message:TwmLButtonDown); message wm_LButtonDown;
    procedure wmMouseMove(var Message:TwmMouseMove); message wm_MouseMove;
    procedure wmLButtonUp(var Message:TwmLButtonUp); message wm_LButtonUp;
    {---}
    procedure SetStartColor(Value:TColor);
    procedure SetEndColor(Value:TColor);
    procedure SetFillDirection(Value:TFillDirection);
    procedure SetGradientSteps(Value:byte);
    procedure SetAlignment(Value:TAlignment);
    procedure SetPicture(Value:TPicture);
    function GetGifImage:TGifImage;
    procedure SetGifImage(Value:TGifImage);
    function GetAnimate:boolean;
    procedure SetAnimate(Value:boolean);
    function GetUsePicture:boolean;
    procedure SetUsePicture(Value:boolean);
    function GetFrameIndex:integer;
    procedure SetFrameIndex(Value:integer);
    procedure SetVertical(Value:boolean);
    procedure PictureChanged(Sender:TObject);
  protected {---Protected declarations}
    procedure Paint; override;
  public {---Public declarations}
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published {---Published declarations }
    property Align;
    property Caption;
    property Font;
    property ShowHint;
    property ParentShowHint;
    property Enabled;
    property Visible;
    property Picture:tPicture read FPicture write SetPicture;
    property GifImage:tGifImage read GetGifImage write SetGifImage;
    property Animate:boolean read GetAnimate write SetAnimate;
    property UsePicture:boolean read GetUsePicture write SetUsePicture;
    property FrameIndex:integer read GetFrameIndex write SetFrameIndex;
    property Alignment:tAlignment read FAlignment write SetAlignment;
    property StartColor:tColor read FStartColor write SetStartColor;
    property EndColor:tColor read FEndColor write SetEndColor;
    property FillDirection:tFillDirection read FFillDirection write SetFillDirection;
    property GradientSteps:byte read FGradientSteps write SetGradientSteps;
    property Vertical:boolean read FVertical write SetVertical;
    // ---
    property OnMouseDown:tMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove:tMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp:tMouseEvent read FOnMouseUp write FOnMouseUp;
  end;

procedure Register;

implementation

{$R GrdBox.res}

procedure Register;
begin
  RegisterComponents('LAGODROM components', [TGradientBox]);
end;

(*** *** ***)

constructor TGradientBox.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csOpaque];
  FStartColor:=clGray;
  FEndColor:=clSilver;
  FFillDirection:=fdLeftToRight;
  FGradientSteps:=64;
  FAlignment:=taLeftJustify;
  FPicture:=TPicture.Create;
  FPicture.OnChange:=PictureChanged;
  Width:=100;
  Height:=16;
  // ---
  FGifAnimator:=TRxGifAnimator.Create(Self);
  FGifAnimator.OnChange:=PictureChanged;
  FGifAnimator.Left:=Left+6;
  FGifAnimator.Top:=Top+((Height-FGifAnimator.Image.Height) div 2);
end;

destructor TGradientBox.Destroy;
begin
  FGifAnimator.Free;
  FPicture.Free;
  inherited Destroy;
end;

procedure TGradientBox.SetStartColor(Value:TColor);
begin
  if Value <>FStartColor then begin
    FStartColor:=Value;
    Invalidate;
  end;
end;

procedure TGradientBox.SetEndColor(Value:TColor);
begin
  if Value <>FEndColor then begin
    FEndColor:=Value;
    Invalidate;
  end;
end;

procedure TGradientBox.SetFillDirection(Value:TFillDirection);
begin
  if Value <>FFillDirection then begin
    FFillDirection:=Value;
    Invalidate;
  end;
end;

procedure TGradientBox.SetGradientSteps(Value:byte);
begin
  if Value <>FGradientSteps then begin
    FGradientSteps:=Value;
    Invalidate;
  end;
end;

procedure TGradientBox.SetAlignment(Value:TAlignment);
begin
  if Value <>FAlignment then begin
    FAlignment:=Value;
    Invalidate;
  end;
end;

procedure TGradientBox.SetPicture(Value:TPicture);
begin
  FPicture.Assign(Value);
end;

function TGradientBox.GetGifImage:TGifImage;
begin
  Result:=FGifAnimator.Image;
end;

procedure TGradientBox.SetGifImage(Value:TGifImage);
begin
  FGifAnimator.Image.Assign(Value);
end;

function TGradientBox.GetAnimate:boolean;
begin
  Result:=FGifAnimator.Animate;
end;

procedure TGradientBox.SetAnimate(Value:boolean);
begin
  FGifAnimator.Animate:=Value;
end;

function TGradientBox.GetUsePicture:boolean;
begin 
  Result:=FUsePicture;
end;

procedure TGradientBox.SetUsePicture(Value:boolean);
begin
  if FUsePicture =Value then exit;

  FUsePicture:=Value;
  Invalidate;
end;

function TGradientBox.GetFrameIndex:integer;
begin
  Result:=FGifAnimator.FrameIndex;
end;

procedure TGradientBox.SetFrameIndex(Value:integer);
begin
  FGifAnimator.FrameIndex:=Value;
end;

procedure TGradientBox.PictureChanged(Sender:TObject);
begin
  FGifAnimator.Left:=Left+6;
  FGifAnimator.Top:=Top+((Height-FGifAnimator.Image.Height) div 2);
  Invalidate;
end;

(***procedure TGradientBox.Paint;
var
  R:tRect;
  x:integer;
  vCanvas:tCanvas;

begin
  R:=Rect(0,0,Width-1,Height-1);
  {---}
  try
    vCanvas:=tCanvas.Create;
    vCanvas.Handle:=CreateCompatibleDC(0);
    if vCanvas.Handle =0 then begin
      Canvas.Brush.Color:=clWhite;
      Canvas.Brush.Style:=bsSolid;
      Canvas.FillRect(R);
      Beep;
    end
    else begin
      vCanvas.Font:=Font;
      GradientFillRect(vCanvas,
                       R,
                       FStartColor,
                       FEndColor,
                       FFillDirection,
                       FGradientSteps);
      vCanvas.Brush.Style:=bsClear;
      case Alignment of
        taLeftJustify: x:=4;
        taRightJustify: x:=Width-vCanvas.TextWidth(Caption)-3;
      else
        {taCenter:} x:=(Width-vCanvas.TextWidth(Caption)) div 2;
      end;
      vCanvas.TextOut(x,(Height-vCanvas.TextHeight(Caption)) div 2,Caption);
      Canvas.CopyRect(R,vCanvas,R);
    end;
  finally
    if vCanvas.Handle <>0 then
      DeleteDC(vCanvas.Handle);
    vCanvas.Free;
  end;
end;***)

procedure TGradientBox.Paint;
var
  R:tRect;
  x:integer;
  i:integer;
  {---
  lf:tLogFont;
  tf:tFont;}

begin
  R:=Rect(0,0,Width-1,Height-1);
  GradientFillRect(Canvas,
                   R,
                   FStartColor,
                   FEndColor,
                   FFillDirection,
                   FGradientSteps);
  {---}
  case FVertical of
    false: begin
      Canvas.Font:=Font;
      Canvas.Brush.Style:=bsClear;
      if FUsePicture then begin
        // режим: Картинка
        i:=FPicture.Width;
        Canvas.Draw(6,(Height-FPicture.Height) div 2,FPicture.Graphic);
        {---}
        case Alignment of
          taLeftJustify: x:=i+16;
          taRightJustify: x:=Width-(Canvas.TextWidth(Caption)+15);
        else
          {taCenter:} x:=(Width-(Canvas.TextWidth(Caption)+i)) div 2;
        end;
      end
      else begin
        // режим: Анимированный GIF
        i:=FGifAnimator.Image.Width;
        Canvas.Draw(6,(Height-FGifAnimator.Image.Height) div 2,FGifAnimator.Image);
        case Alignment of
          taLeftJustify: x:=i+16;
          taRightJustify: x:=Width-(Canvas.TextWidth(Caption)+15);
        else
          {taCenter:} x:=(Width-(Canvas.TextWidth(Caption)+i)) div 2;
        end;
      end;
      {---}
      Canvas.TextOut(x,(Height-Canvas.TextHeight(Caption)) div 2,Caption);
    end;

    true: begin
      Canvas.Draw((Width-FPicture.Width) div 2,Height-6-FPicture.Height,FPicture.Graphic);
      {Canvas.Brush.Style:=bsClear;}
      {---}
     (***
      {Canvas.Font.Name:=Font.Name;
      Canvas.Font.Size:=Font.Size;
      Canvas.Font.Color:=Font.Color;}
      {Canvas.Font:=Font;}
      tf:=tFont.Create;
      tf.Assign(Font);
      GetObject(tf.Handle,SizeOf(lf),@lf);
      lf.lfEscapement:=450;
      lf.lfOrientation:=0; {450;}
      tf.Handle:=CreateFontIndirect(lf);
      if tf.Handle =0 then beep;
      Canvas.Font.Assign(tf);
      tf.Free;
      Canvas.Font:=Font;
      Canvas.Font.Handle:=CreateRotatedFont(Canvas.Font,45);
      if Canvas.Font.Handle =0 then beep;
      {Canvas.TextOut((Width-Canvas.TextHeight('Hy')) div 2,Height-6,Caption);}
      Canvas.TextOut(Width div 2,Height div 2,'ABC');
     ***)
     (***)
      Canvas.Font.Name:=Self.Font.Name;
      Canvas.Font.Style:=[fsBold];
      Canvas.Font.Size:=Self.Font.Size;
      Canvas.Font.Color:=clBlack;
      Canvas.Font.Handle:=CreateRotatedFont(Canvas.Font,90);
      if Canvas.Handle =0 then beep;
      ExtTextOut(Canvas.Handle,0,R.Bottom-20,ETO_Clipped,@R,pChar(Caption),Length(Caption),nil);
     (***)
     end;
  end; (*CASE FVertical*)
end;

procedure TGradientBox.cmFontChanged(var Message:TMessage);
begin
  Invalidate;
end;

procedure TGradientBox.cmTextChanged(var Message:TMessage);
begin
  Invalidate;
end;

procedure TGradientBox.wmLButtonDown(var Message:TwmLButtonDown);
begin
  inherited;
  if Assigned(FOnMouseDown) then with TWMMouse(Message) do
    FOnMouseDown(Self,mbLeft,KeysToShiftState(Keys),XPos,YPos);
end;

procedure TGradientBox.wmMouseMove(var Message:TwmMouseMove);
begin
  inherited;
  if Assigned(FOnMouseMove) then with Message do
    FOnMouseMove(Self,KeysToShiftState(Keys),XPos,YPos);
end;

procedure TGradientBox.wmLButtonUp(var Message:TwmLButtonUp);
begin
  inherited;
  if Assigned(FOnMouseUp) then with TWMMouse(Message) do
    FOnMouseDown(Self,mbLeft,KeysToShiftState(Keys),XPos,YPos);
end;

procedure TGradientBox.SetVertical(Value:boolean);
begin
  if FVertical =Value then exit;
  FVertical:=Value;
  Invalidate;
end;

end.
