unit DataUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Registry, StdCtrls, ComObj, IniFiles;

//  Controls,
//  StdCtrls;
//ComObj

type
  TData = class(TDataModule)
    DB1: TDatabase;
    Upit: TQuery;
    UpitSource: TDataSource;
    Lager: TQuery;
    LagerSource: TDataSource;
    Upit2: TQuery;
    Upit3: TQuery;
    OtpisSource: TDataSource;
    Otpis: TQuery;
    NEBULA: TDatabase;
    Otpis2: TQuery;
    OtpisSource2: TDataSource;
    ds3: TDataSource;
    procedure DataCreate(Sender: TObject);
    procedure DataDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    Godina, Skladiste: String;
    V, Sheet: Variant;
    procedure UpitOpen(Query:TQuery; S:String );
    procedure UpitExec(Query:TQuery; S:String );
    function  MakniZarez(s:String):String;
    procedure Floatiraj(Query: TQuery);
    procedure Daj_Trazi(Polje,Str:String);
    procedure Daj_Trazi_F6(Polje,Str:String);
    procedure Daj_Godina;
    procedure Daj_Skladiste;
    procedure Arange_Grid(S:String);
    procedure Gimme_F1(S:String);
    procedure Gimme_F2(S:String);
    procedure Gimme_F3(S:String);
    procedure Gimme_F4(S:String);
    procedure Gimme_F5(S:String); //ulazi - primke
    procedure Gimme_F6;           //lager skladišta
    procedure Gimme_F6_GroupOnly; //lager skladišta po grupama
    procedure Gimme_F7(S:String); //ulazi - primke + povrati
    procedure Gimme_F8(S:String); //meðuskladišnice
    procedure Gimme_F9(S:String);
    procedure Gimme_F10(S:String);
    procedure Gimme_F11(S:String);
    procedure Gimme_F12(S:String); //barkodovi
    procedure OtvoriStavke(s:String); // daj stavke otpisa
    procedure OtvoriZaglavlja;        // daj zaglavlja otpisa
    procedure Insert_Z(S:string);     // dodaj Otpis zaglavlje
    procedure Insert_S(sif,kol:String); // dodaj Otpis stavku
    procedure Delete_Z(S:String);       // obriši zaglavlje
    procedure Delete_S(S:String);       // obriši stavka
    procedure Zakljuci(S:String);       // zakljuèivanje otpisa
    procedure DetNabava;          // detalji za nabavu
    { Public declarations }
  end;

var
  Data: TData;
  sustav, DBName: String;
  MyIni: TIniFile;

implementation

uses MainUnit, PregledUnit, PojamUnit, SplashUnit, dxTL, Grids;

{$R *.DFM}

procedure TData.UpitOpen(Query:TQuery; S:String );
begin
     Query.Close;
     Query.SQL.Clear;
     Query.SQL.Add( S );
//     ShowMessage(s);
     try
        Query.Open;
     except
        ShowMessage(s);
        Query.SQL.SaveToFile('c:\x.txt');
     end;
end;

procedure TData.UpitExec(Query:TQuery; S:String );
begin
     Query.Close;
     Query.SQL.Clear;
     Query.SQL.Add( S );
     try
        Query.ExecSQL;
     except
        ShowMessage(S);
        Query.Close;
        Query.SQL.Clear;
     end;
end;

Function TData.MakniZarez(s:String):String;
begin
     while Pos(',', S) > 0 do S[Pos(',', S)] := '.'; // "," u "."
     Result:=S;
end;

procedure TData.Floatiraj(Query: TQuery);
var I: Integer;
begin
     for I := 0 to Query.ComponentCount - 1 do
         if Query.Components[I] is TNumericField then
            if ((Query.Components[I] as TField).DisplayName <> 'kolicina_u_skl') and
            ((Query.Components[I] as TField).DisplayName <> 'kolicina_ulaz') and
            ((Query.Components[I] as TField).DisplayName <> 'kolicina_u_pak') then ( Query.Components[I] as TNumericField ).DisplayFormat := '#,###,###,##0.00'
            else ( Query.Components[I] as TNumericField ).DisplayFormat := '0.000';
end;

procedure TData.DataDestroy(Sender: TObject);
begin
     if Length(Copy(Godina,3,2)+Sustav)=4 then
     begin
          MyIni := TiniFile.Create(GetCurrentDir + '\Config.ini');
          MyIni.WriteString('F6','Godina','ROBA'+Copy(Godina,3,2)+Sustav);
          MyIni.Free;
     end
     else ShowMessage('ROBA'+Copy(Godina,3,2)+Sustav+' greška!');
end;

