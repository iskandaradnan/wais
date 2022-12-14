USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstQAPIndicator_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstQAPIndicator_Save
Description			: QAPIndicator Insert/update
Authors				: Dhilip V
Date				: 30-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstQAPIndicator_Save] @pQAPIndicatorId =1 ,@pServiceId =2 ,@pIndicatorCode ='B1',@pIndicatorDescription='Bems 1',@pIndicatorStandard='10'
,@pRemarks=null,@pUserId=1

SELECT * FROM MstQAPIndicator
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstQAPIndicator_Save]
	
	@pQAPIndicatorId			INT,
	@pServiceId					INT,
	@pIndicatorCode				NVARCHAR(25),
	@pIndicatorDescription		NVARCHAR(250) =null,
	@pIndicatorStandard			NUMERIC(24,2),
	@pRemarks					NVARCHAR(500)=null,
	@pUserId					INT,
	@pTimestamp					VARBINARY(200)		=	NULL
				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values

-- Execution

    IF(isnull(@pQAPIndicatorId,0)= 0 OR @pQAPIndicatorId='')
	  BEGIN
	    --      INSERT INTO MstQAPIndicator(	ServiceId,
					--						IndicatorCode,
					--						IndicatorDescription,
					--						IndicatorStandard,
					--						Remarks,
					--						CreatedBy,
					--						CreatedDate,
					--						CreatedDateUTC,
					--						ModifiedBy,
					--						ModifiedDate,
					--						ModifiedDateUTC									                                                                                                           
     --                      )OUTPUT INSERTED.QAPIndicatorId INTO @Table
			  --VALUES		(	@pServiceId,
					--			@pIndicatorCode,
					--			@pIndicatorDescription,
					--			@pIndicatorStandard,
					--			@pRemarks,
					--			@pUserId,
					--			GETDATE(),
					--			GETUTCDATE(),
					--			@pUserId,
					--			GETDATE(),
					--			GETUTCDATE()							
					--		)

			   	   SELECT				QAPIndicatorId,
										[Timestamp]
				   FROM					MstQAPIndicator
				   WHERE				QAPIndicatorId IN (SELECT ID FROM @Table)
	
		END

  ELSE

	  BEGIN
				DECLARE @mTimestamp varbinary(200);
				SELECT	@mTimestamp = Timestamp FROM	MstQAPIndicator 
				WHERE	QAPIndicatorId	=	@pQAPIndicatorId

				IF (@mTimestamp=@pTimestamp)
				
				BEGIN

				UPDATE MstQAPIndicator SET	
											--ServiceId				=	@pServiceId,
											--IndicatorCode			=	@pIndicatorCode,
											--IndicatorDescription	=	@pIndicatorDescription,
											IndicatorStandard		=	@pIndicatorStandard,
											Remarks					=	@pRemarks,
											ModifiedBy				=	@pUserId,
											ModifiedDate			=	GETDATE(),
											ModifiedDateUTC			=	GETUTCDATE()
											OUTPUT INSERTED.QAPIndicatorId INTO @Table
				WHERE QAPIndicatorId =   @pQAPIndicatorId

			   	SELECT	QAPIndicatorId,
						[Timestamp]
				FROM	MstQAPIndicator
				WHERE	QAPIndicatorId IN (SELECT ID FROM @Table)

        END   

				ELSE
			BEGIN
				SELECT	QAPIndicatorId,
						IndicatorCode,
						[Timestamp],							
						'Record Modified. Please Re-Select' AS ErrorMessage
				FROM	MstQAPIndicator
				WHERE	QAPIndicatorId =@pQAPIndicatorId
			END

END

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
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
GO
