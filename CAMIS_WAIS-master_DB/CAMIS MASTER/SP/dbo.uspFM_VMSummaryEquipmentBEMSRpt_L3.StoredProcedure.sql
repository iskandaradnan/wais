USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMSummaryEquipmentBEMSRpt_L3]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name	: ASIS
Version				: 
File Name			: uspFM_VMSummaryEquipmentBEMSRpt_L3
Procedure Name		: uspFM_VMSummaryEquipmentBEMSRpt_L3
Author(s) Name(s)	: Hari Haran N
Date				: 14 Jun 2018
Purpose				: Report SP For approved list of buildings FEMS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        

EXEC [uspFM_VMSummaryEquipmentBEMSRpt_L3] '200','4610','2017'
EXEC [uspFM_VMSummaryEquipmentBEMSRpt_L3] 'national','1','monthly','02','2017','','',''
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
          

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    
    
CREATE PROCEDURE [dbo].[uspFM_VMSummaryEquipmentBEMSRpt_L3]
(
				
		@Facility_Id		VARCHAR(20),
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
	'' as AssetNo,
	'' as AssetDescription,
	'' as Manufacturer,
	'' as Model,
	'' as purchaseprojectcost,
	'' as VariationStatus,
	'' as StartServiceDate,
	'' as ExpiryDate,
	'' as ServiceStopDate,
	'' as BldBuiltUpArea,
	''  as ProposedRateDW,
	'' as ProposedRatePW,
	''  as MonhlyProposedFeeDW,
	'' as MonthlyProposedFeePW,
	'' as DoneRemarks,	
	''	as Prepared_name,
	''	 as Acknowledged_name	,
	'' as Verified_name	,	
	''	as Prepared_Designation	,
	'' as Verified_Designation,
'' as Acknowledged_Designation,
	'' as Prepared_date,
	'' as Acknowledged_date,
	'' as Verified_date,	
	'' as Effective_date	
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END
GO
