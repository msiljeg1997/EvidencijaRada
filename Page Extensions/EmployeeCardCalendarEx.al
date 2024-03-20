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
            }
        }
    }

    actions
    {
        addafter("A&bsences")
        {
            action("Generate Calendar")
            {
                ApplicationArea = All;
                Image = Calendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Generate Calendar';

                trigger OnAction()
                var
                    GenerateYearlyCalendar: Codeunit 50137;
                    EmployeeCode: Code[20];
                    WorkingDays: List of [Date];
                begin
                    EmployeeCode := Rec."No.";
                    WorkingDays := GenerateYearlyCalendar.GenerateYearlyCalendarForEmployee(EmployeeCode);

                end;
            }
        }
    }

    var
        myInt: Integer;



}