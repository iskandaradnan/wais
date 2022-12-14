USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_OSWRecordSheet_OtherScheduleWasteSave]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_OSWRecordSheet_OtherScheduleWasteSave](
	[OSWRecordId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[CollectionTime] [time](7) NULL,
	[CollectionStatus] [nvarchar](50) NULL,
	[QC] [nvarchar](50) NULL,
	[OSWRId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_OSWRecordSheet_OtherScheduleWasteSave]  WITH CHECK ADD FOREIGN KEY([OSWRId])
REFERENCES [dbo].[HWMS_OSWRecordSheet] ([OSWRId])
GO
