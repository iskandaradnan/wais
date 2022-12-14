USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FmHistory]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FmHistory](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](1000) NULL,
	[TableGuid] [uniqueidentifier] NOT NULL,
	[TableRowData] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedUTCDate] [datetime] NULL,
 CONSTRAINT [PK_HistoryId] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
