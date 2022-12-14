USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CSWRecordSheet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CSWRecordSheet](
	[CSWRecordSheetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[RRWNo] [nvarchar](50) NULL,
	[WasteType] [nvarchar](50) NULL,
	[WasteCode] [nvarchar](50) NULL,
	[UserAreaCode] [nvarchar](50) NULL,
	[UserAreaName] [nvarchar](50) NULL,
	[Month] [varchar](50) NULL,
	[Year] [varchar](50) NULL,
	[CollectionType] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[TotalWeight] [float] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CSWRecordSheetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
