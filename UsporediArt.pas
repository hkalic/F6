unit UsporediArt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxExEdtr, dxDBEdtr, dxDBELib, dxEdLib, dxCntner, dxEditor,
  StdCtrls, DBTables, DB, DBClient, dxTL, dxDBCtrl, dxDBGrid, Provider;

type
  TK2A = class(TForm)
    GroupBox1: TGroupBox;
    dxDBGrid1: TdxDBGrid;
    dxDBGrid1Column1: TdxDBGridColumn;
    dxDBGrid1Column2: TdxDBGridColumn;
    dxDBGrid1Column3: TdxDBGridColumn;
    dxDBGrid1Column4: TdxDBGridColumn;
    LBaza1: TDataSource;
    Query1: TQuery;
    GroupBox2: TGroupBox;
    dxDBGrid2: TdxDBGrid;
    dxDBGrid2Column1: TdxDBGridColumn;
    dxDBGrid2Column2: TdxDBGridColumn;
    dxDBGrid2Column3: TdxDBGridColumn;
    dxDBGrid2Column4: TdxDBGridColumn;
    dxDBGrid1Column5: TdxDBGridColumn;
    dxDBGrid2Column5: TdxDBGridColumn;
    procedure dxDBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure dxDBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Daj_K2A(polje,str:string);
    procedure dxDBGrid1Enter(Sender: TObject);
    procedure dxDBGrid1Exit(Sender: TObject);
    procedure dxDBGrid1CustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  K2A: TK2A;

implementation

uses MainUnit, DataUnit, PojamUnit;

{$R *.dfm}

procedure TK2A.dxDBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
     if Key in ['A'..'Z','a'..'z','0'..'9','š','ð','è','æ','ž','Š','Ð','Ž','Æ','È','%'] then
     begin
          PojamForm.Edit1.Text := Key;
          PojamForm.Edit1.SelStart := 1;
          PojamForm.ShowModal;
//          if PojamForm.ModRes then Query1.Locate((Sender as TdxDBGrid).FocusedField.FieldName, PojamForm.Edit1.Text, [loCaseInsensitive, loPartialKey]);
          if PojamForm.ModRes then Daj_K2A((Sender as TdxDBGrid).FocusedField.FieldName, PojamForm.Edit1.Text);
     end;
end;

procedure TK2A.dxDBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key=27 then Close;
end;

procedure TK2A.Daj_K2A(polje,str:string);
var Uvjet, Order, Top: String;
begin
     if Polje = 'Asa' then
     begin
          Uvjet := 'AND al.sifra_artikla>="'+Str+'"';
          Order := 'ORDER BY al.sifra_artikla';
     end
     else if Polje = 'Ksa' then
     begin
          Uvjet := 'AND ko.sifra_artikla>="'+Str+'"';
          Order := 'ORDER BY ko.sifra_artikla';
     end
     else if Polje = 'Ana' then
     begin
          Uvjet := 'AND al.naziv_artikla like "'+Str+'%"';
          Order := 'ORDER BY al.naziv_artikla';
     end
     else if Polje = 'Kna' then
     begin
          Uvjet := 'AND ko.naziv_artikla like "'+Str+'%"';
          Order := 'ORDER BY ko.naziv_artikla';
     end
     else if Polje = 'Kng' then
     begin
          Uvjet := 'AND kg.naziv_grupe_art like "'+Str+'%"';
          Order := 'ORDER BY ko.naziv_artikla';
     end
     else if Polje = 'Ang' then
     begin
          Uvjet := 'AND ag.naziv_grupe_art like "'+Str+'%"';
          Order := 'ORDER BY al.naziv_artikla';
     end
     else if Polje = 'Ksg' then
     begin
          Uvjet := 'AND ko.sifra_grupe_art = "'+Str+'"';
          Order := 'ORDER BY ko.naziv_artikla';
     end
     else if Polje = 'Asg' then
     begin
          Uvjet := 'AND al.sifra_grupe_art = "'+Str+'"';
          Order := 'ORDER BY al.naziv_artikla';
     end
     else if Polje = 'bk' then
     begin
          Uvjet := 'AND kb.sifra_bar_koda = "'+Str+'"';
          Order := 'ORDER BY al.naziv_artikla';
     end
     else
     begin
          Uvjet := '';
          Order := '';
     end;
     if str='' then top:='' else top:='TOP 1000';
//     ShowMessage(Query1.SQL.Text);
     Data.UpitOpen(Query1, ' SELECT '+top+
                           ' bk=null,'+
                           ' Kng=kg.naziv_grupe_art,'+
                           ' Ksg=ko.sifra_grupe_art,'+
                           ' Kna=ko.naziv_artikla,'+
                           ' Ksa=ko.sifra_artikla,'+
                           ' Asa=al.sifra_artikla,'+
                           ' Ana=al.naziv_artikla,'+
                           ' Asg=al.sifra_grupe_art,'+
                           ' Ang=ag.naziv_grupe_art'+
                           ' FROM roba0302.dbo.artikal ko (nolock), roba0302.dbo.grupa_artikla kg (nolock),'+
                           ' roba0301.dbo.artikal al (nolock), roba0301.dbo.grupa_artikla ag (nolock),'+
                           ' roba0301.dbo.bar_kod ab (nolock), roba0302.dbo.bar_kod kb (nolock)'+
                           ' WHERE kb.sifra_artikla=ko.sifra_artikla'+
                           ' AND kg.sifra_grupe_art=ko.sifra_grupe_art'+
                           ' AND ab.sifra_artikla=al.sifra_artikla'+
                           ' AND ab.sifra_bar_koda=kb.sifra_bar_koda'+
                           ' AND ag.sifra_grupe_art=al.sifra_grupe_art '+Uvjet+
                           ' GROUP BY kg.naziv_grupe_art, ko.sifra_grupe_art, ko.naziv_artikla, ko.sifra_artikla, al.sifra_artikla, al.naziv_artikla, al.sifra_grupe_art, ag.naziv_grupe_art '
                           +Order);
end;

procedure TK2A.dxDBGrid1Enter(Sender: TObject);
begin
     (Sender as TdxDBGrid).HighlightColor:=clHighlight;
end;

procedure TK2A.dxDBGrid1Exit(Sender: TObject);
begin
     (Sender as TdxDBGrid).HighlightColor:=clMenu;
end;

procedure TK2A.dxDBGrid1CustomDrawCell(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
  ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
  var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
  var ADone: Boolean);
begin
     if not(Sender as TdxDBGrid).Focused then
     begin
        if ASelected then
        Begin
             AColor := clSilver;
             AFont.Color := clBlack;
        end;
     end else
     begin
        if ASelected then
        Begin
             AColor := clYellow;
             AFont.Color := clRed;
        end;
     end;
end;

end.
