pageextension 50106 "Absence Registration Ex" extends "Absence Registration"
{
    layout
    {
        addafter("Employee No.")
        {
            field("Employee Full Name"; GetEmployeeFullName())
            {
                ApplicationArea = All;
                Caption = 'Employee Full Name';
                Editable = false;
                Enabled = false;
                ToolTip = 'Employee Full Name';
            }
            field(Date; Rec.Date)
            {
                ApplicationArea = All;
                Caption = 'Date';
                Editable = true;
                Enabled = true;
                ToolTip = 'Date';
            }
            field("Start Time"; rec."Start Time")
            {
                ApplicationArea = All;
                Caption = 'Start Time';
                Editable = true;
                Enabled = true;
                ToolTip = 'Start Time';
            }
            field("Finish Time"; rec."Finish Time")
            {
                ApplicationArea = All;
                Caption = 'Finish Time';
                Editable = true;
                Enabled = true;
                ToolTip = 'Finish Time';
            }
            field("Duration"; rec.CalculateDuration())
            {
                ApplicationArea = All;
                Caption = 'Duration';
                Editable = true;
                Enabled = true;
                ToolTip = 'Duration';
            }
            field("Weekday"; rec.WeekDay)
            {
                ApplicationArea = All;
                Caption = 'Weekday';
                Editable = false;
                Enabled = true;
                ToolTip = 'Weekday';
            }

        }
    }

    var
        Employee: Record Employee;

    local procedure GetEmployeeFullName(): Text[90];
    begin
        if Employee.Get(rec."Employee No.") then
            exit(StrSubstNo('%1 %2', Employee."First Name", Employee."Last Name"));
    end;
}