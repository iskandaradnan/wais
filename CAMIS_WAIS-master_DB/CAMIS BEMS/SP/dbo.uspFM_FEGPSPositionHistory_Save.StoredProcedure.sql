USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FEGPSPositionHistory_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FEGPSPositionHistory_Save
Description			: User GPS Positions
Authors				: Dhilip V
Date				: 01-June-2018
-----------------------------------------------------------------------------------------------------------
select * from FMLovMst
Unit Test:

EXEC [uspFM_FEGPSPositionHistory_Save] @pGPSPositionHistoryId=0,@pUserRegistrationId=1,@pStaffId=NULL,@pDateTime='2018-06-01',@pLatitude='12.00',@pLongitude='13.00',
@pRemarks=NULL

SELECT * FROM FEGPSPositionHistory
SELECT * FROM UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FEGPSPositionHistory_Save]

	@pGPSPositionHistoryId	INT,
	@pUserRegistrationId	INT,	
	@pDateTime				DATETIME,	
	@pLatitude				NUMERIC(24,15),
	@pLongitude				NUMERIC(24,15),
	@pRemarks				NVARCHAR(500) =NULL,
	@pUserId				INT
				
AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	DECLARE	@mDateTimeUTC			DATETIME
	SET @mDateTimeUTC		= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pDateTime)
	DECLARE @Table TABLE (ID INT)

-- Default Values

-- Execution

    IF(ISNULL(@pGPSPositionHistoryId,0)= 0 OR @pGPSPositionHistoryId='')
	BEGIN
		
		INSERT INTO FEGPSPositionHistory (	UserRegistrationId,										
											DateTime,
											DateTimeUTC,
											Latitude,
											Longitude,
											Remarks,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC
										)
										output inserted.GPSPositionHistoryId into @Table
								VALUES	(
											@pUserRegistrationId,											
											@pDateTime,
											@mDateTimeUTC,
											@pLatitude,
											@pLongitude,
											@pRemarks,
											@pUserId,						
											GETDATE(),					
											GETUTCDATE(),					
											@pUserId,						
											GETDATE(),					
											GETUTCDATE()
										)

	SELECT GPSPositionHistoryId			
	FROM FEGPSPositionHistory 
	WHERE GPSPositionHistoryId in (select id from @Table)

	END	
	

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
 --       END   


END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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
