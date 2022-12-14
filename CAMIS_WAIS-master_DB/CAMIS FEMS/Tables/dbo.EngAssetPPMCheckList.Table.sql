USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckList]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckList](
	[PPMCheckListId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[AssetTypeCodeId] [int] NULL,
	[PPMChecklistNo] [nvarchar](60) NULL,
	[ManufacturerId] [int] NULL,
	[ModelId] [int] NULL,
	[PPMFrequency] [int] NULL,
	[PpmHours] [numeric](24, 2) NULL,
	[SpecialPrecautions] [nvarchar](1000) NULL,
	[DoneBy] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[Description] [nvarchar](255) NULL,
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
	[TaskCode] [nvarchar](50) NOT NULL,
	[TaskDescription] [nvarchar](550) NULL,
	[VersionNo] [numeric](24, 2) NULL,
	[Model] [varchar](1000) NULL,
	[Manufacturer] [varchar](1000) NULL,
	[AssetTypeCode] [varchar](1000) NULL,
 CONSTRAINT [PK_EngAssetPPMCheckList] PRIMARY KEY CLUSTERED 
(
	[PPMCheckListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] ADD  CONSTRAINT [DF_EngAssetPPMCheckList_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] ADD  CONSTRAINT [DF_EngAssetPPMCheckList_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] ADD  CONSTRAINT [DF_EngAssetPPMCheckList_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckList_EngAssetStandardizationManufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[EngAssetStandardizationManufacturer] ([ManufacturerId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] CHECK CONSTRAINT [FK_EngAssetPPMCheckList_EngAssetStandardizationManufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckList_EngAssetStandardizationModel_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[EngAssetStandardizationModel] ([ModelId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] CHECK CONSTRAINT [FK_EngAssetPPMCheckList_EngAssetStandardizationModel_ModelId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckList_EngAssetTypeCode_AssetTypeCodeId] FOREIGN KEY([AssetTypeCodeId])
REFERENCES [dbo].[EngAssetTypeCode] ([AssetTypeCodeId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] CHECK CONSTRAINT [FK_EngAssetPPMCheckList_EngAssetTypeCode_AssetTypeCodeId]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetPPMCheckList_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetPPMCheckList] CHECK CONSTRAINT [FK_EngAssetPPMCheckList_MstService_ServiceId]
GO
