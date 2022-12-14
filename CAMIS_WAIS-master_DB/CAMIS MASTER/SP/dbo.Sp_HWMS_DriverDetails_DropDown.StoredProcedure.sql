USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetails_DropDown]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DriverDetails_DropDown]
@pScreenName	nvarchar(400)
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	if(@pScreenName = 'DriverDetails')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='DriverStatusLovs' and ScreenName = @pScreenName


			SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='ClassGradeLovs' and  ScreenName = @pScreenName	 

			SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='IssuingBodyLovs' and  ScreenName = 'LicenseType'	 

			SELECT  TreatmentPlantId AS LovId, TreatmentPlantName AS FieldValue, 0 as IsDefault from HWMS_TreatementPlant

			select RouteCollectionId AS LovId, RouteCode AS FieldValue, 0 as IsDefault from HWMS_RouteCollectionCategory A
			LEFT JOIN FmLovMst B on A.Status = B.LovId WHERE B.FieldValue = 'Active'
			UNION
			select RouteTransportationId, RouteCode , 0  from HWMS_RouteTransportation A
			LEFT JOIN FmLovMst B on A.Status = B.LovId WHERE B.FieldValue = 'Active'
	END

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
select * from FMLovMst order by LovId desc
GO
