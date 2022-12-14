USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngMWOHandOverHistoryTxn]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMWOHandOverHistoryTxn](
	[HandOverHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[WorkorderId] [int] NULL,
	[AssignedUserId] [int] NULL,
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
 CONSTRAINT [PK_EngMWOHandOverHistoryTxn_HandOverHistoryId] PRIMARY KEY CLUSTERED 
(
	[HandOverHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMWOHandOverHistoryTxn] ADD  CONSTRAINT [DF_EngMWOHandOverHistoryTxn_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngMWOHandOverHistoryTxn] ADD  CONSTRAINT [DF_EngMWOHandOverHistoryTxn_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngMWOHandOverHistoryTxn] ADD  CONSTRAINT [DF_EngMWOHandOverHistoryTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
