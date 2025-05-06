program DelphiCustomerManager;

uses
  Vcl.Forms,
  CustomerForm in 'C:\Users\Erika\Documents\Embarcadero\Studio\Projects\CustomerForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
