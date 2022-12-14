USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FMDocument]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_FMDocument] AS TABLE(
	[DocumentId] [int] NULL,
	[GuId] [nvarchar](500) NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[DocumentNo] [nvarchar](30) NULL,
	[DocumentTitle] [nvarchar](300) NULL,
	[DocumentDescription] [nvarchar](255) NULL,
	[DocumentCategory] [int] NULL,
	[DocumentCategoryOthers] [nvarchar](255) NULL,
	[DocumentExtension] [nvarchar](255) NULL,
	[MajorVersion] [int] NULL,
	[MinorVersion] [int] NULL,
	[FileType] [int] NULL,
	[FilePath] [nvarchar](500) NULL,
	[FileName] [nvarchar](255) NULL,
	[UploadedDateUTC] [datetime] NULL,
	[ScreenId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[Active] [bit] NULL,
	[DocumentGuId] [nvarchar](500) NULL
)
GO
