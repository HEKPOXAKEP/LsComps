{***********************************************}
{                                               }
{         Open sound (wave) file dialog         }
{             Version 0.01.03/g0310             }
{  Copyright 2003-2006 Lagodrom Solutions Ltd   }
{              All rights reserved              }
{                                               }
{***********************************************}

{$DEFINE UseRx}
{$DEFINE UseRussian}

unit LsOpenSndDlg;

{$R-}

interface

uses
  Messages,Windows,SysUtils,Classes,Controls,StdCtrls,ExtCtrls,Graphics,
  Forms,Dialogs,
  {$IFDEF UseRx} RxCtrls, {$ELSE} Buttons, {$ENDIF}
  mmSystem;

type
  TLsOpenSndDlg=class(TOpenDialog)
  private
    FBtnsPanel:tPanel;
    FLabel:tLabel;
    {$IFDEF UseRx}
    FPlayBtn:tRxSpeedButton;
    FStopBtn:tRxSpeedButton;
    {$ELSE}
    FPLayBtn:tSpeedButton;
    FStopBtn:tSpeedButton;
    {$ENDIF}
    FWavInfo:tLabel;
    FDeviceId:word;
    { --- }
    procedure PlayClick(Sender:tObject);
    procedure StopClick(Sender:tObject);
  protected
    procedure DoClose; override;
    procedure DoSelectionChange; override;
    procedure DoShow; override;
    // ---
    procedure MCINotify(var Message:tMessage); message MM_MCINOTIFY;
    function PlayWaveFile:longint;
    procedure StopSound;
    procedure CloseSndDevice;
  public
    constructor Create(aOwner:tComponent); override;
    destructor Destroy; override;
    function Execute:boolean; override;
  published
    // ---
  end;

procedure Register;

implementation

uses
 {$IFDEF UseRx} VCLUtils, {$ENDIF}
 LsOpenSndDlg_Const;

{$R LsOpenSndDlg.res}

{$IFDEF UseRussian}
 {$R LsOpenSndDlg_ru.res}
{$ELSE}
 {$R LsOpenSndDlg_en.res}
{$ENDIF}

type
  tWaveHdr=packed record
    Marker1:        array[0..3] of char;
    BytesFollowing: longint;
    Marker2:        array[0..3] of char;
    Marker3:        array[0..3] of char;
    Fixed1:         longint;
    FormatTag:      word;
    Channels:       word;
    SampleRate:     longint;
    BytesPerSecond: longint;
    BytesPerSample: word;
    BitsPerSample:  word;
    Marker4:        array[0..3] of char;
    DataBytes:      longint;
  end;

procedure Register;
begin
  RegisterComponents('LAGODROM components',[TLsOpenSndDlg]);
end;

(*************** Miscellaneous routines ******************)

function Numb2Acc(n:integer):string;
var
  I,NA:integer;
  s:string;

begin
  s:=IntToStr(n);
  I:=Length(s);
  Result:=s;
  NA:=0;

  while (I >0) do begin
    if ((Length(Result)-I+1-NA) mod 3=0) and (I <>1) then begin
      Insert(' ', Result,I);
      Inc(NA);
    end;

    Dec(I);
  end;
end;

{$IFNDEF UseRx}
function WidthOf(r:tRect):integer;
begin
  Result:=r.Right-r.Left;
end;

function HeightOf(r:tRect):integer;
begin
  Result:=r.Bottom-r.Top;
end;
{$ENDIF}

(***************** Open sound dialog *****************)

constructor TLsOpenSndDlg.Create(aOwner:tComponent);
begin
  inherited Create(aOwner);

  Filter:=LoadStr(SWavMask);

  FBtnsPanel:=tPanel.Create(Self);
  with FBtnsPanel do begin
    Name:='panBtns';
    Caption:='';
    SetBounds(5,170,300,76);
    //BevelInner:=bvNone;
    BevelOuter:=bvNone;
    TabOrder:=1;
  end;

  FLabel:=tLabel.Create(FBtnsPanel);
  with FLabel do begin
    Name:='lblTest';
    SetBounds(2,9,100,16);
    Autosize:=false;
    Caption:=LoadStr(STest);
    Parent:=FBtnsPanel;
  end;

  {$IFDEF UseRx}
  FPlayBtn:=tRxSpeedButton.Create(FBtnsPanel);
  {$ELSE}
  FPlayBtn:=tSpeedButton.Create(FBtnsPanel);
  {$ENDIF}
  with FPlayBtn do begin
    Name:='sbtnPlay';
    SetBounds(100,6,22,22);
    Enabled:=false;
    Hint:=LoadStr(SPlayHint);
    Glyph.LoadFromResourceName(hInstance,'PlayGlyph');
    OnClick:=PlayClick;
    Parent:=FBtnsPanel;
  end;

  {$IFDEF UseRx}
  FStopBtn:=tRxSpeedButton.Create(FBtnsPanel);
  {$ELSE}
  FStopBtn:=tSpeedButton.Create(FBtnsPanel);
  {$ENDIF}
  with FStopBtn do begin
    Name:='sbtnStop';
    SetBounds(123,6,22,22);
    Enabled:=false;
    Hint:=LoadStr(SStopHint);
    Glyph.LoadFromResourceName(hInstance,'StopGlyph');
    OnClick:=StopClick;
    Parent:=FBtnsPanel;
  end;

  FWavInfo:=tLabel.Create(FBtnsPanel);
  with FWavInfo do begin
    Name:='lblWavInfo';
    SetBounds(158,9,100,16);
    Autosize:=false;
    Caption:='';
    Parent:=FBtnsPanel;
  end;
end;

