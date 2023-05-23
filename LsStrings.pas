(**************************************************
**                                               **
**     pascal string manipulation for Delphi     **
**     Copyright 2023 LAGODROM Solutions Ltd     **
**  Copyright 1997-1999  UNIVERSAL SOFTWARE Inc  **
**     Portion Copyright TurboPower Software     **
**                                               **
**************************************************)

unit LsStrings;

interface

type
 CharSet=set of char;
 ExtStr=string[3];

function WordCount(const s:string; const WordDelims:CharSet):integer;
{-WordCount given a set of word delimiters, return number of words in S. }
function WordPosition(const n:integer; const s:string; const WordDelims:CharSet):integer;
{-Given a set of word delimiters, return start position of N'th word in S}
function ExtractWord(n:integer; const s:string; const WordDelims:CharSet):string;
{-Given a set of word delimiters, return the N'th word in S}

(******** General purpose string manipulation ********)
function CharStr(Ch:char; Len:integer):string;
{-Return a string of length len filled with ch}
function PadCh(s:string; Ch:char; Len:integer):string;
{-Return a string right-padded to length len with ch}
function Pad(s:string; Len:integer):string;
{-Return a string right-padded to length len with blanks}
function LeftPadCh(s:string; Ch:char; Len:integer):string;
{-Return a string left-padded to length len with ch}
function LeftPad(s:string; Len:integer):string;
{-Return a string left-padded to length len with blanks}
function TrimLead(s:string):string;
{-Return a string with leading white space removed}
function TrimTrail(s:string):string;
{-Return a string with trailing white space removed}
function Trim(s:string):string;
{-Return a string with leading and trailing white space removed}
function CenterCh(s:string; Ch:char; Width:integer):string;
{-Return a string centered in a string of Ch with specified width}
function Center(s:string; Width:integer):string;
{-Return a string centered in a blank string of specified width}
function ReplaceCh(s:string; f:char; r:char):string;
{-Return a string with all F chars replaced by R}

(*************** DOS pathname parsing *****************)
function DefaultExtension(Name:string; Ext:ExtStr):string;
{-Return a file name with a default extension attached}
function ForceExtension(Name:string; Ext:ExtStr):string;
{-Force the specified extension onto the file name}
function JustFilename(PathName:string):string;
{-Return just the filename and extension of a pathname}
function JustName(PathName:string):string;
{-Return just the name (no extension, no path) of a pathname}
function JustExtension(Name:string):ExtStr;
{-Return just the extension of a pathname}
function JustPathname(PathName:string):string;
{-Return just the drive:directory portion of a pathname}
function AddBackSlash(DirName:string):string;
{-Add a default backslash to a directory name}

implementation

const
  Digits:array[0..$F] of char='0123456789ABCDEF';
  DosDelimSet:set of char=['\',':',#0];
  ExtLen=3;

function CharStr(Ch:char; Len:integer):string;
{-Return a string of length len filled with ch}
begin
  SetLength(Result,Len);
  if Len >0 then FillChar(Result[1],Len,Ch);
end;

function PadCh(s:string; Ch:char; Len:integer):string;
{-Return a string right-padded to length len with ch}
begin
  if Length(s) >=Len then
    Result:=s
  else begin
    SetLength(Result,Len);
    Move(s[1],Result[1],Length(s));
    FillChar(Result[succ(Length(s))],Len-Length(s),Ch);
  end;
end;

function Pad(s:string; Len:integer):string;
{-Return a string right-padded to length len with blanks}
begin
  Pad:=PadCh(s,' ',Len);
end;

function LeftPadCh(s:string; Ch:char; Len:integer):string;
{-Return a string left-padded to length len with ch}
begin
  if Length(s) >=Len then
    Result:=s
  else begin
    SetLength(Result,Len);
    Move(s[1],Result[succ(Len)-Length(s)],Length(s));
    FillChar(Result[1],Len-Length(s),Ch);
  end;
end;

function LeftPad(s:string; Len:integer):string;
{-Return a string left-padded to length len with blanks}
begin
  LeftPad:=LeftPadCh(s,' ',Len);
end;

function TrimLead(s:string):string;
{-Return a string with leading white space removed}
var
  i:integer;

begin
  i:=1;
  while (i <=length(s)) and (s[i] in [' ',^I]) do Inc(i);
  Dec(i);
  if i >0 then Delete(s,1,i);
  Result:=s;
end;

function TrimTrail(s:string):string;
{-Return a string with trailing white space removed}
var
  i:integer;

begin
  i:=Length(s);
  while (i >0) and (s[i] in [' ',^I]) do Dec(i);
  Result:=copy(s,1,i);
end;

function Trim(s:string):string;
{-Return a string with leading and trailing white space removed}
begin
  Result:=TrimTrail(TrimLead(s));
end;

function CenterCh(s:string; Ch:char; Width:integer):string;
{-Return a string centered in a string of Ch with specified width}
begin
  if Length(s) >=Width then
    Result:=s
  else begin
    SetLength(Result,Width);
    FillChar(Result[1],Width,Ch);
    Move(s[1],Result[succ(Width-Length(s))],Length(s));
  end;
end;

function Center(s:string; Width:integer):string;
{-Return a string centered in a blank string of specified width}
begin
  Center:=CenterCh(s,' ',Width);
end;

function ReplaceCh(s:string; f:char; r:char):string;
{-Return a string with all F chars replaced by R}
var
  i:integer;

begin
  for i:=1 to Length(s) do if s[i] =f then s[i]:=r;
  Result:=s;
end;

function WordCount(const s:string; const WordDelims:CharSet):integer;
{ WordCount given a set of word delimiters, return number of words in S. }
var
  sLen,i:cardinal;

begin
  Result:=0;
  i:=1;
  sLen:=Length(s);
  while i <=sLen do begin
    while (i <=sLen) and (s[i] in WordDelims) do Inc(i);
    if i <=sLen then Inc(Result);
    while (i <=sLen) and not(s[i] in WordDelims) do Inc(i);
  end;
end;

function WordPosition(const n:integer; const s:string; const WordDelims:CharSet):integer;
var
  Count,i:integer;

begin
  Count:=0;
  i:=1;
  Result:=0;
  while (i <=Length(s)) and (Count <>n) do begin
    { skip over delimiters }
    while (i <=Length(s)) and (s[i] in WordDelims) do Inc(i);
    { if we're not beyond end of S, we're at the start of a word }
    if i <=Length(s) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <>n then
      while (i <=Length(s)) and not (s[i] in WordDelims) do Inc(i)
    else
      Result:=i;
  end;
end;

function ExtractWord(n:integer; const s:string; const WordDelims:CharSet):string;
var
  i:integer;
  Len:integer;

begin
  Len:=0;
  I:=WordPosition(n,s,WordDelims);
  if i <>0 then
    { find the end of the current word }
    while (i <=Length(s)) and not(s[i] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result,Len);
      Result[Len]:=s[i];
      Inc(i);
    end;
  SetLength(Result,Len);
end;

function HasExtension(Name:string; var DotPos:integer):boolean;
{-Return whether and position of extension separator dot in a pathname}
var
  i:integer;

begin
  DotPos:=0;
  for i:=Length(Name) downto 1 do
    if (Name[i] ='.') and (DotPos =0) then DotPos:=i;
  Result:=(DotPos >0) and (Pos('\',copy(Name,succ(DotPos),64)) =0);
end;

function DefaultExtension(Name:string; Ext:ExtStr):string;
{-Return a pathname with the specified extension attached}
var
  DotPos:integer;

begin
  if HasExtension(Name,DotPos) then
    Result:=Name
  else
    if Name ='' then
      Result:=''
    else
      Result:=Name+'.'+Ext;
end;

function ForceExtension(Name:string; Ext:ExtStr):string;
{-Return a pathname with the specified extension attached}
var
  DotPos:integer;

begin
  if HasExtension(Name,DotPos) then
    Result:=copy(Name,1,DotPos)+Ext
  else
    if Name ='' then
      Result:=''
    else
      Result:=Name+'.'+Ext;
end;

function JustExtension(Name:string):ExtStr;
{-Return just the extension of a pathname}
var
  DotPos:integer;

begin
  if HasExtension(Name,DotPos) then
    Result:=copy(Name,succ(DotPos),ExtLen)
  else
    Result:='';
end;

function JustFilename(PathName:string):string;
{-Return just the filename of a pathname}
var
  i:integer;

begin
  i:=succ(Length(PathName));
  repeat
    Dec(I);
  until (PathName[i] in DosDelimSet) or (i =0);
  Result:=copy(PathName,succ(i),64);
end;

function JustName(PathName:string):string;
{-Return just the name (no extension, no path) of a pathname}
var
 DotPos:integer;

begin
  PathName:=JustFileName(PathName);
  DotPos:=Pos('.', PathName);
  if DotPos >0 then
    PathName:=copy(PathName,1,DotPos-1);
  Result:=PathName;
end;

function JustPathname(PathName:string):string;
{-Return just the drive:directory portion of a pathname}
var
  i:integer;

begin
  i:=succ(Length(PathName));
  repeat
    Dec(i);
  until (PathName[i] in DosDelimSet) or (i =0);

  if i =0 then
    {Had no drive or directory name}
    Result:=''
  else
    if i =1 then
      {Either the root directory of default drive or invalid pathname}
      Result:=PathName[1]
    else
      if (PathName[i] ='\') then begin
        if PathName[pred(i)] =':' then
          {Root directory of a drive, leave trailing backslash}
          Result:=copy(PathName,1,i)
        else
          {Subdirectory, remove the trailing backslash}
          Result:=copy(PathName,1,pred(i));
       end else
         {Either the default directory of a drive or invalid pathname}
         Result:=copy(PathName,1,i);
end;

function AddBackSlash(DirName:string):string;
{-Add a default backslash to a directory name}
begin
  if DirName[Length(DirName)] in DosDelimSet then
    Result:=DirName
  else
    Result:=DirName+'\';
end;

end.
