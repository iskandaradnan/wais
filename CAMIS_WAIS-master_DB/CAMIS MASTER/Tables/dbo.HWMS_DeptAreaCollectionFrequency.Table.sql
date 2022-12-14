USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DeptAreaCollectionFrequency]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DeptAreaCollectionFrequency](
	[FrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[WasteType] [nvarchar](50) NULL,
	[FrequencyType] [nvarchar](50) NULL,
	[CollectionFrequency] [nvarchar](50) NULL,
	[StartTime1] [time](7) NULL,
	[EndTime1] [time](7) NULL,
	[StartTime2] [time](7) NULL,
	[EndTime2] [time](7) NULL,
	[StartTime3] [time](7) NULL,
	[EndTime3] [time](7) NULL,
	[StartTime4] [time](7) NULL,
	[EndTime4] [time](7) NULL,
	[DeptAreaId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDelete] [int] NULL
) ON [PRIMARY]
GO
