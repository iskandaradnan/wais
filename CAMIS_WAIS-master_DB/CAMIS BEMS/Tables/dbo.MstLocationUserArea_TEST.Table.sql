USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationUserArea_TEST]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationUserArea_TEST](
	[UserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockId] [int] NOT NULL,
	[LevelId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](25) NOT NULL,
	[UserAreaName] [nvarchar](100) NOT NULL,
	[CustomerUserId] [int] NOT NULL,
	[FacilityUserId] [int] NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[QRCode] [varbinary](max) NULL,
	[BEMS_ID] [int] NULL,
	[FEMS_ID] [int] NULL,
 CONSTRAINT [PK_MstLocationUserArea_TEST] PRIMARY KEY CLUSTERED 
(
	[UserAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
