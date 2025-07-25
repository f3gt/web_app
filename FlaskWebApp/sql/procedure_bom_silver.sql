/*
creating procedure to insert bom data from bronze layer to silver layer

no data should get duplicate
*/

TRUNCATE table silver.precast_bom

create procedure bom_in as 
begin
insert into silver.precast_bom(
			E_identity ,
    TO_CHECK_LATEST_DATE ,
    Sr_no ,
    FACTORY ,
    ELEMENT_FG_Item_Code_EFG ,
    Element_ID ,
    date ,
    Remark ,
    OLD_BOM_code_S0016 ,
    ELEMENT_BOM_CODE_EBC ,
    Site ,
    FABRICATION_MOULD_DETAIL_DWG ,
    REINFORCEMENT ,
    MEP ,
    STEEL_MESH_BOM_CODE_SBC ,
    STEEL_MESH_FG_Code_SFG ,
    STEEL_MESH_Element_ID ,
    Light_Weight_Concrete_M20_CUM ,
    M25_CUM ,
    M40_SCC_CUM ,
    M60_HCS_CUM ,
    M55_TB_CUM ,
    M60_POD_CUM ,
    M65_DB_CUM ,
    TMT_6mm_FE500_MT ,
    TMT_8mm_FE500D_MT ,
    TMT_10mm_FE500D_MT ,
    TMT_12mm_FE500D_MT ,
    TMT_16mm_FE500D_MT ,
    TMT_20mm_FE500D_MT ,
    TMT_25mm_FE500D_MT ,
    TMT_32mm_FE500D_MT ,
    Spherical_Head_Lifters_2_5MT_NOS ,
    Two_Hole_Lifter_2_5MT_NOS ,
    Two_Hole_Lifter_5MT_NOS ,
    Groutec_Coupler_16mm ,
    Groutec_Coupler_20mm ,
    Groutec_Coupler_25mm ,
    Groutec_Coupler_32mm ,
    Mech_Coupler_12mm ,
    Mech_Coupler_16mm ,
    Mech_Coupler_20mm ,
    Mech_Coupler_25mm ,
    Mech_Coupler_32mm ,
    PVC_Pipe_20dia_LMS_M ,
    PVC_Pipe_25dia_LMS_M ,
    Wire_loop_Element ,
    Dowel_Tube_25dia_M ,
    Dowel_Tube_30dia_M ,
    Dowel_Tube_40dia_M ,
    Dowel_Tube_50dia_M ,
    Dowel_Tube_60dia_M ,
    Dowel_Tube_80dia_M ,
    HMS_PVC_20mm_Conduit_M1 ,
    HMS_PVC_20mm_Conduit_M2 ,
    HMS_PVC_20mm_Conduit_M3 ,
    HMS_PVC_20mm_Conduit_M4 ,
    HMS_PVC_20mm_Conduit_M5 ,
    HMS_PVC_20mm_Conduit_M6 ,
    HMS_PVC_20mm_Conduit_M7 ,
    HMS_PVC_20mm_Conduit_M8 ,
    HMS_PVC_20mm_Conduit_M9 ,
    HMS_PVC_20mm_Conduit_M10 ,
    HMS_PVC_20mm_Conduit_M11 ,
    HMS_PVC_20mm_Conduit_M12 ,
    HMS_PVC_20mm_Conduit_M13 ,
    HMS_PVC_20mm_Conduit_M14 ,
    HMS_PVC_20mm_Conduit_M15 ,
    HMS_PVC_25mm_Conduit_M ,
    HMS_PVC_32mm_Conduit_M ,
    GI_Modular_Back_Box_2M ,
    GI_Modular_Back_Box_3M ,
    GI_Modular_Back_Box_4M ,
    GI_Modular_Back_Box_6M ,
    GI_Modular_Back_Box_8M ,
    Fan_Box_140mm_dia ,
    Shallow_JB_1Way ,
    DEEP_JB_1Way ,
    Shallow_JB_2Way ,
    Shallow_JB_3Way ,
    DEEP_JB_3Way ,
    PVC_Bend_20dia ,
    PVC_Bend_25dia ,
    PVC_Bend_32dia ,
    PVC_Coupling_20mm ,
    STRAND_9_6_0_430KG_M_MT ,
    STRAND_12_9_0_790KG_M_MT )
select * from bronze.precast_bom b
where not exists (select 1 from silver.precast_bom s
			where b.Element_ID = s.Element_ID and b.date = s.date)
end
		select * from silver.precast_bom
		exec bom_in
