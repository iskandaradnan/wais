USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSWeighingScaleMstAttachment]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSWeighingScaleMstAttachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[WeighingScaleId] [int] NOT NULL,
	[FileType] [int] NOT NULL,
	[FileName] [nvarchar](500) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_LLSWeighingScaleMstAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSWeighingScaleMstAttachment]  WITH CHECK ADD  CONSTRAINT [FK_LLSWeighingScaleMstAttachment_LLSWeighingScaleMst_WeighingScaleId] FOREIGN KEY([WeighingScaleId])
REFERENCES [dbo].[LLSWeighingScaleMst] ([WeighingScaleId])
GO
ALTER TABLE [dbo].[LLSWeighingScaleMstAttachment] CHECK CONSTRAINT [FK_LLSWeighingScaleMstAttachment_LLSWeighingScaleMst_WeighingScaleId]
GO
