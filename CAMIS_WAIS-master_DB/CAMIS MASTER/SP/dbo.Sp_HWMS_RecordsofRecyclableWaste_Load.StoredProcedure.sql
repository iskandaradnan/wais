USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Load]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Load]
@pScreenName nvarchar(400)
AS

BEGIN TRY

-- Paramter Validation

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution

if(@pScreenName = 'RecordsofRecyclableWaste')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='MethodofDisposalValue' and ModuleName = 'HWMS'


			 SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)
            WHERE Active = 1 AND ScreenName = 'Waste Type' and FieldName = 'WasteType'

			SELECT	LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='TransportationCategoryValue' and ModuleName = 'HWMS'

		
			end

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
