USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsumablesReceptacles_Load]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Sp_HWMS_ConsumablesReceptacles_Load]
@pScreenName	nvarchar(400)
AS
BEGIN TRY
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

if(@pScreenName = 'ConsumablesReceptacles')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ItemTypeConsumables' and ScreenName = @pScreenName

			SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)
            WHERE Active = 1 AND ScreenName = 'Waste Type' and FieldName = 'WasteType'

			SELECT LovId	AS LovId,	FieldValue	AS FieldValue,IsDefault	FROM FMLovMst WITH(NOLOCK) 
			WHERE Active = 1 AND ScreenName = 'Waste Type' and FieldName = 'WasteCategory'

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='UnitOfMeasurementValues' 
			End

END TRY
BEGIN CATCH
INSERT INTO ErrorLog(
Spname,
ErrorMessage,
createddate)
VALUES( OBJECT_NAME(@@PROCID),
'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),
getdate()
)
END CATCH
GO
