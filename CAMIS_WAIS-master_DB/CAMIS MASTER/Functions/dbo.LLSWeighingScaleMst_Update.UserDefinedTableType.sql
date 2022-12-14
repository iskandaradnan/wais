USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSWeighingScaleMst_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSWeighingScaleMst_Update] AS TABLE(
	[IssuedBy] [nvarchar](300) NULL,
	[ItemDescription] [nvarchar](600) NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[Status] [int] NULL,
	[WeighingScaleId] [int] NULL
)
GO
