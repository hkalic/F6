unit Popis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls;

type
  TPopisForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    procedure DodajStavku;
    procedure ObrisiRed(red:Integer);
    procedure DodajRed(red:Integer);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PopisForm: TPopisForm;

implementation

uses DataUnit,MainUnit,xcel;

{$R *.DFM}

procedure TPopisForm.DodajStavku;
begin
     if pravo[13,2] then
     Begin
          PopisForm.Visible:=True;
          StringGrid1.Cells[0,StringGrid1.RowCount-1]:=Data.Upit.Fields[0].AsString;
          StringGrid1.Cells[1,StringGrid1.RowCount-1]:=Data.Upit.Fields[2].AsString;
          StringGrid1.Cells[2,StringGrid1.RowCount-1]:=Data.Upit.Fields[3].AsString;
          StringGrid1.Cells[3,StringGrid1.RowCount-1]:=Data.Upit.Fields[5].AsString;
          StringGrid1.RowCount:=StringGrid1.RowCount+1;
     end;
end;

procedure TPopisForm.FormCreate(Sender: TObject);
begin
     StringGrid1.Cells[0,0]:='ŠIFRA';
     StringGrid1.Cells[1,0]:='NAZIV ARTIKLA';
     StringGrid1.Cells[2,0]:='JM';
     StringGrid1.Cells[3,0]:='CIJENA';
end;

procedure TPopisForm.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//     ShowMessage(IntToStr(key));
       case key of
       27: Close;
       46: ObrisiRed(StringGrid1.Row); // DELETE Row;
       45: DodajRed(StringGrid1.Row);  // INSERT Row;
       end;
end;

procedure TPopisForm.ObrisiRed(red:Integer);
var i:    Integer;
begin
     For i:=red to StringGrid1.RowCount-2 do StringGrid1.Rows[i]:=StringGrid1.Rows[i+1];
     StringGrid1.RowCount:=StringGrid1.RowCount-1;
end;

procedure TPopisForm.DodajRed(red:Integer);
var i:    Integer;
begin
     StringGrid1.RowCount:=StringGrid1.RowCount+1;
     For i:=StringGrid1.RowCount-1 downto red do StringGrid1.Rows[i]:=StringGrid1.Rows[i-1];
     StringGrid1.Cells[0,red]:='';
     StringGrid1.Cells[1,red]:='';
     StringGrid1.Cells[2,red]:='';
     StringGrid1.Cells[3,red]:='';
end;

procedure TPopisForm.Button2Click(Sender: TObject);
begin
     Excel.Visible:=True;
     Excel.StvoriMe;
     Excel.SGridDodajData(StringGrid1,0);
     Excel.PokaziExcel;
     Excel.Visible:=False;
end;

end.
