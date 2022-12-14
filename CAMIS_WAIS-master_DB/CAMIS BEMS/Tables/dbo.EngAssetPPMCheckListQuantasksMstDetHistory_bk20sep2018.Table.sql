USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory_bk20sep2018]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory_bk20sep2018](
	[PPMCheckListHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[PPMCheckListQNId] [int] NULL,
	[PPMCheckListId] [int] NOT NULL,
	[QuantitativeTasks] [nvarchar](1000) NOT NULL,
	[UOM] [nvarchar](10) NULL,
	[SetValues] [nvarchar](10) NULL,
	[LimitTolerance] [nvarchar](10) NULL,
	[VersionNo] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
