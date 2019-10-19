unit PregledUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids, DBGrids, StdCtrls, dxCntner, dxTL, dxDBCtrl, dxDBGrid, db;

type
  TPregledForm = class(TForm)
    StatusBar1: TStatusBar;
    Button1: TButton;
    DBGrid1: TdxDBGrid;
    DBGrid1Column1: TdxDBGridColumn;
    DBGrid1Column2: TdxDBGridColumn;
    DBGrid1Column3: TdxDBGridColumn;
    DBGrid1Column4: TdxDBGridColumn;
    DBGrid1Column5: TdxDBGridColumn;
    DBGrid1Column6: TdxDBGridColumn;
    DBGrid1Column7: TdxDBGridColumn;
    DBGrid1Column8: TdxDBGridColumn;
    DBGrid1Column9: TdxDBGridColumn;
    DBGrid1Column10: TdxDBGridColumn;
    DBGrid1Column11: TdxDBGridColumn;
    DBGrid1Column12: TdxDBGridColumn;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PregledForm: TPregledForm;

implementation

uses DataUnit, PojamUnit, MainUnit;

{$R *.DFM}

procedure TPregledForm.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = 27 then Close;
//     if Key = 13 then DBGrid1.CopySelectedToClipboard;
end;

procedure TPregledForm.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
     if Key in ['A'..'Z','a'..'z','0'..'9','š','ð','è','æ','ž','Š','Ð','Ž','Æ','È','%','<','>'] then
     begin
          PojamForm.Edit1.Text := Key;
          PojamForm.Edit1.SelStart := 1;
          PojamForm.ShowModal;
          if PojamForm.ModRes then Data.Lager.Locate(DBGrid1.FocusedField.FieldName,PojamForm.Edit1.Text,[loCaseInsensitive,loPartialKey]);

     end;
end;

procedure TPregledForm.Button1Click(Sender: TObject);
begin
     if MainForm.SaveDialog1.Execute then
        DBGrid1.SaveToXLS(MainForm.SaveDialog1.FileName, True);
end;

procedure TPregledForm.FormActivate(Sender: TObject);
begin
     DBGrid1.KeyField:=Data.Lager.Fields[0].FieldName;
     DBGrid1Column1.Sorted:=csUp;
     if (UpperCase(MainForm.CurrentUserName)='BORIS') or
        (UpperCase(MainForm.CurrentUserName)='ADMINISTRATOR') then
              DBGrid1Column3.Visible:=False;
end;

end.
