USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[QAPCarTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QAPCarTxn](
	[CarId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[CARNumber] [nvarchar](50) NOT NULL,
	[CARDate] [datetime] NOT NULL,
	[CARDateUTC] [datetime] NULL,
	[QAPIndicatorId] [int] NULL,
	[AssetId] [int] NULL,
	[FromDate] [datetime] NULL,
	[FromDateUTC] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[ToDateUTC] [datetime] NULL,
	[FollowupCARId] [int] NULL,
	[ProblemStatement] [nvarchar](500) NOT NULL,
	[PriorityLovId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[IssuerUserId] [int] NULL,
	[VerifiedDate] [datetime] NULL,
	[VerifiedDateUTC] [datetime] NULL,
	[VerifiedBy] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[ExpectedPercentage] [numeric](24, 2) NULL,
	[ActualPercentage] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[AssignedUserId] [int] NULL,
	[IsAutoCar] [bit] NOT NULL,
	[CARStatus] [int] NULL,
	[CARTargetDate] [datetime] NULL,
 CONSTRAINT [PK_QAPCarTxn] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QAPCarTxn] ADD  CONSTRAINT [DF_QAPCarTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[QAPCarTxn] ADD  CONSTRAINT [DF_QAPCarTxn_IsAutoCar]  DEFAULT ((0)) FOR [IsAutoCar]
GO
ALTER TABLE [dbo].[QAPCarTxn]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[QAPCarTxn] CHECK CONSTRAINT [FK_QAPCarTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[QAPCarTxn]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxn_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[QAPCarTxn] CHECK CONSTRAINT [FK_QAPCarTxn_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[QAPCarTxn]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[QAPCarTxn] CHECK CONSTRAINT [FK_QAPCarTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[QAPCarTxn]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxn_MstQAPIndicator_QAPIndicatorId] FOREIGN KEY([QAPIndicatorId])
REFERENCES [dbo].[MstQAPIndicator] ([QAPIndicatorId])
GO
ALTER TABLE [dbo].[QAPCarTxn] CHECK CONSTRAINT [FK_QAPCarTxn_MstQAPIndicator_QAPIndicatorId]
GO
ALTER TABLE [dbo].[QAPCarTxn]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[QAPCarTxn] CHECK CONSTRAINT [FK_QAPCarTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[QAPCarTxn]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarTxn_UMUserRegistration_IssuerUserId] FOREIGN KEY([IssuerUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[QAPCarTxn] CHECK CONSTRAINT [FK_QAPCarTxn_UMUserRegistration_IssuerUserId]
GO
