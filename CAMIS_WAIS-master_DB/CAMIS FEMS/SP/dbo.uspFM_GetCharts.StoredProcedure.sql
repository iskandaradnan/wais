USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetCharts]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_GetMenus
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
Exec [uspFM_GetCharts] @Id=1,@pFacilityId=1
Exec [uspFM_GetCharts] @Id=1,@pFacilityId=NULL

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_GetCharts]

	--@PageSize		INT,
	--@PageIndex		INT,
	@Id				INT,
	@pFacilityId	INT = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @mUserRoleId INT;

	IF (ISNULL(@pFacilityId, 0) = 0)
		BEGIN
			
			SET @mUserRoleId= (	SELECT	TOP 1 B.UserRoleId 
								FROM	UMUserRegistration A
										JOIN UMUserLocationMstDet B ON A.UserRegistrationId = B.UserRegistrationId
										JOIN MstLocationFacility C ON B.FacilityId = C.FacilityId
										JOIN MstCustomer D ON B.CustomerId = D.CustomerId
								WHERE	A.UserRegistrationId = @Id 
								ORDER BY D.CustomerName ASC, C.FacilityName ASC
								)
		END
	ELSE
		BEGIN
			SET @mUserRoleId= (	SELECT	TOP 1 A.UserRoleId 
								FROM	UMUserLocationMstDet A
								WHERE	A.UserRegistrationId = @Id AND A.FacilityId = @pFacilityId 
							)
		END


-- Declaration
	CREATE TABLE #ScreenIds (	Id INT IDENTITY(1,1),
								ScreenId INT
							)
	CREATE TABLE #Menu (	ScreenId INT, 
							ScreenName NVARCHAR(100),
							PageURL NVARCHAR(250),
							ParentMenuId INT,
							SequenceNo INT,
							ControllerName NVARCHAR(200)
						)
	DECLARE @Count INT;
	DECLARE @ScreenId INT;

-- Default Values



-- Execution
		INSERT INTO #ScreenIds (ScreenId)
		SELECT D.ScreenId
		FROM UMUserRegistration A
		JOIN UMUserLocationMstDet B ON A.UserRegistrationId = B.UserRegistrationId
		JOIN UMRoleScreenPermission C ON B.UserRoleId = C.UMUserRoleId
		JOIN UMScreen D ON C.ScreenId = D.ScreenId
		WHERE A.UserRegistrationId = @Id AND CHARINDEX('1',C.[Permissions]) != 0 AND B.UserRoleId=@mUserRoleId and D.ModuleId in (12)

		SELECT @Count = COUNT(1) FROM #ScreenIds

		WHILE @Count > 0
		BEGIN
			SELECT @ScreenId = ScreenId FROM #ScreenIds WHERE Id = @Count;

			WITH EntityChildren AS
			(
			SELECT ScreenId, ScreenName, PageURL, 
					ParentMenuId, SequenceNo, 
					ControllerName FROM UMScreen WHERE ScreenId = @ScreenId and ModuleId  in (12)
			UNION ALL
			SELECT A.ScreenId, A.ScreenName, A.PageURL, 
					A.ParentMenuId, A.SequenceNo, 
					A.ControllerName 
					FROM UMScreen A 
					JOIN EntityChildren B on A.ScreenId = B.ParentMenuId where  a.ModuleId  in (12)
			)
			INSERT INTO #Menu (ScreenId, ScreenName, PageURL, 
						ParentMenuId, SequenceNo, 
						ControllerName) 
			SELECT ScreenId, ScreenName, PageURL, 
						ParentMenuId, SequenceNo, 
						ControllerName FROM EntityChildren

		SET @Count = @Count - 1;
		END

		SELECT DISTINCT ScreenName into #OrderToDisplay FROM #Menu WHERE ScreenName NOT IN ('CHART')

		Alter table #OrderToDisplay add OrderNo int

		Update #OrderToDisplay set OrderNo =1 where ScreenName = 'Asset Classification'
		Update #OrderToDisplay set OrderNo =2 where ScreenName = 'Asset Category'
		Update #OrderToDisplay set OrderNo =3 where ScreenName = 'Expiry Alert List'
		Update #OrderToDisplay set OrderNo =4 where ScreenName = 'PPM Work Order'
		Update #OrderToDisplay set OrderNo =5 where ScreenName = 'BM Work Order'
		Update #OrderToDisplay set OrderNo =6 where ScreenName = 'Equipment Uptime'
		Update #OrderToDisplay set OrderNo =7 where ScreenName = 'KPI'
		Update #OrderToDisplay set OrderNo =8 where ScreenName = 'KPI Target'
		Update #OrderToDisplay set OrderNo =9 where ScreenName = 'Service Fee'
		Update #OrderToDisplay set OrderNo =10 where ScreenName = 'Maintenance Cost'
		Update #OrderToDisplay set OrderNo =11 where ScreenName = 'BER Asset'

		select ScreenName from #OrderToDisplay order by OrderNo

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
