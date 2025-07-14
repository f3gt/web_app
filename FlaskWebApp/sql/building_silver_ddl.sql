create table building_element(elment_id nvarchar(50),req int)
insert building_element (elment_id,req) values('NLW - 101',100) 



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

create procedure  b15_update as
begin
	truncate table silver.b15
	insert into silver.b15
	(    sr_no ,
    building ,
    element_type ,
    element_id ,
    type ,
    F1 ,
    F2 ,
    F3 ,
    F4 ,
    F5 ,
    F6 ,
    F7 ,
    F8 ,
    F9 ,
    F10 ,
    F11 ,
    F12 ,
    F13 ,
    F14 ,
    F15 ,
    F16 ,
    F17 ,
    F18 ,
    F19 ,
    F20 ,
    F21 ,
    F22 ,
    F23 ,
    terrace ,
    per_building_total )

	select 
	sr_no ,
    building ,
    element_type ,
    replace(replace(element_id,' ',''),'-',' - ') ,
    type ,
    F1 ,
    F2 ,
    F3 ,
    F4 ,
    F5 ,
    F6 ,
    F7 ,
    F8 ,
    F9 ,
    F10 ,
    F11 ,
    F12 ,
    F13 ,
    F14 ,
    F15 ,
    F16 ,
    F17 ,
    F18 ,
    F19 ,
    F20 ,
    F21 ,
    F22 ,
    F23 ,
    terrace ,
    per_building_total from bronze.b15
end

select * from silver.b15
select * from bronze.b15
exec b15_update


SELECT element_id,per_building_total,casted,COALESCE(sum(pending),0) pending FROM (
		SELECT 
			b.element_id,
			SUM(b.per_building_total) AS per_building_total,
			COALESCE(s.casted, 0) AS casted,
			CASE 
				WHEN SUM(b.per_building_total) = 0 OR SUM(b.per_building_total) IS NULL THEN 0
				ELSE SUM(b.per_building_total) - COALESCE(s.casted, 0)
			END AS pending
		FROM silver.b15 b
		LEFT JOIN (
			-- total casted quantity per element
			SELECT 
				element, 
				COALESCE(SUM(quantity), 0) AS casted
			FROM (
				SELECT * FROM silver.carousal_fac
				UNION ALL
				SELECT * FROM silver.hcs_fac
				UNION ALL
				SELECT * FROM silver.special_fac
				UNION ALL
				SELECT * FROM silver.pod_fac
			) AS tot_casted
			GROUP BY element
		) s ON b.element_id = s.element
				GROUP BY b.element_id,s.casted

	) gr
	group by element_id,per_building_total,casted
	having element_id = 'NLW - 102'





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





