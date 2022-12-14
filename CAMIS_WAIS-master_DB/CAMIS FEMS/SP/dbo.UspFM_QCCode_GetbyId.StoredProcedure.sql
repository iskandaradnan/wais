USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_QCCode_GetbyId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_PorteringTransaction_GetById
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_QCCode_GetbyId]  @pQualityCauseId = 123
SELECT * FROM MstQAPQualityCauseDet 
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_QCCode_GetbyId]                           
 -- @pUserId				INT	=	NULL,
  @pQualityCauseId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	


	IF(ISNULL(@pQualityCauseId,0) = 0) RETURN



	SELECT	QualityCauseDet.QualityCauseDetId AS RootCauseId,
			QualityCauseDet.Details AS RootCauseDescription

	FROM	MstQAPQualityCauseDet											AS QualityCauseDet

	WHERE QualityCauseDet.QualityCauseId = @pQualityCauseId

	


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
