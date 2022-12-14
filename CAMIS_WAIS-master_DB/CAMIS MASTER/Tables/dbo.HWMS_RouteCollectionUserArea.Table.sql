USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RouteCollectionUserArea]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RouteCollectionUserArea](
	[RouteCollectionUserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[RouteCollectionId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](100) NOT NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[Remarks] [nvarchar](100) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_RouteCollectionUserArea]  WITH CHECK ADD  CONSTRAINT [Collections_FK_CollectionId] FOREIGN KEY([RouteCollectionId])
REFERENCES [dbo].[HWMS_RouteCollectionCategory] ([RouteCollectionId])
GO
ALTER TABLE [dbo].[HWMS_RouteCollectionUserArea] CHECK CONSTRAINT [Collections_FK_CollectionId]
GO
