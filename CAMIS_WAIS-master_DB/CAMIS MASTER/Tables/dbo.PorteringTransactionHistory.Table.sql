USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[PorteringTransactionHistory]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PorteringTransactionHistory](
	[PorteringDetId] [int] IDENTITY(1,1) NOT NULL,
	[PorteringId] [int] NOT NULL,
	[WorkFlowStatusId] [int] NULL,
	[WFDoneBy] [int] NULL,
	[WFDoneByDate] [datetime] NULL,
	[PorteringStatusLovId] [int] NULL,
	[PorteringStatusDoneBy] [int] NULL,
	[PorteringStatusDoneByDate] [datetime] NULL,
	[IsMoment] [bit] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PorteringTransactionHistory] PRIMARY KEY CLUSTERED 
(
	[PorteringDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PorteringTransactionHistory] ADD  CONSTRAINT [DF_PorteringTransactionHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[PorteringTransactionHistory]  WITH CHECK ADD  CONSTRAINT [FK_PorteringTransactionHistory_PorteringTransaction_PorteringId] FOREIGN KEY([PorteringId])
REFERENCES [dbo].[PorteringTransaction] ([PorteringId])
GO
ALTER TABLE [dbo].[PorteringTransactionHistory] CHECK CONSTRAINT [FK_PorteringTransactionHistory_PorteringTransaction_PorteringId]
GO
