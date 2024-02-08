tableextension 50105 BaseCalendarChangeTabEx extends "Base Calendar Change"
{
    fields
    {
        field(50000; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            TableRelation = "Employee Absence"."Cause of Absence Code";
        }
    }

    var
        myInt: Integer;
}