USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FMDocument04112020]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMDocument04112020](
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
	[DocumentGuId] [nvarchar](500) NULL
) ON [PRIMARY]
GO
