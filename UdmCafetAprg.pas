unit UdmCafetAprg;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery;

type
  TDmCafetAprg = class(TDataModule)
    IBDatabase: TIBDatabase;
    IBTransaction1: TIBTransaction;
    QryTravail: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  DmCafetAprg: TDmCafetAprg;

implementation

{$R *.dfm}

uses
  IniFiles, Dialogs, Forms, StrUtils;

procedure TDmCafetAprg.DataModuleCreate(Sender: TObject);
var
  zIniFile: TIniFile;
  zFileName: string;
begin
  zFileName := ExtractFileName(ParamStr(0));
  zFileName := LeftStr(zFileName, Length(zFileName) - 4);
  zFileName := ExtractFilePath(ParamStr(0)) + zFileName + '.ini';
  // Lecture des param�tres de connexion dans le fichier INI
  if FileExists(zFileName) then
  begin
    zIniFile := TIniFile.Create(zFileName);
    with IBDatabase do
    begin
      DatabaseName := zIniFile.ReadString('SERVER', 'DatabaseName', '');
      Params.Add('user_name=' + zIniFile.ReadString('SERVER', 'user_name', ''));
      Params.Add('password=' + zIniFile.ReadString('SERVER', 'password', ''));
      Params.Add('lc_ctype=' + zIniFile.ReadString('SERVER', 'lc_ctype', ''));
    end;
    zIniFile.Free;
    try
      IBDatabase.Connected := True;
    except
      ShowMessage('Erreur de connexion � la base de donn�es');
    end;
  end
  else
    ShowMessage('Le fichier de configuration est introuvable.');
  if not IBDatabase.Connected then
    Application.Terminate;
end;

end.
