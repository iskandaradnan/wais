USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[BERApplicationTxn]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BERApplicationTxn](
	[ApplicationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[BERno] [nvarchar](50) NULL,
	[AssetId] [int] NULL,
	[EstRepcostToExpensive] [bit] NULL,
	[RepairEstimate] [numeric](24, 2) NULL,
	[ValueAfterRepair] [numeric](24, 2) NULL,
	[EstDurUsgAfterRepair] [numeric](12, 2) NULL,
	[NotReliable] [bit] NULL,
	[StatutoryRequirements] [bit] NULL,
	[OtherObservations] [nvarchar](500) NULL,
	[ApplicantUserId] [int] NOT NULL,
	[BERStatus] [int] NULL,
	[BER2TechnicalCondition] [nvarchar](500) NULL,
	[BER2RepairedWell] [nvarchar](250) NULL,
	[BER2SafeReliable] [nvarchar](500) NULL,
	[BER2EstimateLifeTime] [nvarchar](500) NULL,
	[BER2Syor] [nvarchar](250) NULL,
	[BER2Remarks] [nvarchar](500) NULL,
	[TBER2StillLifeSpan] [bit] NULL,
	[BIL] [nvarchar](100) NULL,
	[BER1Remarks] [nvarchar](500) NULL,
	[ParentApplicationId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedDateUTC] [datetime] NULL,
	[JustificationForCertificates] [nvarchar](500) NULL,
	[ApplicationDate] [date] NOT NULL,
	[RejectedBERReferenceId] [int] NULL,
	[BER2TechnicalConditionOthers] [nvarchar](500) NULL,
	[BER2SafeReliableOthers] [nvarchar](500) NULL,
	[BER2EstimateLifeTimeOthers] [nvarchar](500) NULL,
	[BERStage] [int] NOT NULL,
	[CircumstanceOthers] [nvarchar](500) NULL,
	[ExaminationFirstResultOthers] [nvarchar](250) NULL,
	[EstimatedRepairCost] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[CurrentValue] [numeric](24, 2) NULL,
	[RequestorUserId] [int] NULL,
	[Obsolescence] [bit] NULL,
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
	[CurrentRepairCost] [numeric](24, 2) NULL,
	[CannotRepair] [bit] NOT NULL,
 CONSTRAINT [PK_BERApplicationTxn] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BERApplicationTxn] ADD  CONSTRAINT [DF_BERApplicationTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[BERApplicationTxn] ADD  DEFAULT ((0)) FOR [CannotRepair]
GO
ALTER TABLE [dbo].[BERApplicationTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[BERApplicationTxn] CHECK CONSTRAINT [FK_BERApplicationTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[BERApplicationTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[BERApplicationTxn] CHECK CONSTRAINT [FK_BERApplicationTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[BERApplicationTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[BERApplicationTxn] CHECK CONSTRAINT [FK_BERApplicationTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[BERApplicationTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[BERApplicationTxn] CHECK CONSTRAINT [FK_BERApplicationTxn_MstService_ServiceId]
GO
ALTER TABLE [dbo].[BERApplicationTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationTxn_UMUserRegistration_ApplicantUserId] FOREIGN KEY([ApplicantUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[BERApplicationTxn] CHECK CONSTRAINT [FK_BERApplicationTxn_UMUserRegistration_ApplicantUserId]
GO
ALTER TABLE [dbo].[BERApplicationTxn]  WITH CHECK ADD  CONSTRAINT [FK_BERApplicationTxn_UMUserRegistration_RequestorUserId] FOREIGN KEY([RequestorUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[BERApplicationTxn] CHECK CONSTRAINT [FK_BERApplicationTxn_UMUserRegistration_RequestorUserId]
GO
