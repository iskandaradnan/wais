USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationFacility_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[V_MstLocationFacility_Export]
AS
	SELECT	Facility.CustomerId,
			Facility.FacilityId,
			Customer.CustomerName,
			Customer.CustomerCode,
			Facility.FacilityName,
			Facility.FacilityCode,
			Facility.Address as Address1,
			Facility.Address2,
			Facility.PostCode,
			Facility.State,
			Facility.Country,
				Facility.ContactNo         As PhoneNumber,
			Facility.FaxNo             As FaxNumber,
			CASE 
			WHEN WeekEnds.Item='1' then 'Sunday' 
			WHEN WeekEnds.Item='2' then 'Monday' 
			WHEN WeekEnds.Item='3' then 'Tuesday' 
			WHEN WeekEnds.Item='4' then 'Wednesday' 
			WHEN WeekEnds.Item='5' then 'Thursday' 
			WHEN WeekEnds.Item='6' then 'Friday' 
			WHEN WeekEnds.Item='7' then 'Saturday' 
			end  as WeekEnds,
			Facility.Latitude,
			Facility.Longitude,
			 CAST(Facility.ActiveFrom AS DATE)	AS	ActiveFrom,
			CAST(Facility.ActiveTo	 AS DATE)		AS	ActiveTo,
			Facility.ContractPeriodInMonths,
			--Lov1.FieldValue as TypeofContract,
			Facility.InitialProjectCost AS InitialProjectCost,
			Lov2.FieldValue as TypeofNomenclature,
			Lov2.FieldValue as LifeExpectancy,
			Facility.MonthlyServiceFee,
			FacilityInfo.Name,
			FacilityInfo.Designation,
			FacilityInfo.ContactNo,
			FacilityInfo.Email,
			Facility.ModifiedDateUTC
	FROM	MstLocationFacility Facility	WITH(NOLOCK)
			INNER JOIN MstCustomer Customer	WITH(NOLOCK)	ON Facility.CustomerId	=	Customer.CustomerId
			--INNER JOIN FmLovMst Lov1 WITH(NOLOCK) ON Facility.TypeOfContractLovId=Lov1.LovId
			INNER JOIN FmLovMst Lov2 WITH(NOLOCK) ON Facility.TypeOfNomenclature=Lov2.LovId
			INNER JOIN FmLovMst Lov3 WITH(NOLOCK) ON Facility.TypeOfNomenclature=Lov3.LovId
			LEFT JOIN MstLocationFacilityContactInfo FacilityInfo WITH(NOLOCK)	ON Facility.FacilityId=FacilityInfo.FacilityId
			OUTER APPLY SplitString(Facility.WeeklyHoliday,',') WeekEnds
	WHERE Facility.Active = 1 


	----Select * from MstLocationFacility
GO
