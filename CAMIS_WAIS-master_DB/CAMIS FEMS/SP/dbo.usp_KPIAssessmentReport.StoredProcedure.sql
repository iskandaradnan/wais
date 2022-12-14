USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_KPIAssessmentReport]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================          
Application Name : UETrack-BEMS                        
Version    : 1.0          
Procedure Name  : [usp_KPIAssessmentReport]          
Description   : Asset number fetch control          
Authors    : Krishna S      
Date    : 07-Jan-2019          
-----------------------------------------------------------------------------------------------------------          
          
Unit Test:    
EXEC [usp_KPIAssessmentReport] @pYear=2018,@pMonth=8, @pServiceId=2,@pFacilityId=1    
EXEC [usp_KPIAssessmentReport] @pYear=2018,@pMonth=11, @pServiceId=2,@pFacilityId=1    
-----------------------------------------------------------------------------------------------------------          
Version History           
-----:------------:---------------------------------------------------------------------------------------          
Init : Date       : Details          
========================================================================================================          
------------------:------------:-------------------------------------------------------------------          
Raguraman J    : 07/09/2016 : B1 - Responsetime emergency:15 mins / normal:120 mins          
         B2 - Working days greater than 7 days          
         B3 - PPM,SCM & RI          
         B4 - Uptime & Downtime Calculation          
         B5 - From NCR           
-----:------------:------------------------------------------------------------------------------*/          
      
CREATE PROCEDURE [dbo].[usp_KPIAssessmentReport] (          
       @pYear   INT,          
       @pMonth  INT,          
       @pServiceId INT,          
       @pFacilityId INT,      
       @pCustomerId int = NULL      
       )      
 AS      
 SET FMTONLY OFF     
