USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngPPMRegisterHistoryMst]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_EngPPMRegisterHistoryMst] AS TABLE(
	[PPMHistoryId] [int] NULL,
	[PPMId] [int] NULL,
	[DocumentId] [int] NULL,
	[Version] [numeric](24, 2) NULL,
	[EffectiveDate] [datetime] NULL,
	[UploadDate] [datetime] NULL,
	[FileImage] [varbinary](max) NULL,
	[UserId] [int] NULL
)
GO
