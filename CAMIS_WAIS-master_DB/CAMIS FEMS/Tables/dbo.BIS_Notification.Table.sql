USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[BIS_Notification]    Script Date: 20-09-2021 16:53:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BIS_Notification](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[BISWOID] [int] NOT NULL,
	[Created date] [datetime] NOT NULL,
	[Email_sent] [int] NULL,
 CONSTRAINT [PK_BIS_Notification] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
