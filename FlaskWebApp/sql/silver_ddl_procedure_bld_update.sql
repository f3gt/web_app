
CREATE TABLE silver.b15 (
    sr_no int ,
    building NVARCHAR(100),
    element_type NVARCHAR(100),
    element_id NVARCHAR(100),
    type NVARCHAR(50),
    F1 INT,
    F2 INT,
    F3 INT,
    F4 INT,
    F5 INT,
    F6 INT,
    F7 INT,
    F8 INT,
    F9 INT,
    F10 INT,
    F11 INT,
    F12 INT,
    F13 INT,
    F14 INT,
    F15 INT,
    F16 INT,
    F17 INT,
    F18 INT,
    F19 INT,
    F20 INT,
    F21 INT,
    F22 INT,
    F23 INT,
    terrace INT,
    per_building_total INT,

);










	SELECT element_id FROM silver.b15
	WHERE element_id like 'HCS%'

	select * from silver.b15
	WHERE element_id = 'HCS - 101M'

	select * from silver.hcs_fac
	SELECT * FROM silver.carousal_fac
	WHERE element = 'NLW - 102'

	select element_id,SUM(per_building_total) from silver.b15
	where element_id = 'NLW - 102'
	GROUP BY element_id





