USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequestAssessment_Mobile]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_CRMRequestAssessment_Mobile] AS TABLE(
	[CRMAssesmentId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[CRMRequestWOId] [int] NULL,
	[StaffMasterId] [int] NULL,
	[FeedBack] [nvarchar](1000) NULL,
	[AssessmentStartDateTime] [datetime] NULL,
	[AssessmentStartDateTimeUTC] [datetime] NULL,
	[AssessmentEndDateTime] [datetime] NULL,
	[AssessmentEndDateTimeUTC] [datetime] NULL,
	[UserId] [int] NULL
)
GO
