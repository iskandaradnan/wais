USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMApprovedList_BEMS_L3]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
-- =============================================
-- Author		:Aravinda Raja 
-- Create date	:05-06-2018
-- Description	:Asset Details
-- =============================================
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
--EXEC [uspFM_VMApprovedList_BEMS_L3] 'national','','2017-01-01','2017-03-01',''
--EXEC [uspFM_VMApprovedList_BEMS_L3] '1','1','2017'
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
   
CREATE PROCEDURE [dbo].[uspFM_VMApprovedList_BEMS_L3]
(
					
		@FacilityId	VARCHAR(20),
		@Period			VARCHAR(20),
		@year			VARCHAR(20)
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                     
  
 SELECT 

	'' as FacilityId,		
	'' as VariationRaisedDate,
	'' as AssetId,
	'' as Department,
	'' as Equipment_Description,
	'' as Equipment_Code,
	'' as Asset_Number,	
	'' as purchaseprojectcost,
    '' as MonhlyProposedFeeDW,
	'' as MonthlyProposedFeePW,
	'' as DoneRemarks,	
	''	as Prepared_name,
	''	 as Verified_name	,
	'' as Acknowledged_name	,	
	'' as Prepared_Designation	,
	''	as Verified_Designation,
	'' as Acknowledged_Designation,
	'' as Prepared_date,
	'' as Verified_date,
	'' as Acknowledged_date,	
	'' as Effective_date

   
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
GO