procedure TData.DataCreate(Sender: TObject);
var I: Integer;
begin
     MyIni := TiniFile.Create(GetCurrentDir + '\Config.ini');
     DBName := MyIni.ReadString('F6','Godina','N/A');
     sustav := Copy(DBName,7,2);
     MyIni.Free;
     try MainForm.Config.Lines.LoadFromFile('config_f6.txt'); // Uèitaj podatke o dostupnim skladištima
     except MainForm.Config.Lines.SaveToFile('config_f6.txt')
     end;
     MainForm.ComboBox2.Items.Clear;
     for i:=0 to MainForm.Config.Lines.Count-1 do
         MainForm.ComboBox2.Items.Add(MainForm.Config.Lines.Strings[i]);
     MainForm.ComboBox2.ItemIndex := 0;

     Upit.DisableControls;
     with DB1.Params do
     begin
          Clear;
          Add( 'database name=sustav' );
          Add( 'enable bcd=True' );
          Add( 'server name=dbserver2' );
          Add( 'application name=F6 - '+MainForm.CurrentUserName+'@'+MainForm.CurrentComputerName );
          Add( 'user name=sa' );
          Add( 'password=' );
     end;
     DB1.Connected := True;
     UpitOpen( Upit, ' select godina from godina (nolock)'+
                     ' where sifra_is='+Sustav+
                     ' order by godina desc');
     for I := 0 to Upit.RecordCount - 1 do
     begin
          MainForm.ComboBox1.Items.Add( Upit.Fields[0].AsString );
          Upit.Next;
     end;
     Godina:='20'+Copy(DBName,5,2);
     MainForm.ComboBox1.ItemIndex := MainForm.ComboBox1.Items.IndexOf(Godina);
     DB1.Connected := False;
     with DB1.Params do
     begin
          Clear;
          Add( 'database name='+DBName );
          Add( 'enable bcd=True' );
          Add( 'server name=dbserver1' );
          Add( 'application name=F6 - '+MainForm.CurrentUserName+'@'+MainForm.CurrentComputerName );
          Add( 'user name=sa' );
          Add( 'password=' );
     end;
     with NEBULA.Params do
     begin
          Clear;
          Add( 'database name=Nebula' );
          Add( 'enable bcd=True' );
          Add( 'server name=dbserver1' );
          Add( 'application name=Otpis - '+MainForm.CurrentUserName+'@'+MainForm.CurrentComputerName );
          Add( 'user name=sa' );
          Add( 'password=' );
     end;
     if Sustav = '01' then MainForm.DBGrid1.Color := clWindow
     else if Sustav = '02' then MainForm.DBGrid1.Color := clYellow;
end;

