
use prod_data
IF OBJECT_ID('bronze.user_tab','U') is not null
	drop table bronze.user_tab

create table bronze.user_tab (
	sr_no int  identity(1,1),
	userid nvarchar(20) primary key,
	first_name nvarchar(50),
	last_name nvarchar(50),
	element nvarchar(50),
	user_pass nvarchar(50),
	Factory nvarchar(50) ,
	data_in_date dateTIME default getdate()

	)

IF OBJECT_ID('bronze.pod_fac','U') is not null
	drop table bronze.pod_fac

create table bronze.pod_fac (
	sr_no int  identity(1,1) primary key ,
	prd_date date,
	element_type nvarchar(50),
	element nvarchar(50),
	quantity int,
	volume float,
	concrete_grade nvarchar(50),
	Factory nvarchar(50) default 'POD',
	remarks nvarchar(100),
	data_in_date dateTIME default getdate(),
	userid nvarchar(20) foreign key references bronze.user_tab(userid),
	transaction_id as 
	LEFT(Factory, 2) + 
    FORMAT(data_in_date, 'yyyyMM') + 
    RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3) 
	)

IF OBJECT_ID('bronze.hcs_fac','U') is not null
	drop table bronze.hcs_fac

	create table bronze.hcs_fac (
		sr_no int  identity(1,1) primary key ,
		prd_date date,
		element_type nvarchar(50),
		element nvarchar(50),
		quantity int,
		volume float,
		concrete_grade nvarchar(50),
		Factory nvarchar(50) default 'HCS',
		remarks nvarchar(100),
		data_in_date dateTIME default getdate(),
		userid nvarchar(20) foreign key references bronze.user_tab(userid),
		transaction_id as 
		LEFT(Factory, 2) + 
		FORMAT(data_in_date, 'yyyyMM') + 
		RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3)
		)

IF OBJECT_ID('bronze.special_fac','U') is not null
	drop table bronze.special_fac

	create table bronze.special_fac (
		sr_no int  identity(1,1) primary key ,
		prd_date date,
		element_type nvarchar(50),
		element nvarchar(50),
		quantity int,
		volume float,
		concrete_grade nvarchar(50),
		Factory nvarchar(50) default 'SPECIAL MOULD',
		remarks nvarchar(100),
		data_in_date dateTIME default getdate(),
		userid nvarchar(20) foreign key references bronze.user_tab(userid),
		transaction_id as 
		LEFT(Factory, 2) + 
		FORMAT(data_in_date, 'yyyyMM') + 
		RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3)
		)

IF OBJECT_ID('bronze.carousal_fac','U') is not null
	drop table bronze.carousal_fac

	create table bronze.carousal_fac (
		sr_no int  identity(1,1) primary key ,
		prd_date date,
		element_type nvarchar(50),
		element nvarchar(50),
		quantity int,
		volume float,
		concrete_grade nvarchar(50),
		Factory nvarchar(50) default 'CAROUSAL',
		remarks nvarchar(100),
		data_in_date dateTIME default getdate(),
		userid nvarchar(20) foreign key references bronze.user_tab(userid),
		transaction_id as 
		LEFT(Factory, 2) + 
		FORMAT(data_in_date, 'yyyyMM') + 
		RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3)
		)


IF OBJECT_ID('bronze.log_recieve','U') is not null
	drop table bronze.log_recieve

	create table bronze.log_recieve (
		sr_no int  identity(1,1) primary key ,
		prd_date date,
		element_type nvarchar(50),
		element nvarchar(50),
		quantity int,
		volume float,
		concrete_grade nvarchar(50),
		recieve_date datetime,
		Factory nvarchar(50) default 'CAROUSAL',
		remarks nvarchar(100),
		data_in_date dateTIME default getdate(),
		userid nvarchar(20) foreign key references bronze.user_tab(userid),
		transaction_id as 
		LEFT(Factory, 2) + 
		FORMAT(data_in_date, 'yyyyMM') + 
		RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3)
		)

IF OBJECT_ID('bronze.log_issue','U') is not null
	drop table bronze.log_issue

	create table bronze.log_issue (
		sr_no int  identity(1,1) primary key ,
		prd_date date,
		element_type nvarchar(50),
		element nvarchar(50),
		quantity int,
		recieve_date datetime,
		issue_date datetime,
		Factory nvarchar(50) default 'CAROUSAL',
		remarks nvarchar(100),
		data_in_date dateTIME default getdate(),
		userid nvarchar(20) foreign key references bronze.user_tab(userid),
		transaction_id as 
		LEFT(Factory, 2) + 
		FORMAT(data_in_date, 'yyyyMM') + 
		RIGHT('000' + CAST(sr_no AS VARCHAR(3)), 3)
		)
select * from bronze.log_issue



select * from bronze.user_tab
use prod_data

INSERT INTO bronze.user_tab(
				userid,first_name,last_name,user_pass,Factory) VALUES(12347,'ASHISH','Yadav',12347,'CAROUSAL')

				SELECT * FROM bronze.user_tab

				SELECT * FROM bronze.user_tab
				select * from bronze.carousal_fac
				select * from bronze.pod_fac
				select * from bronze.special_fac

				select * from bronze.log_recieve

