USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_WasteType_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_HWMS_WasteType_Get]
(
	@Id INT
)
	
AS 

BEGIN
SET NOCOUNT ON

BEGIN TRY
	
	SELECT * FROM HWMS_WasteType WHERE WasteTypeId = @Id
	select *from HWMS_WasteType_WasteCode WHERE WasteTypeId=@Id AND [isDeleted] = 0
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
