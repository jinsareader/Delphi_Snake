program SProject1;

uses
  Vcl.Forms,
  SUnit1 in 'SUnit1.pas' {Form1},
  SUnit2 in 'SUnit2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
