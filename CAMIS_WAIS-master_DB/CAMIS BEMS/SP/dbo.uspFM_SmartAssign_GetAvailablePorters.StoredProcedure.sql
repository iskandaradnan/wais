USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SmartAssign_GetAvailablePorters]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_SmartAssign_GetAvailablePorters]
Description			: Assign the staff for Portering the asset
Authors				: Dhilip V
Date				: 09-Aug-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_SmartAssign_GetAvailablePorters] @pPorteringId=7,@pSourceLatitude='12.800884',@pSourceLongitude='80.22403'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_SmartAssign_GetAvailablePorters]

	@pPorteringId		INT		=	NULL,
	@pSourceLatitude	NUMERIC(24,11), 
	@pSourceLongitude	NUMERIC(24,11)



AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

--1) Get the asset with Competency details based on work order
	SELECT	IDENTITY(INT, 1,1) ID,
			Porter.FromFacilityId	AS FacilityId,
			Porter.PorteringId,
			Porter.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			Asset.AssetTypeCodeId,
			Classify.AssetClassificationId,
			Classify.AssetClassificationDescription AS AssetClassification
	INTO	#TempAssetDet
	FROM	PorteringTransaction				AS	Porter		WITH(NOLOCK)
			INNER JOIN EngAsset					AS	Asset		WITH(NOLOCK)	ON Porter.AssetId				=	Asset.AssetId
			INNER JOIN EngAssetClassification	AS	Classify	WITH(NOLOCK)	ON Asset.AssetClassification	=	Classify.AssetClassificationId
	WHERE	Porter.PorteringId	=	7
	
	--SELECT * FROM #TempAssetDet

--2) User with Competency bassed on asset
	SELECT	UserReg.UserRegistrationId,
			Comp.AssetClassificationDescription AS Competency,
			UserReg.UserGradeId,
			Grade.UserGrade,
			CAST(0  AS NUMERIC(24,11)) AS DistanceInKms,
			CAST(0  AS NUMERIC(24,11)) AS Latitude,
			CAST(0  AS NUMERIC(24,11)) AS Longitude
	INTO	#CompetencyUser
	FROM	UMUserRegistration	AS	UserReg
			OUTER APPLY dbo.SplitString (UserReg.UserCompetencyId,',') AS SplitComp
			LEFT JOIN EngAssetClassification	AS Comp		WITH(NOLOCK)	ON Comp.AssetClassificationId	= SplitComp.Item
			LEFT JOIN UserGrade			AS Grade	WITH(NOLOCK)	ON UserReg.UserGradeId		= Grade.UserGradeId
	WHERE	UserReg.UserCompetencyId IS NOT NULL --AND ISNULL(UserReg.IsUserEngaged,0) = 0
			AND Comp.AssetClassificationDescription 
				IN	(	SELECT AssetClassification 
						FROM #TempAssetDet
					)
			--AND UserReg.UserRegistrationId not in(select Userid from FEUserAssigned) 
			--AND UserReg.UserRegistrationId 
			--	IN	(	SELECT	UserRegistrationId
			--			FROM	FEClock	
			--			WHERE	CAST([DateTime] AS DATE) = CAST(GETDATE() AS DATE)
			--		)
	ORDER BY Grade.UserGradeId ASC

--3) Calculate the distance for the users
	-- hindustan university Padur, Kelambakam  Lat - '12.800884' , Long - '80.22403'

	SELECT	UserRegistrationId,			
			DistanceBtPoints,
			Latitude,
			Longitude
	INTO	#CompetencyUserUp
	FROM (
		SELECT	GPSPos.UserRegistrationId,
				GPSPos.[DateTime] [DateTime],
				dbo.udf_DistanceBtPoints (@pSourceLatitude, @pSourceLongitude, GPSPos.Latitude,GPSPos.Longitude) AS DistanceBtPoints,
				GPSPos.Latitude,
				GPSPos.Longitude,
				--dbo.udf_DistanceBtPoints ('12.800884', '80.22403', GPSPos.Latitude,GPSPos.Longitude) AS DistanceBtPoints,
				ROW_NUMBER() OVER (PARTITION BY GPSPos.UserRegistrationId ORDER BY GPSPos.[DateTime] DESC) Rnk
		FROM	FEGPSPositionHistory		AS GPSPos WITH(NOLOCK)
				INNER JOIN #CompetencyUser	AS CompUser			ON GPSPos.UserRegistrationId	=	CompUser.UserRegistrationId
				--INNER JOIN FEClock			AS Clock			ON CompUser.UserRegistrationId=Clock.UserRegistrationId AND CAST(Clock.ClockIn AS DATE) = CAST(GETDATE() AS DATE)  AND Clock.ClockOut IS NULL
		--WHERE	CAST(GPSPos.[DateTime] AS DATE) = CAST(GETDATE() AS DATE)
		) SUB
	WHERE Rnk=1

	UPDATE B SET	B.DistanceInKms	=	A.DistanceBtPoints,
					B.Latitude	=	A.Latitude,
					B.Longitude	=	A.Longitude
	FROM #CompetencyUserUp A INNER JOIN #CompetencyUser B ON A.UserRegistrationId = B.UserRegistrationId

	--SELECT * FROM #CompetencyUser

	SELECT	ComUser.UserRegistrationId,
			ComUser.UserGradeId,
			ComUser.UserGrade,
			ComUser.DistanceInKms,
			ComUser.Latitude,
			ComUser.Longitude,
			CAST(0  AS NUMERIC(24,11)) AS DistanceInRoad
	--INTO	#AssignUser
	FROM	#CompetencyUser	AS 	ComUser
	--WHERE	DistanceInKms > 0


	--UPDATE	PorteringTransaction SET	AssignPorterId	=	(	SELECT TOP 1 UserRegistrationId 
	--																FROM #AssignUser 
	--																WHERE ISNULL(UserGradeId,0)<>0 
	--																ORDER BY UserGradeId ASC , DistanceInKms ASC
	--															)
	--		WHERE	PorteringId	=	@pPorteringId 

	--SELECT	PorteringId,
	--		AssignPorterId
	--FROM	PorteringTransaction
	--WHERE	PorteringId	=	@pPorteringId



	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRAN
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
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   );
		   THROW;

END CATCH
GO
