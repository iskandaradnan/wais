USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UmScreenHelp]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UmScreenHelp](
	[ScreenHelpId] [int] IDENTITY(1,1) NOT NULL,
	[ScreenId] [int] NOT NULL,
	[HelpDescription] [nvarchar](max) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ScreenHelpId] PRIMARY KEY CLUSTERED 
(
	[ScreenHelpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UmScreenHelp] ADD  CONSTRAINT [DF_UmScreenHelp_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UmScreenHelp]  WITH CHECK ADD  CONSTRAINT [FK_UmScreenHelp_UmScreen_ScreenId] FOREIGN KEY([ScreenId])
REFERENCES [dbo].[UMScreen] ([ScreenId])
GO
ALTER TABLE [dbo].[UmScreenHelp] CHECK CONSTRAINT [FK_UmScreenHelp_UmScreen_ScreenId]
GO
