USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngPPMRegisterHistoryMst]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngPPMRegisterHistoryMst](
	[PPMHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[PPMId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[Version] [numeric](24, 2) NULL,
	[EffectiveDate] [datetime] NULL,
	[UploadDate] [datetime] NULL,
	[FileImage] [varbinary](max) NULL,
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
 CONSTRAINT [PK_EngPPMRegisterHistoryMst] PRIMARY KEY CLUSTERED 
(
	[PPMHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst] ADD  CONSTRAINT [DF_EngPPMRegisterHistoryMst_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst] ADD  CONSTRAINT [DF_EngPPMRegisterHistoryMst_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst] ADD  CONSTRAINT [DF_EngPPMRegisterHistoryMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterHistoryMst_EngPPMRegisterMst_PPMId] FOREIGN KEY([PPMId])
REFERENCES [dbo].[EngPPMRegisterMst] ([PPMId])
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst] CHECK CONSTRAINT [FK_EngPPMRegisterHistoryMst_EngPPMRegisterMst_PPMId]
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst]  WITH CHECK ADD  CONSTRAINT [FK_EngPPMRegisterHistoryMst_FMDocument_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[FMDocument] ([DocumentId])
GO
ALTER TABLE [dbo].[EngPPMRegisterHistoryMst] CHECK CONSTRAINT [FK_EngPPMRegisterHistoryMst_FMDocument_DocumentId]
GO
