USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngDefectDetailsTxnDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngDefectDetailsTxnDet](
	[DefectDetId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DefectId] [int] NOT NULL,
	[DefectDetails] [nvarchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[StartDateUTC] [datetime] NOT NULL,
	[CompletionDate] [datetime] NULL,
	[CompletionDateUTC] [datetime] NULL,
	[ActionTaken] [nvarchar](100) NULL,
	[DocumentId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngDefectDetailsTxnDet] PRIMARY KEY CLUSTERED 
(
	[DefectDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxnDet] ADD  CONSTRAINT [DF_EngDefectDetailsTxnDet]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngDefectDetailsTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngDefectDetailsTxnDet_EngDefectDetailsTxn_DefectId] FOREIGN KEY([DefectId])
REFERENCES [dbo].[EngDefectDetailsTxn] ([DefectId])
GO
ALTER TABLE [dbo].[EngDefectDetailsTxnDet] CHECK CONSTRAINT [FK_EngDefectDetailsTxnDet_EngDefectDetailsTxn_DefectId]
GO
