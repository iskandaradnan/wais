USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_QAPCarTxnDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_QAPCarTxnDet] AS TABLE(
	[CarDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[CarId] [int] NULL,
	[Activity] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL,
	[TargetDate] [datetime] NULL,
	[CompletedDate] [datetime] NULL,
	[ResponsiblePersonUserId] [int] NULL,
	[ResponsibilityId] [int] NULL,
	[IsDeleted] [bit] NULL
)
GO
