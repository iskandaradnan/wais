USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationUserArea_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_MstLocationUserArea_Export]
AS
	SELECT	UserArea.UserAreaId,
			UserArea.CustomerId,
			Customer.CustomerName,
			UserArea.FacilityId,
			Facility.FacilityName,
			Block.BlockCode,
			Block.BlockName,
            UserArea.UserAreaCode,
            UserArea.UserAreaName,
			Level.LevelCode									AS	[UserLevelCode],
			Level.LevelName									AS	[UserLevelName],
			CASE WHEN UserArea.Active=1 THEN 'Active'
				 WHEN UserArea.Active=0 THEN 'Inactive'
			END												AS	StatusValue,			
			UserArea.Active,
			FORMAT(UserArea.ActiveFromDate,'dd-MMM-yyyy')	AS	[StartServiceDate],
			FORMAT(UserArea.ActiveToDate,'dd-MMM-yyyy')		AS	[StopServiceDate],
			CustomerUser.StaffName							AS	[CompanyRepresentative],
			FacilityUser.StaffName							AS	[FacilityRepresentative],
			UserArea.Remarks,
			UserArea.ModifiedDateUTC
	FROM	MstLocationUserArea				AS	UserArea		WITH(NOLOCK)
			INNER JOIN MstLocationBlock		AS	Block			WITH(NOLOCK)	ON	UserArea.BlockId		=	Block.BlockId
			INNER JOIN MstLocationLevel		AS	Level			WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON	UserArea.FacilityId		=	Facility.FacilityId
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON	UserArea.CustomerId		=	Customer.CustomerId
			LEFT JOIN UMUserRegistration	AS	CustomerUser	WITH(NOLOCK)	ON	UserArea.CustomerUserId	=	CustomerUser.UserRegistrationId
			LEFT JOIN UMUserRegistration	AS	FacilityUser	WITH(NOLOCK)	ON	UserArea.FacilityUserId	=	FacilityUser.UserRegistrationId
GO
