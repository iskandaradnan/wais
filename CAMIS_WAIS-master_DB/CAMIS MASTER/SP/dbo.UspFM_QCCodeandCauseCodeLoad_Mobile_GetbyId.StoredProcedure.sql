USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_QCCodeandCauseCodeLoad_Mobile_GetbyId]    Script Date: 20-09-2021 16:43:01 ******/
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
EXEC [UspFM_QCCodeandCauseCodeLoad_Mobile_GetbyId] 
SELECT * FROM MstQAPQualityCauseDet 
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_QCCodeandCauseCodeLoad_Mobile_GetbyId]                           
 -- @pUserId				INT	=	NULL,
  --@pQualityCauseDetId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT

	--IF(ISNULL(@pQualityCauseDetId,0) = 0) RETURN


	SELECT	QualityCause.QualityCauseId,
			QualityCause.CauseCode,
			QualityCause.Description

	FROM	MstQAPQualityCause												AS QualityCause


	SELECT	QualityCauseDet.QualityCauseDetId,
			QualityCauseDet.QcCode,
			QualityCauseDet.Details

	FROM	MstQAPQualityCauseDet											AS QualityCauseDet



	


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
