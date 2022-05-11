unit UStatusRemessa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmStatusRemessa = class(TForm)
    RectToolBar1: TRectangle;
    lbNovaRemessa: TLabel;
    imgVoltar: TImage;
    lbDescricao: TLabel;
    LayoutTela: TLayout;
    imgLocais: TImage;
    lbOrigem: TLabel;
    lbDestino: TLabel;
    lbValor: TLabel;
    rectCancelar: TRectangle;
    lbCancelarEntrega: TLabel;
    rectFinalizarEntrega: TRectangle;
    lbFinalizarEntrega: TLabel;
    procedure imgVoltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStatusRemessa: TfrmStatusRemessa;

implementation

{$R *.fmx}

procedure TfrmStatusRemessa.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
