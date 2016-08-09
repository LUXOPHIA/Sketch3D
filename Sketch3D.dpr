program Sketch3D;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LIB.Model.Wire in '_LIBRARY\LIB.Model.Wire.pas',
  LUX in '_LIBRARY\LUXOPHIA\LUX\LUX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
