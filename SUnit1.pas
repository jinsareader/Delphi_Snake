unit SUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TThreadA = class(TThread)
    protected
      procedure Execute; override;
    public
  end;
  TThreadB = class(TThread)
    protected
      procedure Execute; override;
    public
  end;
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ThreadA : TThreadA;
  ThreadB : TThreadB;
  Form1: TForm1;
  board_label : array of TLabel;

  board : array of integer;
  board_width : integer = 20;
  board_length : integer = 20;
  dir_info : integer = 1;
  snake_length : integer = 4;
  food_ate : boolean = False;
  lose : boolean = true;
  temp : integer;

  is_executing : boolean = false;

implementation

{$R *.dfm}

uses SUnit2;

procedure TForm1.Button1Click(Sender: TObject);
var
  area, i, j, k : integer;
begin
  area := (board_width+2) * (board_length+2);

  if lose then
  begin
  dir_info := 1;
  snake_length := 4;

  form1.Height := (board_length+8)*20;
  form1.Width := (board_width+6)*20;
  setlength(board, area);
  setlength(board_label, area);

  clear_board(board, board_width, board_length);
  set_board_wall(board, board_width, board_length);
  set_snake(board,board_width, board_length, snake_length);
  set_food(board, board_width, board_length);

  for i := 0 to board_length+1 do
    for j := 0 to board_width+1 do
      begin
        k := i*(board_width+2) + j;
        board_label[k] := Tlabel.Create(self);
        board_label[k].Parent := self;
        board_label[k].Top := 40 + 20 * i;
        board_label[k].Left:= 40 + 20 * j;
        board_label[k].Width := 20;
        board_label[k].height := 20;
        board_label[k].Transparent := false;
        board_label[k].Tag := k;
      end;
  for i := 0 to (board_width+2)*(board_length+2)-1 do
    begin
    if (board[i] = -100) then
      board_label[i].Color := clblue
    else if (board[i] = -1) then
      board_label[i].Color := clred
    else if (board[i] = 0) then
      board_label[i].Color := clblack
    else if (board[i] = 1) then
      board_label[i].Color := clyellow
    else if (board[i] > 1) then
      board_label[i].Color := clwhite;
    end;

  button1.Caption := 'start';
  label2.Caption := '0';
  label3.Caption := 'Snake Game';
  lose := false;
  end

  else if lose = false then
  begin
  threada := tthreada.Create(true);
  threadb := tthreadb.Create(true);

  is_executing := true;

  ThreadA.resume;
  ThreadB.resume;
  end;
end;

procedure TForm1.Button1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #119 then
    if dir_info <> 4 then
    begin
      dir_info := 2; //up
    //showmessage('w pressed');
    end;
  if key = #97 then
    if dir_info <>3 then
    begin
      dir_info := 1; //left
    //showmessage('a pressed');
    end;
  if key = #115 then
    if dir_info <> 2 then
    begin
      dir_info := 4; //down
    //showmessage('s pressed');
    end;
  if key = #100 then
    if dir_info <> 1 then
    begin
      dir_info := 3; //right
    //showmessage('d pressed');
    end;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if is_executing = true then
  begin
  threada.Terminate;
  threadb.Terminate;
  threada.Free;
  threadb.Free;
  end;
end;

{ TThreadA }


procedure TThreadA.Execute;
var
  i : integer;
begin
  while lose = false do
  begin
    for i := 0 to (board_width+2)*(board_length+2)-1 do
    begin
    if (board[i] = -1) then
      board_label[i].Color := clred
    else if (board[i] = 0) then
      board_label[i].Color := clblack
    else if (board[i] = 1) then
      board_label[i].Color := clyellow
    else if (board[i] > 1) then
      board_label[i].Color := clwhite;
    end;
    form1.Label2.Caption := inttostr(snake_length - 4);
    if terminated then break;

    sleep(100);
  end;
end;

{ TThreadB }


procedure TThreadB.Execute;
var
  i : integer;
begin
  while lose = false do
  begin
    if is_lose(board, board_width, board_length, dir_info) then
    begin
      form1.Button1.caption := 'restart';
      form1.Label3.Caption := 'You Lose';
      lose := true;
      is_executing := false;
    end;
    food_ate := is_food_ate(board, board_width, board_length, dir_info);
    snake_move(board, board_width, board_length, snake_length, dir_info, food_ate);
    if food_ate then
    begin
      set_food(board, board_width, board_length);
      food_ate := false;
    end;
    if terminated then break;

    sleep(500);
  end;
end;

end.
