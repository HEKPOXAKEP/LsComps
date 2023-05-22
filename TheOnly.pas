(***********************************************)
(*                                             *)
(*                  TheOnly                    *)
(*                  ~~~~~~~                    *)
(*  yet another component to limit the number  *)
(*  of your application's instances to one     *)
(*                                             *)
(*          Version 0.01.01/b0128              *)
(*    Copyright 2006 Lagodrom Solutions Ltd    *)
(*            All rights reserved              *)
(*                                             *)
(***********************************************)

unit TheOnly;

interface

uses
 Windows,
 SysUtils,
 Classes,
 Controls,
 Forms,
 Dialogs;

type
 TTheOnly=class(tComponent)
 private
  FAutomatic:boolean;
  { TRUE: TheOnly will automatically stop second instance and bring
    to the front first instance }

  FSecInstMsg:string;
  { display this message at second instance startup }

  FIpcName:string;
  { memory-mapped file name }

  FIpcHandle:tHandle;
  { memory-mapped file handle }

  FpIpc:pointer;
  { pointer to memory-mapped file data }

  FPrevInstHWnd:HWND;
  { Handle of prev instance main window }

  // ---
  procedure CloseHandles;
  { close FIpcHandle, FpIpc and assign they to zero (nil) }
 protected
  procedure Loaded; override;
 public
  constructor Create(aOwner:tComponent); override;
  destructor Destroy; override;
  // ---
  property PrevInstHWnd:HWND read FPrevInstHWnd;
 published
  property Automatic:boolean read FAutomatic write FAutomatic;
  property IpcName:string read FIpcName write FIpcName;
  property SecInstMsg:string read FSecInstMsg write FSecInstMsg;
 end;

procedure Register;

implementation

{$R TheOnly.res}

procedure Register;
begin
 RegisterComponents('LAGODROM components',[TTheOnly]);
end;

constructor TTheOnly.Create(aOwner:tComponent);
begin
 inherited Create(aOwner);
end;

destructor TTheOnly.Destroy;
begin
 CloseHandles;

 inherited Destroy;
end;

procedure TTheOnly.Loaded;
begin
 inherited Loaded;

 if (csDesigning in ComponentState) or (FIpcName ='') then exit;

 FIpcHandle:=OpenFileMapping(FILE_MAP_READ,false,pChar(FIpcName));
 if FIpcHandle =0 then begin
  // prev instance not found -- create our semaphore
  FIpcHandle:=CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(HWND),pChar(FIpcName));
  if FIpcHandle =0 then
   raise Exception.Create('Unable to CreateFileMapping()');

  FpIpc:=MapViewOfFile(FIpcHandle,FILE_MAP_WRITE,0,0,SizeOf(HWND));
  if FpIpc <>nil then begin
   //HWND(FpIpc^):=tWinControl(Owner).Handle;
   HWND(FpIpc^):=Application.Handle;
   UnmapViewOfFile(FpIpc);
   FpIpc:=nil;
  end
  else begin
   CloseHandles;
   raise Exception.Create('Unable to MapViwOfFile()');
  end;
 end
 else begin
  // found prev instance -- get its wnd handle
  FpIpc:=MapViewOfFile(FIpcHandle,FILE_MAP_READ,0,0,SizeOf(HWND));
  if FpIpc <>nil then begin
   FPrevInstHWnd:=HWND(FpIpc^);

   if FSecInstMsg <>'' then
    MessageDlg(FSecInstMsg,mtWarning,[mbOk],0);

   if FAutomatic then begin
    // automatically stop second instance and bring to front first one
    if IsIconic(FPrevInstHWnd) then begin
     ShowWindow(FPrevInstHWnd,sw_Restore);
     //BringWindowToTop(FPrevInstHWnd);
    end
    else
     SetForegroundWindow(FPrevInstHWnd);

    Application.Terminate;
   end; (*IF FAutomatic*)

   CloseHandles;
  end
  else
   CloseHandles;
 end;
end;

procedure TTheOnly.CloseHandles;
begin
 if FpIpc <>nil then begin
  UnmapViewOfFile(FpIpc);
  FpIpc:=nil;
 end;

 if FIpcHandle <>0 then begin
  CloseHandle(FIpcHandle);
  FIpcHandle:=0;
 end;
end;

end.
