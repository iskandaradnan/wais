USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_WasteType_WasteCode]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_WasteType_WasteCode](
	[WasteId] [int] IDENTITY(1,1) NOT NULL,
	[WasteTypeId] [int] NOT NULL,
	[WasteCode] [nvarchar](50) NULL,
	[WasteDescription] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_WasteType_WasteCode]  WITH CHECK ADD  CONSTRAINT [FK_IdWaste] FOREIGN KEY([WasteTypeId])
REFERENCES [dbo].[HWMS_WasteType] ([WasteTypeId])
GO
ALTER TABLE [dbo].[HWMS_WasteType_WasteCode] CHECK CONSTRAINT [FK_IdWaste]
GO
