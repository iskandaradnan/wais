USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_IncidentReport]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_IncidentReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CMRRequestNum] [bigint] NULL,
	[ReportSent] [varchar](max) NULL,
	[IncidentCategory] [varchar](max) NULL,
	[PartiesInvolved] [varchar](max) NULL,
	[CriteriaofCriticalEvent] [varchar](max) NULL,
	[Events] [varchar](max) NULL,
	[IncidentDescription] [varchar](max) NULL,
	[FindingRootCause] [varchar](max) NULL,
	[ImmediateActionTaken] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
