unit RobotAppTester;

interface

uses
  DUnitX.TestFramework,
  RobotApp.PositionCalculator,
  System.SysUtils,
  Classes,
  StrUtils;

type
  [TestFixture]
  TRobotAppTest = class
  public
    [Test]
    procedure PositionInputTest();

    [Test]
    [TestCase('Simple','POSITION 0 0 SOUTH, FORWARD 2, TURNAROUND.NORTH 0 2','.')]
    [TestCase('Left_Only','POSITION 0 0 SOUTH, LEFT.EAST 0 0', '.')]
    [TestCase('Right_Only','POSITION 0 0 SOUTH, RIGHT.WEST 0 0', '.')]
    [TestCase('Wait_Only','POSITION 0 0 SOUTH, WAIT.SOUTH 0 0', '.')]
    [TestCase('Out_Of_Bounds','POSITION 0 0 SOUTH, FORWARD 9, RIGHT, FORWARD 9.WEST 0 7', '.')]
    procedure GetNewPositionTest(const ACommands : String;const AOutput : String);
  end;

implementation

procedure TRobotAppTest.PositionInputTest;
var
  CommandList: TCommandList;
  StringCommandList: TStringList;
begin
  StringCommandList := TStringList.Create();
  try
    StringCommandList.Clear;
    StringCommandList.Delimiter       := ',';
    StringCommandList.StrictDelimiter := True;
    StringCommandList.DelimitedText   := 'POSITION 5 3 EAST, FORWARD 3';

    CommandList := TCommandList.Create(StringCommandList);
    try
      Assert.AreEqual(CommandList.Position.RetrievePosition,'EAST 5 3')
    finally
      FreeAndNil(CommandList);
    end;
  finally
    FreeAndNil(StringCommandList);
  end;
end;

procedure TRobotAppTest.GetNewPositionTest(const ACommands : String;const AOutput : String);
var
  CommandList: TCommandList;
  StringCommandList: TStringList;
begin
  StringCommandList := TStringList.Create();
  try
    StringCommandList.Clear;
    StringCommandList.Delimiter       := ',';
    StringCommandList.StrictDelimiter := True;
    StringCommandList.DelimitedText   := ACommands;

    CommandList := TCommandList.Create(StringCommandList);
    try
      Assert.AreEqual(CommandList.GetNewPosition(),AOutput)
    finally
      FreeAndNil(CommandList);
    end;
  finally
    FreeAndNil(StringCommandList);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TRobotAppTest);

end.
