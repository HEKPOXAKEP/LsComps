object SQLErrFm: TSQLErrFm
  Left = 389
  Top = 218
  ActiveControl = panErrCode
  BorderStyle = bsDialog
  Caption = 'SQL Error'
  ClientHeight = 355
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  DesignSize = (
    473
    355)
  PixelsPerInch = 125
  TextHeight = 16
  object pgcSQLErr: TPageControl
    Left = 0
    Top = 0
    Width = 473
    Height = 316
    ActivePage = tsGeneral
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      object imgError: TImage
        Left = 16
        Top = 16
        Width = 32
        Height = 32
        Picture.Data = {
          055449636F6E0000010002002020100000000000E80200002600000010101000
          00000000280100000E0300002800000020000000400000000100040000000000
          8002000000000000000000000000000000000000000000000000800000800000
          0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
          00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
          0000000000000000000011111110000000000000000000000111FFFFFFF11100
          00000000000000099FFF1919191FFF11000000000000009FF1919191919191FF
          10000000000009F91919191919191919F100000000009F919191919191919191
          9F1000000009F919191919191919191919F10000009FF1919191919191919191
          919F1000009F19191919191919191919191F100009F191919191919191919191
          9191F10009F9191919191919191919191919F10009F191919191919191919191
          9191F1009F191919191919191919191919191F109F9188888888888888888888
          88819F109F19FFFFFFFFFFFFFFFFFFFFFF891F109F91FFFFFFFFFFFFFFFFFFFF
          FF819F109F19FFFFFFFFFFFFFFFFFFFFFF891F109F91FFFFFFFFFFFFFFFFFFFF
          FF819F109F191919191919191919191919191F1009F191919191919191919191
          9191F10009F9191919191919191919191919F10009F191919191919191919191
          9191F100009F19191919191919191919191F1000009FF1919191919191919191
          919F10000009F919191919191919191919F1000000009F919191919191919191
          9F100000000009F91919191919191919F10000000000009FF1919191919191FF
          10000000000000099FFF1919191FFF9900000000000000000999FFFFFFF99900
          0000000000000000000099999990000000000000FFF01FFFFFC003FFFF0000FF
          FC00007FFC00003FF800001FF000000FE0000007C0000003C000000380000001
          8000000180000001000000000000000000000000000000000000000000000000
          00000000800000018000000180000001C0000003C0000003E0000007F000000F
          F800001FFC00003FFE00007FFF8003FFFFF01FFF280000001000000020000000
          0100040000000000C00000000000000000000000000000000000000000000000
          00008000008000000080800080000000800080008080000080808000C0C0C000
          0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
          000000000000FFFFFFF00000000F1919191F000000F191919191F0000F191919
          19191F00F1919191919191F0F9191919191919F0F1888888888881F0F1FFFFFF
          FFFFF9F0F1FFFFFFFFFFF1F0F9191919191919F0F1919191919191F00F191919
          19191F0000F191919191F000000F1919191F00000000FFFFFFF00000F01FF191
          F00F9191E0079191C00310008001191900001919000019190000100000009191
          00009191000091910000F10080011919C0031919E0071919F00FF100}
      end
      object lblGeneral: TLabel
        Left = 72
        Top = 24
        Width = 377
        Height = 41
        AutoSize = False
        Caption = 'Fatal error ocurred while executing sql statement'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Bevel1: TBevel
        Left = 8
        Top = 72
        Width = 449
        Height = 2
      end
      object Label1: TLabel
        Left = 48
        Top = 96
        Width = 81
        Height = 16
        AutoSize = False
        Caption = 'Error code:'
      end
      object Label2: TLabel
        Left = 48
        Top = 128
        Width = 81
        Height = 16
        AutoSize = False
        Caption = 'SQL code:'
      end
      object Bevel2: TBevel
        Left = 8
        Top = 176
        Width = 449
        Height = 2
      end
      object panErrCode: TPanel
        Left = 128
        Top = 92
        Width = 81
        Height = 25
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = '-666'
        TabOrder = 0
      end
      object panSQLCode: TPanel
        Left = 128
        Top = 124
        Width = 81
        Height = 25
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = '-666'
        TabOrder = 1
      end
    end
    object tsError: TTabSheet
      Caption = 'Error'
      ImageIndex = 1
      DesignSize = (
        465
        285)
      object grpErrorMsg: TGroupBox
        Left = 8
        Top = 8
        Width = 449
        Height = 129
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Error message'
        TabOrder = 0
        DesignSize = (
          449
          129)
        object memErrorMsg: TMemo
          Left = 8
          Top = 24
          Width = 433
          Height = 94
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object grpErrorCodes: TGroupBox
        Left = 8
        Top = 144
        Width = 449
        Height = 130
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Error codes'
        TabOrder = 1
        DesignSize = (
          449
          130)
        object memErrorCodes: TMemo
          Left = 8
          Top = 24
          Width = 433
          Height = 94
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
    object tsSQLMsg: TTabSheet
      Caption = 'SQL'
      ImageIndex = 3
      DesignSize = (
        465
        285)
      object grpSQLMsg: TGroupBox
        Left = 8
        Top = 8
        Width = 449
        Height = 129
        Anchors = [akLeft, akTop, akRight]
        Caption = 'SQL message'
        TabOrder = 0
        DesignSize = (
          449
          129)
        object memSQLMsg: TMemo
          Left = 8
          Top = 24
          Width = 433
          Height = 94
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object grpSQL: TGroupBox
        Left = 8
        Top = 144
        Width = 449
        Height = 130
        Anchors = [akLeft, akTop, akRight]
        Caption = 'SQL statement'
        TabOrder = 1
        DesignSize = (
          449
          130)
        object memSQL: TMemo
          Left = 8
          Top = 24
          Width = 433
          Height = 94
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
  end
  object btnOk: TButton
    Left = 388
    Top = 323
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
end
