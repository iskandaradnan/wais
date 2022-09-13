USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TPDisposal]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TPDisposal](
	[MethodofDisposal] [varchar](max) NULL,
	[Status] [varchar](max) NULL,
	[DesignCapacity] [varchar](max) NULL,
	[LicensedCapacity] [varchar](max) NULL,
	[Unit] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
