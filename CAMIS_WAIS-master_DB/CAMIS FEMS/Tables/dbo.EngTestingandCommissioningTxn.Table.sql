USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngTestingandCommissioningTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngTestingandCommissioningTxn](
	[TestingandCommissioningId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[TandCDocumentNo] [nvarchar](50) NOT NULL,
	[TandCDate] [datetime] NOT NULL,
	[TandCDateUTC] [datetime] NOT NULL,
	[AssetTypeCodeId] [int] NULL,
	[TandCStatus] [int] NOT NULL,
	[TandCCompletedDate] [datetime] NULL,
	[TandCCompletedDateUTC] [datetime] NULL,
	[HandoverDate] [datetime] NULL,
	[HandoverDateUTC] [datetime] NULL,
	[PurchaseCost] [numeric](24, 2) NULL,
	[PurchaseDate] [datetime] NULL,
	[PurchaseDateUTC] [datetime] NULL,
	[ServiceStartDate] [datetime] NULL,
	[ServiceStartDateUTC] [datetime] NULL,
	[ContractLPONo] [nvarchar](100) NULL,
	[VariationStatus] [int] NOT NULL,
	[TandCContractorRepresentative] [nvarchar](150) NULL,
	[CustomerRepresentativeUserId] [int] NULL,
	[FacilityRepresentativeUserId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[WarrantyDuration] [int] NULL,
	[WarrantyStartDate] [datetime] NULL,
	[WarrantyStartDateUTC] [datetime] NULL,
	[WarrantyEndDate] [datetime] NULL,
	[WarrantyEndDateUTC] [datetime] NULL,
	[MainSupplierCode] [nvarchar](50) NULL,
	[MainSupplierName] [nvarchar](100) NULL,
	[ServiceEndDate] [datetime] NULL,
	[ServiceEndDateUTC] [datetime] NULL,
	[Status] [int] NULL,
	[VerifyRemarks] [nvarchar](500) NULL,
	[ApprovalRemarks] [nvarchar](500) NULL,
	[RejectRemarks] [nvarchar](500) NULL,
	[AssetId] [int] NULL,
	[QRCode] [varbinary](max) NULL,
	[AssetCategoryLovId] [int] NULL,
	[ManufacturerId] [int] NULL,
	[ModelId] [int] NULL,
	[AssetNoOld] [nvarchar](100) NULL,
	[SerialNo] [nvarchar](100) NULL,
	[PONo] [nvarchar](100) NULL,
	[RequiredCompletionDate] [datetime] NULL,
	[PurchaseOrderNo] [nvarchar](100) NULL,
	[IsSNF] [bit] NOT NULL,
	[Field1] [nvarchar](500) NULL,
	[Field2] [nvarchar](500) NULL,
	[Field3] [nvarchar](500) NULL,
	[Field4] [nvarchar](500) NULL,
	[Field5] [nvarchar](500) NULL,
	[Field6] [nvarchar](500) NULL,
	[Field7] [nvarchar](500) NULL,
	[Field8] [nvarchar](500) NULL,
	[Field9] [nvarchar](500) NULL,
	[Field10] [nvarchar](500) NULL,
	[ContractorId] [int] NULL,
	[TandCFailedDate] [datetime] NULL,
	[IsMailSent] [bit] NULL,
	[CRMRequestId] [int] NULL,
	[RequestDate] [datetime] NULL,
	[RequestDateUTC] [datetime] NULL,
	[BatchNo] [varchar](100) NULL,
 CONSTRAINT [PK_EngTestingandCommissioningTxn] PRIMARY KEY CLUSTERED 
(
	[TestingandCommissioningId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] ADD  CONSTRAINT [DF_EngTestingandCommissioningTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] ADD  CONSTRAINT [DF_EngTestingandCommissioningTxn_IsSNF]  DEFAULT ((0)) FOR [IsSNF]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] ADD  CONSTRAINT [DF_EngTestingandCommissioningTxn_IsMailSent]  DEFAULT ((0)) FOR [IsMailSent]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxn_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxn_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxn_UMUserRegistration_CustomerRepresentativeUserId] FOREIGN KEY([CustomerRepresentativeUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxn_UMUserRegistration_CustomerRepresentativeUserId]
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngTestingandCommissioningTxn_UMUserRegistration_FacilityRepresentativeUserId] FOREIGN KEY([FacilityRepresentativeUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngTestingandCommissioningTxn] CHECK CONSTRAINT [FK_EngTestingandCommissioningTxn_UMUserRegistration_FacilityRepresentativeUserId]
GO
