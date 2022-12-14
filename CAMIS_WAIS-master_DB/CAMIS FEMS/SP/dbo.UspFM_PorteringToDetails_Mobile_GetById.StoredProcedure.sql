USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_PorteringToDetails_Mobile_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoReschedulingTxn_GetById
Description			: To Get the data from table EngPPMRescheduleTxnDet using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_PorteringToDetails_Mobile_GetById] @pCustomerId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_PorteringToDetails_Mobile_GetById]                           
  @pCustomerId					INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pCustomerId,0) = 0) RETURN

	SELECT FacilityId,FacilityCode,FacilityName  FROM MstLocationFacility where CustomerId = @pCustomerId

	SELECT BlockId,BlockCode,BlockName,FacilityId  FROM MstLocationBlock where CustomerId = @pCustomerId

	SELECT LevelId,LevelCode,LevelName,FacilityId,BlockId  FROM MstLocationLevel where CustomerId = @pCustomerId

	SELECT UserAreaId,UserAreaCode,UserAreaName,FacilityId,LevelId  FROM MstLocationUserArea where CustomerId = @pCustomerId

	SELECT UserLocationId,UserLocationCode,UserLocationName,FacilityId,UserAreaId  FROM MstLocationUserLocation where CustomerId = @pCustomerId

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
