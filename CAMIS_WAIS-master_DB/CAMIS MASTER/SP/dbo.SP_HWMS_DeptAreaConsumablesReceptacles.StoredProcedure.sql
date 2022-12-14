USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_DeptAreaConsumablesReceptacles]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_HWMS_DeptAreaConsumablesReceptacles](
       @ReceptaclesId int,
       @pWasteType nvarchar(50),
	   @pItemCode nvarchar(50),
	   @pItemName nvarchar(50)='',
	   @pSize nvarchar(50)='',
	   @pUOM nvarchar(50)='',
       @pShelfLevelQuantity nvarchar(50),
	   @pDeptAreaId int,
	   @IsDeleted bit
	--@CreatedDate datetime,
	--@ModifiedBy int,
    --@ModifiedDate datetime,
	--@CreateDateUTC datetime,
	--@ModifiedDateUTC datetime,
	)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(EXISTS(SELECT 1 FROM HWMS_DeptAreaConsumablesReceptacles WHERE [ReceptaclesId]=@ReceptaclesId AND [DeptAreaId]=@pDeptAreaId ))
        BEGIN
		UPDATE HWMS_DeptAreaConsumablesReceptacles SET WasteType=@pWasteType,ItemCode=@pItemCode,ItemName=@pItemName,Size=@pSize,
		UOM = @pUOM,ShelfLevelQuantity=@pShelfLevelQuantity, [isDeleted] = CAST(@IsDeleted AS INT) 
		WHERE [ReceptaclesId] = @ReceptaclesId AND [DeptAreaId]=@pDeptAreaId
        END
ELSE
	   BEGIN		
	   INSERT INTO HWMS_DeptAreaConsumablesReceptacles(
	   [WasteType],[ItemCode],[ItemName],[Size],[UOM],[ShelfLevelQuantity],[DeptAreaId],[isDeleted])
	   																			
	   VALUES( @pWasteType,@pItemCode,@pItemName,@pSize,@pUOM,@pShelfLevelQuantity,@pDeptAreaId,CAST(@IsDeleted AS INT))    				
	   END
END TRY
BEGIN CATCH
	INSERT INTO ExceptionLog (
	ErrorLine, ErrorMessage, ErrorNumber,
	ErrorProcedure, ErrorSeverity, ErrorState,
	DateErrorRaised
	)
	SELECT
	ERROR_LINE () as ErrorLine,
	Error_Message() as ErrorMessage,
	Error_Number() as ErrorNumber,
	Error_Procedure() as 'SP_HWMS_DeptAreaConsumablesReceptacles',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END


GO
