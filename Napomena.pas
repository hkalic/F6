unit Napomena;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TOdabir = class(TForm)
    Button1: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    ModRes: Boolean;
    { Public declarations }
  end;

var
  Odabir: TOdabir;

implementation

{$R *.dfm}

procedure TOdabir.Button1Click(Sender: TObject);
begin
     ModRes := True;
     Close;
end;

procedure TOdabir.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = 27 then
     begin
          ModRes := False;
          Close;
     end;
     if key = 13 then
     begin
          ModRes := True;
          Close;
     end;
end;

end.