---- 
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


----- Creating table for Bom data store

use prod_data



IF OBJECT_ID('bronze.precast_bom','U') is not null
	drop table bronze.precast_bom

CREATE TABLE bronze.precast_bom (
	E_identity nvarchar(50),
    TO_CHECK_LATEST_DATE nvarchar(50),
    Sr_no nvarchar(50),
    FACTORY NVARCHAR(100),
    ELEMENT_FG_Item_Code_EFG NVARCHAR(100),
    Element_ID NVARCHAR(100),
    date DATE,
    Remark NVARCHAR(255),
    OLD_BOM_code_S0016 NVARCHAR(100),
    ELEMENT_BOM_CODE_EBC NVARCHAR(100),
    Site NVARCHAR(100),
    FABRICATION_MOULD_DETAIL_DWG NVARCHAR(255),
    REINFORCEMENT NVARCHAR(100),
    MEP NVARCHAR(100),
    STEEL_MESH_BOM_CODE_SBC NVARCHAR(100),
    STEEL_MESH_FG_Code_SFG NVARCHAR(100),
    STEEL_MESH_Element_ID NVARCHAR(100),
    Light_Weight_Concrete_M20_CUM FLOAT,
    M25_CUM FLOAT,
    M40_SCC_CUM FLOAT,
    M60_HCS_CUM FLOAT,
    M55_TB_CUM FLOAT,
    M60_POD_CUM FLOAT,
    M65_DB_CUM FLOAT,
    TMT_6mm_FE500_MT FLOAT,
    TMT_8mm_FE500D_MT FLOAT,
    TMT_10mm_FE500D_MT FLOAT,
    TMT_12mm_FE500D_MT FLOAT,
    TMT_16mm_FE500D_MT FLOAT,
    TMT_20mm_FE500D_MT FLOAT,
    TMT_25mm_FE500D_MT FLOAT,
    TMT_32mm_FE500D_MT FLOAT,
    Spherical_Head_Lifters_2_5MT_NOS INT,
    Two_Hole_Lifter_2_5MT_NOS INT,
    Two_Hole_Lifter_5MT_NOS INT,
    Groutec_Coupler_16mm INT,
    Groutec_Coupler_20mm INT,
    Groutec_Coupler_25mm INT,
    Groutec_Coupler_32mm INT,
    Mech_Coupler_12mm INT,
    Mech_Coupler_16mm INT,
    Mech_Coupler_20mm INT,
    Mech_Coupler_25mm INT,
    Mech_Coupler_32mm INT,
    PVC_Pipe_20dia_LMS_M FLOAT,
    PVC_Pipe_25dia_LMS_M FLOAT,
    Wire_loop_Element NVARCHAR(100),
    Dowel_Tube_25dia_M FLOAT,
    Dowel_Tube_30dia_M FLOAT,
    Dowel_Tube_40dia_M FLOAT,
    Dowel_Tube_50dia_M FLOAT,
    Dowel_Tube_60dia_M FLOAT,
    Dowel_Tube_80dia_M FLOAT,
    HMS_PVC_20mm_Conduit_M1 FLOAT,
    HMS_PVC_20mm_Conduit_M2 FLOAT,
    HMS_PVC_20mm_Conduit_M3 FLOAT,
    HMS_PVC_20mm_Conduit_M4 FLOAT,
    HMS_PVC_20mm_Conduit_M5 FLOAT,
    HMS_PVC_20mm_Conduit_M6 FLOAT,
    HMS_PVC_20mm_Conduit_M7 FLOAT,
    HMS_PVC_20mm_Conduit_M8 FLOAT,
    HMS_PVC_20mm_Conduit_M9 FLOAT,
    HMS_PVC_20mm_Conduit_M10 FLOAT,
    HMS_PVC_20mm_Conduit_M11 FLOAT,
    HMS_PVC_20mm_Conduit_M12 FLOAT,
    HMS_PVC_20mm_Conduit_M13 FLOAT,
    HMS_PVC_20mm_Conduit_M14 FLOAT,
    HMS_PVC_20mm_Conduit_M15 FLOAT,
    HMS_PVC_25mm_Conduit_M FLOAT,
    HMS_PVC_32mm_Conduit_M FLOAT,
    GI_Modular_Back_Box_2M INT,
    GI_Modular_Back_Box_3M INT,
    GI_Modular_Back_Box_4M INT,
    GI_Modular_Back_Box_6M INT,
    GI_Modular_Back_Box_8M INT,
    Fan_Box_140mm_dia INT,
    Shallow_JB_1Way INT,
    DEEP_JB_1Way INT,
    Shallow_JB_2Way INT,
    Shallow_JB_3Way INT,
    DEEP_JB_3Way INT,
    PVC_Bend_20dia INT,
    PVC_Bend_25dia INT,
    PVC_Bend_32dia INT,
    PVC_Coupling_20mm INT,
    STRAND_9_6_0_430KG_M_MT FLOAT,
    STRAND_12_9_0_790KG_M_MT FLOAT
);
select * from bronze.precast_bom