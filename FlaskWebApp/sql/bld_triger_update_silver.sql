/*
procedure to update build quantity list
*/

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
