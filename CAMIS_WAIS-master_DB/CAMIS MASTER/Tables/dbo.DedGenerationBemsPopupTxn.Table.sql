USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[DedGenerationBemsPopupTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedGenerationBemsPopupTxn](
	[BEMSDedGenerationPopupId] [int] IDENTITY(1,1) NOT NULL,
	[DedGenerationId] [int] NOT NULL,
	[FacilityId] [int] NULL,
	[ServiceWorkDateTime] [datetime] NULL,
	[ID] [int] NOT NULL,
	[ServiceRequestNo] [nvarchar](200) NULL,
	[ServiceWorkNo] [nvarchar](200) NULL,
	[AssetNo] [nvarchar](102) NULL,
	[AssetDescription] [nvarchar](510) NULL,
	[WorkGroup] [nvarchar](500) NULL,
	[AssetTypeCode] [nvarchar](200) NULL,
	[UnderWarranty] [nvarchar](50) NULL,
	[Requestor] [nvarchar](150) NULL,
	[ResponseDateTime] [datetime] NULL,
	[RepsonseDurationHrs] [nvarchar](50) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[WorkOrderStatus] [nvarchar](150) NULL,
	[DowntimeHrs] [nvarchar](50) NULL,
	[Type] [nvarchar](200) NULL,
	[TargetDate] [datetime] NULL,
	[UserLocationCode] [nvarchar](150) NULL,
	[TaskCode] [nvarchar](150) NULL,
	[SCMAgreedDate] [datetime] NULL,
	[TypeofTransaction] [nvarchar](150) NULL,
	[PurchaseCost] [numeric](30, 2) NULL,
	[DemeritValue1] [int] NULL,
	[DemeritValue2] [int] NULL,
	[DemeritPoint] [int] NULL,
	[DeductionValue] [numeric](30, 2) NULL,
	[TCDocumentNo] [nvarchar](150) NULL,
	[SRDateTime] [datetime] NULL,
	[RequiredDateTime] [datetime] NULL,
	[SRDetails] [nvarchar](1000) NULL,
	[TCStatus] [nvarchar](150) NULL,
	[PurchaseCostRM] [numeric](20, 2) NULL,
	[IndicatorNo] [varchar](100) NULL,
	[SubParameterDetId] [int] NULL,
	[Month] [int] NULL,
	[Year] [int] NULL,
	[IsNCR] [bit] NULL,
	[TCDate] [datetime] NULL,
	[TCCompletedDate] [datetime] NULL,
	[NCRNo] [nvarchar](100) NULL,
	[NCRDateTime] [datetime] NULL,
	[IsDemerit] [bit] NULL,
	[TotalDeduction] [int] NULL,
	[GroupFlag] [nvarchar](50) NULL,
	[TotalTransactionCount] [int] NULL,
	[RescheduleDate] [datetime] NULL,
	[PurchaseDate] [datetime] NULL,
	[TargetPercentage] [numeric](4, 2) NULL,
	[ServiceWorkComplaintDetails] [nvarchar](2000) NULL,
	[ResponseCategory] [nvarchar](100) NULL,
	[ServiceWorkCompletionDate] [datetime] NULL,
	[ServiceWorkDate] [datetime] NULL,
	[DeductionValueperasset] [int] NULL,
	[B1Deduction] [int] NULL,
	[B2DemeritPoint] [int] NULL,
	[B2Deduction] [int] NULL,
	[TotalResponseTime] [int] NULL,
	[B2TotalRepairTime] [int] NULL,
	[AssetAge] [int] NULL,
	[GenPercentage] [int] NULL,
	[DemeritSlab] [int] NULL,
	[DedValue] [int] NULL,
	[FirstPrevDed] [int] NULL,
	[SecPrevDed] [int] NULL,
	[AssetRegisterId] [int] NULL,
	[VariationPurchaseCost] [numeric](15, 2) NULL,
	[Deduction] [numeric](15, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DedGenerationBemsPopupTxn] PRIMARY KEY CLUSTERED 
(
	[BEMSDedGenerationPopupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DedGenerationBemsPopupTxn] ADD  CONSTRAINT [DF_DedGenerationBemsPopupTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
