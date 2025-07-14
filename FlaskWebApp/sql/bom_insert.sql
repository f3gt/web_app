-----Inserting Bom data in to the bronze.precast_bom table

use prod_data

bulk insert  bronze.precast_bom
from 'Y:\DASHBOARD REPORTS\Source File\Corrected rc\TRUE BOM 2-1-24 alt.csv'
with(
	fieldterminator = ',',
	firstrow = 4,
	keepnulls,
		tablock


)