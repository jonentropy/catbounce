unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TCat }

  TCat = class(TImage)
  private
    MovingUp, MovingRight: boolean;
  public
    constructor Create(Sender:TComponent); override;
    constructor Create(Sender:TComponent; Im: TImage); overload;
    procedure Move;
  end;

  { TfrmMain }

  TfrmMain = class(TForm)
    btnClicky: TButton;
    ImCat: TImage;
    lblBirthday: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure btnClickyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    procedure RandomlyPlaceCat(Ct: TCat);
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

const
  MAX_CATS = 5;

implementation
{$R *.lfm}

{ TCat }

constructor TCat.Create(Sender: TComponent);
begin
  inherited Create(Sender);
end;

constructor TCat.Create(Sender:TComponent; Im: TImage);
begin
  Create(Sender);
  Self.Picture.Bitmap.Assign(Im.Picture.Bitmap);
  MovingUp := Random(2) = 0;
  MovingRight := Random(2) = 0;
  Self.Width := Im.Width;
  Self.Height := Im.Height;
  Self.Visible := False;
end;

procedure TCat.Move;
begin
  if MovingUp then
    Self.Top := Self.Top - 1
  else
    Self.Top := Self.Top + 1;

  if MovingRight then
    Self.Left := Self.Left + 1
  else
    Self.Left := Self.Left - 1;

  if Self.Left > (Self.Parent.Width - Self.Width) then
    MovingRight := False;

  if Self.Left < 0 then
    MovingRight := True;

  if Self.Top > (Self.Parent.Height - Self.Height) then
    MovingUp := True;

  if Self.Top < 0 then
    MovingUp := False;
end;

{ TfrmMain }

procedure TfrmMain.btnClickyClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[i] is TCat then
      TCat(Self.Components[i]).Visible := True;

  Timer1.Enabled := True;
  Timer2.Enabled := True;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: integer;
  c: TCat;
begin
  Randomize();

  for i := 1 to MAX_CATS do
  begin
    c := TCat.Create(Self, ImCat);
    c.Parent := Self;
  end;

  for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[i] is TCat then
      RandomlyPlaceCat(TCat(Self.Components[i]));
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[i] is TCat then
      TCat(Self.Components[i]).Move();
end;

procedure TfrmMain.Timer2Timer(Sender: TObject);
begin
  lblBirthday.Visible := not lblBirthday.Visible;
end;

procedure TfrmMain.RandomlyPlaceCat(Ct: TCat);
begin
  Ct.Top := Random(Self.Height);
  Ct.Left := Random(Self.Width);
end;

end.

