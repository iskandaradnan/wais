USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCentralLinenStoreHKeepingTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCentralLinenStoreHKeepingTxnDet] AS TABLE(
	[HouseKeepingId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Date] [date] NULL,
	[HousekeepingDone] [int] NULL,
	[DateTimeStamp] [datetime] NULL,
	[CreatedBy] [int] NOT NULL
)
GO
