USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_FEAcknowledge]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_FEAcknowledge] AS TABLE(
	[AcknowledgeId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[Acknowledge] [bit] NULL,
	[Signatureimage] [varbinary](max) NULL
)
GO
