USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[QueueWebtoMobileHistory]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueueWebtoMobileHistory](
	[QueueHistoryid] [int] IDENTITY(1,1) NOT NULL,
	[Queueid] [int] NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[Tableprimaryid] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Status] [nvarchar](50) NULL,
	[QueueDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_QueueWebtoMobileHistory] PRIMARY KEY CLUSTERED 
(
	[QueueHistoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueueWebtoMobileHistory] ADD  CONSTRAINT [DF_QueueWebtoMobileHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
