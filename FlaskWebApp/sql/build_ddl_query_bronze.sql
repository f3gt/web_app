/*
dataframe to store building element list raw data in the bronze layer
*/

CREATE TABLE bronze.b15 (
    sr_no INT ,
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

bulk insert  bronze.b15
from "C:\Users\Akshay Yadav\Desktop\pyworkspace\WebApp\FlaskWebApp\b15.csv"
with(
	firstrow = 2,
	fieldterminator = ',',
	tablock
)

select * from bronze.b15
