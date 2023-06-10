unit LsFormScale;

interface

uses
  Forms,
  Controls;

procedure DoAutoScale(AForm: TForm);

implementation

type
  TFooClass = class(TControl);  { ���������� �������� ������������ }
                                { �������� Font }

procedure DoAutoScale(AForm: TForm);
const
  cScreenWidth: integer = 800;
  cScreenHeight: integer = 600;
  cPixelsPerInch: integer = 96;
  cFontHeight: integer = -11; {� ������ �������������� �������� �� Font.Height}

var
  i: integer;

begin
  {
  �����!! : ���������� � ���������� �������� �������� Scaled TForm � FALSE.

  ��������� ��������� ������������ ����� ���, ����� ��� ��������� ���������
  �������������� �� ������� ������ � �������� �� ����. ������������� ����
  ������� ���� ���������, ���������� �� ������ ������ �� ����� ����������
  �� ������� �� ����� ��������������. ���� ��, Scaled ��������������� � True
  � ���������� ����� �������������� ���, ����� ��� ���������� � ��� ��
  ������� ������, ��� � �� ����� ��������������.
  }
  if (Screen.width <> cScreenWidth) or 
     (Screen.PixelsPerInch <> cPixelsPerInch) then begin
    AForm.Scaled := true;
    AForm.Height := AForm.Height * Screen.Height div cScreenHeight;
    AForm.Width := AForm.Width * Screen.Width div cScreenWidth;
    AForm.ScaleBy(Screen.Width, cScreenWidth);
  end;
  {
  ���� ��� ���������, ���������� �� ������ ������ �� ����� ���������� ��
  ������� �� ����� ��������������. ���� �� ����� ���������� pixelsperinch
  ����� ���������� �� pixelsperinch �� ����� ��������������, ������ �����
  �������������� ���, ����� ����� �� ���������� �� ���, ������� ���� ��
  ����� ����������. ��������������� ������������ ������ �� ������������,
  ����������� ����� ������� �������� font.height �� ����� ��������������
  �� font.height �� ����� ����������. Font.size � ���� ������ �������� ��
  �����, ��� ��� ��� ����� ���� ��������� �������, ��� ������� �������
  �����������, ��� ���� ����� ����� ��������� �� ��������� ������� ����������.
  ��������, ����� ������� ��� �������� ������ 800x600 � ��������������
  ���������� ��������, �������� ������ font.size = 8. ����� �� ����������
  � ������� � 800x600 � �������� ��������, font.size ����� ����� ����� 8,
  �� ����� ����� ������� ��� ��� ������ � ������� � ���������� ��������.
  ������ ��������������� ��������� ����� ���� � ��� �� ������ �������
  ��� ��������� ���������� �������.
  }
  if (Screen.PixelsPerInch <> cPixelsPerInch) then  begin
    for i := AForm.ControlCount - 1 downto 0 do
      TFooClass(AForm.Controls[i]).Font.Height :=
        (AForm.Font.Height div cFontHeight) * TFooClass(AForm.Controls[i]).Font.Height;
  end;
end;

end.
