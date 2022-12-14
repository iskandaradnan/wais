USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[QAPCarHistory]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QAPCarHistory](
	[CarHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[RootCause] [nvarchar](500) NULL,
	[Solution] [nvarchar](500) NULL,
	[Remarks] [nvarchar](500) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_QAPCarHistory] PRIMARY KEY CLUSTERED 
(
	[CarHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QAPCarHistory] ADD  CONSTRAINT [DF_QAPCarHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[QAPCarHistory]  WITH CHECK ADD  CONSTRAINT [FK_QAPCarHistory_QAPCarTxn_CarId] FOREIGN KEY([CarId])
REFERENCES [dbo].[QAPCarTxn] ([CarId])
GO
ALTER TABLE [dbo].[QAPCarHistory] CHECK CONSTRAINT [FK_QAPCarHistory_QAPCarTxn_CarId]
GO
