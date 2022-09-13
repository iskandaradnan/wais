USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DisposalType]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DisposalType](
	[MethodofDisposal] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[DesignCapacity] [nvarchar](max) NULL,
	[LicensedCapacity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
