USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[QRCodeUserArea]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QRCodeUserArea](
	[QRCodeUserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[BlockId] [int] NULL,
	[LevelId] [int] NULL,
	[UserAreaId] [int] NOT NULL,
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
 CONSTRAINT [PK_QRCodeUserArea] PRIMARY KEY CLUSTERED 
(
	[QRCodeUserAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[QRCodeUserArea] ADD  CONSTRAINT [DF_QRCodeUserArea_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[QRCodeUserArea]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserArea_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[QRCodeUserArea] CHECK CONSTRAINT [FK_QRCodeUserArea_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[QRCodeUserArea]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserArea_MstLocationBlock_BlockId] FOREIGN KEY([BlockId])
REFERENCES [dbo].[MstLocationBlock] ([BlockId])
GO
ALTER TABLE [dbo].[QRCodeUserArea] CHECK CONSTRAINT [FK_QRCodeUserArea_MstLocationBlock_BlockId]
GO
ALTER TABLE [dbo].[QRCodeUserArea]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserArea_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[QRCodeUserArea] CHECK CONSTRAINT [FK_QRCodeUserArea_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[QRCodeUserArea]  WITH CHECK ADD  CONSTRAINT [FK_QRCodeUserArea_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[QRCodeUserArea] CHECK CONSTRAINT [FK_QRCodeUserArea_MstService_ServiceId]
GO
