USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Summary_DAR_Header]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: [usp_FM_Summary_DAR_Header] 
Author(s) Name(s)	: Balaji M S
Date				: 31/05/2018
Purpose				: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC [usp_FM_Summary_DAR_Header]  '@pFacilityId','@pMonth','@pYear'  
EXEC [uspFM_Summary_DAR_Header]  '1',2,4,2018
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   
 			          
CREATE PROCEDURE  [dbo].[uspFM_Summary_DAR_Header]                            
( 
		@pFacilityId			INT,                                           
		@pFromMonth				INT,
		@pToMonth				INT,
		@pYear					INT

 )           
AS                                              
BEGIN                                
SET NOCOUNT ON  
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF                                  
  


select	 MonthId												AS 'MonthId',
		 FacilityName										    AS 'Hospital_Name',
		 Month AS 'Month',
		 @pYear													AS 'Year'

From	MstLocationFacility,FMTimeMonth	
WHERE FacilityId = @pFacilityId AND MonthId BETWEEN @pFromMonth AND @pToMonth

SET ANSI_WARNINGS ON 
SET ARITHABORT ON
SET NOCOUNT OFF  

END
GO
