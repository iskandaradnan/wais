USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSLinenInjectionTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSLinenInjectionTxnDet](
	[LinenInjectionDetId] [int] IDENTITY(1,1) NOT NULL,
	[LinenInjectionId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LinenItemId] [int] NULL,
	[QuantityInjected] [int] NOT NULL,
	[TestReport] [nvarchar](150) NULL,
	[LifeSpanValidity] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
	[LinenPrice] [numeric](18, 5) NULL,
 CONSTRAINT [PK_LLSLinenInjectionTxnDet] PRIMARY KEY CLUSTERED 
(
	[LinenInjectionDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
