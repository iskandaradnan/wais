USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRegistrationMappingExcel]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRegistrationMappingExcel](
	[UserRegistrationId] [int] NULL,
	[Master_UserRegistrationId] [int] NULL,
	[BEMS] [int] NULL,
	[FEMS] [int] NULL,
	[CLS] [varchar](50) NULL,
	[LLS] [varchar](50) NULL,
	[HWMS] [varchar](50) NULL
) ON [PRIMARY]
GO
