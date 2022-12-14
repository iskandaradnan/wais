USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenInjectionTxn]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenInjectionTxn] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[InjectionDate] [datetime] NOT NULL,
	[DONo] [nvarchar](50) NULL,
	[PONo] [nvarchar](50) NULL,
	[DODate] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
