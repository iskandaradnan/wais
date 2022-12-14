USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[FEAcknowledge]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEAcknowledge](
	[AcknowledgeId] [int] IDENTITY(1,1) NOT NULL,
	[ScreenName] [nvarchar](100) NOT NULL,
	[Documentid] [int] NOT NULL,
	[DocumentNo] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[Userid] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[Acknowledge] [bit] NULL,
	[Signatureimage] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AcknowledgeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
