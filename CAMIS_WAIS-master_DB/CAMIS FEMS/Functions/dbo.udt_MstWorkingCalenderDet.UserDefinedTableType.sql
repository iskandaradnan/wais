USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstWorkingCalenderDet]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_MstWorkingCalenderDet] AS TABLE(
	[CalenderDetId] [int] NULL,
	[CalenderId] [int] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[Day] [int] NULL,
	[IsWorking] [bit] NULL,
	[Remarks] [nvarchar](500) NULL
)
GO
