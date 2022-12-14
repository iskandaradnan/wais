USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FEMSCheckListFinal]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEMSCheckListFinal](
	[TypeCodeSub] [float] NULL,
	[TypeCodeMst] [float] NULL,
	[ModelSub] [float] NULL,
	[ModelMst] [float] NULL,
	[ManuSub] [float] NULL,
	[ManuMst] [float] NULL,
	[TaskCode] [nvarchar](255) NULL,
	[PPMFreq] [float] NULL,
	[CheckListNo] [nvarchar](255) NULL
) ON [PRIMARY]
GO
