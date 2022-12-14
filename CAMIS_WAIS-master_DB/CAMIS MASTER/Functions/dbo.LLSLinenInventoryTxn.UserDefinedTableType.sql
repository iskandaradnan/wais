USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenInventoryTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenInventoryTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[StoreType] [nvarchar](50) NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[Date] [datetime] NOT NULL,
	[UserAreaId] [int] NULL,
	[VerifiedBy] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
