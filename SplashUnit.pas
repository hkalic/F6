unit SplashUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TSplashForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashForm: TSplashForm;

implementation

uses DataUnit, MainUnit;

{$R *.DFM}

procedure TSplashForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
//var i: Integer;
begin
     flag_excel:=False;           // TRUE=Query u *.xls, FALSE=Query u Excel
     if Key = 27 then Close
     else if Key = 13 then
     begin
          // Uèitavanje prava za korisnike
          if Edit1.Text='OTPIS' then
          begin
               flag_otpis:=True;
               MainForm.StatusBar1.SimpleText:='ENTER - Ulaz u stavke otpisa, <-- - Povratak na popis otpisa, INSERT - Dodavanje otpisa/artikala, DELETE - Brisanje otpisa/artikala';
               if UpperCase(MainForm.CurrentComputerName)='TERMINAL' then
               begin
                    ShowMessage('OTPIS se ne može raditi u TERMINALu!!!');
                    flag_otpis:=False;
                    MainForm.StatusBar1.SimpleText:='';
               end;
          end else flag_otpis:=False;
          if Edit1.Text='CJENIK' then
          begin
               flag_cjenik:=True;
//               MainForm.StatusBar1.SimpleText:='ENTER - Ulaz u stavke otpisa, <-- - Povratak na popis otpisa, INSERT - Dodavanje otpisa/artikala, DELETE - Brisanje otpisa/artikala';
               if UpperCase(MainForm.CurrentComputerName)='TERMINAL' then
               begin
                    ShowMessage('CJENIK se ne može mjenjati u TERMINALu!!!');
                    flag_otpis:=False;
                    MainForm.StatusBar1.SimpleText:='';
               end;
          end else flag_cjenik:=False;

          MainForm.ComboBox1.Enabled:=not (flag_otpis or flag_cjenik);
          MainForm.ComboBox2.Enabled:=not (flag_otpis or flag_cjenik);
          Data.Daj_Skladiste;
          SplashForm.ModalResult := mrOK;
     end;
end;


end.
