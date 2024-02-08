pageextension 50123 BaseCalChangeEx extends "Base Calendar Changes"
{
    layout
    {
        addafter(Nonworking)
        {
            field("Type of Work"; Rec."Cause of Absence Code")
            {
                ApplicationArea = All;
                Caption = 'Cause of Absence Code';
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}