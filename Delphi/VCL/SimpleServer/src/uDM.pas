unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB,

  uRESTDWAbout, uRESTDWServerEvents, uRESTDWDatamodule, uRESTDWParams,
  uRESTDWConsts, uRESTDWComponentBase, uRESTDWBasic, uRESTDWBasicDB,
  uRESTDWServerContext, uRESTDWDriverBase, uRESTDWFireDACDriver,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.DApt, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat

    ;

type
  TDM = class(TServerMethodDataModule)
    RESTDWServerEvents1: TRESTDWServerEvents;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    FDConnection1: TFDConnection;
    RESTDWServerContext1: TRESTDWServerContext;
    RESTDWFireDACDriver1: TRESTDWFireDACDriver;
    RESTDWPoolerDB2: TRESTDWPoolerDB;
    procedure teste(var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure testebody(var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure testeheader(var Params: TRESTDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure relatorio(const Params: TRESTDWParams; var ContentType: string;
      const Result: TMemoryStream; const RequestType: TRequestType;
      var StatusCode: Integer);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDM.testebody(var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
  textos: TStringList;
begin
  textos := TStringList.Create;
  textos.Add('seus params: ' + Params.ToJSON);
  textos.Add('o body: ' + Params.RawBody.AsObject);

  Result := textos.Text;
  textos.Free;
end;

procedure TDM.testeheader(var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
  textos: TStringList;
  I: Integer;
begin
  textos := TStringList.Create;
  textos.Add('seus params: ' + Params.ToJSON);
  for I := 0 to pred(Params.Count) do
    textos.AddPair(Params.Items[I].ParamName, Params.Items[I].AsString);

  Result := textos.Text;

end;

procedure TDM.relatorio(const Params: TRESTDWParams; var ContentType: string;
  const Result: TMemoryStream; const RequestType: TRequestType;
  var StatusCode: Integer);
begin
  ContentType := GetMIMEType('.\relatorio.pdf');
  Result.LoadFromFile('.\relatorio.pdf');
end;

procedure TDM.ServerMethodDataModuleCreate(Sender: TObject);
begin
  FDConnection1.Params.Clear;
  FDConnection1.DriverName := 'SQLite';
  FDConnection1.Params.Add('Database=' + ExtractFilePath(ParamStr(0)) +
    'employee.db');
  FDConnection1.Params.Add('LockingMode=normal');
end;

procedure TDM.teste(var Params: TRESTDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
  case RequestType of
    rtGet, rtDelete:
      StatusCode := 200;
    rtPost, rtPut, rtPatch:
      StatusCode := 201;
  end;
end;

end.
