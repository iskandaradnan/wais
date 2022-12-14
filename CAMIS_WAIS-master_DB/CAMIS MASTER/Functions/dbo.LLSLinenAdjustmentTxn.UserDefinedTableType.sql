USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenAdjustmentTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenAdjustmentTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[DocumentDate] [datetime] NOT NULL,
	[AuthorisedBy] [nvarchar](150) NOT NULL,
	[LinenInventoryId] [int] NULL,
	[Date] [datetime] NULL,
	[Status] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
