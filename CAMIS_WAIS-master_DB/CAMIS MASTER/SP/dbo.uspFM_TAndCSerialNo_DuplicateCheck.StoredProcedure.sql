USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TAndCSerialNo_DuplicateCheck]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_TAndCSerialNo_DuplicateCheck
Description			: T&C - SerialNo Duplicate check
Authors				: Biju.N.B
Date				: 10-Oct-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Declare @IsDuplicate BIT 
Exec [[uspFM_TAndCSerialNo_DuplicateCheck]] @pTestingandCommissioningId=0, @pSerialNo='sasadasd',@IsDuplicate=@IsDuplicate OUT
SELECT @IsDuplicate

SELECT SerialNo,* FROM EngTestingandCommissioningTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_TAndCSerialNo_DuplicateCheck]

	@pTestingandCommissioningId INT,
	@pSerialNo NVARCHAR(100),
	@IsDuplicate BIT OUTPUT

	
AS 

BEGIN TRY

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	IF (@pTestingandCommissioningId = 0)
	SELECT @Cnt = COUNT(1) FROM EngTestingandCommissioningTxn WHERE SerialNo = @pSerialNo
	ELSE
	SELECT @Cnt = COUNT(1) FROM EngTestingandCommissioningTxn WHERE SerialNo = @pSerialNo AND TestingandCommissioningId <> @pTestingandCommissioningId

	IF (@Cnt = 0) SET @IsDuplicate = 0;
	ELSE SET @IsDuplicate = 1;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
GO
