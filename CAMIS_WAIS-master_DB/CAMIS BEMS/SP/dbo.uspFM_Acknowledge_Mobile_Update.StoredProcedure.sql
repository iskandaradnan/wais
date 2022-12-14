USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Acknowledge_Mobile_Update]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_Acknowledge_Mobile_Update
Description			: work order Acknowledge save
Authors				: Dhilip V
Date				: 19-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pAcknowledge [dbo].[udt_FEAcknowledge]
INSERT INTO @pAcknowledge ([AcknowledgeId],[Remarks],[Acknowledge],[Signatureimage]) VALUES (1,'D',1,NULL)

EXEC uspFM_Acknowledge_Mobile_Update  @pAcknowledge=@pAcknowledge

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_Acknowledge_Mobile_Update]
		
		@pAcknowledge		[dbo].[udt_FEAcknowledge]  READONLY
AS                                              

BEGIN TRY


-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	

	UPDATE A SET	A.Remarks			=	B. Remarks,
					A.Acknowledge		=	B.Acknowledge,
					A.Signatureimage	=	B.Signatureimage
					OUTPUT INSERTED.AcknowledgeId	INTO @Table
	FROM	FEAcknowledge A 
			INNER JOIN @pAcknowledge B	ON A.AcknowledgeId	=	B.AcknowledgeId
	WHERE	ISNULL(B.AcknowledgeId,0)>0

			SELECT	AcknowledgeId,
					'' AS	ErrorMessage
			FROM	FEAcknowledge
			WHERE	AcknowledgeId IN (SELECT ID FROM @Table)



		
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
