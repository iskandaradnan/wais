USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngPPMRegisterMst]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngPPMRegisterMst](
	[PPMId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetTypeCodeId] [int] NOT NULL,
	[StandardTaskDetId] [int] NULL,
	[PPMChecklistNo] [nvarchar](25) NULL,
	[ManufacturerId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[PPMFrequency] [int] NOT NULL,
	[PPMHours] [numeric](24, 2) NULL,
	[BemsTaskCode] [nvarchar](50) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EHRMHeppmId] PRIMARY KEY CLUSTERED 
(
	[PPMId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] ADD  CONSTRAINT [DF_EngPPMRegisterMst_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] ADD  CONSTRAINT [DF_EngPPMRegisterMst_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] ADD  CONSTRAINT [DF_EngPPMRegisterMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterMst_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] CHECK CONSTRAINT [FK_EngPPMRegisterMst_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterMst_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] CHECK CONSTRAINT [FK_EngPPMRegisterMst_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterMst_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] CHECK CONSTRAINT [FK_EngPPMRegisterMst_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterMst_EngAssetTypeCodeStandardTasksDet_StandardTaskDetId] FOREIGN KEY([StandardTaskDetId])
REFERENCES [dbo].[EngAssetTypeCodeStandardTasksDet] ([StandardTaskDetId])
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] CHECK CONSTRAINT [FK_EngPPMRegisterMst_EngAssetTypeCodeStandardTasksDet_StandardTaskDetId]
GO
ALTER TABLE [dbo].[EngPPMRegisterMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterMst_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngPPMRegisterMst] CHECK CONSTRAINT [FK_EngPPMRegisterMst_MstService_ServiceId]
GO
