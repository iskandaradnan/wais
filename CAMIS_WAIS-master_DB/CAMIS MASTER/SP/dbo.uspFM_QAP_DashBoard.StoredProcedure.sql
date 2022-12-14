USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAP_DashBoard]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAP_DashBoard
Description			: Get the QAP DashBoard details 
Authors				: Dhilip V
Date				: 12-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_QAP_DashBoard  @pFacilityId=2,@pYear=2018

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_QAP_DashBoard]   
		@pFacilityId	INT,
		@pYear			INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Execution


	SELECT	B.QAPIndicatorId,
			B.IndicatorCode,
			0.0	AS	ExceptedPercentage,
			0.0	AS	ActualPercentage
	FROM MstQAPIndicator B 
		LEFT JOIN MstQapIndicatorCommon A ON A.QIndicatorId =B.QAPIndicatorId
	WHERE B.QAPIndicatorId IN (1,2)
	
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		THROW;

END CATCH
GO
