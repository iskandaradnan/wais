USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstDedPenalty_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstDedPenalty_Save
Description			: If Penalty already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @MstDedPenaltyDet AS [dbo].[udt_MstDedPenaltyDet]
 insert into  @MstDedPenaltyDet(PenaltyDetId,ServiceId,PenaltyId,CriteriaId,Status)VALUES
('1','2','1','1','2')


EXEC [uspFM_MstDedPenalty_Save] @MstDedPenaltyDet,
@pUserId='1',@pPenaltyId='1',@PenaltyDescription='Accidents due to non-compliance to standard operating procedure(SOP) and safety requirement related to operation and maintenance'
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstDedPenalty_Save]

			@MstDedPenaltyDet				AS [dbo].[udt_MstDedPenaltyDet] READONLY,			
			@pUserId						INT = null,
			@pPenaltyId						INT = null,
			@PenaltyDescription				NVARCHAR(1000) = null

AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE	@Active		BIT = 1
	DECLARE	@BuiltIn	BIT = 1

-- Default Values


-- Execution

    IF(isnull(@pPenaltyId,0)> 0 OR @pPenaltyId='')

	  BEGIN


			    UPDATE DedPenaltyDet SET										
									DedPenaltyDet.status						= DedPenaltyDetType.Status,
									DedPenaltyDet.ModifiedBy					= @pUserId,
									DedPenaltyDet.ModifiedDate					= GETDATE(),
									DedPenaltyDet.ModifiedDateUTC				= GETUTCDATE()
					FROM	MstDedPenaltyDet						AS DedPenaltyDet 
							INNER JOIN @MstDedPenaltyDet			AS DedPenaltyDetType ON DedPenaltyDet.PenaltyDetId	=	DedPenaltyDetType.PenaltyDetId
					WHERE ISNULL(DedPenaltyDetType.PenaltyDetId,0)>0
			
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

--DROP TYPE [udt_MstDedPenaltyDet]

--CREATE TYPE [dbo].[udt_MstDedPenaltyDet] AS TABLE(
--PenaltyDetId					INT,
--ServiceId						INT,
--PenaltyId						INT,
--CriteriaId						INT,
--Status							INT
--)
--GO
GO
