USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DailyWeighingRecordBinNo_Save]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DailyWeighingRecordBinNo_Save](
	[BinDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[BinNo] [varchar](50) NULL,
	[Weight] [float] NULL,
	[DWRId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_DailyWeighingRecordBinNo_Save]  WITH CHECK ADD FOREIGN KEY([DWRId])
REFERENCES [dbo].[HWMS_DailyWeighingRecord] ([DWRId])
GO
