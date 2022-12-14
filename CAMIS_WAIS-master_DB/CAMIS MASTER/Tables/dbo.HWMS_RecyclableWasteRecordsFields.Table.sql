USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RecyclableWasteRecordsFields]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RecyclableWasteRecordsFields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RecyclableId] [int] NULL,
	[UserAreaCode] [varchar](50) NULL,
	[UserAreaName] [varchar](50) NULL,
	[CSWRSNo] [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_RecyclableWasteRecordsFields]  WITH CHECK ADD  CONSTRAINT [Recyclable_FK_Id] FOREIGN KEY([RecyclableId])
REFERENCES [dbo].[HWMS_RecyclableWasteRecords] ([RecyclableId])
GO
ALTER TABLE [dbo].[HWMS_RecyclableWasteRecordsFields] CHECK CONSTRAINT [Recyclable_FK_Id]
GO
