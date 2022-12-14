USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_KPIPreVCMReport]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [uspFM_DedGenerationTxn]    
Description   : Asset number fetch control    
Authors    : Krishna S
Date    : 08-May-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC [usp_KPIPreVCMReport] @pYear=2018,@pMonth=11, @pServiceId=2,@pFacilityId=1
EXEC [usp_KPIPreVCMReport] @pYear=2018,@pMonth=4, @pServiceId=2,@pFacilityId=2    
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

CREATE PROCEDURE [dbo].[usp_KPIPreVCMReport] (    
						 @pYear			INT,    
						 @pMonth		INT,    
						 @pServiceId	INT,    
						 @pFacilityId	INT,
						 @pCustomerId	int = NULL
						 )
 AS
BEGIN TRY
	DECLARE @pFacilityNameParam		NVARCHAR(512)
	DECLARE @pServiceNameParam		NVARCHAR(512)
	DECLARE @pCustomerNameParam		NVARCHAR(512)
	DECLARE @pCustomer_Id			INT
	
	IF(ISNULL(@pFacilityId,'') != '')
	BEGIN 
		SELECT @pFacilityNameParam = facilityname, @pCustomer_Id = customerid from mstlocationfacility where facilityid = @pFacilityId
	END
	
	IF(ISNULL(@pServiceId,'') != '')
	BEGIN 
		SELECT @pServiceNameParam = servicename from MstService where serviceid = @pServiceId
	END
	
	IF(ISNULL(@pServiceId,'') != '')
	BEGIN 
		SELECT @pCustomerNameParam = customername from MstCustomer where customerid = @pCustomer_Id
	END
		
	DECLARE @ResultTempT TABLE (IndicatorDetId int, IndicatorNo NVARCHAR(100),IndicatorName NVARCHAR(100), 
	SubParameter INT,SubParameterDetId INT,TransDemeritPoints INT,TotalDemeritPoints INT,DeductionValue NUMERIC(24,2),    
	DeductionPer NUMERIC(24,2))    
	
	DECLARE @MonthlyServiceFee TABLE (MonthlyServiceFee NUMERIC(18,9), IsDeductionGenerated INT)

	INSERT INTO @ResultTempT(IndicatorDetId,IndicatorNo,IndicatorName,SubParameter,SubParameterDetId,TransDemeritPoints,
	TotalDemeritPoints,DeductionValue,DeductionPer)    
	EXEC [uspFM_DedGenerationTxn_A] @pYear=@pYear,@pMonth=@pMonth, @pServiceId=@pServiceId,@pFacilityId=@pFacilityId

	INSERT INTO @MonthlyServiceFee(MonthlyServiceFee, IsDeductionGenerated)
	EXEC uspFM_KPIGeneration_GetById @pYear=@pYear,@pMonth=@pMonth, @pFacilityId=@pFacilityId, @pCustomerId= @pCustomerId


	
	declare @MonthDesc varchar(30)

	set @MonthDesc= (Select DateName( month , DateAdd( month , @pMonth , -1 ) ))


	SELECT A.IndicatorDetId, A.IndicatorNo, A.IndicatorName,A.SubParameter,A.SubParameterDetId,A.TransDemeritPoints,
	A.TotalDemeritPoints,A.DeductionValue,A.DeductionPer, B.MonthlyServiceFee, B.IsDeductionGenerated,
	ISNULL(@pYear,'') AS  pYear, ISNULL(@MonthDesc,'') AS pMonth, ISNULL(@pFacilityNameParam,'') as FacilityNameParam
	, ISNULL(@pServiceNameParam,'') AS ServiceNameParam, ISNULL(@pCustomerNameParam,'') as CustomerNameParam
	FROM @ResultTempT AS A, @MonthlyServiceFee AS B

   
END TRY    
    
BEGIN CATCH  
 
    
 INSERT INTO ErrorLog(Spname, ErrorMessage, createddate)    
 VALUES(  OBJECT_NAME(@@PROCID), 'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(), getdate() )    
    
END CATCH
GO
