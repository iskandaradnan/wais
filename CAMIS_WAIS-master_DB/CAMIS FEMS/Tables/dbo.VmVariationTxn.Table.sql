USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[VmVariationTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VmVariationTxn](
	[VariationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[SNFDocumentNo] [nvarchar](50) NOT NULL,
	[SnfDate] [date] NOT NULL,
	[AssetId] [int] NULL,
	[AssetClassification] [int] NULL,
	[VariationStatus] [int] NOT NULL,
	[PurchaseProjectCost] [numeric](24, 2) NULL,
	[VariationDate] [datetime] NULL,
	[VariationDateUTC] [datetime] NULL,
	[StartServiceDate] [datetime] NULL,
	[StartServiceDateUTC] [datetime] NULL,
	[ServiceStopDate] [datetime] NULL,
	[ServiceStopDateUTC] [datetime] NULL,
	[CommissioningDate] [datetime] NULL,
	[CommissioningDateUTC] [datetime] NULL,
	[WarrantyDurationMonth] [int] NULL,
	[WarrantyStartDate] [datetime] NULL,
	[WarrantyStartDateUTC] [datetime] NULL,
	[WarrantyEndDate] [datetime] NULL,
	[WarrantyEndDateUTC] [datetime] NULL,
	[ClosingMonth] [int] NULL,
	[ClosingYear] [int] NULL,
	[VariationApprovedStatus] [int] NULL,
	[OldUsage] [nvarchar](150) NULL,
	[NewUsage] [nvarchar](150) NULL,
	[UserLocation] [nvarchar](150) NULL,
	[Justification] [nvarchar](500) NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedDateUTC] [datetime] NULL,
	[ApprovedAmount] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[AuthorizedStatus] [bit] NULL,
	[IsMonthClosed] [bit] NULL,
	[Period] [int] NULL,
	[PaymentStartDate] [datetime] NULL,
	[PaymentStartDateUTC] [datetime] NULL,
	[PWPaymentStartDate] [datetime] NULL,
	[PWPaymentStartDateUTC] [datetime] NULL,
	[ProposedRateDW] [numeric](10, 2) NULL,
	[ProposedRatePW] [numeric](10, 2) NULL,
	[MonthlyProposedFeeDW] [numeric](10, 2) NULL,
	[MonthlyProposedFeePW] [numeric](10, 2) NULL,
	[CalculatedFeePW] [numeric](10, 2) NULL,
	[CalculatedFeeDW] [numeric](10, 2) NULL,
	[VariationRaisedDate] [datetime] NULL,
	[VariationRaisedDateUTC] [datetime] NULL,
	[AssetOldVariationData] [bit] NULL,
	[VariationWFStatus] [int] NULL,
	[DoneBy] [int] NULL,
	[DoneDate] [datetime] NULL,
	[DoneDateUTC] [datetime] NULL,
	[DoneRemarks] [nvarchar](500) NULL,
	[IsVerify] [bit] NULL,
	[GovernmentAssetNo] [nvarchar](50) NULL,
	[GovernmentAssetNoDescription] [nvarchar](250) NULL,
	[PurchaseDate] [datetime] NULL,
	[PurchaseDateUTC] [datetime] NULL,
	[VariationPurchaseCost] [numeric](24, 2) NULL,
	[ContractCost] [numeric](8, 2) NULL,
	[ContractLpoNo] [nvarchar](100) NULL,
	[CompanyAssetPraId] [int] NULL,
	[CompanyAssetRegId] [int] NULL,
	[WarrantyProvision] [int] NULL,
	[UserAreaId] [int] NULL,
	[AOId] [int] NULL,
	[AODate] [datetime] NULL,
	[AODateUTC] [datetime] NULL,
	[JOHNId] [int] NULL,
	[JOHNDate] [datetime] NULL,
	[JOHNDateUTC] [datetime] NULL,
	[HosDirectorId] [int] NULL,
	[HosDirectorDate] [datetime] NULL,
	[HosDirectorDateUTC] [datetime] NULL,
	[AvailableCost] [numeric](10, 2) NULL,
	[MainSupplierCode] [nvarchar](25) NULL,
	[MainSupplierName] [nvarchar](75) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[ContractType] [int] NULL,
	[AGEID] [int] NULL,
	[ChassisNo] [nvarchar](100) NULL,
	[EngineNo] [nvarchar](100) NULL,
 CONSTRAINT [PK_VmVariationDetailsTxn] PRIMARY KEY CLUSTERED 
(
	[VariationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VmVariationTxn] ADD  CONSTRAINT [DF_VmVariationDetailsTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[VmVariationTxn]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[VmVariationTxn] CHECK CONSTRAINT [FK_VmVariationTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[VmVariationTxn]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[VmVariationTxn] CHECK CONSTRAINT [FK_VmVariationTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[VmVariationTxn]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[VmVariationTxn] CHECK CONSTRAINT [FK_VmVariationTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[VmVariationTxn]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[VmVariationTxn] CHECK CONSTRAINT [FK_VmVariationTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[VmVariationTxn]  WITH CHECK ADD  CONSTRAINT [FK_VmVariationTxn_UMUserRegistration_DoneBy] FOREIGN KEY([DoneBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[VmVariationTxn] CHECK CONSTRAINT [FK_VmVariationTxn_UMUserRegistration_DoneBy]
GO
