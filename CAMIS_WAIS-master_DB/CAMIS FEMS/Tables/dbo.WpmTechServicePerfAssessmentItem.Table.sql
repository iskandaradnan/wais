USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[WpmTechServicePerfAssessmentItem]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WpmTechServicePerfAssessmentItem](
	[ItemId] [int] IDENTITY(1,1) NOT NULL,
	[Item] [nvarchar](500) NULL,
	[Parameter] [int] NULL,
	[PartOfAssessmentId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ItemId] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WpmTechServicePerfAssessmentItem] ADD  CONSTRAINT [DF_WpmTechServicePerfAssessmentItem_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[WpmTechServicePerfAssessmentItem]  WITH CHECK ADD  CONSTRAINT [FK_WpmTechServicePerfAssessmentItem_WpmTechServicePerfAssessmentPartOfAssessment_PartOfAssessmentId] FOREIGN KEY([PartOfAssessmentId])
REFERENCES [dbo].[WpmTechServicePerfAssessmentPartOfAssessment] ([PartOfAssessmentId])
GO
ALTER TABLE [dbo].[WpmTechServicePerfAssessmentItem] CHECK CONSTRAINT [FK_WpmTechServicePerfAssessmentItem_WpmTechServicePerfAssessmentPartOfAssessment_PartOfAssessmentId]
GO