destructor TLsOpenSndDlg.Destroy;
begin
  FLabel.Free;
  FPlayBtn.Free;
  FStopBtn.Free;
  FWavInfo.Free;
  FBtnsPanel.Free;
  inherited Destroy;
end;

procedure TLsOpenSndDlg.DoSelectionChange;
var
  FullName:string;
  ValidWav:boolean;
  f:file;
  h:tWaveHdr;
  o:integer;
  s:string;

function ValidFile(const fn:string):boolean;
begin
  Result:=GetFileAttributes(pChar(fn)) <>$FFFFFFFF;
end;

begin
  FullName:=FileName;
  ValidWav:=FileExists(FullName) and ValidFile(FullName);

  if ValidWav then begin
    AssignFile(f,FullName);
    reset(f,1);
    BlockRead(f,h,SizeOf(tWaveHdr),o);
    CloseFile(f);

    if (o =SizeOf(tWaveHdr)) and
       (h.Marker1 ='RIFF') and
       (h.Marker2 ='WAVE') and
       (h.Marker3 ='fmt ') then begin
     // correct WAVE-file
     if h.Channels >1 then s:=LoadStr(SStereo)
     else s:=LoadStr(SMono);

     ValidWav:=true;
     FWavInfo.Caption:=FloatToStrF(h.DataBytes/h.BytesPerSecond,ffFixed,15,3)+
                       ' '+LoadStr(SSecs)+'; '+
                       Numb2Acc(h.SampleRate)+' '+LoadStr(SHz)+'; '+
                       IntToStr(h.BitsPerSample)+' '+LoadStr(SBits)+'; '+
                       s;
   end
   else begin
     // not a WAVE-file
     ValidWav:=false;
     FWavInfo.Caption:=''; //LoadStr(SWavInfo)+LoadStr(SErrNotAWav);
   end;
  end;

  FPlayBtn.Enabled:=ValidWav;

  inherited DoSelectionChange;
end;

procedure TLsOpenSndDlg.DoClose;
begin
  inherited DoClose;
  { Hide any hint windows left behind }
  Application.HideHint;
end;

procedure TLsOpenSndDlg.DoShow;
var
  BtnsPanRect,StaticRect:tRect;

begin
  { Set butons area to entire dialog }
  GetClientRect(Handle,BtnsPanRect);
  StaticRect:=GetStaticRect;

  { Move buttons area to bottom of static area }
  BtnsPanRect.Top:=StaticRect.Top+HeightOf(StaticRect);
  Inc(BtnsPanRect.Left,8);
  FBtnsPanel.BoundsRect:=BtnsPanRect;
  FWavInfo.Width:=WidthOf(BtnsPanRect)-FWavInfo.Left-4;

  FBtnsPanel.ParentWindow:=Handle;
  inherited DoShow;
end;

function TLsOpenSndDlg.Execute;
begin
  if NewStyleControls and not (ofOldStyleDialog in Options) then
    Template:='SNDDLGTPL'
  else
    Template:=nil;

  Result:=inherited Execute;
end;

procedure TLsOpenSndDlg.MCINotify(var Message:tMessage);
begin
  CloseSndDevice;
  DoSelectionChange;
  FStopBtn.Enabled:=false;
end;

procedure TLsOpenSndDlg.PlayClick(Sender:tObject);
var
  dwRez:longint;
  cErr:array[0..128] of char;

begin
  dwRez:=PlayWaveFile;
  if dwRez <>0 then begin
    mciGetErrorString(dwRez,cErr,SizeOf(cErr));
    MessageDlg(cErr,mtWarning,[mbOk],0);
  end
  else begin
    FPlayBtn.Enabled:=false;
    FStopBtn.Enabled:=true;
  end;
end;

procedure TLsOpenSndDlg.StopClick(Sender:tObject);
begin
  StopSound;
end;

function TLsOpenSndDlg.PlayWaveFile:longint;
var
  mciOpenParms:tMCI_OPEN_PARMS;
  mciPlayParms:tMCI_PLAY_PARMS;

begin
  // Open the device by specifying the device and filename.
  // MCI will choose a device capable of playing the specified file.

  mciOpenParms.lpstrDeviceType:='waveaudio';
  mciOpenParms.lpstrElementName:=pChar(FileName);

  Result:=mciSendCommand(
    0,
    MCI_OPEN,
    MCI_OPEN_TYPE or MCI_OPEN_ELEMENT,
    longint(@mciOpenParms));

  if Result <>0 then
    // Failed to open device. Don't close it; just return error.
    exit;

  // The device opened successfully; get the device ID.
  FDeviceId:=mciOpenParms.wDeviceID;

  // Begin playback. The window procedure function for the parent
  // window will be notified with an MM_MCINOTIFY message when
  // playback is complete. At this time, the window procedure closes
  // the device.

  mciPlayParms.dwCallback:=Handle;

  Result:=mciSendCommand(
    FDeviceId,
    MCI_PLAY,
    MCI_NOTIFY,
    longint(@mciPlayParms));
end;

procedure TLsOpenSndDlg.StopSound;
var
  mciGenParms:tMCI_GENERIC_PARMS;

begin
  mciGenParms.dwCallback:=Handle;

  // stop playing
  mciSendCommand(
    FDeviceId,
    MCI_STOP,
    0, //MCI_NOTIFY,
    longint(@mciGenParms));
end;

procedure TLsOpenSndDlg.CloseSndDevice;
var
  mciGenParms:tMCI_GENERIC_PARMS;

begin
  if FDeviceId =0 then exit;

  mciGenParms.dwCallback:=Handle;

  // close the MCI device
  mciSendCommand(
    FDeviceId,
    MCI_CLOSE,
    MCI_WAIT,
    longint(@mciGenParms));

  FDeviceId:=0;
end;

end.
