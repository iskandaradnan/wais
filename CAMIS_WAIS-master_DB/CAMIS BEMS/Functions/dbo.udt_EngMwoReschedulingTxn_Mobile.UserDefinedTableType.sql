USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoReschedulingTxn_Mobile]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngMwoReschedulingTxn_Mobile] AS TABLE(
	[WorkOrderReschedulingId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[RescheduleApprovedBy] [int] NULL,
	[WorkOrderId] [int] NULL,
	[RescheduleDate] [datetime] NULL,
	[RescheduleDateUTC] [datetime] NULL,
	[Reason] [int] NULL,
	[ImpactSchedulePlanner] [bit] NULL,
	[UserId] [int] NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [varbinary](max) NULL
)
GO
