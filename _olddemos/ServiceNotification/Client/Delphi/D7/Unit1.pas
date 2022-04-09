unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDWAbout, uRESTDwProcessThread, StdCtrls;

type
  TForm1 = class(TForm)
    RESTDWClientNotification1: TRESTDWClientNotification;
    Button1: TButton;
    Button2: TButton;
    ePorta: TEdit;
    eHost: TEdit;
    Memo1: TMemo;
    eConnectionName: TEdit;
    Button4: TButton;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RESTDWClientNotification1ReceiveMessage(Username,
      aMessage: String; var Accept: Boolean; var ErrorMessage: String);
    procedure Button4Click(Sender: TObject);
    procedure RESTDWClientNotification1BeforeConnect(Sender: TObject);
    procedure RESTDWClientNotification1Connect(Sender: TObject);
    procedure RESTDWClientNotification1Disconnect(Sender: TObject);
    procedure RESTDWClientNotification1ReceiveStream(Username: String;
      const aStream: TStream; var Accept: Boolean;
      var ErrorMessage: String);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 Memo1.Lines.Clear;
 RESTDWClientNotification1.Host := eHost.Text;
 RESTDWClientNotification1.Port := StrToInt(ePorta.Text);
 RESTDWClientNotification1.Connect;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 RESTDWClientNotification1.Disconnect;
end;

procedure TForm1.RESTDWClientNotification1ReceiveMessage(Username,
  aMessage: String; var Accept: Boolean; var ErrorMessage: String);
begin
 Memo1.Lines.Add(aMessage);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 RESTDWClientNotification1.ConnectionName := eConnectionName.Text;
end;

procedure TForm1.RESTDWClientNotification1BeforeConnect(Sender: TObject);
begin
 Memo1.Lines.Add('Before connect...');
end;

procedure TForm1.RESTDWClientNotification1Connect(Sender: TObject);
begin
 Memo1.Lines.Add('Connected...');
 eConnectionName.Text := RESTDWClientNotification1.ConnectionName;
end;

procedure TForm1.RESTDWClientNotification1Disconnect(Sender: TObject);
begin
 If Memo1 <> Nil Then
  Memo1.Lines.Add('Disconnected...');
end;

procedure TForm1.RESTDWClientNotification1ReceiveStream(Username: String;
  const aStream: TStream; var Accept: Boolean; var ErrorMessage: String);
Var
 vDirectory : String;
begin
 vDirectory := ExtractFilePath(ParamStr(0)) + 'temp\';
 If Not(DirectoryExists(vDirectory)) Then
  ForceDirectories(vDirectory);
 Try
  TMemoryStream(aStream).SaveToFile(vDirectory + FormatDateTime('ddmmyyyy_hhmmss', Now) + '.pdf');
 Finally
 End;
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
 vMessage : String;
begin
 vMessage := Inputbox('Insira a MSG para broadcast...', 'Message', '');
 RESTDWClientNotification1.SendMessage(vMessage);
end;

procedure TForm1.Button5Click(Sender: TObject);
Var
 vUsername,
 vMessage : String;
begin
 vUsername := Inputbox('Qual o usu�rio da msg?', 'Username', '');
 vMessage := Inputbox('Insira a MSG para Envio...', 'Message', '');
 RESTDWClientNotification1.SendMessage(vUsername, vMessage);
end;

procedure TForm1.Button6Click(Sender: TObject);
Var
 vFile : TFileStream;
begin
 If OpenDialog1.Execute Then
  Begin
   vFile := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
   Try
    vFile.Position := 0;
    RESTDWClientNotification1.SendStream(vFile);
   Finally
    FreeAndNil(vFile);
   End;
  End;
end;

procedure TForm1.Button7Click(Sender: TObject);
Var
 vUsername : String;
 vFile     : TFileStream;
begin
 vUsername := Inputbox('Qual o usu�rio da msg?', 'Username', '');
 If OpenDialog1.Execute Then
  Begin
   vFile := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
   Try
    vFile.Position := 0;
    RESTDWClientNotification1.SendStream(vUsername, vFile);
   Finally
    FreeAndNil(vFile);
   End;
  End;
end;

end.
