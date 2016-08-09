unit LIB.Model.Wire;

interface //#################################################################### ■

uses System.Types, System.Classes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyWireModel

     TMyWireModel = class( TControl3D )
     private
       ///// メソッド
       procedure MakeModel;
     protected
       _Geometry :TMeshData;
       _Material :TMaterialSource;
       ///// アクセス
       function GetPoinN :Integer;
       procedure SetPoinN( const PoinsN_:Integer );
       function GetPoin( const I_:Integer ) :TPoint3D;
       procedure SetPoin( const I_:Integer; const Poin_:TPoint3D );
       ///// メソッド
       procedure Render; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Material                 :TMaterialSource read   _Material write   _Material;
       property PoinN                    :Integer         read GetPoinN    write SetPoinN   ;
       property Poin[ const I_:Integer ] :TPoint3D        read GetPoin     write SetPoin    ;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.RTLConsts;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyWireModel

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TMyWireModel.MakeModel;
var
   I :Integer;
begin
     with _Geometry.IndexBuffer do
     begin
          Length := 2 * ( PoinN - 1 );

          for I := 0 to PoinN-2 do
          begin
               Indices[ 2 * I + 0 ] := I + 0;
               Indices[ 2 * I + 1 ] := I + 1;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TMyWireModel.GetPoinN :Integer;
begin
     Result := _Geometry.VertexBuffer.Length;
end;

procedure TMyWireModel.SetPoinN( const PoinsN_:Integer );
begin
     _Geometry.VertexBuffer.Length := PoinsN_;

     MakeModel;
end;

function TMyWireModel.GetPoin( const I_:Integer ) :TPoint3D;
begin
     Result := _Geometry.VertexBuffer.Vertices[ I_ ];
end;

procedure TMyWireModel.SetPoin( const I_:Integer; const Poin_:TPoint3D );
begin
     _Geometry.VertexBuffer.Vertices[ I_ ] := Poin_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyWireModel.Render;
begin
     with Context do
     begin
          SetMatrix( AbsoluteMatrix );

          DrawLines( _Geometry.VertexBuffer                  ,
                     _Geometry.IndexBuffer                   ,
                     TMaterialSource.ValidMaterial(_Material),
                     AbsoluteOpacity                          );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyWireModel.Create( Owner_:TComponent );
begin
     inherited;

     _Geometry := TMeshData.Create;

     HitTest := False;
     PoinN   := 100;

     MakeModel;
end;

destructor TMyWireModel.Destroy;
begin
     _Geometry.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