BEGIN TRY   

 DECLARE @pCustomer_Id   INT      
       
 IF(ISNULL(@pFacilityId,'') != '')      
 BEGIN       
  SELECT  @pCustomer_Id = customerid from mstlocationfacility where facilityid = @pFacilityId      
 END      
 declare @MonthDesc varchar(30)      
      
 set @MonthDesc= (Select DateName( month , DateAdd( month , @pMonth , -1 ) ))      
      
      
 DECLARE @MonthlyServiceFee TABLE (      
 MonthlyServiceFee NUMERIC(18,2),       
 IsDeductionGenerated INT)      
  
 DECLARE @DeductionAdjustment TABLE (IndicatorDetId int,IndicatorNo nvarchar(50),IndicatorName nvarchar(100),  
 TotalDemeritPoints int, DeductionValue numeric(24,2),DeductionPer numeric(24,2),PostDemeritPoints INT,  
 PostDeductionValue numeric(24,2),PostDeductionPer numeric(24,2),IsAdjustmentSaved int default(0),  
 DocumentNo NVARCHAR(50),Remarks NVARCHAR(1000))   
   
 INSERT INTO @DeductionAdjustment(IndicatorDetId ,IndicatorNo ,IndicatorName , TotalDemeritPoints , DeductionValue ,  
 DeductionPer,PostDemeritPoints , PostDeductionValue ,PostDeductionPer ,IsAdjustmentSaved , DocumentNo ,Remarks )  
 EXEC uspFM_DedGenerationTxn_AdjustmentFetch @pYear = @pYear, @pMonth = @pMonth, @pServiceId = @pServiceId, @pFacilityId = @pFacilityId , @pErrorMessage =''  
   
 INSERT INTO @MonthlyServiceFee(MonthlyServiceFee, IsDeductionGenerated)      
 EXEC uspFM_KPIGeneration_GetById @pYear=@pYear,@pMonth=@pMonth, @pFacilityId=@pFacilityId, @pCustomerId= @pCustomer_Id      
      
 DECLARE @KPIAssessmentReport TABLE (      
 CustomerName  NVARCHAR(512),       
 FacilityName  NVARCHAR(512),       
 ServiceName   NVARCHAR(512),      
 Month    INT,      
 Year    INT,      
 MonthlyServiceFeeAmt NUMERIC(24,2),      
 DeductionStatus  NVARCHAR(10),      
 DocumentNo   NVARCHAR(256),      
 Remarks    NVARCHAR(1000),      
 CreatedByName  NVARCHAR(512),      
 DeductionValue  NUMERIC(24,2),      
 DeductionPercentage NUMERIC(6,2),      
 TransactionDemeritPoint NUMERIC(6,0),      
 IndicatorDetId  int,      
 IndicatorNo   NVARCHAR(50),      
 IndicatorName  NVARCHAR(512),      
 --Frequency   INT,      
 Frequency   VARCHAR(50),      
 Designation   NVARCHAR(512),      
 SubmittedDate  DATETIME      
 )            
 INSERT INTO @KPIAssessmentReport(CustomerName, FacilityName, ServiceName, Month, Year, MonthlyServiceFeeAmt,       
 DeductionStatus, DocumentNo, Remarks, CreatedByName, DeductionValue, DeductionPercentage, TransactionDemeritPoint,       
 IndicatorDetId, IndicatorNo, IndicatorName, Frequency, SubmittedDate, Designation)      
        
 SELECT MC.CustomerName, MLF.FacilityName, MS.ServiceName, DGT.Month, DGT.Year, DGT.MonthlyServiceFee,       
 DGT.DeductionStatus, DGT.DocumentNo, DGT.Remarks, CREATED.StaffName, DGTD.PostDeductionValue, DGTD.PostDeductionPercentage,       
 DGTD.PostTransactionDemeritPoint, MDID.IndicatorDetId, MDID.IndicatorNo, MDID.IndicatorName, fREQ.FieldValue AS Frequency      
 , DGT.ModifiedDateUTC, UD.Designation AS Designation      
 FROM DedGenerationTxn AS DGT WITH (NOLOCK)       
 INNER JOIN DedGenerationTxnDet AS DGTD WITH (NOLOCK) ON DGT.dedgenerationid = dgtd.dedgenerationid      
 INNER JOIN MstDedIndicatorDet AS MDID WITH (NOLOCK) ON MDID.IndicatorDetId = DGTD.IndicatorDetId      
 INNER JOIN MstLocationFacility AS MLF WITH (NOLOCK) ON MLF.facilityid = DGT.facilityid      
 INNER JOIN MstCustomer AS MC WITH (NOLOCK) ON MC.Customerid = DGT.Customerid      
 INNER JOIN MstService AS MS WITH (NOLOCK) ON MS.ServiceId = DGT.ServiceId      
 INNER JOIN UMUserRegistration AS CREATED WITH (NOLOCK) ON CREATED.UserRegistrationId=DGT.CreatedBy      
 LEFT JOIN UserDesignation AS UD WITH(NOLOCK) ON UD.UserDesignationId = CREATED.UserDesignationId  
 LEFT JOIN FMLovMst fREQ WITH (NOLOCK) ON fREQ.LovId=MDID.Frequency  
   
 WHERE DGT.DeductionStatus = 'A'      
 AND  DGT.FacilityId = @pFacilityId      
 AND  DGT.ServiceId = @pServiceId      
 AND  DGT.Year  = @pYear      
 AND  DGT.Month  = @pMonth      
      
      
 SELECT A.CustomerName, A.FacilityName, A.ServiceName, @MonthDesc as Month, Year, A.MonthlyServiceFeeAmt,       
 A.DeductionStatus, A.DocumentNo, A.Remarks, A.IndicatorDetId, A.IndicatorNo, A.IndicatorName, A.Frequency,       
 C.PostDeductionValue AS DeductionValue, C.PostDeductionPer AS DeductionPercentage, C.PostDemeritPoints AS TransactionDemeritPoint,   
 CreatedByName, Designation, FORMAT(SubmittedDate,'dd-MMM-yyyy') as SubmittedDate ,      
 B.MonthlyServiceFee, B.IsDeductionGenerated       
 FROM @KPIAssessmentReport AS A   
 INNER JOIN @DeductionAdjustment AS C ON A.IndicatorDetId = C.IndicatorDetId,  
  @MonthlyServiceFee AS B      
    
    --SELECT * FROM  @KPIAssessmentReport  
    -- SELECT * FROM @DeductionAdjustment  
       
END TRY          
          
BEGIN CATCH        

 INSERT INTO ErrorLog(Spname, ErrorMessage, createddate)          
 VALUES(  OBJECT_NAME(@@PROCID), 'Error_line: '+CONVERT(VARCHAR(10), ERROR_LINE())+' - '+ERROR_MESSAGE(), GETDATE() )          
      
END CATCH   
SET FMTONLY ON
GO
