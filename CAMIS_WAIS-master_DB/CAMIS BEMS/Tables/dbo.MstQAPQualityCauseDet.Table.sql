USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstQAPQualityCauseDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstQAPQualityCauseDet](
	[QualityCauseDetId] [int] IDENTITY(1,1) NOT NULL,
	[QualityCauseId] [int] NOT NULL,
	[ProblemCode] [int] NOT NULL,
	[QcCode] [nvarchar](25) NULL,
	[Details] [nvarchar](255) NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MstQapQualityCauseDet] PRIMARY KEY CLUSTERED 
(
	[QualityCauseDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstQAPQualityCauseDet] ADD  CONSTRAINT [DF_MstQapQualityCauseDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstQAPQualityCauseDet] ADD  CONSTRAINT [DF_MstQapQualityCauseDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstQAPQualityCauseDet] ADD  CONSTRAINT [DF_MstQapQualityCauseDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstQAPQualityCauseDet]  WITH CHECK ADD  CONSTRAINT [FK_MstQAPQualityCauseDet_MstQAPQualityCause_QualityCauseId] FOREIGN KEY([QualityCauseId])
REFERENCES [dbo].[MstQAPQualityCause] ([QualityCauseId])
GO
ALTER TABLE [dbo].[MstQAPQualityCauseDet] CHECK CONSTRAINT [FK_MstQAPQualityCauseDet_MstQAPQualityCause_QualityCauseId]
GO
