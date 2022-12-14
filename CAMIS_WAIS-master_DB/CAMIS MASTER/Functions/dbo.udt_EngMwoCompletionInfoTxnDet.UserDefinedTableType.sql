USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoCompletionInfoTxnDet]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngMwoCompletionInfoTxnDet] AS TABLE(
	[CompletionInfoDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[StaffMasterId] [int] NULL,
	[StandardTaskDetId] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[StartDateTimeUTC] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL
)
GO
