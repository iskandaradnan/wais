USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FMDocument]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMDocument](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[GuId] [uniqueidentifier] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NULL,
	[DocumentNo] [nvarchar](30) NULL,
	[DocumentTitle] [nvarchar](300) NULL,
	[DocumentDescription] [nvarchar](255) NULL,
	[DocumentCategory] [int] NULL,
	[DocumentCategoryOthers] [nvarchar](255) NULL,
	[DocumentExtension] [nvarchar](255) NULL,
	[MajorVersion] [int] NULL,
	[MinorVersion] [int] NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[UploadedDateUTC] [datetime] NULL,
	[ScreenId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UploadedBy] [int] NULL,
	[UploadedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[FileType] [int] NULL,
	[FilePath] [nvarchar](500) NULL,
	[DocumentGuId] [nvarchar](500) NULL,
 CONSTRAINT [PK_FMDocument] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMDocument]  WITH CHECK ADD  CONSTRAINT [FK_FMDocument_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[FMDocument] CHECK CONSTRAINT [FK_FMDocument_MstCustomer_CustomerId]
GO
