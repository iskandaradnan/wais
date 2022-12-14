USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[seppp]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seppp](
	[NO#] [float] NULL,
	[TARGET DATE] [datetime] NULL,
	[NEXT PPM DATE ] [datetime] NULL,
	[WORK ORDER NO] [nvarchar](255) NULL,
	[ASSET NO ] [nvarchar](255) NULL,
	[ASSET DESC] [nvarchar](255) NULL,
	[WG] [nvarchar](255) NULL,
	[TYPE CODE] [float] NULL,
	[TASK CODE] [nvarchar](255) NULL,
	[DEPT NAME] [nvarchar](255) NULL,
	[LOCATION CODE] [nvarchar](255) NULL,
	[LOCATION NAME] [nvarchar](255) NULL,
	[MODEL] [nvarchar](255) NULL,
	[S/N] [nvarchar](255) NULL,
	[MANUFACTURER] [nvarchar](255) NULL,
	[EMPLOYEE NO#] [nvarchar](255) NULL,
	[EMPLOYEE NAME] [nvarchar](255) NULL,
	[DATE] [datetime] NULL,
	[StartDateTime] [nvarchar](255) NULL,
	[START TIME] [nvarchar](255) NULL,
	[F21] [nvarchar](255) NULL,
	[DATE1] [datetime] NULL,
	[F23] [nvarchar](255) NULL,
	[END TIME] [nvarchar](255) NULL,
	[F25] [nvarchar](255) NULL,
	[PPM AGREED DATE] [datetime] NULL,
	[ACTION TAKEN] [nvarchar](255) NULL,
	[COMPLETED NAME] [nvarchar](255) NULL,
	[F29] [float] NULL,
	[COMPLETED DATE] [datetime] NULL,
	[COMPLETED TIME] [nvarchar](255) NULL,
	[VERIFIED NAME] [nvarchar](255) NULL,
	[DESIGNATION] [nvarchar](255) NULL,
	[VERIFIED DATE] [datetime] NULL,
	[VERIFIED TIME] [nvarchar](255) NULL,
	[CLOSE BY HELPDESK] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[RESCHEDULE DATE] [nvarchar](255) NULL,
	[F39] [nvarchar](255) NULL,
	[F40] [float] NULL
) ON [PRIMARY]
GO
