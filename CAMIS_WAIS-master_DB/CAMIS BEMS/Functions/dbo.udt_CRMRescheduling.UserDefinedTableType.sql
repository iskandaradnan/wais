USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRescheduling]    Script Date: 20-09-2021 17:09:18 ******/
CREATE TYPE [dbo].[udt_CRMRescheduling] AS TABLE(
	[CRMRequestWOId] [int] NULL,
	[AssignedUserId] [int] NULL
)
GO
