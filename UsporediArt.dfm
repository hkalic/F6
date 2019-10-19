object K2A: TK2A
  Left = 276
  Top = 312
  Width = 926
  Height = 463
  Caption = 'Usporedba artikala Konzum - Alastor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 452
    Height = 436
    Align = alLeft
    Caption = ' Konzum '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object dxDBGrid1: TdxDBGrid
      Left = 2
      Top = 15
      Width = 448
      Height = 419
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnEnter = dxDBGrid1Enter
      OnExit = dxDBGrid1Exit
      OnKeyDown = dxDBGrid1KeyDown
      OnKeyPress = dxDBGrid1KeyPress
      BandFont.Charset = DEFAULT_CHARSET
      BandFont.Color = clWindowText
      BandFont.Height = -11
      BandFont.Name = 'MS Sans Serif'
      BandFont.Style = [fsBold]
      DataSource = LBaza1
      Filter.Criteria = {00000000}
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -9
      HeaderFont.Name = 'MS Sans Serif'
      HeaderFont.Style = [fsBold]
      OptionsBehavior = [edgoAutoSort, edgoDragScroll, edgoMouseScroll, edgoTabThrough, edgoVertThrough]
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoUseBookmarks]
      PreviewFont.Charset = DEFAULT_CHARSET
      PreviewFont.Color = clBlue
      PreviewFont.Height = -11
      PreviewFont.Name = 'MS Sans Serif'
      PreviewFont.Style = [fsBold]
      OnCustomDrawCell = dxDBGrid1CustomDrawCell
      object dxDBGrid1Column1: TdxDBGridColumn
        Caption = 'Naziv grupe'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HeaderAlignment = taCenter
        Width = 95
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Kng'
      end
      object dxDBGrid1Column2: TdxDBGridColumn
        Caption = #352'ifra'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HeaderAlignment = taCenter
        Width = 32
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Ksg'
      end
      object dxDBGrid1Column5: TdxDBGridColumn
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Width = 20
        BandIndex = 0
        RowIndex = 0
        FieldName = 'bk'
      end
      object dxDBGrid1Column3: TdxDBGridColumn
        Caption = 'Naziv artikla'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HeaderAlignment = taCenter
        Width = 221
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Kna'
      end
      object dxDBGrid1Column4: TdxDBGridColumn
        Caption = #352'ifra'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HeaderAlignment = taCenter
        Width = 60
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Ksa'
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 452
    Top = 0
    Width = 466
    Height = 436
    Align = alClient
    Caption = ' Alastor '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object dxDBGrid2: TdxDBGrid
      Left = 2
      Top = 15
      Width = 462
      Height = 419
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      SummaryGroups = <>
      SummarySeparator = ', '
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnEnter = dxDBGrid1Enter
      OnExit = dxDBGrid1Exit
      OnKeyDown = dxDBGrid1KeyDown
      OnKeyPress = dxDBGrid1KeyPress
      BandFont.Charset = DEFAULT_CHARSET
      BandFont.Color = clWindowText
      BandFont.Height = -11
      BandFont.Name = 'MS Sans Serif'
      BandFont.Style = [fsBold]
      DataSource = LBaza1
      Filter.Criteria = {00000000}
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'MS Sans Serif'
      HeaderFont.Style = [fsBold]
      OptionsBehavior = [edgoAutoCopySelectedToClipboard, edgoAutoSort, edgoDragScroll, edgoMouseScroll, edgoTabThrough, edgoVertThrough]
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoUseBookmarks]
      PreviewFont.Charset = DEFAULT_CHARSET
      PreviewFont.Color = clBlue
      PreviewFont.Height = -11
      PreviewFont.Name = 'MS Sans Serif'
      PreviewFont.Style = [fsBold]
      OnCustomDrawCell = dxDBGrid1CustomDrawCell
      object dxDBGrid2Column4: TdxDBGridColumn
        Caption = #352'ifra'
        HeaderAlignment = taCenter
        Width = 56
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Asa'
      end
      object dxDBGrid2Column3: TdxDBGridColumn
        Caption = 'Naziv artikla'
        HeaderAlignment = taCenter
        Width = 207
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Ana'
      end
      object dxDBGrid2Column5: TdxDBGridColumn
        Width = 20
        BandIndex = 0
        RowIndex = 0
        FieldName = 'bk'
      end
      object dxDBGrid2Column2: TdxDBGridColumn
        Caption = #352'ifra'
        HeaderAlignment = taCenter
        Width = 38
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Asg'
      end
      object dxDBGrid2Column1: TdxDBGridColumn
        Caption = 'Naziv grupe'
        HeaderAlignment = taCenter
        Width = 121
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Ang'
      end
    end
  end
  object LBaza1: TDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 88
    Top = 224
  end
  object Query1: TQuery
    AutoCalcFields = False
    DatabaseName = 'Laj2'
    SQL.Strings = (
      'SELECT'
      'Kng=kg.naziv_grupe_art,'
      'Ksg=ko.sifra_grupe_art,'
      'Kna=ko.naziv_artikla,'
      'Ksa=ko.sifra_artikla,'
      'Asa=al.sifra_artikla,'
      'Ana=al.naziv_artikla,'
      'Asg=al.sifra_grupe_art,'
      'Ang=ag.naziv_grupe_art'
      
        'FROM roba0302.dbo.artikal ko (nolock), roba0302.dbo.grupa_artikl' +
        'a kg (nolock),'
      
        'roba0301.dbo.artikal al (nolock), roba0301.dbo.grupa_artikla ag ' +
        '(nolock),'
      'nebula.dbo.deskript x (nolock)'
      'WHERE x.konzum=ko.sifra_artikla'
      'AND kg.sifra_grupe_art=ko.sifra_grupe_art'
      'AND x.alastor=al.sifra_artikla '
      'AND ag.sifra_grupe_art=al.sifra_grupe_art'
      '')
    Left = 48
    Top = 224
  end
end
