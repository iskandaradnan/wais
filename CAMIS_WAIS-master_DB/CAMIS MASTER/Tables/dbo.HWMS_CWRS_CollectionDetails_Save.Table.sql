USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CWRS_CollectionDetails_Save]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CWRS_CollectionDetails_Save](
	[CollectionDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[UserAreaCode] [varchar](50) NULL,
	[FrequencyType] [varchar](50) NULL,
	[CollectionFequency] [int] NULL,
	[CollectionTime] [time](7) NULL,
	[CollectionStatus] [varchar](50) NULL,
	[QC] [varchar](50) NULL,
	[NoofBags] [int] NULL,
	[NoofReceptaclesOnsite] [int] NULL,
	[NoofReceptacleSanitize] [int] NULL,
	[Sanitize] [varchar](50) NULL,
	[CWRecordSheetId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL,
	[CollectionFrequency] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_CWRS_CollectionDetails_Save]  WITH CHECK ADD FOREIGN KEY([CWRecordSheetId])
REFERENCES [dbo].[HWMS_CWRecordSheet_Save] ([CWRecordSheetId])
GO
