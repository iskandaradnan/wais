USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRescheduling]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[udt_CRMRescheduling] AS TABLE(
	[CRMRequestWOId] [int] NULL,
	[AssignedUserId] [int] NULL
)
GO
