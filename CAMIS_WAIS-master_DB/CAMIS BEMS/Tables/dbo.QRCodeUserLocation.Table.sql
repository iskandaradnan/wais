USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[QRCodeUserLocation]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QRCodeUserLocation](
	[QRCodeUserLocationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[BlockId] [int] NULL,
	[LevelId] [int] NULL,
	[UserAreaId] [int] NOT NULL,
	[UserLocationId] [int] NOT NULL,
	[QRCodeSize1] [varbinary](max) NOT NULL,
	[QRCodeSize2] [varbinary](max) NULL,
	[QRCodeSize3] [varbinary](max) NULL,
	[QRCodeSize4] [varbinary](max) NULL,
	[QRCodeSize5] [varbinary](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[BatchGenerated] [nvarchar](200) NULL,
 CONSTRAINT [PK_QRCodeUserLocation] PRIMARY KEY CLUSTERED 
(
	[QRCodeUserLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[QRCodeUserLocation] ADD  CONSTRAINT [DF_QRCodeUserLocation_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[QRCodeUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserLocation_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[QRCodeUserLocation] CHECK CONSTRAINT [FK_QRCodeUserLocation_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[QRCodeUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserLocation_MstLocationBlock_BlockId] FOREIGN KEY([BlockId])
REFERENCES [dbo].[MstLocationBlock] ([BlockId])
GO
ALTER TABLE [dbo].[QRCodeUserLocation] CHECK CONSTRAINT [FK_QRCodeUserLocation_MstLocationBlock_BlockId]
GO
ALTER TABLE [dbo].[QRCodeUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserLocation_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[QRCodeUserLocation] CHECK CONSTRAINT [FK_QRCodeUserLocation_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[QRCodeUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserLocation_MstLocationLevel_LevelId] FOREIGN KEY([LevelId])
REFERENCES [dbo].[MstLocationLevel] ([LevelId])
GO
ALTER TABLE [dbo].[QRCodeUserLocation] CHECK CONSTRAINT [FK_QRCodeUserLocation_MstLocationLevel_LevelId]
GO
ALTER TABLE [dbo].[QRCodeUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserLocation_MstLocationUserArea_UserAreaId] FOREIGN KEY([UserAreaId])
REFERENCES [dbo].[MstLocationUserArea] ([UserAreaId])
GO
ALTER TABLE [dbo].[QRCodeUserLocation] CHECK CONSTRAINT [FK_QRCodeUserLocation_MstLocationUserArea_UserAreaId]
GO
ALTER TABLE [dbo].[QRCodeUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserLocation_MstLocationUserLocation_UserLocationId] FOREIGN KEY([UserLocationId])
REFERENCES [dbo].[MstLocationUserLocation] ([UserLocationId])
GO
ALTER TABLE [dbo].[QRCodeUserLocation] CHECK CONSTRAINT [FK_QRCodeUserLocation_MstLocationUserLocation_UserLocationId]
GO
