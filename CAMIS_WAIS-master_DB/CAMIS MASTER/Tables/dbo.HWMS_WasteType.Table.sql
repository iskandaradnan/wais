USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_WasteType]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_WasteType](
	[WasteTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[WasteCategory] [nvarchar](50) NULL,
	[WasteType] [nvarchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[WasteTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
