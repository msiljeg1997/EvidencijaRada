table 50126 "WorkTrackRecord"
{
    DataPerCompany = false;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Finish Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert();
    var
        LastRecord: Record "WorkTrackRecord";
    begin
        if LastRecord.FindLast() then
            "Entry No." := LastRecord."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}