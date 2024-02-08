codeunit 50137 kitara
{


    var
        myInt: Integer;



    procedure IsWorkingDay(WorkDate: Date; BaseCalendarCode: Code[10]): Boolean;
    var
        BaseCalendar: Record "Base Calendar";
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        if not BaseCalendar.Get(BaseCalendarCode) then
            Error('kurac na m2', BaseCalendarCode);

        BaseCalendarChange.SetRange("Base Calendar Code", BaseCalendarCode);
        BaseCalendarChange.SetRange(Date, WorkDate);

        if BaseCalendarChange.FindFirst() then begin
            if BaseCalendarChange."Nonworking" then
                exit(false)
            else
                exit(true);
        end else
            exit(true);
    end;




    procedure NameThisDate(WorkDate: Date): Text;
    var
        DateForWeek: Record Date;
        WeekDay: Text;
    begin
        if DateForWeek.Get(DateForWeek."Period Type"::Date, WorkDate) then
            WeekDay := DateForWeek."Period Name";

        exit(WeekDay);
    end;

    procedure IsWorkingDayMoja(WorkDate: Date; BaseCalendarCode: Code[10]): Boolean;
    var
        BaseCalendar: Record "Base Calendar";
        BaseCalendarChange: Record "Base Calendar Change";
        DayName: Text;
    begin
        if not BaseCalendar.Get(BaseCalendarCode) then
            Error('kurac na m2', BaseCalendarCode);
        DayName := NameThisDate(WorkDate);
        BaseCalendarChange.SetRange("Base Calendar Code", BaseCalendarCode);

        If BaseCalendarChange.Find('-') then
            repeat
                // KORAK JEDAN, PROVJERI JE LI PONAVLJANJE GODISNJE ILI TJEDNO
                // AKO JE TJEDNO, PROVJERI KOJI JE NAZIV DANA UPISAN
                // AKO JE GODISNJE, PROVJERI JE LI DATUM U RASPOREDU
                // AKO JE OZNACEN SA NONWORKING, NERADNI JE DAN, INACE JE RADNI

                // UVJEK RADIM FIND REPEAT UNTILL AKO DOHVAĆAM VIŠE REDAKA IZ TABLICE!!!
                // SETRANGE JE FILTER DA NE IDE SVE PO REDU, NE TREBA MI UVIJEK SVE IZ TABLICE!!!
                // FINDFIRST JE ZA JEDAN REDAK, FIND JE ZA VIŠE REDAKA
                // FIND REPEAT UNTILL JE ZA VIŠE REDAKA, FINDFIRST JE ZA JEDAN REDAK
                // IZVRTI MOGUCNOSTI NAUCI SETRAANGE, FIND, FINDFIRST, FIND REPEAT UNTILL I NEXT I PREVIOUS I NECE BIT PROBLEMA...MOZES ISPISAT SA MESSAGE.

                if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Annual Recurring" then begin
                    if BaseCalendarChange."Date" = WorkDate then begin
                        if BaseCalendarChange."Nonworking" then
                            exit(false)
                        else
                            exit(true);
                    end;
                end else begin
                    if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Weekly Recurring" then begin
                        if Format(BaseCalendarChange.Day) = DayName then begin
                            if BaseCalendarChange."Nonworking" then
                                exit(false)
                            else
                                exit(true);
                        end;
                    end;
                end;

                if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::" " then begin
                    if BaseCalendarChange.Date = WorkDate then begin
                        if BaseCalendarChange."Nonworking" then
                            exit(false)
                        else
                            exit(true);
                    end;
                end;

            until BaseCalendarChange.Next() = 0;


        if BaseCalendarChange.FindFirst() then begin
            if BaseCalendarChange."Nonworking" then
                exit(false)
            else
                exit(true);
        end else
            exit(true);
    end;
}