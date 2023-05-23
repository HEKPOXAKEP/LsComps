object fmConnectEx: TfmConnectEx
  Left = 331
  Top = 175
  HelpContext = 4
  ActiveControl = cboxPath
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Database'
  ClientHeight = 264
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Pitch = fpFixed
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  OnShow = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object lblPath: TLabel
    Left = 16
    Top = 80
    Width = 57
    Height = 25
    AutoSize = False
    Caption = 'Path:'
    Layout = tlCenter
  end
  object lblServer: TLabel
    Left = 16
    Top = 48
    Width = 57
    Height = 25
    AutoSize = False
    Caption = 'Server:'
    Layout = tlCenter
  end
  object Bevel1: TBevel
    Left = 8
    Top = 112
    Width = 329
    Height = 2
  end
  object Image1: TImage
    Left = 16
    Top = 8
    Width = 32
    Height = 32
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      0000000000000000000080000080000000808000800000008000800080800000
      C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF0000000000000000000000000000000000000000000000000000000087
      7708880000000000000000000000087778788880000000000000000000000878
      8000008000000000077770000000088777888800000000007777700000000877
      7878888000008888770770000000087880000080000800087777700000000887
      7788880000080000877770000000087778788880000800000888800000000878
      8000008000080000000000000000088777888800000800000000000000000877
      7878888000080000000000000000087880000080000088888888888880000887
      7788880000000000000000000800087778788880000000000000000008000878
      8000008000000000000000000800088777888800000000000000088880000877
      7878888007777777777700000000087880000080077777777777000000B00887
      77777700000000000000000000B0087777777770000008880000000000B00087
      77777700000000000000000000B0000888000000008777777770000B00B00B00
      000000000084AAAAAA700000B0B0B00000000000008422222A70000000B00000
      00000000008422222A700BBBBB0BBBBBB0000000008422222A70000000B00000
      00000000008422222A700000B0B0B00000000000008444444470000B00B00B00
      00000000008888888880000000B0000000000000000000000000000000B00000
      00000000FFFFFE03FFFFFC21FFFBF800FF83F800FF003800FE03F800F003F800
      EE03F800EF003800EF83F800EFFBF800EFFFF800EFFFF800F0007800FFFFB800
      FFFFB800FFFFB800800878000007F8000007D800800FD800F07FDC01C01FDE03
      800EDBFF800F57FF800FDFFF8008207F800FDFFF800F57FF800EDBFF800FDFFF
      C01FDFFF}
  end
  object Bevel2: TBevel
    Left = 8
    Top = 184
    Width = 329
    Height = 2
  end
  object lblUser: TLabel
    Left = 16
    Top = 120
    Width = 81
    Height = 24
    AutoSize = False
    Caption = 'User:'
    Layout = tlCenter
  end
  object lblPassword: TLabel
    Left = 16
    Top = 152
    Width = 81
    Height = 24
    AutoSize = False
    Caption = 'Password:'
    Layout = tlCenter
  end
  object lblDialect: TLabel
    Left = 16
    Top = 197
    Width = 81
    Height = 16
    AutoSize = False
    Caption = 'Dialect:'
  end
  object Bevel3: TBevel
    Left = 8
    Top = 224
    Width = 329
    Height = 2
  end
  object cboxPath: TComboBox
    Left = 72
    Top = 80
    Width = 225
    Height = 24
    Hint = 'Path to databse'
    ItemHeight = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object cboxServer: TComboBox
    Left = 72
    Top = 48
    Width = 225
    Height = 24
    Hint = 'Database server name'
    ItemHeight = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object btnServer: TButton
    Left = 304
    Top = 48
    Width = 24
    Height = 24
    Hint = 'Browse available servers'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnServerClick
  end
  object btnPath: TButton
    Left = 304
    Top = 80
    Width = 24
    Height = 24
    Hint = 'Browse available databases'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnPathClick
  end
  object rgrpProtocol: TRadioGroup
    Left = 72
    Top = 0
    Width = 257
    Height = 41
    Hint = 'Database type'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Local'
      'Network')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TabStop = True
    OnClick = rgrpProtocolClick
  end
  object btnOk: TButton
    Left = 176
    Top = 234
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 256
    Top = 234
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object edUser: TEdit
    Left = 96
    Top = 120
    Width = 233
    Height = 24
    Hint = 'User name'
    TabOrder = 5
  end
  object edPassword: TEdit
    Left = 96
    Top = 152
    Width = 233
    Height = 24
    Hint = 'User password'
    TabOrder = 6
  end
  object cboxDialect: TComboBox
    Left = 96
    Top = 192
    Width = 233
    Height = 24
    ItemHeight = 16
    Items.Strings = (
      'Dialect 1'
      'Dialect 2'
      'Dialect 3')
    TabOrder = 9
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'gdb'
    Filter = 'Interbase GDB|*.gdb'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Title = 'Локальная база данных'
    Left = 128
    Top = 64
  end
  object Socket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    Service = 'gds_dl'
    OnDisconnect = SocketDisconnect
    OnRead = SocketRead
    OnError = SocketError
    Left = 200
    Top = 64
  end
end
