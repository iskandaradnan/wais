USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FEPostGPSPositionHistorySync_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoPartReplacementTxn_Save
Description			: If Maintenance Work Order Completion Info already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pGPSPositionHistorySync		[dbo].[udt_PostGPSPositionHistorySyncType]
INSERT INTO @pGPSPositionHistorySync (GPSPositionHistoryId,UserRegistrationId,DateTime,DateTimeUTC,Latitude,Longitude,Remarks,UserId) 
VALUES (0,1,'2018-06-13 16:40:45.057','2018-06-13 16:40:45.057',80.2345545,12.45643432434,'AAA',2)

EXEC [uspFM_FEPostGPSPositionHistorySync_Save] @pGPSPositionHistorySync
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[uspFM_FEPostGPSPositionHistorySync_Save]
		
		@pGPSPositionHistorySync			 [dbo].[udt_PostGPSPositionHistorySyncType]   READONLY


AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT




--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngMwoPartReplacementTxn

			IF EXISTS(SELECT 1 FROM @pGPSPositionHistorySync WHERE GPSPositionHistoryId = NULL OR GPSPositionHistoryId =0)

BEGIN
	
			INSERT INTO FEGPSPositionHistory
						(	
							UserRegistrationId,
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
						)	OUTPUT INSERTED.GPSPositionHistoryId INTO @Table							

						
						SELECT 	
							UserRegistrationId,
							DateTime,
							DateTimeUTC,			
							Latitude,			
							Longitude,			
							Remarks,				
							UserId,				
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE()
						FROM @pGPSPositionHistorySync		AS GPSPositionHistorySyncType
						WHERE 	GPSPositionHistorySyncType.GPSPositionHistoryId =0

			SELECT	GPSPositionHistoryId,
					[Timestamp]
			FROM	FEGPSPositionHistory
			WHERE	GPSPositionHistoryId IN (SELECT ID FROM @Table)

			--SET @PrimaryKeyId  = (SELECT ID FROM @Table)
		     

END

IF EXISTS(SELECT 1 FROM @pGPSPositionHistorySync WHERE GPSPositionHistoryId >0) 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.EngMwoPartReplacementTxn UPDATE

			

BEGIN

	    UPDATE  PositionHistory	SET	
							PositionHistory.UserRegistrationId			= PositionHistoryudt.UserRegistrationId,
							PositionHistory.DateTime					= PositionHistoryudt.DateTime,
							PositionHistory.DateTimeUTC					= PositionHistoryudt.DateTimeUTC,
							PositionHistory.Latitude					= PositionHistoryudt.Latitude,
							PositionHistory.Longitude					= PositionHistoryudt.Longitude,
							PositionHistory.Remarks						= PositionHistoryudt.Remarks,
							PositionHistory.ModifiedBy					= PositionHistoryudt.UserId,
							PositionHistory.ModifiedDate				= GETDATE(),
							PositionHistory.ModifiedDateUTC				= GETUTCDATE()
				OUTPUT INSERTED.GPSPositionHistoryId INTO @Table
				FROM	FEGPSPositionHistory	AS PositionHistory INNER JOIN @pGPSPositionHistorySync		AS PositionHistoryudt
				ON	PositionHistory.GPSPositionHistoryId= PositionHistoryudt.GPSPositionHistoryId 
						AND ISNULL(PositionHistoryudt.GPSPositionHistoryId,0)>0


	

END



	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END
		
END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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

-------------------------------------------------------------------------------------------------

--drop proc [uspFM_FEPostGPSPositionHistorySync_Save]
--drop  type [udt_PostGPSPositionHistorySyncType]

--CREATE TYPE [dbo].[udt_PostGPSPositionHistorySyncType] AS TABLE(
--GPSPositionHistoryId		INT  NULL,		
--UserRegistrationId			INT  NULL,
--DateTime					DATETIME  NULL,
--DateTimeUTC					DATETIME  NULL,
--Latitude					NUMERIC(24,2)  NULL,
--Longitude					NUMERIC(24,2)  NULL,
--Remarks						NVARCHAR(500)  NULL,
--UserId						INT  NULL
--)
GO
