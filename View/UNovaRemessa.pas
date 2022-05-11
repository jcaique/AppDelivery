unit UNovaRemessa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TfrmNovaRemessa = class(TForm)
    RectToolBar1: TRectangle;
    Label1: TLabel;
    imgVoltar: TImage;
    imgSalvar: TImage;
    edRemessaDescricao: TEdit;
    edRemessaValor: TEdit;
    edRemessaEnderecoEntrega: TEdit;
    edRemessaEnderecoRetirada: TEdit;
    imgDelete: TImage;
    procedure imgVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNovaRemessa: TfrmNovaRemessa;

implementation

{$R *.fmx}

procedure TfrmNovaRemessa.imgSalvarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNovaRemessa.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
