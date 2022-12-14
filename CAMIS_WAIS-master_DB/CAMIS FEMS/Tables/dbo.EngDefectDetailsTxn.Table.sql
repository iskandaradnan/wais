USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngDefectDetailsTxn]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngDefectDetailsTxn](
	[DefectId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[AssetId] [int] NULL,
	[TestingandCommissioningId] [int] NULL,
	[DefectNo] [nvarchar](100) NULL,
	[DefectDate] [datetime] NOT NULL,
	[DefectFlag] [int] NOT NULL,
	[DefectType] [int] NULL,
	[ClosedDateTime] [datetime] NULL,
	[ClosedDateTimeUTC] [datetime] NULL,
	[Duration] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngDefectDetailsTxn] PRIMARY KEY CLUSTERED 
(
	[DefectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn] ADD  CONSTRAINT [DF_EngDefectDetailsTxn]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngDefectDetailsTxn_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn] CHECK CONSTRAINT [FK_EngDefectDetailsTxn_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngDefectDetailsTxn_EngTestingandCommissioningTxn_TestingandCommissioningId] FOREIGN KEY([TestingandCommissioningId])
REFERENCES [dbo].[EngTestingandCommissioningTxn] ([TestingandCommissioningId])
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn] CHECK CONSTRAINT [FK_EngDefectDetailsTxn_EngTestingandCommissioningTxn_TestingandCommissioningId]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngDefectDetailsTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn] CHECK CONSTRAINT [FK_EngDefectDetailsTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngDefectDetailsTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn] CHECK CONSTRAINT [FK_EngDefectDetailsTxn_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn]  WITH CHECK ADD  CONSTRAINT [FK_EngDefectDetailsTxn_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngDefectDetailsTxn] CHECK CONSTRAINT [FK_EngDefectDetailsTxn_MstService_ServiceId]
GO
