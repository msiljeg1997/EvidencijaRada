tableextension 50143 CalendarEx extends Employee
{

    fields
    {

        field(1321; "Calendar"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            TableRelation = "Base Calendar".Code;
        }

    }

    keys
    {
    }

    fieldgroups
    {
    }

    var
        myInt: Integer;
}