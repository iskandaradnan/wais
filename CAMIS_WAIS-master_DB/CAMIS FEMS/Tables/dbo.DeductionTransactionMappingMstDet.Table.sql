USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[DeductionTransactionMappingMstDet]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionTransactionMappingMstDet](
	[DedTxnMappingDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DedTxnMappingId] [int] NOT NULL,
	[Date] [datetime] NULL,
	[DocumentNo] [nvarchar](100) NULL,
	[Details] [nvarchar](1000) NULL,
	[DemeritPoint] [int] NULL,
	[IsValid] [bit] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[DeductionValue] [int] NULL,
	[FinalDemeritPoint] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[AssetNo] [nvarchar](100) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[DisputedPendingResolution] [int] NULL,
 CONSTRAINT [PK_DeductionTransactionMappingMstDet] PRIMARY KEY CLUSTERED 
(
	[DedTxnMappingDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeductionTransactionMappingMstDet] ADD  CONSTRAINT [DF_DeductionTransactionMappingMstDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
