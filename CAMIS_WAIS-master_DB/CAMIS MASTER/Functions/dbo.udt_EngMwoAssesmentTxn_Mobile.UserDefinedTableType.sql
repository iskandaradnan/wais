USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoAssesmentTxn_Mobile]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngMwoAssesmentTxn_Mobile] AS TABLE(
	[AssesmentId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[StaffMasterId] [int] NULL,
	[Justification] [nvarchar](1000) NULL,
	[ResponseDateTime] [datetime] NULL,
	[ResponseDateTimeUTC] [datetime] NULL,
	[ResponseDuration] [numeric](24, 2) NULL,
	[AssetRealtimeStatus] [int] NULL,
	[TargetDateTime] [datetime] NULL,
	[IsChangeToVendor] [int] NULL,
	[AssignedVendor] [int] NULL,
	[UserId] [int] NULL,
	[Signature] [varbinary](max) NULL
)
GO
