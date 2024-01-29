table 50145 "Employee Absence Duration"
{
    fields
    {
        field(10; "Employee Absence Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "DurationCalc"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Employee Absence Code")
        {
            Clustered = true;
        }
    }
}