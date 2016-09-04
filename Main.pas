unit Main;

interface //#################################################################### Å°

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Viewport3D,
  System.Math.Vectors, FMX.Types3D, FMX.Objects3D, FMX.Controls3D,
  FMX.MaterialSources,
  LIB.Model.Wire;

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Dummy1: TDummy;
    Dummy2: TDummy;
    Camera1: TCamera;
    Light1: TLight;
    Grid3D1: TGrid3D;
    ColorMaterialSource1: TColorMaterialSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { private êÈåæ }
    _MouseS :TShiftState;
    _MouseP :TPointF;
  public
    { public êÈåæ }
    _WireModel :TMyWireModel;
    ///// ÉÅÉ\ÉbÉh
    function ScrTo3D( const P_:TPointF ) :TPoint3D;
  end;

var
  Form1: TForm1;

implementation //############################################################### Å°

uses System.Math;

{$R *.fmx}

function TForm1.ScrTo3D( const P_:TPointF ) :TPoint3D;
var
   W, H :Single;
   S, P :TPoint3D;
begin
     W := Viewport3D1.Width  / 2;
     H := Viewport3D1.Height / 2;

     S.X := P_.X - W;
     S.Y := P_.Y - H;
     S.Z := H / Tan( DegToRad( Camera1.AngleOfView / 2 ) );

     P := S / S.Z * -Camera1.Position.Z;

     Result := Camera1.LocalToAbsolute3D( P );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseS := [];

     _WireModel := TMyWireModel.Create( Self );

     with _WireModel do
     begin
          Parent   := Viewport3D1;
          Material := ColorMaterialSource1;
          PoinN    := 1;
     end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _WireModel.Free;
end;

procedure TForm1.Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     _MouseS := Shift;
     _MouseP := TPointF.Create( X, Y );

     if ssLeft  in _MouseS then
     begin
          with _WireModel do
          begin
               PoinN     := 1;
               Poin[ 0 ] := ScrTo3D( _MouseP );
          end;
     end
     else
     if ssRight in _MouseS then
     begin

     end;
end;

procedure TForm1.Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
   P :TPointF;
   I :Integer;
begin
     if ssLeft  in _MouseS then
     begin
          P := TPointF.Create( X, Y );

          with _WireModel do
          begin
               I := PoinN;

               PoinN     := PoinN + 1;
               Poin[ I ] := ScrTo3D( _MouseP );

               Repaint;
          end;

          _MouseP := P;
     end
     else
     if ssRight in _MouseS then
     begin
          P := TPointF.Create( X, Y );

          with Dummy1.RotationAngle do Y := Y + ( P.X - _MouseP.X ) / 2;
          with Dummy2.RotationAngle do X := X - ( P.Y - _MouseP.Y ) / 2;

          _MouseP := P;
     end;
end;

procedure TForm1.Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     Viewport3D1MouseMove( Sender, Shift, X, Y );

     _MouseS := [];
end;

end. //######################################################################### Å°
