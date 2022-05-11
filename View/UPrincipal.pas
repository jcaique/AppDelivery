unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Ani, System.Generics.Collections, uFunctions, uLoading, FMX.DialogService;

type
  TfrmPrincipal = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    RectAbas: TRectangle;
    imgAba1: TImage;
    imgAba2: TImage;
    imgAba3: TImage;
    RectAbaSelecao: TRectangle;
    RectToolBar1: TRectangle;
    imgLogoApp: TImage;
    imgAdd: TImage;
    Label1: TLabel;
    LvRemessa: TListView;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    Image5: TImage;
    Rectangle3: TRectangle;
    Label3: TLabel;
    Image6: TImage;
    Image7: TImage;
    imgBolaAmarela: TImage;
    ImgLocais1: TImage;
    ImgLocais2: TImage;
    ImgStatusAndamento: TImage;
    ImgStatusFinalizado: TImage;
    imgBolaCinza: TImage;
    imgFundoValorAmarelo: TImage;
    imgFundoValorCinza: TImage;
    lvEntrega: TListView;
    lvHistorico: TListView;
    procedure imgAba1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgAddClick(Sender: TObject);
    procedure LvRemessaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvEntregaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvHistoricoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    imgAbaSelecionada: TImage;
    procedure SelecionaAba(Img: TImage);
    procedure AddRemessa(IdRemessa: Integer; RemessaStatus, RemessaDescricao, RemessaEndereco: string; RemessaValor: double);
    procedure ListarRemessas;
    procedure ThreadRemessasOnTerminate(Sender: TObject);
    procedure AddEntrega(EntregaId: Integer; EntregaDescricao,
      EntregaEnderecoOrigem, EntregaEnderecoDestino: String;
      EntregaValor: Double);
    procedure ListarEntregas;
    procedure ThreadEntregaOnTerminate(Sender: TObject);
    procedure AddHistorico(RemessaId, UsuarioId: Integer; Status,
      RemessaData, Descricao, Origem, Destino: String; Valor: Double);
    procedure ThreadHistoricoOnTerminate(Sender: TObject);
    procedure ListaHistorico;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  const TempoTesteEspera: Integer = 1500;

implementation

uses
  UNovaRemessa, UStatusRemessa;

{$R *.fmx}

procedure TFrmPrincipal.SelecionaAba(Img: TImage);
begin
   imgAbaSelecionada := Img;

   TAnimator.AnimateFloat(RectAbaSelecao, // O Objeto que quero animar na tela
                          'Position.X', // A propriedade deste objeto que desejo animar
                          Img.Position.x, // O novo valor da propriedade animada
                          0.2, // O tempo de duração
                          TAnimationType.In, // Tipo de animação
                          TInterpolationType.Circular); // Tipo de interpolação

  TabControl.GotoVisibleTab(Img.Tag); //Muda a tab de posição

  if img.Tag = 1 then
    ListarEntregas
  else
  if Img.Tag = 2 then
    ListaHistorico;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  SelecionaAba(imgAba1); // Deixar aba 1 como padrão
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
  if Assigned(imgAbaSelecionada) then
  begin
    RectAbaSelecao.Position.X := imgAbaSelecionada.Position.X;
    RectAbaSelecao.Width := imgAbaSelecionada.Width;
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  ListarRemessas;
end;

procedure TfrmPrincipal.imgAba1Click(Sender: TObject);
begin
  SelecionaAba(TImage(Sender)); //TypeCasting
end;

procedure TfrmPrincipal.ListarRemessas;
var
  Th: TTHread;
begin
  TLoading.show(Self, 'Carregando Remessas...');

  LvRemessa.Items.Clear;
  LvRemessa.BeginUpdate;

  // thread para fazer a atualização da lista em paralelo
  Th := TThread.CreateAnonymousThread(procedure
  begin
    // Acessar a API em busca das remessas

    Sleep(TempoTesteEspera); //teste

    // Utilizando o conceito de sincronização, para que execute alguma coisa na Thread principal.
    // É interessante utilizar este conceito, pois podem ocorrer erros durante a execução da Thread
    // paralela e ficar complicado de achar onde está sendo gerado o erro.
    TThread.Synchronize(TThread.CurrentThread,procedure
    begin
      AddRemessa(0, 'P', 'Entrega de Flores', 'Avenida Paulista, 500 - CJ60', 25);
      AddRemessa(0, 'E', 'Entrega de Peças', 'Avenida Paulista, 500 - CJ60', 25);
      AddRemessa(0, 'E', 'Entrega de Documentos', 'Avenida Paulista, 500 - CJ60', 39);
      AddRemessa(0, 'P', 'Entrega de Contabilidade', 'Avenida Paulista, 500 - CJ60', 24.99);
      AddRemessa(0, 'P', 'Entrega de Pizza', 'Avenida Paulista, 500 - CJ60', 50.59);
    end);
  end);

  // Quando a Thread terminar, irá executar esta procedure
  Th.OnTerminate := ThreadRemessasOnTerminate;
  Th.Start;
