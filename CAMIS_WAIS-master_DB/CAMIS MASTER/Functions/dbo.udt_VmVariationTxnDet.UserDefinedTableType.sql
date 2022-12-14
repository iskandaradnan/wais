USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_VmVariationTxnDet]    Script Date: 20-09-2021 16:50:20 ******/
CREATE TYPE [dbo].[udt_VmVariationTxnDet] AS TABLE(
	[VariationDetId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[VariationId] [int] NULL,
	[VariationWFStatus] [int] NULL,
	[DoneBy] [int] NULL,
	[DoneDate] [datetime] NULL,
	[DoneRemarks] [nvarchar](1000) NULL,
	[IsVerify] [bit] NULL
)
GO
