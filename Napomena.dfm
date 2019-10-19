object Odabir: TOdabir
  Left = 357
  Top = 172
  Width = 144
  Height = 200
  BorderIcons = []
  Caption = 'Odabir'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 32
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
    OnKeyDown = FormKeyDown
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 8
    Width = 125
    Height = 17
    Caption = 'RAZBIJENA ROBA'
    TabOrder = 1
    OnKeyDown = FormKeyDown
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 24
    Width = 125
    Height = 17
    Caption = 'ROK TRAJANJA'
    TabOrder = 2
    OnKeyDown = FormKeyDown
  end
  object RadioButton3: TRadioButton
    Left = 8
    Top = 40
    Width = 125
    Height = 17
    Caption = 'UKRADENA ROBA'
    TabOrder = 3
    OnKeyDown = FormKeyDown
  end
  object RadioButton4: TRadioButton
    Left = 8
    Top = 56
    Width = 125
    Height = 17
    Caption = 'POKVARENA ROBA'
    TabOrder = 4
    OnKeyDown = FormKeyDown
  end
  object RadioButton5: TRadioButton
    Left = 8
    Top = 72
    Width = 125
    Height = 17
    Caption = 'O'#352'TE'#262'ENA ROBA'
    TabOrder = 5
    OnKeyDown = FormKeyDown
  end
  object RadioButton6: TRadioButton
    Left = 8
    Top = 88
    Width = 125
    Height = 17
    Caption = 'VO'#262'E I POVR'#262'E'
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object RadioButton7: TRadioButton
    Left = 8
    Top = 104
    Width = 125
    Height = 17
    Caption = 'DELIKATESE'
    TabOrder = 7
    OnKeyDown = FormKeyDown
  end
  object RadioButton8: TRadioButton
    Left = 8
    Top = 120
    Width = 125
    Height = 17
    Caption = 'CVIJE'#262'E'
    TabOrder = 8
    OnKeyDown = FormKeyDown
  end
end
