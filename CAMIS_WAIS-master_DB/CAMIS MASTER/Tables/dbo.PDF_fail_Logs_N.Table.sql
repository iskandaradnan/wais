USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[PDF_fail_Logs_N]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PDF_fail_Logs_N](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type_Code] [varchar](500) NOT NULL,
	[Type_Code_Id] [nchar](10) NOT NULL,
	[Document_No] [varchar](500) NOT NULL,
	[Asset_Id] [int] NOT NULL,
	[ManufacturerId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Created_on] [datetime] NOT NULL,
	[Remarks] [varchar](500) NULL,
 CONSTRAINT [PK_PDF_fail_Logs_] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_Person] UNIQUE NONCLUSTERED 
(
	[Document_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PDF_fail_Logs_N] ADD  CONSTRAINT [DF_PDF_fail_Logs_Created_on_]  DEFAULT (getdate()) FOR [Created_on]
GO
