USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_ConsumablesReceptacles_Items]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMS_ConsumablesReceptacles_Items]
@ItemCodeId int,
@ItemCode nvarchar(30),
@ItemName nvarchar(30),
@ItemType nvarchar(30),
@Size nvarchar(30),
@UOM nvarchar(30),
@ConsumablesId int,
@IsDeleted bit

AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
	IF(EXISTS(SELECT 1 FROM HWMS_ConsumablesReceptaclesItems WHERE ItemCodeId =  @ItemCodeId AND [ConsumablesId]=@ConsumablesId ))    
	BEGIN
			UPDATE HWMS_ConsumablesReceptaclesItems SET [ItemCode] = @ItemCode, [ItemName] = @ItemName,
			[ItemType]= @ItemType, [Size]= @Size, [UOM]= @UOM,[ConsumablesId]= @ConsumablesId, 
			[isDeleted] = CAST(@IsDeleted AS INT)
			WHERE  ItemCodeId =  @ItemCodeId AND [ConsumablesId]=@ConsumablesId
	END
	ELSE
	BEGIN
			INSERT INTO HWMS_ConsumablesReceptaclesItems 
			( [ItemCode], [ItemName], [ItemType], [Size], [UOM], [ConsumablesId], [isDeleted] ) 		
			VALUES(@ItemCode, @ItemName, @ItemType, @Size, @UOM, @ConsumablesId, CAST(@IsDeleted AS INT) )
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
Error_Procedure() as 'SP_HWMS_ConsumablesReceptacles_Items',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
end




GO
