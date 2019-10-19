unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, StdCtrls, Db, DBTables,
  dxCntner, dxTL, dxDBCtrl, dxDBGrid;

type
  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    Panel3: TPanel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    DBGrid2: TDBGrid;
    Config: TMemo;
    Button1: TButton;
    StringGrid1: TStringGrid;
    Button2: TButton;
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
    SaveDialog1: TSaveDialog;
    CheckBox1: TCheckBox;
    TempGrid: TdxDBGrid;
    dxDBGridColumn1: TdxDBGridColumn;
    dxDBGridColumn3: TdxDBGridColumn;
    dxDBGridColumn4: TdxDBGridColumn;
    dxDBGridColumn5: TdxDBGridColumn;
    dxDBGridColumn6: TdxDBGridColumn;
    dxDBGridColumn7: TdxDBGridColumn;
    dxDBGridColumn8: TdxDBGridColumn;
    dxDBGridColumn9: TdxDBGridColumn;
    TempGridColumn11: TdxDBGridColumn;
    TempGridColumn12: TdxDBGridColumn;
    TempGridColumn13: TdxDBGridColumn;
    TempGridColumn14: TdxDBGridColumn;
    TempGridColumn15: TdxDBGridColumn;
    TempGridColumn16: TdxDBGridColumn;
    TempGridColumn17: TdxDBGridColumn;
    TempGridColumn18: TdxDBGridColumn;
    Button3: TButton;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Change(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox2Change(Sender: TObject);
    procedure SpeedButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function CurrentUserName:String;
    function CurrentComputerName:String;
    procedure FormDestroy(Sender: TObject);
    procedure Otpis_detalji;
    procedure Otpis_zaglavlja;
    procedure Dodaj_otpis;
    procedure Brisi_otpis;
    procedure Button1Click(Sender: TObject);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DodajStavku;
    procedure ObrisiRed(red:Integer);
    procedure DodajRed(red:Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  flag_brisanje, flag_excel, flag_otpis, flag_cjenik: Boolean;
  flag_stavka, sifra_otpisa: String;
  pravo: Array [1..15,1..2] of Boolean;
{ opis prava }

implementation

uses DataUnit, PojamUnit, PregledUnit, SplashUnit, xcel, Napomena, UsporediArt;

{$R *.DFM}

procedure TMainForm.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
     if Key in ['A'..'Z','a'..'z','0'..'9','š','ð','è','æ','ž','Š','Ð','Ž','Æ','È','%'] then
     begin
          PojamForm.Edit1.Text := Key;
          PojamForm.Edit1.SelStart := 1;
          PojamForm.ShowModal;
//          if PojamForm.ModRes then Data.Daj_Trazi( DBGrid1.Fields[DBGrid1.SelectedIndex].FieldName, PojamForm.Edit1.Text);
          if PojamForm.ModRes then Data.Daj_Trazi( DBGrid1.FocusedField.FieldName, PojamForm.Edit1.Text);
     end;
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
     Data.Daj_Godina;
end;

procedure TMainForm.ComboBox2Change(Sender: TObject);
begin
     Data.Daj_Skladiste;
     DBGrid1.SetFocus;
end;

procedure TMainForm.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Sender=DBGrid1 then
        case Key of
             VK_F1 : SpeedButton1.Click;
             VK_F2 : SpeedButton2.Click;
             VK_F3 : SpeedButton3.Click;
             VK_F4 : SpeedButton4.Click;
             VK_F5 : SpeedButton5.Click;
             VK_F6 : SpeedButton6.Click;
             VK_F7 : SpeedButton7.Click;
             VK_F8 : SpeedButton8.Click;
             VK_F9 : SpeedButton9.Click;
             VK_F10: SpeedButton10.Click;
             VK_F11: SpeedButton11.Click;
             VK_F12: SpeedButton12.Click;
//             VK_DOWN: Data.Otpis.Fields[4].AsString;
             27    : Begin
                          if flag_otpis then
                          begin
                               Button1.Visible:=True;
                               DBGrid1.Visible:=False;
                               DBGrid2.Visible:=True;
                               DBGrid2.SetFocus;
                          end
                          else if MessageDlg('Da li ste sigurni da želite izaæi iz F6?',mtConfirmation,[mbNo,mbYes],0)=mrYes then Close;
                     end;
             13    : Begin
                          if flag_otpis then              // Za otpis
                          begin
                               Data.Insert_S(DBGrid1.Columns[0].Field.AsString, InputBox('Upišite kolièinu za artikal:',DBGrid1.Columns[2].Field.AsString,''));
                               DBGrid1.Visible:=False;
                               DBGrid2.Visible:=True;
                               DBGrid2.SetFocus;
                               Data.OtvoriStavke(sifra_otpisa);
                          end
                          else
                          Begin
                               DodajStavku;     // Za Excel
                          end;
                     end;
        end
     else
        case Key of
             VK_INSERT : Dodaj_otpis;
             VK_DELETE : Brisi_otpis;
             VK_BACK   : Otpis_zaglavlja;
             13    : Begin
                          sifra_otpisa:=Data.Otpis.Fields[4].AsString;
                          flag_brisanje:=not Data.Otpis.Fields[5].IsNull; // Da li se mogu brisati ili dodavati stavke?
                          Otpis_detalji;
                     end;
             27    : Close;
        end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Data.DB1.Connected := False;
     Application.Terminate;
end;

procedure TMainForm.SpeedButtonClick(Sender: TObject);
var polje, str: string;
begin
     if not Data.Upit.Fields[0].IsNull then
     begin
          if Sender = SpeedButton1 then     // Ispis...
               begin
                    if SaveDialog1.Execute then DBGrid1.SaveToXLS(SaveDialog1.FileName, True);
               end
          else if Sender = SpeedButton2 then              // Otvori/zatvori popis
               begin
                    if DBGrid1.Align=alTop then
                    begin
                         DBGrid1.Align:=alClient;
                         DBGrid1.Anchors:=[akLeft,akTop,akRight,akBottom];
                         DBGrid1.Height:=439;
                    end else
                    begin
                         DBGrid1.Align:=alTop;
                         DBGrid1.Anchors:=[akLeft,akTop,akRight];
                         DBGrid1.Height:=300;
                    end;
               end
          else if Sender = SpeedButton3 then Data.Gimme_F3(InputBox('Upišite broj kalkulacije: ','Skladište='+ComboBox2.Text,'00001'))  // Provjera zavisnog troška
          else if Sender = SpeedButton4 then begin end  // Kartica artikla
          else if Sender = SpeedButton5 then Data.Gimme_F5( Data.Upit.Fields[0].AsString ) // Pregled ulaza
          else if Sender = SpeedButton6 then            // Vrijednost lagera
               if ((UpperCase(CurrentUserName)='BORIS') or
                  (UpperCase(CurrentUserName)='JASNAB') or
                  (UpperCase(CurrentUserName)='DANIJEL') or
                  (UpperCase(CurrentUserName)='LEO') or
                  (UpperCase(CurrentUserName)='ALENH') or
                  (UpperCase(CurrentUserName)='TATJANAK') or          // RETFALA
                  (UpperCase(CurrentUserName)='PETARC') or            // ÐAKOVO
                  (UpperCase(CurrentUserName)='ZVONKOB') or           // ÈEPIN
                  (UpperCase(CurrentUserName)='DALIBORUZ') or         // JUG2
                  (UpperCase(CurrentUserName)='DRAZENL') or           // BOROVO
                  (UpperCase(CurrentUserName)='ERIKAB') or            // BELIŠÆE
                  (UpperCase(CurrentUserName)='ZELJKOV') or           // VALPOVO
                  (UpperCase(CurrentUserName)='VERICA') or            // SJENJAK
                  (UpperCase(CurrentUserName)='GORANK') or         // VINKOVCI
                  (UpperCase(CurrentUserName)='DANIJELAP') or         // SUPER
                  (UpperCase(CurrentUserName)='BLAZENKAP') or         // SUPER
                  (UpperCase(CurrentUserName)='DAMIRB') or            // DOMA
                  (UpperCase(CurrentUserName)='NIKOLAO') or           // ŽUPANJA
                  (UpperCase(CurrentUserName)='DRAZENK') or           // BOSUTSKO
                  (UpperCase(CurrentUserName)='MILKAR') or            // BELI MANASTIR
                  (UpperCase(CurrentUserName)='ADMINISTRATOR')) then Data.Gimme_F6 else Data.Gimme_F6_GroupOnly
          else if Sender = SpeedButton7 then Data.Gimme_F7( Data.Upit.Fields[0].AsString ) // Pregled ulaza + storno primki
          else if Sender = SpeedButton8 then Data.Gimme_F8( Data.Upit.Fields[0].AsString ) // Pregled meðuskladišnica
          else if Sender = SpeedButton9 then
               begin
                    if sustav='02' then // za Konzum
                    begin
                       if (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='sifra_artikla') or
                          (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='naziv_artikla') then
                       begin
                            polje:='Ksa';
                            str:=Data.Upit.Fields[0].AsString;
                       end
                       else if (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='sifra_grupe_art') or
                               (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='naziv_grupe_art') then
                       begin
                            polje:='Ksg';
                            str:=Data.Upit.Fields[7].AsString;
                       end
                       else
                       begin
                            polje:='';
                            str:='';
                       end;
                    end
                    else            // za Alastor
                    begin
                       if (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='sifra_artikla') or
                          (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='naziv_artikla') then
                       begin
                            polje:='Asa';
                            str:=Data.Upit.Fields[0].AsString;
                       end
                       else if (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='sifra_grupe_art') or
                               (DBGrid1.Columns[DBGrid1.FocusedColumn].FieldName='naziv_grupe_art') then
                       begin
                            polje:='Asg';
                            str:=Data.Upit.Fields[7].AsString;
                       end
                       else
                       begin
                            polje:='';
                            str:='';
                       end;
                    end;
                    //ShowMessage(polje+' '+str);
                    K2A.Daj_K2A(polje, str);
                    K2A.ShowModal;
               end  // nema
          else if Sender = SpeedButton10 then begin end // nema
          else if Sender = SpeedButton11 then begin end // nema
          else if Sender = SpeedButton12 then Data.Gimme_F12( Data.Upit.Fields[0].AsString ); // Pregled barkodova za artikal
     end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
          Dbgrid1.Visible:=not flag_otpis;
          DBGrid2.Visible:=flag_otpis;
          Button1.Visible:=flag_otpis;
          StringGrid1.Visible:=not flag_otpis;
          Button2.Visible:=not flag_otpis;
          Button3.Visible:=not flag_otpis;
          CheckBox1.Visible:=not flag_otpis;
     if flag_otpis then
          Caption := 'Otpis - ( Korisnik: '+CurrentUserName+' )'
     else
     begin
          Caption := 'Lagerica - ( Korisnik: '+CurrentUserName+' )';
          StringGrid1.Cells[0,0]:='ŠIFRA';
          StringGrid1.Cells[1,0]:='NAZIV ARTIKLA';
          StringGrid1.Cells[2,0]:='JM';
          StringGrid1.Cells[3,0]:='KOLIÈINA';
          StringGrid1.Cells[4,0]:='CIJENA1';
          StringGrid1.Cells[5,0]:='CIJENA2';
          StringGrid1.Cells[6,0]:='ŠIFRA';
          StringGrid1.Cells[7,0]:='NAZIV GRUPE';
          StringGrid1.Cells[8,0]:='RABAT';
     end;
end;

function TMainForm.CurrentUserName:String;
var
  u: array[0..127] of Char;
  sz:DWord;
begin
  sz:=SizeOf(u);
  GetUserName(u,sz);
  Result:=u;
end;

function TMainForm.CurrentComputerName:String;
var
  u: array[0..127] of Char;
  sz:DWord;
begin
  sz:=SizeOf(u);
  GetComputerName(u,sz);
  Result:=u;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
     Excel.GasiExcel;
end;

procedure TMainForm.Otpis_detalji;
begin
     Button1.Visible:=False;
     if DBGrid2.Columns[0].FieldName<>'sifra_artikla' then
     begin
          Data.OtvoriStavke(sifra_otpisa);
          With DBGrid2 do
          begin
               Columns.Clear;
               Columns.Add;
               Columns.Add;
               Columns.Add;
               Columns.Add;
               Columns.Add;
               Columns[0].FieldName:='sifra_artikla';
               Columns[1].FieldName:='naziv_artikla';
               Columns[2].FieldName:='kolicina_otpis';
               Columns[3].FieldName:='cijena_art_u_skl';
               Columns[4].FieldName:='vrijednost_otpisa';
               Columns[0].Title.Caption:='Šifra';
               Columns[1].Title.Caption:='Naziv artikla';
               Columns[2].Title.Caption:='Kolicina';
               Columns[3].Title.Caption:='Cijena';
               Columns[4].Title.Caption:='Vrijednost';
               Columns[0].Width:=50;
               Columns[1].Width:=250;
               Columns[2].Width:=50;
               Columns[3].Width:=50;
               Columns[4].Width:=70;
          end;
     end;
end;

procedure TMainForm.Otpis_zaglavlja;
begin
     Button1.Visible:=True;
     Data.OtvoriZaglavlja;
     With DBGrid2 do
     begin
          Columns.Clear;
          Columns.Add;
          Columns.Add;
          Columns.Add;
          Columns.Add;
          Columns[0].FieldName:='broj_otpisa';
          Columns[1].FieldName:='datum_otpisa';
          Columns[2].FieldName:='napomena_dok';
          Columns[3].FieldName:='operater_dok';
          Columns[0].Title.Caption:='Br.Otpisa ';
          Columns[1].Title.Caption:='Datum otpisa';
          Columns[2].Title.Caption:='Napomena dokumenta';
          Columns[3].Title.Caption:='Operater';
          Columns[0].Width:=55;
          Columns[1].Width:=110;
          Columns[2].Width:=300;
          Columns[3].Width:=150;
     end;
     DBGrid2CellClick(DBGrid2.Columns[0]);
end;

procedure TMainForm.Dodaj_otpis;
var nap: String;
begin
     if DBGrid2.Columns[0].FieldName='broj_otpisa' then
     begin
          Odabir.ShowModal;
          if Odabir.ModRes then
          begin
               if Odabir.RadioButton1.Checked then nap:=Odabir.RadioButton1.Caption;
               if Odabir.RadioButton2.Checked then nap:=Odabir.RadioButton2.Caption;
               if Odabir.RadioButton3.Checked then nap:=Odabir.RadioButton3.Caption;
               if Odabir.RadioButton4.Checked then nap:=Odabir.RadioButton4.Caption;
               if Odabir.RadioButton5.Checked then nap:=Odabir.RadioButton5.Caption;
               if Odabir.RadioButton6.Checked then nap:=Odabir.RadioButton6.Caption;
               if Odabir.RadioButton7.Checked then nap:=Odabir.RadioButton7.Caption;
               if Odabir.RadioButton8.Checked then nap:=Odabir.RadioButton8.Caption;
               Data.Insert_Z(nap);
          end;
          Otpis_zaglavlja;
     end else
     begin
          if flag_brisanje then
             ShowMessage('Artikli se ne mogu brisati/dodavati zato što je zaglavlje zakljuèeno!')
          else
          Begin
               Button1.Visible:=False;
               DBGrid1.Visible:=True;
               DBGrid2.Visible:=False;
               DBGrid1.SetFocus;
          end;
     end;
end;

procedure TMainForm.Brisi_otpis;
begin
     if DBGrid2.Columns[0].FieldName='broj_otpisa' then
     begin
          if Data.Otpis.Fields[5].IsNull then
          Begin
               sifra_otpisa:=Data.Otpis.Fields[4].AsString;
               if MessageDlg('Da li ste sigurni da želite obrisati OTPIS?', mtConfirmation, [mbNo, mbYes], 0) = mrYes then
               begin
                    Data.Delete_Z(sifra_otpisa);
                    Otpis_zaglavlja;
               end;
          end
          else ShowMessage('Otpis se ne može obrisati zato što je zakljuèen!');
     end else
     begin
          if flag_brisanje then
          ShowMessage('Artikli se ne mogu brisati/dodavati zato što je zaglavlje zakljuèeno!')
          else
             if MessageDlg('Da li ste sigurni da želite obrisati ARTIKAL?', mtConfirmation, [mbNo, mbYes], 0) = mrYes then
             begin
                  Data.Delete_S(Data.Otpis.Fields[5].AsString);
                  Data.OtvoriStavke(sifra_otpisa);
             end;
     end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
     Data.Zakljuci(Data.Otpis.Fields[4].AsString);
     Otpis_zaglavlja;
end;

procedure TMainForm.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key = VK_DOWN) or (key = VK_UP) then DBGrid2CellClick(DBGrid2.Columns[0]);
end;

procedure TMainForm.DBGrid2CellClick(Column: TColumn);
begin
     Button1.Enabled:=Data.Otpis.Fields[5].IsNull;
end;

procedure TMainForm.DodajStavku;
begin
//     if pravo[13,2] then
     Begin
          StringGrid1.Cells[0,StringGrid1.RowCount-1]:=Data.Upit.Fields[0].AsString;
          StringGrid1.Cells[1,StringGrid1.RowCount-1]:=Data.Upit.Fields[2].AsString;
          StringGrid1.Cells[2,StringGrid1.RowCount-1]:=Data.Upit.Fields[3].AsString;
          StringGrid1.Cells[3,StringGrid1.RowCount-1]:=Data.Upit.Fields[4].AsString;
          StringGrid1.Cells[4,StringGrid1.RowCount-1]:=Data.Upit.Fields[5].AsString;
          StringGrid1.Cells[5,StringGrid1.RowCount-1]:=Data.Upit.Fields[6].AsString;
          StringGrid1.Cells[6,StringGrid1.RowCount-1]:=Data.Upit.Fields[7].AsString;
          StringGrid1.Cells[7,StringGrid1.RowCount-1]:=Data.Upit.Fields[8].AsString;
          StringGrid1.Cells[8,StringGrid1.RowCount-1]:=Data.Upit.Fields[9].AsString;
          StringGrid1.RowCount:=StringGrid1.RowCount+1;
     end;
end;

procedure TMainForm.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//     ShowMessage(IntToStr(key));
       case key of
       27: if MessageDlg('Da li ste sigurni da želite izaæi iz F6?',mtConfirmation,[mbNo,mbYes],0)=mrYes then Close;
       46: ObrisiRed(StringGrid1.Row); // DELETE Row;
       45: DodajRed(StringGrid1.Row);  // INSERT Row;
       end;
end;

procedure TMainForm.ObrisiRed(red:Integer);
var i:    Integer;
begin
     For i:=red to StringGrid1.RowCount-2 do StringGrid1.Rows[i]:=StringGrid1.Rows[i+1];
     StringGrid1.RowCount:=StringGrid1.RowCount-1;
end;

procedure TMainForm.DodajRed(red:Integer);
var i:    Integer;
begin
     StringGrid1.RowCount:=StringGrid1.RowCount+1;
     For i:=StringGrid1.RowCount-1 downto red do StringGrid1.Rows[i]:=StringGrid1.Rows[i-1];
     StringGrid1.Cells[0,red]:='';
     StringGrid1.Cells[1,red]:='';
     StringGrid1.Cells[2,red]:='';
     StringGrid1.Cells[3,red]:='';
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
     if not MainForm.CheckBox1.Checked then Excel.SG2Excel('Popis.xls',StringGrid1)
     else
     Begin
          Data.DetNabava;
          if SaveDialog1.Execute then TempGrid.SaveToXLS(SaveDialog1.FileName,True);
     end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
     With Data.Upit do
     Begin
          First;
          While not Eof do
          begin
               DodajStavku;
               Next;
          end;
     end;
end;

end.
