USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VM_DashBoard]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VM_DashBoard
Description			: Get the variation details for dashboard.
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_VM_DashBoard  @pFacilityId=2,@pYear=2018,@pMonth=4

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_VM_DashBoard]  
		@pFacilityId	INT,
		@pYear			INT,
		@pMonth			INT

AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

CREATE TABLE #VMVariationStatus
	(	Id			INT IDENTITY(1,1) NOT NULL,
		FacilityId	INT,
		StatusName	VARCHAR(50),
		TotalCount	INT,
	)


-- Default Values

	INSERT INTO #VMVariationStatus (FacilityId,StatusName,TotalCount)	VALUES (@pFacilityId,'Variation Raised',0)
	INSERT INTO #VMVariationStatus (FacilityId,StatusName,TotalCount)	VALUES (@pFacilityId,'Unauthorized',0)
	INSERT INTO #VMVariationStatus (FacilityId,StatusName,TotalCount)	VALUES (@pFacilityId,'Authorized',0)
	INSERT INTO #VMVariationStatus (FacilityId,StatusName,TotalCount)	VALUES (@pFacilityId,'Approved',0)

-- Execution


	SELECT *	INTO #VMVariationStatus1 FROM (
		SELECT	'Variation Raised'			AS	StatusName,
				FacilityId,
				COUNT(DISTINCT VariationId)	AS	TotalCount
		FROM	VmVariationTxn	WITH(NOLOCK)
		WHERE   FacilityId=@pFacilityId 
				AND Year(VariationRaisedDate)=@pYear 
				AND Month(VariationRaisedDate)=@pMonth
		GROUP BY	FacilityId,CustomerId,
					Month(VariationRaisedDate),
					Year(VariationRaisedDate)
	UNION
		
		SELECT	'Unauthorized'				AS	StatusName,
				FacilityId,
				COUNT(DISTINCT VariationId)	AS	TotalCount
		FROM	VmVariationTxn	WITH(NOLOCK) 
		WHERE   ISNULL(AuthorizedStatus,0)	=	0
				AND FacilityId=@pFacilityId 
				AND Year(VariationRaisedDate)=@pYear 
				AND Month(VariationRaisedDate)=@pMonth
		GROUP BY	FacilityId,CustomerId,
					Month(VariationRaisedDate),
					Year(VariationRaisedDate)
	UNION
	
		SELECT	'Authorized'				AS	StatusName,
				FacilityId,
				COUNT(DISTINCT VariationId)	AS	TotalCount
		FROM	VmVariationTxn	WITH(NOLOCK) 
		WHERE   ISNULL(AuthorizedStatus,0)	=	1
				AND FacilityId=@pFacilityId 
				AND Year(VariationRaisedDate)=@pYear 
				AND Month(VariationRaisedDate)=@pMonth
		GROUP BY	FacilityId,CustomerId,
					Month(VariationRaisedDate),
					Year(VariationRaisedDate)
	
	UNION
	
		SELECT	'Approved'					AS	StatusName,
				FacilityId,
				COUNT(DISTINCT VariationId)	AS	TotalCount
		FROM	VmVariationTxn	WITH(NOLOCK) 
		WHERE   VariationWFStatus=1
				AND FacilityId=@pFacilityId 
				AND Year(VariationRaisedDate)=@pYear 
				AND Month(VariationRaisedDate)=@pMonth
		GROUP BY	FacilityId,CustomerId,
					Month(VariationRaisedDate),
					Year(VariationRaisedDate)
		
	) SUB

	UPDATE B SET B.TotalCount	=	A.TotalCount 
	FROM	#VMVariationStatus1 A 
			INNER JOIN #VMVariationStatus B ON A.StatusName=B.StatusName

	SELECT	StatusName,
			TotalCount
	FROM	#VMVariationStatus

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
