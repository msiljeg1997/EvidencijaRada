pageextension 50125 PageCalendarEx extends "Employee Card"
{
    layout
    {
        addafter("Termination Date")
        {
            field("Calendar"; Rec."Calendar")
            {
                ApplicationArea = All;
                Caption = 'Calendar';

                // trigger OnValidate();
                // var
                //     EvdencijaRada: Record "Employee Absence";
                //     BaseCalendarChange: Record "Base Calendar Change";
                // begin
                //     EvdencijaRada.FindFirst();
                //     BaseCalendarChange.FindFirst();
                //     CreateWorkLogs(EvdencijaRada."Employee No.", BaseCalendarChange."Base Calendar Code");
                // end;
            }
            // Add changes to page layout here
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;



}