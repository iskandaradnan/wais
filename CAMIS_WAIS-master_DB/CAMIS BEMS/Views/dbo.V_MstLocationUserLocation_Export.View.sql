USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationUserLocation_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_MstLocationUserLocation_Export]

AS

	SELECT	UserLocation.UserLocationId,

			UserLocation.CustomerId,

			Customer.CustomerName,

			UserLocation.FacilityId,

			Facility.FacilityName,

			Block.BlockCode,

			Block.BlockName,

			Level.LevelCode,

			Level.LevelName,

			UserLocation.UserLocationCode,

			UserLocation.UserLocationName,

            UserArea.UserAreaCode,

            UserArea.UserAreaName,

			CASE WHEN UserLocation.Active=1 THEN 'Active'

				 WHEN UserLocation.Active=0 THEN 'Inactive'

			END									AS	Status,

			CASE WHEN UserLocation.Active=1 THEN '1'

				 WHEN UserLocation.Active=0 THEN '0'

			END									AS	StatusValue,

			FORMAT(UserLocation.ActiveFromDate,'dd-MMM-yyyy')	AS	[StartServiceDate],

			FORMAT(UserLocation.ActiveToDate,'dd-MMM-yyyy')		AS	[StoptServiceDate],

			UMUser.StaffName									AS	[AuthorizedPerson],
			
			CompanyStaffId.StaffName							AS [CompanyRepresentative],

			UserLocation.Remarks,

			UserArea.ModifiedDateUTC

	FROM	MstLocationUserLocation			AS	UserLocation	WITH(NOLOCK)

			INNER JOIN MstLocationUserArea	AS	UserArea		WITH(NOLOCK)	ON	UserLocation.UserAreaId			=	UserArea.UserAreaId

			INNER JOIN MstLocationBlock		AS	Block			WITH(NOLOCK)	ON	UserArea.BlockId				=	Block.BlockId

			INNER JOIN MstLocationLevel		AS  Level			WITH(NOLOCK)	ON UserArea.LevelId					= Level.LevelId

			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON	UserArea.FacilityId				=	Facility.FacilityId

			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON	UserArea.CustomerId				=	Customer.CustomerId

			LEFT JOIN UMUserRegistration	AS	UMUser			WITH(NOLOCK)	ON	UserLocation.AuthorizedUserId	=	UMUser.UserRegistrationId

			LEFT JOIN UMUserRegistration	AS	CompanyStaffId	WITH(NOLOCK)	ON	UserLocation.CompanyStaffId		=	CompanyStaffId.UserRegistrationId
GO
