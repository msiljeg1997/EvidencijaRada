page 50136 Kadrovska
{
    PageType = Card;
    ApplicationArea = All;

    actions
    {
        area(Navigation)
        {
            group(test)
            {
                Caption = 'test';
                action(BaseCalendar)
                {
                    ApplicationArea = All;
                    Caption = 'Base Calendar';
                    RunObject = Page "Base Calendar List";
                    Promoted = true;
                    PromotedIsBig = true;
                }
                action("Evidencija Rada")
                {
                    ApplicationArea = All;
                    Caption = 'Evidencija Rada';
                    RunObject = Page "Absence Registration";
                    Promoted = true;
                    PromotedIsBig = true;
                }
                action(evid)
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        EvidencijaRada: Record "Employee Absence";
                        rCompanyInformation: Record "Company Information" temporary;
                        BaseCalendarChange: Record "Base Calendar Change";
                        BaseCalendar: Record "Base Calendar";
                        WorkDate: Date;
                        EndOfYear: Date;
                        Year: Integer;
                        StartTime: Time;
                        EndTime: Time;
                        CalendarManagement: Codeunit "Calendar Management 2";
                        CustomCalendar: Record "Customized Calendar Change";
                        DateForWeek: Record Date;
                        NextEntryNo: Integer;
                        kita: Boolean;
                        a: Page 7604;
                        EmployeeNo: Code[20];
                        p: Page 9027;
                        ki2ta: Codeunit kitara;

                    begin
                        EmployeeNo := 'EH';
                        Year := Date2DMY(TODAY, 3); // daj sadasnju god
                        WorkDate := DMY2DATE(1, 1, Year); // pocetak god
                        EndOfYear := DMY2DATE(31, 12, Year); // kraj god
                        StartTime := 080000T; // start namjesten na 8 sati ujutro
                        EndTime := 160000T; // kraj namjesten na 4 sati popodne

                        rCompanyInformation.INIT();
                        rCompanyInformation."Base Calendar Code" := 'PONPET';
                        rCompanyInformation.Insert();


                        CalendarManagement.SetSource(rCompanyInformation, CustomCalendar);

                        while WorkDate <= EndOfYear do begin
                            CustomCalendar.Date := WorkDate;
                            if NOT ki2ta.IsWorkingDay(WorkDate, rCompanyInformation."Base Calendar Code") then begin
                                EvidencijaRada.Init();
                                EvidencijaRada."Entry No." := NextEntryNo;
                                EvidencijaRada."Employee No." := EmployeeNo;
                                EvidencijaRada."Employee Full Name" := EvidencijaRada."Employee Full Name";
                                EvidencijaRada.Date := WorkDate;
                                if DateForWeek.Get(DateForWeek."Period Type"::Date, WorkDate) then
                                    EvidencijaRada.WeekDay := DateForWeek."Period Name";
                                EvidencijaRada."Cause of Absence Code" := 'Prisutan';
                                EvidencijaRada."Start Time" := StartTime;
                                EvidencijaRada."Finish Time" := EndTime;
                                EvidencijaRada."Description" := '';
                                EvidencijaRada.CalculateDuration();
                                EvidencijaRada.Insert();

                                NextEntryNo := NextEntryNo + 1;
                            end;
                            WorkDate := WorkDate + 1;
                        end;
                    end;
                }

            }
        }
    }

    var
        myInt: Integer;
        EvidencijaRada: Codeunit Kalendarcic;

}