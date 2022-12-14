USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenInjectionTxnDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenInjectionTxnDet] AS TABLE(
	[LinenInjectionId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LinenItemId] [int] NULL,
	[QuantityInjected] [int] NOT NULL,
	[TestReport] [nvarchar](150) NULL,
	[LifeSpanValidity] [datetime] NULL,
	[CreatedBy] [int] NOT NULL
)
GO
