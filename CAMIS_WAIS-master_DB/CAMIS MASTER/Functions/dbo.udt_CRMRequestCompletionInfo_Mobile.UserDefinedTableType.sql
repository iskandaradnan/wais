USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequestCompletionInfo_Mobile]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[udt_CRMRequestCompletionInfo_Mobile] AS TABLE(
	[CRMCompletionInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[CRMRequestWOId] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[StartDateTimeUTC] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL,
	[HandoverDateTime] [datetime] NULL,
	[HandoverDateTimeUTC] [datetime] NULL,
	[HandoverDelay] [int] NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [varbinary](max) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[UserId] [int] NULL,
	[CompletedBy] [int] NULL,
	[CompPositionId] [int] NULL,
	[CompletedRemarks] [nvarchar](1000) NULL
)
GO
