object FormEventLogger: TFormEventLogger
  Left = 0
  Top = 0
  Caption = 'Event Logger'
  ClientHeight = 562
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 359
    Width = 784
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 36
    ExplicitWidth = 340
  end
  object Panel_Top: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 36
    Align = alTop
    TabOrder = 0
    object Button_Start: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 120
      Height = 28
      Align = alLeft
      Caption = 'Start'
      TabOrder = 0
      OnClick = Button_StartClick
    end
    object Button_Stop: TButton
      AlignWithMargins = True
      Left = 130
      Top = 4
      Width = 120
      Height = 28
      Align = alLeft
      Caption = 'Stop'
      Enabled = False
      TabOrder = 1
      OnClick = Button_StopClick
    end
    object Button_Token: TButton
      AlignWithMargins = True
      Left = 408
      Top = 4
      Width = 120
      Height = 28
      Align = alRight
      Caption = 'Token'
      Enabled = False
      TabOrder = 2
      OnClick = Button_TokenClick
    end
    object Button_GlobalConfig: TButton
      AlignWithMargins = True
      Left = 534
      Top = 4
      Width = 120
      Height = 28
      Align = alRight
      Caption = 'Global Config Data'
      Enabled = False
      TabOrder = 3
      OnClick = Button_GlobalConfigClick
    end
    object Button_WSConfig: TButton
      AlignWithMargins = True
      Left = 660
      Top = 4
      Width = 120
      Height = 28
      Align = alRight
      Caption = 'WS Config Data'
      Enabled = False
      TabOrder = 4
      OnClick = Button_WSConfigClick
    end
  end
  object StringGrid_Data: TStringGrid
    Left = 0
    Top = 36
    Width = 784
    Height = 323
    Align = alClient
    ColCount = 1
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 1
    OnClick = StringGrid_DataClick
  end
  object Panel_Details: TPanel
    Left = 0
    Top = 362
    Width = 784
    Height = 200
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      784
      200)
    object Label_Direction: TLabel
      Left = 44
      Top = 6
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Direction:'
    end
    object Label_Verb: TLabel
      Left = 64
      Top = 22
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'Verb:'
    end
    object Label_Resource: TLabel
      Left = 41
      Top = 38
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Resource:'
    end
    object Label_Querystring: TLabel
      Left = 25
      Top = 54
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Query String:'
    end
    object Label_Payload: TLabel
      Left = 48
      Top = 86
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Payload:'
    end
    object Label_DirectionData: TLabel
      Left = 96
      Top = 6
      Width = 31
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Label1'
    end
    object Label_VerbData: TLabel
      Left = 96
      Top = 22
      Width = 31
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Label1'
    end
    object Label_ResourceData: TLabel
      Left = 96
      Top = 38
      Width = 31
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Label1'
    end
    object MemoParams: TMemo
      Left = 96
      Top = 54
      Width = 684
      Height = 35
      Anchors = [akLeft, akTop, akRight]
      Lines.Strings = (
        'MemoParams')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MemoPayload: TMemo
      Left = 96
      Top = 95
      Width = 684
      Height = 98
      Anchors = [akLeft, akTop, akRight, akBottom]
      Lines.Strings = (
        'Memo1')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
end
