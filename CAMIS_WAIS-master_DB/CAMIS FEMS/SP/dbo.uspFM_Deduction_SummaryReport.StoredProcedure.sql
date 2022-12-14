USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Deduction_SummaryReport]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: [usp_FM_Deduction_Summary] 
Author(s) Name(s)	: Balaji M S
Date				: 31/06/2018
Purpose				: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC [uspFM_Deduction_Summary]  '@pFacilityId','@pMonth','@pYear'
EXEC [uspFM_Deduction_SummaryReport] '1',2,5,2018

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/  
CREATE PROCEDURE [dbo].[uspFM_Deduction_SummaryReport]
(                                                
	@pFacilityId						int,                                    
	@pFrommonth							INT,
	@pTomonth							INT,
	@pYear								INT


)             
AS                                                
BEGIN    

select 2 as MonthId,'February' as	MonthValue,2018 as	Year,2 as	FacilityId,'Pantai Hospital Ipoh' as	FacilityName,1.00 as	MSFValue,
0 as	CFValue,0 as	DeductionValue, 1 as	TOTAL


                              
SET NOCOUNT ON



SET NOCOUNT OFF  
END
GO
