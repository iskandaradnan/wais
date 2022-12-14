USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RecyclableWasteRecordFetch]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RecyclableWasteRecordFetch](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserAreaCode] [nvarchar](max) NULL,
	[UserAreaName] [nvarchar](max) NULL,
	[CSWRSNo] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_HWMS_RecyclableWasteRecordFetch] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
