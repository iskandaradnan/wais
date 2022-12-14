USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstQAPIndicator_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstQAPIndicator_GetById
Description			: To Get the data from table MstQAPIndicator using the Primary Key id
Authors				: Dhilip V
Date				: 01-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstQAPIndicator_GetById] @pQAPIndicatorId=2
select * from MstQAPIndicator
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_MstQAPIndicator_GetById]                           

  @pQAPIndicatorId	INT
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    SELECT	QAPInd.QAPIndicatorId,
			QAPInd.ServiceId,
			Service.ServiceKey	AS ServiceName,
			QAPInd.IndicatorCode,
			QAPInd.IndicatorDescription,
			QAPInd.IndicatorStandard,
			QAPInd.Remarks,
			QAPInd.Timestamp
	FROM	MstQAPIndicator								AS QAPInd		WITH(NOLOCK)
			INNER JOIN MstService						AS Service		WITH(NOLOCK)	ON QAPInd.ServiceId			= Service.ServiceId
	WHERE	QAPInd.QAPIndicatorId = @pQAPIndicatorId
	ORDER BY QAPInd.ModifiedDateUTC DESC


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
