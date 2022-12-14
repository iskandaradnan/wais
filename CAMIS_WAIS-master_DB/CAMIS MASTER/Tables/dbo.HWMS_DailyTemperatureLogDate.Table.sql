USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DailyTemperatureLogDate]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DailyTemperatureLogDate](
	[DateId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[TemperatureReading] [nvarchar](50) NULL,
	[DailyId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_DailyTemperatureLogDate]  WITH CHECK ADD  CONSTRAINT [Daily_FK_Id] FOREIGN KEY([DailyId])
REFERENCES [dbo].[HWMS_DailyTemperatureLog] ([DailyId])
GO
ALTER TABLE [dbo].[HWMS_DailyTemperatureLogDate] CHECK CONSTRAINT [Daily_FK_Id]
GO
