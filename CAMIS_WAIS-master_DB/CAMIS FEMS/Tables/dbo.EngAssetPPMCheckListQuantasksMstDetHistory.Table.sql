USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory](
	[PPMCheckListHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[PPMCheckListQNId] [int] NULL,
	[PPMCheckListId] [int] NOT NULL,
	[QuantitativeTasks] [nvarchar](1000) NOT NULL,
	[UOM] [int] NOT NULL,
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
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngAssetPPMCheckListQuantasksMstDetHistory] PRIMARY KEY CLUSTERED 
(
	[PPMCheckListHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksMstDetHistory_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksMstDetHistory_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetPPMCheckListQuantasksMstDetHistory] ADD  CONSTRAINT [DF_EngAssetPPMCheckListQuantasksMstDetHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
