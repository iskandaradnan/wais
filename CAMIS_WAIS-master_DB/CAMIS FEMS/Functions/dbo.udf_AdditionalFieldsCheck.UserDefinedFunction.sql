USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AdditionalFieldsCheck]    Script Date: 20-09-2021 17:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[udf_AdditionalFieldsCheck]
(

	@pCustomerId int, @pScreenNameLovId int, @PFieldname nvarchar (100), @pFieldTypeLovId int
)

RETURNS BIT AS

BEGIN
DECLARE @UsedCount INT  = 0
DECLARE @IsUsed BIT = 0;
if ( @pScreenNameLovId= 314)   --  EngAsset
BEGIN
	IF @PFieldname = 'Field1'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field1 IS NOT NULL AND Field1 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field1 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field2'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field2 IS NOT NULL AND Field2 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field2 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field3'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field3 IS NOT NULL AND Field3 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field3 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field4'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field4 IS NOT NULL AND Field4 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field4 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field5'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field5 IS NOT NULL AND Field5 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field5 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field6'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field6 IS NOT NULL AND Field6 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field6 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field7'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field7 IS NOT NULL AND Field7 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field7 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field8'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field8 IS NOT NULL AND Field8 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field8 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field9'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field9 IS NOT NULL AND Field9 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field9 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field10'
	SELECT @UsedCount = COUNT(*) FROM EngAsset WHERE Field10 IS NOT NULL AND Field10 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field10 != 'null')) AND CustomerId = @pCustomerId
	
end
ELSE   if ( @pScreenNameLovId= 315)   --  TandC
BEGIN
	IF @PFieldname = 'Field1'
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field1 IS NOT NULL AND Field1 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field1 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field2'
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field2 IS NOT NULL AND Field2 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field2 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field3'
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field3 IS NOT NULL AND Field3 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field3 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field4'
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field4 IS NOT NULL AND Field4 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field4 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field5'	   
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field5 IS NOT NULL AND Field5 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field5 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field6'	   
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field6 IS NOT NULL AND Field6 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field6 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field7'	   
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field7 IS NOT NULL AND Field7 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field7 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field8'	   
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field8 IS NOT NULL AND Field8 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field8 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field9'	  
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field9 IS NOT NULL AND Field9 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field9 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field10'	   
	SELECT @UsedCount = COUNT(*) FROM EngTestingandCommissioningTxn WHERE Field10 IS NOT NULL AND Field10 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field10 != 'null')) AND CustomerId = @pCustomerId
	
end

ELSE   if ( @pScreenNameLovId= 335)   --  ber
BEGIN
	IF @PFieldname = 'Field1'
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field1 IS NOT NULL AND Field1 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field1 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field2'
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field2 IS NOT NULL AND Field2 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field2 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field3'
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field3 IS NOT NULL AND Field3 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field3 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field4'
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field4 IS NOT NULL AND Field4 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field4 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field5'	   
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field5 IS NOT NULL AND Field5 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field5 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field6'	   
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field6 IS NOT NULL AND Field6 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field6 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field7'	   
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field7 IS NOT NULL AND Field7 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field7 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field8'	   
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field8 IS NOT NULL AND Field8 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field8 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field9'	  
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field9 IS NOT NULL AND Field9 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field9 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field10'	   
	SELECT @UsedCount = COUNT(*) FROM BERApplicationTxn WHERE Field10 IS NOT NULL AND Field10 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field10 != 'null')) AND CustomerId = @pCustomerId

END

ELSE   if ( @pScreenNameLovId= 337)   --  Work Order
BEGIN
	IF @PFieldname = 'Field1'
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field1 IS NOT NULL AND Field1 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field1 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field2'
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field2 IS NOT NULL AND Field2 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field2 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field3'
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field3 IS NOT NULL AND Field3 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field3 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field4'
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field4 IS NOT NULL AND Field4 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field4 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field5'	   
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field5 IS NOT NULL AND Field5 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field5 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field6'	   
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field6 IS NOT NULL AND Field6 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field6 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field7'	   
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field7 IS NOT NULL AND Field7 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field7 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field8'	   
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field8 IS NOT NULL AND Field8 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field8 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field9'	  
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field9 IS NOT NULL AND Field9 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field9 != 'null')) AND CustomerId = @pCustomerId
	IF @PFieldname = 'Field10'	   
	SELECT @UsedCount = COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE Field10 IS NOT NULL AND Field10 != '' AND (@pFieldTypeLovId = 325 OR (@pFieldTypeLovId = 324 AND Field10 != 'null')) AND CustomerId = @pCustomerId

END

IF @UsedCount > 0 SET @IsUsed = 1;
ELSE SET @IsUsed = 0
RETURN @IsUsed

END
GO