end;

procedure TfrmPrincipal.ListarEntregas;
begin
  TLoading.show(Self, 'Carregando entregas...');

  LvEntrega.Items.Clear;
  LvEntrega.BeginUpdate;

  // thread para fazer a atualização da lista em paralelo
  var ThEntrega := TThread.CreateAnonymousThread(procedure
  begin
    // Acessar a API em busca das remessas

    Sleep(TempoTesteEspera); //teste

    // Utilizando o conceito de sincronização, para que execute alguma coisa na Thread principal.
    // É interessante utilizar este conceito, pois podem ocorrer erros durante a execução da Thread
    // paralela e ficar complicado de achar onde está sendo gerado o erro.
    TThread.Synchronize(TThread.CurrentThread,procedure
    begin
      AddEntrega(0, 'Entrega de Flores', 'Entrega de Flores', 'Avenida Paulista, 500 - CJ60', 25);
      AddEntrega(1, 'Entrega de Peças', 'Entrega de Peças', 'Avenida Paulista, 500 - CJ60', 25);
      AddEntrega(2, 'Entrega de Documentos', 'Entrega de Documentos', 'Avenida Paulista, 500 - CJ60', 39);
      AddEntrega(3, 'Entrega de Contabilidade', 'Entrega de Contabilidade', 'Avenida Paulista, 500 - CJ60', 24.99);
      AddEntrega(4, 'Entrega de Pizza', 'Entrega de Pizza', 'Avenida Paulista, 500 - CJ60', 50.59);
    end)
  end);

  // Quando a Thread terminar, irá executar esta procedure
  ThEntrega.OnTerminate := ThreadEntregaOnTerminate;
  ThEntrega.Start;
end;

procedure TfrmPrincipal.ListaHistorico;
begin
  TLoading.Show(Self, 'Carregando histórico...');

  lvHistorico.Items.Clear;
  lvHistorico.BeginUpdate;

  var Th := TThread.CreateAnonymousThread(procedure
  begin
    // Acessar a API para buscar os dados do histórico

    Sleep(TempoTesteEspera); //teste

    TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      AddHistorico(1, 2, 'P', '13/08/2022', 'Entrega de Flores', 'Porto Feliz', 'Sorocaba', 200.00);
      AddHistorico(1, 2, 'F', '19/01/2022', 'Entrega de Flores', 'Porto Feliz', 'São Paulo', 200.00);
      AddHistorico(1, 2, 'P', '12/06/2020', 'Entrega de Flores', 'Porto Feliz', 'Itu', 289.97);
      AddHistorico(1, 2, 'P', '19/06/2022', 'Entrega de Flores', 'Porto Feliz', 'Tietê', 260.00);
      AddHistorico(1, 2, 'F', '17/04/2022', 'Entrega de Flores', 'Porto Feliz', 'Salto', 250.00);
      AddHistorico(1, 2, 'P', '12/03/2021', 'Entrega de Flores', 'Porto Feliz', 'Pirapora', 220.00);
    end);
  end);

  Th.OnTerminate := ThreadHistoricoOnTerminate;
  Th.Start;
end;

procedure TfrmPrincipal.ThreadRemessasOnTerminate(Sender: TObject);
begin
  // Será executada assim que a Thread utilizada para atualizar a lista terminar
  // Dever ter esta mesma assinatura por padrão
  TLoading.Hide;

  lvRemessa.EndUpdate;

  if ErroThread(Sender) then
    Exit;
end;

procedure TfrmPrincipal.ThreadEntregaOnTerminate(Sender: TObject);
begin
  TLoading.Hide;
  lvEntrega.EndUpdate;

  if ErroThread(Sender) then
    Exit;
end;

procedure TfrmPrincipal.ThreadHistoricoOnTerminate(Sender: TObject);
begin
  TLoading.Hide;
  lvHistorico.Hide;

  if ErroThread(Sender) then
    Exit;
