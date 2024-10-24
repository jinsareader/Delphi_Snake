unit SUnit2;

interface
var
  board : array of integer;
  board_width : integer;
  board_length : integer;
  dir_info : integer;
  snake_length : integer;
  food_ate : boolean;

procedure clear_board(var board: array of integer; board_width : integer; board_length : integer);
procedure set_board_wall(var board: array of integer; board_width : integer; board_length : integer);
procedure set_snake(var board: array of integer; board_width : integer; board_length : integer; snake_length : integer);
procedure set_food(var board: array of integer; board_width : integer; board_length : integer);
function find_loc(board: array of integer; board_width : integer; board_length : integer; num : integer) : integer;
procedure snake_move(var board: array of integer; board_width : integer; board_length : integer; var snake_length : integer; dir_info : integer; food_ate : boolean);
function is_lose(board: array of integer; board_width : integer; board_length : integer; dir_info : integer) : boolean;
function is_food_ate(board: array of integer; board_width : integer; board_length : integer; dir_info : integer) : boolean;

implementation

procedure clear_board(var board: array of integer; board_width : integer; board_length : integer);
var
  i : integer;
begin
  for I := 0 to (board_width+2) * (board_length+2) - 1 do
    board[i] := 0;
end;

procedure set_board_wall(var board: array of integer; board_width : integer; board_length : integer);
var
  i: integer;
begin
  for i := 0 to (board_width+1) do
  begin
    board[i] := -100;
    board[i+(board_length+1) * (board_width+2)] := -100;
  end;
  for i := 0 to (board_length+1) do
  begin
    board[i*(board_width+2)] := -100;
    board[i*(board_width+2) + (board_width+1)] := -100;
  end;
end;

procedure set_snake(var board: array of integer; board_width : integer; board_length : integer; snake_length : integer);
var
  i, temp : integer;
begin
temp := (board_width+2-snake_length) div 2;
  for i := 0 to snake_length-1 do
  begin
    board[temp+i + (board_width+2) * (board_length+2) div 2] := i+1;
  end;
end;

procedure set_food(var board: array of integer; board_width : integer; board_length : integer);
var
  temp : integer;
begin
  randomize();
  while True do
  begin
    temp := random((board_width+2) * (board_length + 2));
    if board[temp] = 0 then
      break;
  end;
  board[temp] := -1;
end;

function find_loc(board: array of integer; board_width : integer; board_length : integer; num : integer) : integer;
var
  i : integer;
begin
  for I := 0 to (board_width+2) * (board_length+2) - 1 do
    if board[i] = num then
      break;
  result := i;
end;

procedure snake_move(var board: array of integer; board_width : integer; board_length : integer; var snake_length : integer; dir_info : integer; food_ate : boolean);
var
  i, loc : integer;
begin
  for i := snake_length downto 1 do
  begin
    loc := find_loc(board, board_width, board_length, i);
    board[loc] := i + 1;
  end;
  snake_length := snake_length + 1;

  if food_ate = false then
  begin
    loc := find_loc(board, board_width, board_length, snake_length);
    board[loc] := 0;
    snake_length := snake_length - 1;
  end;

  loc := find_loc(board, board_width, board_length, 2);
  case dir_info of
    1 : board[loc - 1] := 1;//left
    2 : board[loc - (board_width+2)] := 1;//up
    3 : board[loc + 1] := 1;//right
    4 : board[loc + (board_width+2)] := 1;//down
    else
  end;
end;

function is_lose(board: array of integer; board_width : integer; board_length : integer; dir_info : integer) : boolean;
var
  temp : boolean;
  head_loc : integer;
begin
  temp := false;
  head_loc := find_loc(board, board_width, board_length, 1);
  case dir_info of
    1 : if ((board[head_loc - 1] > 0) or (board[head_loc - 1] = -100)) then
      temp := true;//left
    2 : if ((board[head_loc - (board_width+2)] > 0) or (board[head_loc - (board_width+2)] = -100)) then
      temp := true;//up
    3 : if ((board[head_loc + 1] > 0) or (board[head_loc + 1] = -100)) then
      temp := true;//right
    4 : if ((board[head_loc + (board_width+2)] > 0) or (board[head_loc + (board_width+2)] = -100)) then
      temp := true;//down
    else
      temp := false;
  end;
  result := temp;
end;

function is_food_ate(board: array of integer; board_width : integer; board_length : integer; dir_info : integer) : boolean;
var
  temp : boolean;
  head_loc : integer;
begin
  temp := false;
  head_loc := find_loc(board, board_width, board_length, 1);
  case dir_info of
    1 : if (board[head_loc - 1] = -1) then
      temp := true;//left
    2 : if (board[head_loc - (board_width+2)] = -1) then
      temp := true;//up
    3 : if (board[head_loc + 1] = -1) then
      temp := true;//right
    4 : if (board[head_loc + (board_width+2)] = -1) then
      temp := true;//down
    else
      temp := false;
  end;
  result := temp;
end;

end.
