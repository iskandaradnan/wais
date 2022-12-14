USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMApprovedList_BEMS]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author		:Aravinda Raja 
-- Create date	:05-06-2015
-- Description	:Asset Details
-- =============================================
--EXEC [uspFM_VMApprovedList_BEMS] '','hospital','','2017-01-01','2017-03-01'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
CREATE PROCEDURE [dbo].[uspFM_VMApprovedList_BEMS]
(
		@MenuName       VARCHAR(500),
		@Level			VARCHAR(20),
		@Option			VARCHAR(20),
		@From_Date      VARCHAR(20),        
		@To_Date        VARCHAR(20)
		
 )               
AS                                                  
BEGIN                                    
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY                                   
CREATE  table #Hospital_Master (HospitalId varchar(25))       
 --IF (@Level='consortia')             
 --BEGIN            
	--insert into  #Hospital_Master(HospitalId)              
	--Select  FacilityId FROM MstLocationFacility Where ConsortiaId=@Option and IsDeleted=0 group by HospitalId           
 --END      
      
 IF (@Level='hospital')             
 BEGIN         
   insert into  #Hospital_Master(HospitalId)  values (@Option)   
 END     
 



 CREATE TABLE #Temp
(
 Row_Id INT IDENTITY(1,1),
 HospitalId VARCHAR(MAX),
 Building_count INT,
 MonhlyProposedFeeDW  numeric (20,2),
 MonthlyProposedFeePW numeric (20,2)
)
INSERT INTO #Temp(HospitalId,Building_count,MonhlyProposedFeeDW,MonthlyProposedFeePW)
SELECT 
	VDT.FacilityId HospitalId,
	COUNT(1) ,
	sum(VDT.MonthlyProposedFeeDW)  as MonhlyProposedFeeDW,
	sum(VDT.MonthlyProposedFeePW) as MonthlyProposedFeePW
FROM EngAsset EARM WITH(NOLOCK) 
JOIN VmVariationTxn VDT WITH(NOLOCK) ON EARM.AssetId = VDT.AssetId 
WHERE exists (select 1 from #Hospital_Master h where h.HospitalId=VDT.FacilityId)
AND EARM.Active = 1
AND convert(date,VDT.VariationRaisedDate) BETWEEN convert(date,@FROM_DATE) AND convert(date,@TO_DATE)
AND   VariationWFStatus = 5583   --Approved by state Level.
GROUP BY  VDT.FacilityId



declare @tcount int
select @tcount=count(*) from #Temp
Select 
		@MenuName as 'MenuName',
		cc.CustomerName as 'Company_Name',
		v.FacilityName AS 'Hospital_Name',
		v.FacilityId HospitalId ,
		Building_count,
		MonhlyProposedFeeDW,
		MonthlyProposedFeePW,		
		@tcount as 'Total_Records'  
FROM #Temp A 
join MstLocationFacility V on V.FacilityId=A.HospitalId
join MstCustomer cc on v.CustomerId=cc.CustomerId
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END
GO
