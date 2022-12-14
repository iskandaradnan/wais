USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocation_Fetch]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstLocation_Fetch]
Description			: QR Code Asset number fetch control
Authors				: Dhilip V
Date				: 24-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstLocation_Fetch]  @pFacilityId=2,@pBlockId=null,@pLevelId=null,@pUserAreaId=null,@pLocationNo =1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstLocation_Fetch]                           
                            
  
  @pFacilityId			INT	=	NULL,
  @pBlockId				INT	=	NULL,
  @pLevelId				INT	=	NULL,
  @pUserAreaId			INT	=	NULL,
  @pLocationNo		    INT	=	NULL
  --@pPageIndex			INT,
  --@pPageSize			INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT


   IF(@pLocationNo = 1 )
   BEGIN
            SELECT BlockId  AS LovId,BlockName AS FieldValue ,  0  IsDefault FROM MstLocationBlock WHERE Active = 1 AND FacilityId = @pFacilityId
   END 
   ELSE IF (@pLocationNo = 2 )
   BEGIN

         SELECT LevelId  AS LovId, LevelName AS FieldValue,  0  IsDefault FROM MstLocationLevel WHERE Active = 1 AND FacilityId = @pFacilityId AND BlockId = @pBlockId
   END 
    ELSE IF (@pLocationNo = 3 )
   BEGIN
		 SELECT UserAreaId  AS LovId, UserAreaName AS FieldValue,  0  IsDefault FROM MstLocationUserArea WHERE Active = 1 AND FacilityId = @pFacilityId AND LevelId = @pLevelId
   END

    ELSE IF (@pLocationNo = 4 )
   BEGIN
		SELECT UserLocationId  AS LovId, UserLocationName AS FieldValue,  0  IsDefault FROM MstLocationUserLocation WHERE Active = 1 AND FacilityId = @pFacilityId AND UserAreaId = @pUserAreaId
   END




			
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
