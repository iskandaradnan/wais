USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_ConsignmentNoteOSWCN_SWRSNo]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_ConsignmentNoteOSWCN_SWRSNo](
	[SWRSNoId] [int] IDENTITY(1,1) NOT NULL,
	[ConsignmentOSWCNId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](30) NULL,
	[UserAreaName] [nvarchar](30) NULL,
	[SWRSNo] [nvarchar](30) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_ConsignmentNoteOSWCN_SWRSNo]  WITH CHECK ADD  CONSTRAINT [FK_consignmentOSWCNId] FOREIGN KEY([ConsignmentOSWCNId])
REFERENCES [dbo].[HWMS_ConsignmentNoteOSWCN] ([ConsignmentOSWCNId])
GO
ALTER TABLE [dbo].[HWMS_ConsignmentNoteOSWCN_SWRSNo] CHECK CONSTRAINT [FK_consignmentOSWCNId]
GO
