USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CSWRecordSheetCollectionDetail]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CSWRecordSheetCollectionDetail](
	[CSWId] [int] IDENTITY(1,1) NOT NULL,
	[CSWRecordSheetId] [int] NULL,
	[Date] [datetime] NULL,
	[NoofBin] [nvarchar](50) NULL,
	[Weight] [float] NULL,
	[CollectionFrequency] [int] NULL,
	[CollectionTime] [time](7) NULL,
	[CollectionStatus] [int] NULL,
	[QC] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CSWId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_CSWRecordSheetCollectionDetail]  WITH CHECK ADD  CONSTRAINT [FK_CWRecordSheetId] FOREIGN KEY([CSWRecordSheetId])
REFERENCES [dbo].[HWMS_CSWRecordSheet] ([CSWRecordSheetId])
GO
ALTER TABLE [dbo].[HWMS_CSWRecordSheetCollectionDetail] CHECK CONSTRAINT [FK_CWRecordSheetId]
GO
