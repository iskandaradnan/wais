USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSWeighingScaleMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSWeighingScaleMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[IssuedBy] [nvarchar](100) NOT NULL,
	[ItemDescription] [nvarchar](255) NULL,
	[SerialNo] [nvarchar](100) NULL,
	[IssuedDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[Status] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
