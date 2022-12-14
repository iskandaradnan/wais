USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FMDocumentFileType]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMDocumentFileType](
	[FileTypeId] [int] IDENTITY(1,1) NOT NULL,
	[FileType] [nvarchar](250) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Active] [int] NOT NULL,
	[BuitIn] [int] NOT NULL,
	[IsDefault] [bit] NULL,
 CONSTRAINT [PK_FMDocumentFileType] PRIMARY KEY CLUSTERED 
(
	[FileTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMDocumentFileType] ADD  CONSTRAINT [DF_FMDocumentFileType_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FMDocumentFileType] ADD  CONSTRAINT [DF_FMDocumentFileType_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[FMDocumentFileType] ADD  CONSTRAINT [DF_FMDocumentFileType_BuitIn]  DEFAULT ((1)) FOR [BuitIn]
GO
ALTER TABLE [dbo].[FMDocumentFileType] ADD  DEFAULT ((0)) FOR [IsDefault]
GO
