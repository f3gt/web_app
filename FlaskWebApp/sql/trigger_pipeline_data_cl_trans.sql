/*
trigger to clean and store data from bronze layer(contains raw data)
to the silver layer for further use
*/

---- =================== creating trigger 
use prod_data
---- Inserting Data bro bronze layer to the silver layer carousal

CREATE TRIGGER silver_carousal_insert
ON bronze.carousal_fac
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.carousal_fac (
		sr_no,
        prd_date,
        element_type,
        element,
		quantity,
        volume,
        concrete_grade,
        Factory,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
		i.quantity,
        i.volume,
        i.concrete_grade,
        i.Factory,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.carousal_fac s
        WHERE s.sr_no = i.sr_no
    );
END;

go
--- 
CREATE TRIGGER silver_pod_insert
ON bronze.pod_fac
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.pod_fac (
		sr_no,
        prd_date,
        element_type,
        element,
		quantity,
        volume,
        concrete_grade,
        Factory,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
		i.quantity,
        i.volume,
        i.concrete_grade,
        i.Factory,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.pod_fac s
        WHERE s.sr_no = i.sr_no
    );
END;

go
---

CREATE TRIGGER silver_hcs_insert
ON bronze.hcs_fac
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.hcs_fac (
		sr_no,
        prd_date,
        element_type,
        element,
		quantity,
        volume,
        concrete_grade,
        Factory,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
		i.quantity,
        i.volume,
        i.concrete_grade,
        i.Factory,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.hcs_fac s
        WHERE s.sr_no = i.sr_no
    );
END;
 -----
 go
 CREATE TRIGGER silver_hcs_insert
ON bronze.hcs_fac
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.hcs_fac (
		sr_no,
        prd_date,
        element_type,
        element,
		quantity,
        volume,
        concrete_grade,
        Factory,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
		i.quantity,
        i.volume,
        i.concrete_grade,
        i.Factory,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.hcs_fac s
        WHERE s.sr_no = i.sr_no
    );
END;

-----
go

 CREATE TRIGGER silver_special_insert
ON bronze.special_fac
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.special_fac (
		sr_no,
        prd_date,
        element_type,
        element,
		quantity,
        volume,
        concrete_grade,
        Factory,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
		i.quantity,
        i.volume,
        i.concrete_grade,
        i.Factory,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.special_fac s
        WHERE s.sr_no = i.sr_no
    );
END;

----

go

 CREATE TRIGGER silver_log_recieve
ON bronze.log_recieve
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.log_recieve(
		sr_no,
        prd_date,
        element_type,
        element,
        quantity,
        recieve_date,
        Factory,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
        i.quantity,
        i.recieve_date,
        i.Factory,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.log_recieve s
        WHERE s.sr_no = i.sr_no
    );
END;

----------
go

 CREATE TRIGGER silver_log_issue
ON bronze.log_issue
AFTER INSERT
AS
BEGIN
    INSERT INTO silver.log_issue(
		sr_no,
        prd_date,
        element_type,
        element,
        quantity,
        recieve_date,
        issue_date,
        remarks,
        userid,
		transaction_id
    )
    SELECT 
		i.sr_no,
        i.prd_date,
        i.element_type,
        REPLACE(REPLACE(i.element, ' ', ''), '-', ' - '),
        i.quantity,
        i.recieve_date,
        i.issue_date,
        i.remarks,
        i.userid,
		i.transaction_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM silver.log_issue s
        WHERE s.sr_no = i.sr_no
    );
END;


select * from silver.log_issue
select * from bronze.pod_fac


------ Generating usnique id on each transaction  combing (factory , year month, srno on 3 digits
SELECT 
    *, 
    -- Padded sr_no for display
    RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3) AS padded_sr_no,

    -- Transaction ID: Factory code + Date (yyyymm) + padded sr_no
    LEFT(Factory, 2) + 
    FORMAT(data_in_date, 'yyyyMM') + 
    RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3) AS transaction_id

FROM bronze.carousal_fac;



select * from bronze.carousal_fac
select * from silver.carousal_fac


select * from bronze.pod_fac
select * from silver.pod_fac

select * from bronze.hcs_fac
select * from silver.hcs_fac

SELECT * FROM bronze.user_tab
