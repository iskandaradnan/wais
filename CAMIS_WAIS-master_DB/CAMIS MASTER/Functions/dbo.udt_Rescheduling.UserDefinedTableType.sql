USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_Rescheduling]    Script Date: 20-09-2021 16:50:20 ******/
CREATE TYPE [dbo].[udt_Rescheduling] AS TABLE(
	[WorkOrderId] [int] NULL,
	[AssetId] [int] NULL,
	[AssignedUserId] [int] NULL,
	[RescheduleDate] [datetime] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserId] [int] NULL,
	[Remarks] [nvarchar](500) NULL
)
GO
