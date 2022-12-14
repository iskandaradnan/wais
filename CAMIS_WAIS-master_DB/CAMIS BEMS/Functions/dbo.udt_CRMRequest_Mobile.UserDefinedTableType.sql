USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequest_Mobile]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_CRMRequest_Mobile] AS TABLE(
	[CRMRequestId] [int] NULL,
	[UserId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[RequestNo] [nvarchar](100) NULL,
	[RequestDateTime] [datetime] NULL,
	[RequestDateTimeUTC] [datetime] NULL,
	[RequestStatus] [int] NULL,
	[RequestDescription] [nvarchar](1000) NULL,
	[TypeOfRequest] [int] NULL,
	[Remarks] [nvarchar](1000) NULL,
	[ModelId] [int] NULL,
	[Manufacturerid] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[Flag] [nvarchar](200) NULL,
	[MasterGuid] [nvarchar](max) NOT NULL,
	[TargetDate] [datetime] NULL,
	[RequestedPerson] [int] NULL,
	[AssigneeId] [int] NULL
)
GO
