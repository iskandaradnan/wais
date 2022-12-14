USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[BerCurrentValueHistoryTxnDet]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BerCurrentValueHistoryTxnDet](
	[CurrentValueId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[CurrentValue] [numeric](24, 2) NOT NULL,
	[Remarks] [nvarchar](1000) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BerCurrentValueHistoryTxnDet] PRIMARY KEY CLUSTERED 
(
	[CurrentValueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BerCurrentValueHistoryTxnDet] ADD  CONSTRAINT [DF_BerCurrentValueHistoryTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[BerCurrentValueHistoryTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_BerCurrentValueHistoryTxnDet_BerApplicationTxn_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[BERApplicationTxn] ([ApplicationId])
GO
ALTER TABLE [dbo].[BerCurrentValueHistoryTxnDet] CHECK CONSTRAINT [FK_BerCurrentValueHistoryTxnDet_BerApplicationTxn_ApplicationId]
GO
