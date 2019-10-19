program F6;

uses
  Forms,
  Controls,
  MainUnit in 'MainUnit.pas' {MainForm},
  DataUnit in 'DataUnit.pas' {Data: TDataModule},
  PojamUnit in 'PojamUnit.pas' {PojamForm},
  PregledUnit in 'PregledUnit.pas' {PregledForm},
  SplashUnit in 'SplashUnit.pas' {SplashForm},
  xcel in '..\Hrvoje\temp\xcel.pas' {Excel},
  Napomena in 'Napomena.pas' {Odabir},
  UsporediArt in 'UsporediArt.pas' {K2A};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'F6 i Otpis, Alastor doo, 2002.';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TData, Data);
  Application.CreateForm(TPojamForm, PojamForm);
  Application.CreateForm(TPregledForm, PregledForm);
  Application.CreateForm(TSplashForm, SplashForm);
  Application.CreateForm(TExcel, Excel);
  Application.CreateForm(TOdabir, Odabir);
  Application.CreateForm(TK2A, K2A);
  SplashForm.ShowModal;
  if SplashForm.ModalResult = mrOK then Application.Run;
end.
