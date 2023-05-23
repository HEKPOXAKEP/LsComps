object fmBrowseDlg: TfmBrowseDlg
  Left = 434
  Top = 236
  Width = 273
  Height = 226
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Обзор баз данных'
  Color = clBtnFace
  Constraints.MinHeight = 226
  Constraints.MinWidth = 273
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Pitch = fpFixed
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 265
    Height = 161
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 245
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Выберите базу данных:'
    end
    object lboxDBs: TTextListBox
      Left = 8
      Top = 32
      Width = 249
      Height = 113
      ExtendedSelect = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 16
      TabOrder = 0
      OnClick = lboxDBsClick
      OnDblClick = lboxDBsDblClick
    end
  end
  object btnOk: TButton
    Left = 104
    Top = 168
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 184
    Top = 168
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
