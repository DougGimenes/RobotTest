program RobotApp;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Classes,
  StrUtils,
  RobotApp.PositionCalculator in 'RobotApp.PositionCalculator.pas';

var
  Commands: String;
  StringCommandList: TStringList;
  CommandList: TCommandList;
  SystemHalt: String;
begin
  Writeln('Please input robot instructions:');
  ReadLn(Commands);


  StringCommandList := TStringList.Create();
  try
    StringCommandList.Clear;
    StringCommandList.Delimiter       := ',';
    StringCommandList.StrictDelimiter := True;
    StringCommandList.DelimitedText   := Commands;

    CommandList := TCommandList.Create(StringCommandList);
    Writeln(CommandList.GetNewPosition());

    Readln(SystemHalt);
  finally
    FreeAndNil(StringCommandList);
    FreeAndNil(CommandList);
  end;
end.
