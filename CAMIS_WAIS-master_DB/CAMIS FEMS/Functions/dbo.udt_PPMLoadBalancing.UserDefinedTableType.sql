USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_PPMLoadBalancing]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_PPMLoadBalancing] AS TABLE(
	[WorkOrderId] [int] NULL,
	[TargetDateTime] [datetime] NULL,
	[NewAssigneeId] [int] NULL,
	[UserId] [int] NULL,
	[Timestamp] [varbinary](200) NULL
)
GO
