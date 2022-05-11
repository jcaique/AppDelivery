program AppDelivery;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'View\UPrincipal.pas' {frmPrincipal},
  uFunctions in 'Utils\uFunctions.pas',
  uLoading in 'Utils\uLoading.pas',
  UNovaRemessa in 'View\UNovaRemessa.pas' {frmNovaRemessa},
  UStatusRemessa in 'View\UStatusRemessa.pas' {frmStatusRemessa};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
