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
    //  dodajem varijable da mogu koristiti te tablice
    var
        //  prvo uzimam tablicu Base Calendar - to je tablica koja sadrži sve kalendare koji su definiranu u sustavu
        BaseCalendar: Record "Base Calendar";
        //  onda uzimam tablicu Base Calendar Change - to je tablica koja sadrži sve promjene koje su definirane u kalendru
        BaseCalendarChange: Record "Base Calendar Change";
        //  onda iniciram varijablu DayName koja će mi sadržavati naziv dana (a napravio sam metodu NameThisDate koja će mi vratiti naziv dana)
        DayName: Text;
    begin
        //  ako ne postoji taj kalendar, onda ispiši grešku
        if not BaseCalendar.Get(BaseCalendarCode) then
            Error('taj kalendar ne postoji', BaseCalendarCode); // OVDJE PUKNE...
        //  ovo je metoda koja će mi vratiti naziv dana iz datuma koji šaljem kao parametar (kasnije ce mi trebati za provjeru tjednog ponavljanja)
        DayName := NameThisDate(WorkDate);
        //  setRange postavlja filter na varijablu tablice "Base Calendar Change". Ukljuciti ce samo one zapise gdje je polje
        //  "Base Calendar Code" (polje iz Base Calendar Change tablice) == "BaseCalendarCode" (parametar)
        BaseCalendarChange.SetRange("Base Calendar Code", BaseCalendarCode);
        //  sada radim find metodu koja će mi vratiti prvi zapis koji zadovoljava uvjet iz setRange metode
        If BaseCalendarChange.Find('-') then
            //  i to sad ponavljam za svaki odgovarajuci zapis i izvrsujem svu logiku ispod napisanu dok ne dođem do kraja tablice za svaki zapis
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


                // ako je ponavljanje godisnje onda kreni
                if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Annual Recurring" then begin
                    // ako je datum iz tablice BaseCalendarChange jednak datumu koji sam poslao kao parametar onda kreni
                    if BaseCalendarChange."Date" = WorkDate then begin
                        // ako je oznacen sa nonworking onda je neradni dan
                        if BaseCalendarChange."Nonworking" then
                            exit(false)
                        else
                            // ako nije oznacen sa nonworking onda je radni dan
                            exit(true);
                    end;
                    //druga provjera
                end else begin
                    //ako je ponavljanje tjedno onda kreni
                    if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::"Weekly Recurring" then begin
                        //ako je naziv dana iz tablice BaseCalendarChange jednak nazivu dana koji sam dobio iz metode NameThisDate onda kreni
                        if Format(BaseCalendarChange.Day) = DayName then begin
                            //ako je oznacen sa nonworking onda je neradni dan
                            if BaseCalendarChange."Nonworking" then
                                exit(false)
                            else
                                // ako nije oznacen sa nonworking onda je radni dan
                                exit(true);
                        end;
                    end;
                end;
                //ako nista od ovoga nije zadovoljeno onda kreni na sljedecu provjeru
                if BaseCalendarChange."Recurring System" = BaseCalendarChange."Recurring System"::" " then begin
                    //ako je base calendar change date jednak datumu koji sam poslao kao parametar onda kreni
                    if BaseCalendarChange.Date = WorkDate then begin
                        // ako je oznacen sa nonworking onda je neradni dan
                        if BaseCalendarChange."Nonworking" then
                            exit(false)
                        else
                            // ako nije oznacen sa nonworking onda je radni dan
                            exit(true);
                    end;
                end;
            // ponavljaj dok ne dodjes do kraja tablice
            until BaseCalendarChange.Next() = 0;
        // ako nades nista onda su svi radni dani
        if BaseCalendarChange.FindFirst() then begin
            if BaseCalendarChange."Nonworking" then
                exit(false)
            else
                exit(true);
        end else
            exit(true);
    end;


    procedure GenerateYearlyCalendarForEmployee(EmployeeCode: Code[20]): List of [Date];
    var
        Employee: Record "Employee Absence";
        BaseCalendarCode: Code[10];
        WorkDate: Date;
        WorkingDays: List of [Date];
        CurrentYear: Integer;
    begin
        // hardkode 2024 za testiranje
        CurrentYear := 2024;

        // povezi radnika sa kalendarom
        if Employee.FindFirst() and (Employee."Base Calendar Code" = EmployeeCode) then
            BaseCalendarCode := Employee."Base Calendar Code";

        // za svaki dan u godini
        WorkDate := DMY2DATE(1, 1, CurrentYear); // 1.1.2024
        // dok je god WorkDate manji od 31.12.2024 kreni
        while WorkDate <= DMY2DATE(31, 12, CurrentYear) do begin // 31.12.2024
                                                                 // provjera za jel radni il neradni
            if IsWorkingDayMoja(WorkDate, BaseCalendarCode) then
                // ak je radni onda ga dodaj u listu
                WorkingDays.Add(WorkDate);
            WorkDate := WorkDate + 1;
        end;

        exit(WorkingDays);
    end;
}