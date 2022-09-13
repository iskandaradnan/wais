USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FEAcknowledge]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_FEAcknowledge] AS TABLE(
	[AcknowledgeId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[Acknowledge] [bit] NULL,
	[Signatureimage] [varbinary](max) NULL
)
GO
