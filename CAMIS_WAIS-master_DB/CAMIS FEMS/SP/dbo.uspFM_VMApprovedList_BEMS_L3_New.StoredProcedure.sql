USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMApprovedList_BEMS_L3_New]    Script Date: 20-09-2021 16:56:54 ******/
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
--EXEC [uspFM_VMApprovedList_BEMS_L3_New] 'national','','2017-01-01','2017-03-01',''
--EXEC [uspFM_VMApprovedList_BEMS_L3_New] '1','1','2017'
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
   
CREATE PROCEDURE [dbo].[uspFM_VMApprovedList_BEMS_L3_New]
(
			
		@Hospital_Id	VARCHAR(20),
		@Period			VARCHAR(20),
		@year			VARCHAR(20)
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                     
  
 declare 
 @Prepared_name			varchar(100),
 @Verified_name			varchar(100),
 @Acknowledged_name		varchar(100),
 @Prepared_Designation	varchar(100),
 @Verified_Designation	varchar(100),
 @Acknowledged_Designation varchar(100),
 @Prepared_date			DATETIME,
 @Verified_date			DATETIME,
 @Acknowledged_date		DATETIME
  
 CREATE TABLE #Temp
(
 Row_Id INT IDENTITY(1,1),
 HospitalId VARCHAR(MAX),
 Periodid   int,
 Period		Varchar(Max),
 Building_count INT
)
create table #tempVM (VariationDetailsId int)
insert into #tempVM (VariationDetailsId)
select VariationId
FROM	EngAsset EARM	 WITH(NOLOCK) 
JOIN 	VmVariationTxn VDT	 WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId 
WHERE VDT.FacilityId	=	@Hospital_Id
AND EARM.AssetClassification=4807   /* FEMS - Building */
AND EARM.Active = 1 
AND year (VDT.VariationRaisedDate) = @year 
AND VDT.period = @Period	
AND VDT.VariationWFStatus = 5583   /* Approved */
	

SELECT 

	EARM.FacilityId,		
	ISNULL(FORMAT(VariationRaisedDate,'dd-MMM-yyyy'),'') as VariationRaisedDate,
	EARM.AssetId,
	GD.BlockName as Department,
	EARM.AssetDescription as Equipment_Description,
	EARM.AssetNo as Equipment_Code,
	EARM.AssetPreRegistrationNo as Asset_Number,	
	VDT.purchaseprojectcost,
    VDT.MonthlyProposedFeeDW  as MonhlyProposedFeeDW,
	VDT.MonthlyProposedFeePW as MonthlyProposedFeePW,
	DoneRemarks,	
	dbo.Fn_DisplayUserNamebyStaffId_BI ( @Prepared_name	)	as Prepared_name,
	dbo.Fn_DisplayUserNamebyStaffId_BI (@Verified_name	)	 as Verified_name	,
	dbo.Fn_DisplayUserNamebyStaffId_BI (@Acknowledged_name	) as Acknowledged_name	,	
	dbo.Fn_DisplayUserDesignation( @Prepared_Designation)	as Prepared_Designation	,
	dbo.Fn_DisplayUserDesignation( @Verified_Designation)	as Verified_Designation,
	dbo.Fn_DisplayUserDesignation( @Acknowledged_Designation )as Acknowledged_Designation,
	ISNULL(FORMAT(@Prepared_date,'dd-MMM-yyyy'),'') as Prepared_date,
	ISNULL(FORMAT(@Verified_date,'dd-MMM-yyyy'),'') as Verified_date,
	ISNULL(FORMAT(@Acknowledged_date,'dd-MMM-yyyy'),'') as Acknowledged_date,	
	ISNULL(FORMAT(VDT.PaymentStartDate,'dd-MMM-yyyy'),'') as Effective_date
FROM	EngAsset EARM	 WITH(NOLOCK) 
left join   MstLocationUserLocation EULM on EULM.UserLocationId=EARM.UserLocationId 
JOIN 	VmVariationTxn VDT	 WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId 
Join	#tempVM t			 WITH(NOLOCK) ON t.VariationDetailsId = VDT.VariationId
left join MstLocationUserArea  EUA ON EULM.UserAreaId = EUA.UserAreaId
left join MstLocationUserArea  FUA ON EUA.UserAreaId = FUA.UserAreaId
left join MstLocationBlock  GD on GD.BlockId=FUA.BlockId


   
END TRY
BEGIN CATCH
throw
insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
GO