end;

procedure TfrmPrincipal.AddRemessa(IdRemessa: Integer; RemessaStatus, RemessaDescricao,
                                   RemessaEndereco: string; RemessaValor: double);
begin
  var Item := LvRemessa.Items.Add;  //TListItemView

  with Item do
  begin
    Tag := IdRemessa;
    Height := 70;

    // Procura por um objeto dentro do item via typecasting
    TListItemText(Objects.FindDrawable('txtDescricao')).Text := RemessaDescricao;
    TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', RemessaValor);
    TListItemText(Objects.FindDrawable('txtEndereco')).Text := RemessaEndereco;

    TListItemImage(Objects.FindDrawable('imgValor')).BitMap := imgFundoValorAmarelo.BitMap;

    if RemessaStatus = 'P' then
      TListItemImage(Objects.FindDrawable('imgIcone')).BitMap := imgBolaCinza.BitMap
    else
      TListItemImage(Objects.FindDrawable('imgIcone')).BitMap := imgBolaAmarela.BitMap;
  end;
end;

procedure TfrmPrincipal.AddEntrega(EntregaId: Integer; EntregaDescricao, EntregaEnderecoOrigem, EntregaEnderecoDestino: String;
                                   EntregaValor: Double);
begin
  var Item := lvEntrega.Items.Add;

  with Item do
  begin
    Tag := EntregaId;
    Height := 130;

    TListItemText(Objects.FindDrawable('txtDescricao')).Text := EntregaDescricao;
    TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', EntregaValor);
    TListItemText(Objects.FindDrawable('txtOrigem')).Text := EntregaEnderecoOrigem;
    TListItemText(Objects.FindDrawable('txtDestino')).Text := EntregaEnderecoDestino;

    TListItemImage(Objects.FindDrawable('imgValor')).Bitmap := imgFundoValorAmarelo.BitMap;
    TListItemImage(Objects.FindDrawable('imgLocal')).Bitmap := ImgLocais1.Bitmap;
  end;
end;

procedure TfrmPrincipal.AddHistorico(RemessaId, UsuarioId: Integer; Status, RemessaData, Descricao, Origem, Destino: String;
                                     Valor: Double);
begin
  var Item := lvHistorico.Items.Add;

  with Item do
  begin
    Tag := RemessaId;
    Height := 150;

    TListItemText(Objects.FindDrawable('txtDescricao')).Text := Descricao;
    TListItemText(Objects.FindDrawable('txtData')).Text := RemessaData;
    TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', Valor);
    TListItemText(Objects.FindDrawable('txtOrigem')).Text := Origem;
    TListItemText(Objects.FindDrawable('txtDestino')).Text := Destino;

    TListItemImage(Objects.FindDrawable('imgValor')).Bitmap := imgFundoValorCinza.Bitmap;
    TListItemImage(Objects.FindDrawable('imgLocais')).Bitmap := imgLocais2.Bitmap;

    if Status = 'F' then
      TListItemImage(Objects.FindDrawable('imgStatus')).Bitmap := ImgStatusFinalizado.Bitmap
    else
      TListItemImage(Objects.FindDrawable('imgStatus')).Bitmap := ImgStatusAndamento.Bitmap;
  end;
end;

procedure TfrmPrincipal.imgAddClick(Sender: TObject);
begin
  if not Assigned(frmNovaRemessa) then
    Application.CreateForm(tfrmNovaremessa, frmNovaRemessa);

  FrmNovaRemessa.Show;
end;

procedure TfrmPrincipal.LvRemessaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if not Assigned(frmNovaRemessa) then
    Application.CreateForm(tfrmNovaremessa, frmNovaRemessa);

  FrmNovaRemessa.Show;
end;

procedure TfrmPrincipal.lvEntregaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TDialogService.MessageDialog('Confirma a solicitaçãop de coleta?',
                                TMsgDlgType.mtConfirmation,
                                [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                TMsgDlgBtn.mbNo,
                                0,
                                procedure(const AResult: TModalResult)
                                begin
                                  if AResult = mrYes then
                                    ShowMessage('Reserva a Entrega.');
                                end);
end;


procedure TfrmPrincipal.lvHistoricoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if not Assigned(frmStatusRemessa) then
    Application.CreateForm(TfrmStatusRemessa, frmStatusRemessa);

  frmStatusRemessa.Show;
end;

end.

{
  Para editar os itrens da lista: Toggle Design Mode


}
