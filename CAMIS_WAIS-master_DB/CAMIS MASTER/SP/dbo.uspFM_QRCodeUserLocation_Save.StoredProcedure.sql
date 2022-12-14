USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QRCodeUserLocation_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QRCodeUserLocation_Save
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pQRCodeUserLocation [udt_QRCodeUserLocation]
INSERT INTO @pQRCodeUserLocation (CustomerId,FacilityId,ServiceId,BlockId,LevelId,UserAreaId,UserLocationId,QRCodeSize1,QRCodeSize2,QRCodeSize3,QRCodeSize4,QRCodeSize5)
VALUES (1,1,2,1,1,1,1,1,
NULL,NULL,NULL,NULL)
EXEC uspFM_QRCodeUserLocation_Save  @pQRCodeUserLocation=@pQRCodeUserLocation,@pUserId=1

SELECT * FROM QRCodeUserLocation
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_QRCodeUserLocation_Save]

	@pQRCodeUserLocation	 [udt_QRCodeUserLocation]  READONLY,
	@pUserId INT
AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY


DECLARE @TotalRecords INT;
DECLARE @pTotalPage NUMERIC(24,2)
DECLARE @mBatchGenerated nvarchar(200)
DECLARE @Table TABLE (ID INT)	

--SET @mBatchGenerated=	CAST(YEAR(GETDATE()) AS NVARCHAR(10))	+	CAST(DATEPART(MM,GETDATE() )AS NVARCHAR(10))
--						+	CAST(DAY(GETDATE()) AS NVARCHAR(10))	+	CAST(DATEPART(HOUR,GETDATE()) AS NVARCHAR(10))
--						+	CAST(DATEPART(MINUTE,GETDATE()) AS NVARCHAR(10))	+	CAST(DATEPART(SECOND,GETDATE()) AS NVARCHAR(10))
--						+	CAST(DATEPART(MILLISECOND,GETDATE()) AS NVARCHAR(10))


SET @mBatchGenerated=	(SELECT MAX(cast(ISNULL(BatchGenerated,0)as int))+CAST (1 AS INT) FROM QRCodeUserLocation )
SET @mBatchGenerated = (SELECT ISNULL(@mBatchGenerated,1))

	INSERT INTO  QRCodeUserLocation(	CustomerId,
									FacilityId,
									ServiceId,
									BlockId,
									LevelId,
									UserAreaId,
									UserLocationId,
									QRCodeSize1,
									QRCodeSize2,
									QRCodeSize3,
									QRCodeSize4,
									QRCodeSize5,
									CreatedBy,
									CreatedDate,
									CreatedDateUTC,
									ModifiedBy,
									ModifiedDate,
									ModifiedDateUTC,
									BatchGenerated
								)OUTPUT INSERTED.QRCodeUserLocationId INTO @Table

	SELECT	CustomerId,
			FacilityId,
			ServiceId,
			BlockId,
			LevelId,
			UserAreaId,
			UserLocationId,
			QRCodeSize1,
			QRCodeSize2,
			QRCodeSize3,
			QRCodeSize4,
			QRCodeSize5,
			@pUserId,
			GETDATE(),
			GETUTCDATE(),
			@pUserId,
			GETDATE(),
			GETUTCDATE(),
			@mBatchGenerated
	FROM @pQRCodeUserLocation

			SELECT	QRCodeUserLocationId,
			[Timestamp],
			'' as ErrorMessage
			FROM	QRCodeUserLocation
			WHERE	QRCodeUserLocationId IN (SELECT ID FROM @Table)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
