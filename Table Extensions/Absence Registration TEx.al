tableextension 50125 "Employee Absence TEx" extends "Employee Absence"
{
    fields
    {
        field(10; "Employee Full Name"; Text[90])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Start Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Finish Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        Duration: Decimal;

    procedure CalculateDuration(): Text[10];
    var
        StartTime: DateTime;
        FinishTime: DateTime;
        DurationInMS: Duration;
        TotalMinutes: Integer;
        Hours: Integer;
        Minutes: Integer;
    begin
        StartTime := CREATEDATETIME("Date", "Start Time");
        FinishTime := CREATEDATETIME("Date", "Finish Time");

        if FinishTime < StartTime then
            FinishTime := CREATEDATETIME("Date" + 1, "Finish Time");

        DurationInMS := FinishTime - StartTime;
        TotalMinutes := DurationInMS / 60000;

        Hours := TotalMinutes / 60;
        Minutes := TotalMinutes MOD 60;

        exit(format(Hours) + ',' + format(Minutes));
    end;
}