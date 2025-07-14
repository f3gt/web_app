/*
working in the flask 
query specific for webapp balance retrieval
check the balance element scope v/s casted
*/

----building pending check

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
