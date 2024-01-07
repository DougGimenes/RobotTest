unit RobotApp.PositionCalculator;

interface

uses
  System.SysUtils,
  Classes,
  StrUtils,
  System.Generics.Collections;

type
  TPosition = class(TObject)
  private
    FFacing: String;
    FPosX: Integer;
    FPosY: Integer;
  public
    property Facing: String read FFacing write FFacing;
    property PosX: Integer read FPosX write FPosX;
    property PosY: Integer read FPosY write FPosY;

    function RetrievePosition(): String;
  end;

  TCommandLine = class(TObject)
  private
    FCommand: String;
    FParameter: Integer;
  public
    property Command: String read FCommand;
    property Parameter: Integer read FParameter;

    constructor Create(ACommand: String; AParam: Integer = 0); overload;
  end;

  TCommandList = class(TObject)
  private
    Commands: TObjectList<TCommandLine>;
    FPosition: TPosition;

    function GenerateCommands(CommandList: TStringList): Boolean;
  public
    property Position: TPosition read FPosition write FPosition;

    function GetNewPosition(): String;
    constructor Create(CommandList: TStringList); overload;
  end;

implementation

{TCommandLine}
constructor TCommandLine.Create(ACommand: String; AParam: Integer = 0);
begin
  FCommand    := ACommand;
  FParameter := AParam;
end;


{TCommandList}
function TCommandList.GenerateCommands(CommandList: TStringList): Boolean;
begin
  Result := False;
  if CommandList.Count > 0 then
  begin
    for var I := 0 to CommandList.Count - 1 do
    begin
      CommandList[I] := CommandList[I].Trim();
      if ContainsText(CommandList[I], 'POSITION') then
      begin
        Self.Position.PosX := StrToInt(CommandList[I].Substring(9, 1));
        Self.Position.PosY := StrToInt(CommandList[I].Substring(11, 1));
        Self.Position.FFacing := CommandList[I].Substring(13);
      end
      else if ContainsText(CommandList[I], 'FORWARD') then
      begin
        Self.Commands.Add(TCommandLine.Create(CommandList[I].Substring(0, 7), StrToInt(CommandList[I].Substring(8, 1))));
      end
      else
      begin
        Self.Commands.Add(TCommandLine.Create(CommandList[I]));
      end;
    end;
  end;
  Result := True;
end;

function TCommandList.GetNewPosition(): String;
begin
  for var I := 0 to Self.Commands.Count - 1 do
  begin
    case AnsiIndexStr(UpperCase(Self.Commands[I].Command), ['FORWARD', 'TURNAROUND', 'LEFT', 'RIGHT']) of
      0: begin
        Self.Position.PosX := Self.Position.PosX + (Self.Commands[I].Parameter * Ord(Self.Position.Facing = 'EAST')) - (Self.Commands[I].Parameter * Ord(Self.Position.Facing = 'WEST'));
        Self.Position.PosY := Self.Position.PosY + (Self.Commands[I].Parameter * Ord(Self.Position.Facing = 'SOUTH')) - (Self.Commands[I].Parameter * Ord(Self.Position.Facing = 'NORTH'));

        Self.Position.PosX := Self.Position.PosX - ((Self.Position.PosX - 7) * Ord(Self.Position.PosX > 7)) + ((Self.Position.PosX * (-1)) * Ord(Self.Position.PosX < 0));
        Self.Position.PosY := Self.Position.PosY - ((Self.Position.PosY - 7) * Ord(Self.Position.PosY > 7)) + ((Self.Position.PosY * (-1)) * Ord(Self.Position.PosY < 0));
      end;

      1: begin
        case AnsiIndexStr(UpperCase(Self.Position.Facing), ['NORTH', 'SOUTH', 'EAST', 'WEST']) of
          0: Self.Position.Facing := 'SOUTH';
          1: Self.Position.Facing := 'NORTH';
          2: Self.Position.Facing := 'WEST';
          3: Self.Position.Facing := 'EAST';
        end;
      end;

      2: begin
        case AnsiIndexStr(UpperCase(Self.Position.Facing), ['NORTH', 'SOUTH', 'EAST', 'WEST']) of
          0: Self.Position.Facing := 'WEST';
          1: Self.Position.Facing := 'EAST';
          2: Self.Position.Facing := 'SOUTH';
          3: Self.Position.Facing := 'NORTH';
        end;
      end;

      3: begin
        case AnsiIndexStr(UpperCase(Self.Position.Facing), ['NORTH', 'SOUTH', 'EAST', 'WEST']) of
          0: Self.Position.Facing := 'EAST';
          1: Self.Position.Facing := 'WEST';
          2: Self.Position.Facing := 'NORTH';
          3: Self.Position.Facing := 'SOUTH';
        end;
      end;
    end;
  end;

  Result := Self.Position.RetrievePosition;
end;

constructor TCommandList.Create(CommandList: TStringList);
begin
  Self.FPosition := TPosition.Create();
  Self.Commands := TObjectList<TCommandLine>.Create(True);
  Self.GenerateCommands(CommandList);
end;

{TPosition}
function TPosition.RetrievePosition(): String;
begin
  Result := Self.Facing + ' ' + Self.PosX.ToString() + ' ' + Self.PosY.ToString();
end;

end.
