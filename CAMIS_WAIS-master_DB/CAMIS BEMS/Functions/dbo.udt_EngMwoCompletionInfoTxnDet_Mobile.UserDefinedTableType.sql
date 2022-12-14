USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoCompletionInfoTxnDet_Mobile]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngMwoCompletionInfoTxnDet_Mobile] AS TABLE(
	[CompletionInfoDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[StaffMasterId] [int] NULL,
	[StandardTaskDetId] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[StartDateTimeUTC] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL,
	[UserId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[MobileGuid] [nvarchar](max) NULL
)
GO
