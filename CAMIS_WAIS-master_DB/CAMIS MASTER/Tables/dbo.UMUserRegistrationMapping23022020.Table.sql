USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRegistrationMapping23022020]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRegistrationMapping23022020](
	[UserRegistrationId] [int] IDENTITY(1,1) NOT NULL,
	[Master_UserRegistrationId] [int] NULL,
	[BEMS] [int] NULL,
	[FEMS] [int] NULL,
	[CLS] [int] NULL,
	[LLS] [int] NULL,
	[HWMS] [int] NULL
) ON [PRIMARY]
GO
