USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_UMUserShiftsDet]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_UMUserShiftsDet] AS TABLE(
	[UserShiftDetId] [int] NULL,
	[LeaveFrom] [datetime] NULL,
	[LeaveTo] [datetime] NULL,
	[NoOfDays] [numeric](18, 0) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[UserId] [int] NULL
)
GO
