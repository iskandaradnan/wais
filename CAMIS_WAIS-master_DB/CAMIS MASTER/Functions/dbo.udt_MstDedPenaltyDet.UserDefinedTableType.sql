USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_MstDedPenaltyDet]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_MstDedPenaltyDet] AS TABLE(
	[PenaltyDetId] [int] NULL,
	[ServiceId] [int] NULL,
	[PenaltyId] [int] NULL,
	[CriteriaId] [int] NULL,
	[Status] [int] NULL
)
GO
