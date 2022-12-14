USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[WpmTechServicePerfAssessmentPartOfAssessment]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WpmTechServicePerfAssessmentPartOfAssessment](
	[PartOfAssessmentId] [int] IDENTITY(1,1) NOT NULL,
	[PartOfAssessment] [nvarchar](2000) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PartOfAssessmentId] PRIMARY KEY CLUSTERED 
(
	[PartOfAssessmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WpmTechServicePerfAssessmentPartOfAssessment] ADD  CONSTRAINT [DF_WpmTechServicePerfAssessmentPartOfAssessment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
