USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_OSWRecordSheet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_OSWRecordSheet](
	[OSWRId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[OSWRSNo] [nvarchar](50) NULL,
	[TotalPackage] [int] NULL,
	[WasteType] [nvarchar](100) NULL,
	[ConsignmentNo] [int] NULL,
	[UserAreaCode] [nvarchar](50) NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[Month] [nvarchar](100) NULL,
	[Year] [int] NULL,
	[CollectionFrequency] [nvarchar](50) NULL,
	[CollectionType] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[OSWRId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
