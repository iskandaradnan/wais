USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstDedIndicator_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstDedIndicator_Save
Description			: If Stock Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @MstDedIndicatorDet AS [dbo].[udt_MstDedIndicatorDet]
 insert into  @MstDedIndicatorDet(IndicatorDetId,IndicatorId,IndicatorNo,IndicatorName,IndicatorDesc,IndicatorType,Weightage,Frequency)VALUES
('1','1','B.1','Response Time','All service requests shall be responded by the Company''s trained technical personal within the timeframe as stipulated in the Agreement.',
'0',0.0,'91')


EXEC [uspFM_MstDedIndicator_Save] @MstDedIndicatorDet,
@pUserId='1',@pIndicatorId='1',@ServiceId='2',@Group='88'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstDedIndicator_Save]

			@MstDedIndicatorDet				AS [dbo].[udt_MstDedIndicatorDet] READONLY,			
			@pUserId						INT = null,
			@pIndicatorId					INT = null,
			@ServiceId						INT = null,
			@Group							INT = null



AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table		TABLE (ID INT)
	DECLARE	@Active		BIT = 1
	DECLARE	@BuiltIn	BIT = 1
-- Default Values


-- Execution

    IF(isnull(@pIndicatorId,0)> 0 OR @pIndicatorId='')


	  BEGIN

			    UPDATE IndicatorDet SET										
									IndicatorDet.Frequency						= MstDedIndicatorDetType.Frequency,
									IndicatorDet.ModifiedBy						= @pUserId,
									IndicatorDet.ModifiedDate					= GETDATE(),
									IndicatorDet.ModifiedDateUTC				= GETUTCDATE()
					FROM	MstDedIndicatorDet AS IndicatorDet 
							INNER JOIN @MstDedIndicatorDet AS MstDedIndicatorDetType ON IndicatorDet.IndicatorDetId	=	MstDedIndicatorDetType.IndicatorDetId
					WHERE ISNULL(MstDedIndicatorDetType.IndicatorDetId,0)>0
			
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

-------------------------------------------------------------------UDT CREATION----------------------------------------------------------

--DROP TYPE [udt_MstDedIndicatorDet]

--CREATE TYPE [dbo].[udt_MstDedIndicatorDet] AS TABLE(
--IndicatorDetId					INT,
--IndicatorId						INT,
--IndicatorNo						NVARCHAR(50),
--IndicatorName					NVARCHAR(500),
--IndicatorDesc					NVARCHAR(1000),
--IndicatorType					INT,
--Weightage						NUMERIC(24,2),
--Frequency						INT
--)
--GO
GO
