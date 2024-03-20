pageextension 50106 "Evidencija Rada" extends "Absence Registration"
{
    Caption = 'Evidencija Rada';
    layout
    {


        modify("Cause of Absence Code")
        {
            ApplicationArea = All;
            Caption = 'Type of Work';
        }
        modify("To Date")
        {
            Visible = false;
        }
        modify("From Date")
        {
            Visible = false;
        }
        modify("Quantity")
        {
            Visible = false;
        }



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
            field("Base Calendar Code"; rec."Base Calendar Code")
            {
                ApplicationArea = All;
                Caption = 'Base Calendar Code';
                Editable = true;
                Enabled = true;
                ToolTip = 'Base Calendar Code';
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

            field("Weekday"; rec.WeekDay)
            {
                ApplicationArea = All;
                Caption = 'Weekday';
                Editable = false;
                Enabled = true;
                ToolTip = 'Weekday';
            }



        }
        addafter("Quantity")
        {
            field("Duration"; rec.CalculateDuration())
            {
                ApplicationArea = All;
                Caption = 'Duration';
                Editable = true;
                Enabled = true;
                ToolTip = 'Duration';
            }
        }
    }

    actions
    {
        addafter("A&bsence")
        {
            action("Generate Calendar")
            {
                ApplicationArea = All;
                Image = Calendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Generate yearly calendar for the selected employee';

                trigger OnAction()
                var
                    GenerateYearlyCalendar: Codeunit 50137;
                    EmployeeAbsence: Record "Employee Absence";
                    EmployeeCode: Code[20];
                    WorkingDays: List of [Date];
                    WorkDate: Date;
                begin
                    EmployeeCode := Rec."Employee No.";
                    WorkingDays := GenerateYearlyCalendar.GenerateYearlyCalendarForEmployee(EmployeeCode);


                    foreach WorkDate in WorkingDays do begin

                        EmployeeAbsence.Init();
                        EmployeeAbsence."Employee No." := EmployeeCode;
                        EmployeeAbsence.Date := WorkDate;
                        // dodaj kasnije jos fields

                        EmployeeAbsence.Insert();
                    end;
                end;
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