procedure TData.Daj_Godina;
begin
     if Godina <> MainForm.ComboBox1.Text then
     begin
          Godina := MainForm.ComboBox1.Text;
          Upit.DisableControls;
          DB1.Connected := False;
          with DB1.Params do
          begin
               Clear;
               Add( 'database name=ROBA'+Copy(godina,3,2)+Sustav );
               Add( 'enable bcd=True' );
               Add( 'server name=dbserver1' );
               Add( 'application name=F6 - '+MainForm.CurrentUserName+'@'+MainForm.CurrentComputerName );
               Add( 'user name=sa' );
               Add( 'password=' );
          end;
          DB1.Connected := True;
          Upit.EnableControls;
          UpitOpen( Upit, ' select a.sifra_artikla, bk=null, a.naziv_artikla, a.jedinica_mjere,'+
                          ' KOL=ISNULL((SELECT SKL3.KOLICINA_U_SKL FROM ARTIKAL_U_SKL SKL3 (NOLOCK) WHERE SKL3.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL3.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"), '+
                          ' C1=ISNULL((SELECT SKL1.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL1 (NOLOCK) WHERE SKL1.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL1.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                          ' C2=ISNULL((SELECT SKL2.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL2 (NOLOCK) WHERE SKL2.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,6,4)+'" AND SKL2.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                          ' a.sifra_grupe_art, ga.naziv_grupe_art, rabat=case when skl.max_rabat=2 then ''2'' else skl.rabat end'+
                          ' from artikal a (nolock), grupa_artikla ga (nolock), artikal_u_skl skl (NOLOCK)'+
                          ' where a.sifra_grupe_art=ga.sifra_grupe_art'+
                          ' AND skl.sifra_artikla=a.sifra_artikla'+
                          ' AND skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                          ' and a.naziv_artikla like "A%"'+
                          ' order by a.naziv_artikla' );
         Floatiraj( Upit );
     end;
end;

procedure TData.Daj_Skladiste;
begin
      DB1.Connected := True;
      Upit.EnableControls;
      UpitOpen( Upit, ' select top 1000 a.sifra_artikla, bk=null, a.naziv_artikla, a.jedinica_mjere,'+
                      ' KOL=ISNULL((SELECT SKL3.KOLICINA_U_SKL FROM ARTIKAL_U_SKL SKL3 (NOLOCK) WHERE SKL3.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL3.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"), '+
                      ' C1=ISNULL((SELECT SKL1.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL1 (NOLOCK) WHERE SKL1.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL1.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                      ' C2=ISNULL((SELECT SKL2.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL2 (NOLOCK) WHERE SKL2.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,6,4)+'" AND SKL2.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                      ' a.sifra_grupe_art, ga.naziv_grupe_art, rabat=case when skl.max_rabat=2 then ''2'' else skl.rabat end'+
                      ' from artikal a (nolock), grupa_artikla ga (nolock), artikal_u_skl skl (nolock)'+
                      ' where a.sifra_grupe_art=ga.sifra_grupe_art'+
                      ' AND skl.sifra_artikla=a.sifra_artikla'+
                      ' AND skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                      ' and a.naziv_artikla like "A%"'+
                      ' order by a.naziv_artikla' );
     Floatiraj( Upit );
     if flag_otpis then MainForm.Otpis_zaglavlja;
end;

procedure TData.Daj_Trazi(Polje,Str:String);
          function ZarezUTocku(S:String):String;
          begin
               while Pos(',',S) > 0 do S[Pos(',',S)] := '.';
               ZarezUTocku := S;
          end;
var Order, Bk: String;
    I: Integer;
begin
     if Polje = 'sifra_artikla' then
     begin
          Str := 'a.sifra_artikla="'+Str+'"';
          Order := 'a.sifra_artikla';
     end
     else if Polje = 'naziv_artikla' then
     begin
          Str := 'a.naziv_artikla like "'+Str+'%"';
          Order := 'a.naziv_artikla';
     end
     else if Polje = 'jedinica_mjere' then
     begin
          Str := 'a.jedinica_mjere="'+Str+'"';
          Order := 'a.naziv_artikla';
     end
     else if Polje = 'kolicina_u_skl' then
     begin
          Str := 'skl.kolicina_u_skl='+ZarezUTocku(Str);
          Order := 'a.naziv_artikla';
     end
     else if Polje = 'cijena_art_u_skl' then
     begin
          Str := 'skl.cijena_art_u_skl='+ZarezUTocku(Str);
          Order := 'a.naziv_artikla';
     end
     else if Polje = 'sifra_grupe_art' then
     begin
          Str := 'a.sifra_grupe_art="'+Str+'"';
          Order := 'a.sifra_artikla';
     end
     else if Polje = 'naziv_grupe_art' then
     begin
          Str := 'ga.naziv_grupe_art like "'+Str+'%"';
          Order := 'a.naziv_artikla';
     end
     else if Polje = 'bk' then
     begin
          Bk := '';
          UpitOpen( Upit2, ' select kod, duzina_sifre_art, koeficijent_sifre, masa, koeficijent_mase from preracun_barkoda (nolock)' );
          for I := 0 to Upit2.RecordCount - 1 do
          begin
               if Upit2.Fields[0].AsString = Copy( Str, 1, Length(Upit2.Fields[0].AsString) ) then
               begin
                    if Upit2.Fields[2].IsNull then Bk := Copy( Str, Length(Upit2.Fields[0].AsString)+1, Upit2.Fields[1].AsInteger )
                    else Bk := IntToStr(StrToInt(Copy( Str, Length(Upit2.Fields[0].AsString)+1, Upit2.Fields[1].AsInteger ))+Upit2.Fields[2].AsInteger);
                    UpitOpen( Upit3, ' select sifra_artikla from artikal (nolock) where sifra_artikla="'+Bk+'"' );
                    if not Upit3.Fields[0].IsNull then Break
                    else Bk := '';
               end;
               Upit2.Next;
          end;
          if Bk = '' then
          begin
               UpitOpen( Upit3, ' select sifra_artikla from bar_kod (nolock) where sifra_bar_koda="'+Str+'"' );
               if not Upit3.Fields[0].IsNull then Bk := Upit3.Fields[0].AsString;
          end;
          if Bk <> '' then
          begin
               UpitOpen( Upit, ' select a.sifra_artikla, bk=null, a.naziv_artikla, a.jedinica_mjere,'+
                               ' KOL=ISNULL((SELECT SKL3.KOLICINA_U_SKL FROM ARTIKAL_U_SKL SKL3 (NOLOCK) WHERE SKL3.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL3.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"), '+
                               ' C1=ISNULL((SELECT SKL1.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL1 (NOLOCK) WHERE SKL1.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL1.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                               ' C2=ISNULL((SELECT SKL2.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL2 (NOLOCK) WHERE SKL2.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,6,4)+'" AND SKL2.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                               ' a.sifra_grupe_art, ga.naziv_grupe_art, rabat=case when skl.max_rabat=2 then ''2'' else skl.rabat end'+
                               ' from artikal a (nolock), grupa_artikla ga (nolock), artikal_u_skl skl (nolock)'+
                               ' where a.sifra_grupe_art=ga.sifra_grupe_art'+
                               ' AND skl.sifra_artikla=a.sifra_artikla'+
                               ' AND skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                               ' and a.sifra_artikla="'+Bk+'"' );
               if Upit.Fields[0].IsNull then ShowMessage( 'TRAŽENI ARTIKAL POSTOJI, ALI NIJE UVEDEN U SKLADIŠTE!' );
               Floatiraj( Upit );
          end
          else ShowMessage( 'BAR-KOD NIJE UVEDEN!' );
     end;
     if Polje <> 'bk' then
     begin
          UpitOpen( Upit, ' select a.sifra_artikla, bk=null, a.naziv_artikla, a.jedinica_mjere,'+
                          ' KOL=SKL.KOLICINA_U_SKL,'+
                          ' C1=SKL.CIJENA_ART_U_SKL,'+
                          ' C2=ISNULL((SELECT SKL2.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL2 (NOLOCK) WHERE SKL2.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,6,4)+'" AND SKL2.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                          ' a.sifra_grupe_art, ga.naziv_grupe_art, rabat=case when skl.max_rabat=2 then ''2'' else skl.rabat end'+
                          ' from artikal a (nolock), grupa_artikla ga (nolock), artikal_u_skl skl (nolock)'+
                          ' where a.sifra_grupe_art=ga.sifra_grupe_art'+
                          ' AND skl.sifra_artikla=a.sifra_artikla'+
                          ' AND skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                          ' and '+Str+
                          ' order by '+Order );
          Floatiraj( Upit );
     end;
end;

procedure TData.Daj_Trazi_F6(Polje,Str:String);
          function ZarezUTocku(S:String):String;
          begin
               while Pos(',',S) > 0 do S[Pos(',',S)] := '.';
               ZarezUTocku := S;
          end;
var Order: String;
begin
     if Polje = 'sifra_grupe_art' then
     begin
          Str := 'ga.sifra_grupe_art like "'+Str+'%"';
          Order := 'ga.sifra_grupe_art';
     end
     else if Polje = 'naziv_grupe_art' then
     begin
          Str := 'ga.naziv_grupe_art like "'+Str+'%"';
          Order := 'ga.naziv_grupe_art';
     end
     else if Polje = 'zaliha' then
     begin
          if (Copy( Str, 1, 1 ) = '>') or (Copy( Str, 1, 1 ) = '<') then Str := 'sum(skl.kolicina_u_skl*skl.cijena_art_u_skl)'+Copy( Str, 1, 1 )+'='+ZarezUTocku( Copy( Str, 2, Length(Str)-1 ) )
          else Str := 'sum(skl.kolicina_u_skl*skl.cijena_art_u_skl)='+ZarezUTocku( Str );
          Order := 'zaliha';
     end;
     if Polje <> 'zaliha' then
        UpitOpen( Lager, ' select ga.sifra_grupe_art, ga.naziv_grupe_art,'+
                         ' zaliha=sum(skl.kolicina_u_skl*skl.cijena_art_u_skl)'+
                         ' from artikal_u_skl skl (nolock) join artikal a (nolock) on (skl.sifra_artikla=a.sifra_artikla)'+
                         ' join grupa_artikla ga (nolock) on (a.sifra_grupe_art=ga.sifra_grupe_art)'+
                         ' where skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                         ' and '+Str+
                         ' group by ga.naziv_grupe_art, ga.sifra_grupe_art'+
                         ' order by '+Order )
     else UpitOpen( Lager, ' select ga.sifra_grupe_art, ga.naziv_grupe_art,'+
                           ' zaliha=sum(skl.kolicina_u_skl*skl.cijena_art_u_skl)'+
                           ' from artikal_u_skl skl (nolock) join artikal a (nolock) on (skl.sifra_artikla=a.sifra_artikla)'+
                           ' join grupa_artikla ga (nolock) on (a.sifra_grupe_art=ga.sifra_grupe_art)'+
                           ' where skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                           ' group by ga.naziv_grupe_art, ga.sifra_grupe_art'+
                           ' having '+Str+
                           ' order by '+Order );
     Floatiraj( Lager );
     Arange_Grid( 'F6' );
end;

procedure TData.Arange_Grid(S:String);
var I: Integer;
begin
     UpitOpen( Upit2, ' select sifra_liste, redni_broj_kolone, polje_kolone, naziv_kolone, duzina_kolone, align_kolone'+
                      ' from zkolona (nolock) where sifra_liste="'+S+'" order by redni_broj_kolone' );
     For I := 0 to PregledForm.DBGrid1.ColumnCount-1 do PregledForm.DBGrid1.Columns[I].Visible:=False;
     for I := 0 to Upit2.RecordCount - 1 do
     begin
          PregledForm.DBGrid1.Columns[I].Visible:=True;
          PregledForm.DBGrid1.Columns[I].FieldName := Upit2.Fields[2].AsString;
          PregledForm.DBGrid1.Columns[I].Caption := Upit2.Fields[3].AsString;
          PregledForm.DBGrid1.Columns[I].Alignment := taCenter;
          PregledForm.DBGrid1.Columns[I].Width := Upit2.Fields[4].AsInteger;
          if Upit2.Fields[5].AsString = 'L' then PregledForm.DBGrid1.Columns[I].Alignment := taLeftJustify
          else if Upit2.Fields[5].AsString = 'C' then PregledForm.DBGrid1.Columns[I].Alignment := taCenter
          else if Upit2.Fields[5].AsString = 'R' then PregledForm.DBGrid1.Columns[I].Alignment := taRightJustify;
          Upit2.Next;
     end;
end;

procedure TData.Gimme_F1(S:String);
begin
//
end;

procedure TData.Gimme_F2(S:String);
begin
//
end;

procedure TData.Gimme_F3(S:String);
begin
     UpitOpen( Upit2, ' select round(sum(zav_trosak_stavke),2)'+
                      ' from stavka (nolock)'+
                      ' where sifra_dokumenta='+
                      ' (select sifra_dokumenta from dokument (nolock)'+
                      ' where broj_dokumenta='''+s+''''+
                      ' and sifra_org_jedinice='''+Copy(MainForm.ComboBox2.Text,1,4)+''''+
                      ' and sifra_tipa_dok=''PR'' and sifra_vrste_dok=''PRUR'' and sifra_podtipa_dok=''PRUR'')');
     if not Upit2.Fields[0].IsNull then ShowMessage('Zavisni trošak za PR'+s+'='+Upit2.Fields[0].AsString);
end;

procedure TData.Gimme_F4(S:String);
begin
//
end;

procedure TData.Gimme_F5(S:String);
begin
     UpitOpen( Lager, ' select s.fakturna_cijena,'+
                      ' rabat=(isnull(s.rabat_stavke,0)*100)/(s.kolicina_ulaz*s.fakturna_cijena),'+
                      ' nab_cijena_ulaz=s.nab_cijena_ulaz*isnull(d.tecaj_valute,1),'+
                      ' marza=((((s.prod_cijena_stavke*s.kolicina_ulaz-isnull(s.maloprod_porez,0))/s.kolicina_ulaz)/(s.nab_cijena_ulaz*isnull(d.tecaj_valute,1)))-1)*100,'+
                      ' s.prod_cijena_stavke, p.sifra_partnera, p.naziv1_partnera, datum_dok=convert(varchar(10),d.datum_dok,104),'+
                      ' dokument=d.sifra_tipa_dok+"-"+d.broj_dokumenta,'+
                      ' s.kolicina_ulaz'+
                      ' from partner p (nolock), dokument d (nolock), stavka s (nolock)'+
                      ' where d.sifra_dokumenta=s.sifra_dokumenta and'+
                      ' d.sifra_partnera=p.sifra_partnera and d.broj_storno_dok is null and'+
                      ' d.sifra_tipa_dok="PR" and d.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'" and'+
                      ' s.sifra_artikla="'+S+'"'+
                      ' order by d.broj_dokumenta desc' );
     Floatiraj( Lager );
     if not Lager.Fields[0].IsNull then
     begin
          Arange_Grid('F5');
          PregledForm.Caption := '[F5] Pregled ulaza za artikal: '+Upit.Fields[0].AsString+' '+Upit.Fields[2].AsString;
          PregledForm.ShowModal;
     end
     else ShowMessage( 'ZA ODABRANI ARTIKAL NE POSTOJE PRIMKE ZA ODABRANO SKLADIŠTE!' );
end;

procedure TData.Gimme_F6;
begin
     UpitOpen( Lager, ' select zaliha=sum(kolicina_u_skl*cijena_art_u_skl)'+
                      ' from artikal_u_skl (nolock)'+
                      ' where sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"' );
     if not Lager.Fields[0].IsNull then
     begin
          PojamForm.Caption := 'ENTER - Detaljni pregled.       ESC - izlaz';
          PojamForm.Edit1.Text := FormatFloat( '#,###,###,##0.00', Lager.Fields[0].Value );
          PojamForm.Edit1.SelectAll;
          PojamForm.ShowModal;
          if PojamForm.ModRes then
          begin
               UpitOpen( Lager, ' select ga.sifra_grupe_art, ga.naziv_grupe_art,'+
                                ' zaliha=sum(skl.kolicina_u_skl*skl.cijena_art_u_skl),'+
                                ' marža=sum(skl.kolicina_u_skl*(skl.cijena_art_u_skl-skl.prosj_nab_cijena))'+
                                ' from artikal_u_skl skl (nolock) join artikal a (nolock) on (skl.sifra_artikla=a.sifra_artikla)'+
                                ' join grupa_artikla ga (nolock) on (a.sifra_grupe_art=ga.sifra_grupe_art)'+
                                ' where skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                                ' group by ga.naziv_grupe_art, ga.sifra_grupe_art'+
                                ' order by ga.naziv_grupe_art' );
               Floatiraj( Lager );
               Arange_Grid( 'F6' );
               PregledForm.Caption := '[F6] Pregled lagera po grupama robe za skladište '+Skladiste+'  ('+PojamForm.Edit1.Text+')';
               PregledForm.ShowModal;
          end;
          PojamForm.Caption := 'Pojam';
     end
     else ShowMessage( 'NA ODABRANOM SKLADIŠTU LAGER JE 0,000' );
end;

procedure TData.Gimme_F6_GroupOnly;
begin
     UpitOpen( Lager, ' select ga.sifra_grupe_art, ga.naziv_grupe_art,'+
                      ' zaliha=sum(skl.kolicina_u_skl*skl.cijena_art_u_skl),'+
                      ' marža=sum(skl.kolicina_u_skl*(skl.cijena_art_u_skl-skl.prosj_nab_cijena))'+
                      ' from artikal_u_skl skl (nolock) join artikal a (nolock) on (skl.sifra_artikla=a.sifra_artikla)'+
                      ' join grupa_artikla ga (nolock) on (a.sifra_grupe_art=ga.sifra_grupe_art)'+
                      ' where skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                      ' group by ga.naziv_grupe_art, ga.sifra_grupe_art'+
                      ' order by ga.naziv_grupe_art' );
     Floatiraj( Lager );
     Arange_Grid( 'F6' );
     PregledForm.Caption := '[F6] Pregled lagera po grupama robe za skladište '+Skladiste;
     PregledForm.ShowModal;
     PojamForm.Caption := 'Pojam';
end;

procedure TData.Gimme_F7(S:String);
begin
     UpitOpen( Lager, ' select fakturna_cijena=isnull(s.fakturna_cijena,0),'+
                      ' rabat=isnull((isnull(s.rabat_stavke,0)*100)/(s.kolicina_ulaz*s.fakturna_cijena),0), nab_cijena_ulaz=isnull(s.nab_cijena_ulaz*isnull(d.tecaj_valute,1),0),'+
                      ' marza=isnull(((((s.prod_cijena_stavke*s.kolicina_ulaz-isnull(s.maloprod_porez,0))/s.kolicina_ulaz)/(s.nab_cijena_ulaz*isnull(d.tecaj_valute,1)))-1)*100,0),'+
                      ' s.prod_cijena_stavke, p.sifra_partnera, p.naziv1_partnera, datum_dok=convert(varchar(10),d.datum_dok,104),s.prod_cijena_stavke, p.sifra_partnera, p.naziv1_partnera, datum_dok=convert(varchar(10),d.datum_dok,104),'+
                      ' dokument=d.sifra_tipa_dok+"-"+d.broj_dokumenta,'+
                      ' s.kolicina_ulaz,'+
                      ' d.broj_storno_dok, d.napomena_dok'+
                      ' from partner p (nolock), dokument d (nolock), stavka s (nolock)'+
                      ' where d.sifra_dokumenta=s.sifra_dokumenta and'+
                      ' d.sifra_partnera=p.sifra_partnera and'+
                      ' d.sifra_tipa_dok="PR" and s.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'" and'+
                      ' s.sifra_artikla="'+S+'"'+
                      ' order by d.broj_dokumenta desc' );
     Floatiraj( Lager );
     if not Lager.Fields[0].IsNull then
     begin
          Arange_Grid('F7');
          //PregledForm.Caption := '[F7] Pregled ulaza za artikal: '+Upit.Fields[0].AsString+' '+Upit.Fields[2].AsString;
          PregledForm.ShowModal;
     end
     else ShowMessage( 'ZA ODABRANI ARTIKAL NE POSTOJE PRIMKE ZA ODABRANO SKLADIŠTE!' );
end;

procedure TData.Gimme_F8(S:String);
begin
     UpitOpen( Lager, ' select ' );

     Floatiraj( Lager );
     if not Lager.Fields[0].IsNull then
     begin
          Arange_Grid('F8');
          PregledForm.Caption := '[F8] Pregled meðuskladišnica za artikal: '+Upit.Fields[0].AsString+' '+Upit.Fields[2].AsString;
          PregledForm.ShowModal;
     end
     else ShowMessage( 'ZA ODABRANI ARTIKAL NE POSTOJE MEÐUSKLADIŠNICE ZA ODABRANO SKLADIŠTE!' );
end;

procedure TData.Gimme_F9(S:String);
begin
//
end;

procedure TData.Gimme_F10(S:String);
begin
//
end;

procedure TData.Gimme_F11(S:String);
begin
//
end;

procedure TData.Gimme_F12(S:String);
begin
     UpitOpen( Lager, ' select b.sifra_pakovanja, p.oznaka, p.kolicina_u_pak, b.sifra_bar_koda'+
                      ' from bar_kod b (nolock), pakovanje_artikla p (nolock)'+
                      ' where b.sifra_pakovanja=p.sifra_pakovanja'+
                      ' and p.sifra_artikla=b.sifra_artikla'+
                      ' and b.sifra_artikla="'+S+'"'+
                      ' order by b.sifra_pakovanja' );
     Floatiraj( Lager );
     if not Lager.Fields[0].IsNull then
     begin
          Arange_Grid('F12');
          PregledForm.Caption := '[F12] Pregled barkodova za artikal: '+Upit.Fields[0].AsString+' '+Upit.Fields[2].AsString;
          PregledForm.ShowModal;
     end
     else ShowMessage( 'ZA ODABRANI ARTIKAL NE POSTOJE BARKODOVI!' );
end;

Procedure TData.OtvoriStavke(s:String);
begin
     flag_stavka:=s;
     UpitOpen( Otpis, ' SELECT s.sifra_artikla, a.naziv_artikla,'+
                      ' s.kolicina_otpis, s.cijena_art_u_skl, s.vrijednost_otpisa, s.id'+
                      ' FROM stavka_otpis s (NOLOCK), '+DBName+'..artikal a (nolock)'+
                      ' WHERE a.sifra_artikla=s.sifra_artikla AND'+
                      ' s.sifra_otpisa='+s);
     Floatiraj(Otpis);
end;

procedure TData.OtvoriZaglavlja;
begin
          NEBULA.Connected := True;
          UpitOpen(Otpis, ' SELECT o.broj_otpisa, o.datum_otpisa, o.napomena_dok, o.operater_dok, o.sifra_otpisa, o.datum_zakljucenja'+
                          ' FROM otpis o (NOLOCK)'+
                          ' WHERE o.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                          ' ORDER BY o.broj_otpisa DESC');
          Otpis.EnableControls;
end;

procedure TData.Insert_Z(s:String); // Novo zaglavlje
var Y, M, D: Word;
begin
     DecodeDate( Now, Y, M, D );
     UpitOpen(Otpis, ' SELECT ISNULL(MAX(broj_otpisa),0)+1 FROM otpis (NOLOCK) WHERE sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"');
     UpitExec(Otpis, ' INSERT INTO otpis (broj_otpisa, sifra_org_jedinice, datum_otpisa, napomena_dok, operater_dok)'+
                     ' VALUES ('+
                     ' "'+Otpis.Fields[0].AsString+'",'+
                     ' "'+Copy(MainForm.ComboBox2.Text,1,4)+'",'+
                     ' "'+IntToStr(M)+'.'+IntToStr(D)+'.'+IntToStr(Y)+'",'+
                     ' "'+s+'",'+
                     ' "'+MainForm.CurrentUserName+'")');
end;

procedure TData.Insert_S(sif,kol:String);
begin
     UpitOpen(Otpis2,' SELECT skl.cijena_art_u_skl FROM '+DBName+'..artikal_u_skl skl (NOLOCK)'+
                     ' WHERE skl.sifra_artikla="'+sif+'" '+
                     ' AND skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"');
     UpitExec(Otpis2,' INSERT INTO stavka_otpis '+
                     ' (sifra_otpisa, sifra_artikla, kolicina_otpis, cijena_art_u_skl) VALUES '+
                     ' ('+sifra_otpisa+','+ // šifra otpisa
                     ' "'+sif+'",'+ // šifra artikla
                     ' '+MakniZarez(kol)+','+ // kolièina za otpis
                     ' '+MakniZarez(Otpis2.Fields[0].AsString)+')');
end;

procedure TData.Delete_Z(S:String);
begin
     UpitExec(Otpis2,' DELETE FROM stavka_otpis'+ // Brisanje stavka
                     ' WHERE stavka_otpis.id IN '+
                       ' (SELECT s.id FROM stavka_otpis s (NOLOCK), otpis o (NOLOCK) '+
                       ' WHERE o.sifra_otpisa="'+S+'" AND o.sifra_otpisa=s.sifra_otpisa '+
                       ' AND o.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'")');
     UpitExec(Otpis2,' DELETE FROM otpis '+       // Brisanje zaglavlja
                     ' WHERE sifra_otpisa="'+S+'" '+
                     ' AND sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"');
end;

procedure TData.Delete_S(S:String);
begin
     UpitExec(Otpis2,' DELETE FROM stavka_otpis'+ // Brisanje stavke
                     ' WHERE id='+S);
end;

procedure TData.Zakljuci(S:String);
var Y, M, D: Word;
begin
     DecodeDate( Now, Y, M, D );
     UpitExec(Otpis, ' UPDATE otpis SET '+          // Zakljuèivanje zaglavlja
                     ' datum_zakljucenja="'+IntToStr(M)+'.'+IntToStr(D)+'.'+IntToStr(Y)+'",'+
                     ' operater_zak="'+MainForm.CurrentUserName+'"'+
                     ' WHERE sifra_otpisa='+S);
end;

procedure TData.DetNabava;
var popis: String;
    i:     Integer;
begin
      popis:='"';
      For i:=1 to MainForm.StringGrid1.RowCount-2 do
           popis:=popis+MainForm.StringGrid1.Cells[0,i]+'","';
      Delete(popis,length(popis)-2,2);
//      ShowMessage(popis);
      UpitOpen(Upit3, ' select * from ('+
                      ' select a.sifra_artikla, bk=null, a.naziv_artikla, a.jedinica_mjere,'+
                      ' KOL=ISNULL((SELECT SKL3.KOLICINA_U_SKL FROM ARTIKAL_U_SKL SKL3 (NOLOCK) WHERE SKL3.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL3.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                      ' C1=ISNULL((SELECT SKL1.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL1 (NOLOCK) WHERE SKL1.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,1,4)+'" AND SKL1.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                      ' C2=ISNULL((SELECT SKL2.CIJENA_ART_U_SKL FROM ARTIKAL_U_SKL SKL2 (NOLOCK) WHERE SKL2.SIFRA_ORG_JEDINICE="'+Copy(MainForm.ComboBox2.Text,6,4)+'" AND SKL2.SIFRA_ARTIKLA=A.SIFRA_ARTIKLA),"0"),'+
                      ' a.sifra_grupe_art, ga.naziv_grupe_art'+
                      ' from artikal a (nolock), grupa_artikla ga (nolock), artikal_u_skl skl (nolock)'+
                      ' WHERE a.sifra_grupe_art=ga.sifra_grupe_art'+
                      ' AND a.sifra_artikla IN ('+popis+')'+
                      ' AND skl.sifra_artikla=a.sifra_artikla'+
                      ' AND skl.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'") as A,'+
                      ' (select s.sifra_artikla, s.fakturna_cijena,'+
                      ' rabat=(isnull(s.rabat_stavke,0)*100)/(s.kolicina_ulaz*s.fakturna_cijena),'+
                      ' nab_cijena_ulaz=s.nab_cijena_ulaz*isnull(d.tecaj_valute,1),'+
                      ' marza=((((s.prod_cijena_stavke*s.kolicina_ulaz-isnull(s.maloprod_porez,0))/s.kolicina_ulaz)/(s.nab_cijena_ulaz*isnull(d.tecaj_valute,1)))-1)*100,'+
                      ' s.prod_cijena_stavke, datum_dok=d.datum_dok,'+
                      ' dokument=d.sifra_tipa_dok+"-"+d.broj_dokumenta,'+
                      ' s.kolicina_ulaz'+
                      ' from dokument d (nolock), stavka s (nolock),'+
                      ' (select maks=max(s.sifra_stav_art)'+
                      ' from dokument d (nolock), stavka s (nolock)'+
                      ' where d.sifra_dokumenta=s.sifra_dokumenta'+
                      ' and d.broj_storno_dok is null and d.sifra_tipa_dok="PR" and d.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                      ' and s.sifra_artikla in ('+popis+')'+
                      ' group by s.sifra_artikla) as nested'+
                      ' where d.sifra_dokumenta=s.sifra_dokumenta and s.sifra_stav_art=nested.maks'+
                      ' and d.broj_storno_dok is null and d.sifra_tipa_dok="PR" and d.sifra_org_jedinice="'+Copy(MainForm.ComboBox2.Text,1,4)+'"'+
                      ' and s.sifra_artikla in ('+popis+')) as B'+
                      ' where A.sifra_artikla=B.sifra_artikla' );
      Floatiraj(Upit3);
end;
end.
