USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BER_DashBoard]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BER_DashBoard
Description			: Get the Deduction_DashBoard
Authors				: Dhilip V
Date				: 10-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_BER_DashBoard  @pFacilityId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_BER_DashBoard]    
		@pFacilityId	INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
--1
	CREATE TABLE #FacilityManager	(	Id INT IDENTITY(1,1),
										[Facility Manager]	NVARCHAR(100),
										BERStatus	NVARCHAR(100),
										[Count]		INT
									)
	INSERT INTO #FacilityManager([Facility Manager],BERStatus,[Count])
	SELECT 'Facility Manager' AS	[Facility Manager],'202,204,205'	AS 	BERStatus,	0 AS [Count]

--2
	CREATE TABLE #HospitalDirector	(	Id INT IDENTITY(1,1),
										[Hospital Director]	NVARCHAR(100),
										BERStatus	NVARCHAR(100),
										[Count]		INT
									)
	INSERT INTO #HospitalDirector([Hospital Director],BERStatus,[Count])
	SELECT 'Hospital Director' AS	[Hospital Director],'203,208'	AS 	BERStatus,	0 AS [Count]

--3
	CREATE TABLE #LiaisonOfficer	(	Id INT IDENTITY(1,1),
										[Liaison Officer]	NVARCHAR(100),
										BERStatus	NVARCHAR(100),
										[Count]		INT
									)
	INSERT INTO #LiaisonOfficer([Liaison Officer],BERStatus,[Count])
	SELECT 'Liaison Officer' AS	[Liaison Officer],'207'	AS 	BERStatus,	0 AS [Count]
-- Default Values

-- Execution

-- Facility Manager

	SELECT 'Facility Manager' AS	[Facility Manager],
			'202,204,205'	AS 	BERStatus,
			COUNT(*) AS [Count]
	INTO	#FacilityManager1
	FROM (
	SELECT	'' [Facility Manager],
			COUNT(*)				AS	TotCount
	FROM	BERApplicationTxn		AS	BER				WITH(NOLOCK)
			INNER JOIN FMLovMst		AS	LovBERStatus	WITH(NOLOCK)	ON	BER.BERStatus	=	LovBERStatus.LovId
	WHERE	BERStatus IN(202,204,205)
			AND	BER.FacilityId	=	@pFacilityId
	GROUP BY	LovBERStatus.FieldValue,BER.BERStatus
	) Sub GROUP BY [Facility Manager]

	UPDATE A SET A.Count=B.Count FROM #FacilityManager A INNER JOIN #FacilityManager1 B ON A.[Facility Manager]	=	B.[Facility Manager]

	SELECT	[Facility Manager],
			BERStatus,
			[Count] 
	FROM #FacilityManager

-- Hospital Director

	SELECT 'Hospital Director' AS	[Hospital Director],
			'203,208'	AS 	BERStatus,
			COUNT(*) AS [Count]
	INTO	#HospitalDirector1
	FROM (
	SELECT	''	AS	'Hospital Director',
			BER.BERStatus,
			COUNT(*)				AS	TotCount
	FROM	BERApplicationTxn		AS	BER				WITH(NOLOCK)
			INNER JOIN FMLovMst		AS	LovBERStatus	WITH(NOLOCK)	ON	BER.BERStatus	=	LovBERStatus.LovId
	WHERE	BERStatus IN(203,208)
			AND	BER.FacilityId	=	@pFacilityId
	GROUP BY	LovBERStatus.FieldValue,BER.BERStatus
	) Sub GROUP BY [Hospital Director]


	UPDATE A SET A.Count=B.Count FROM #HospitalDirector A INNER JOIN #HospitalDirector1 B ON A.[Hospital Director]	=	B.[Hospital Director]

	SELECT	[Hospital Director],
			BERStatus,
			[Count] 
	FROM #HospitalDirector

-- Liaison Officer

	SELECT 'Liaison Officer' AS	[Liaison Officer],
			'207'	AS 	BERStatus,
			COUNT(*) AS [Count]
	INTO	#LiaisonOfficer1
	FROM (
	SELECT	LovBERStatus.FieldValue	AS	'Liaison Officer',
			BER.BERStatus,
			COUNT(*)				AS	TotCount
	FROM	BERApplicationTxn		AS	BER				WITH(NOLOCK)
			INNER JOIN FMLovMst		AS	LovBERStatus	WITH(NOLOCK)	ON	BER.BERStatus	=	LovBERStatus.LovId
	WHERE	BERStatus IN(207)
			AND	BER.FacilityId	=	@pFacilityId
	GROUP BY	LovBERStatus.FieldValue,BER.BERStatus
	) Sub GROUP BY [Liaison Officer]


	UPDATE A SET A.Count=B.Count FROM #LiaisonOfficer A INNER JOIN #LiaisonOfficer1 B ON A.[Liaison Officer]	=	B.[Liaison Officer]

	SELECT	[Liaison Officer],
			BERStatus,
			[Count] 
	FROM #LiaisonOfficer

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
