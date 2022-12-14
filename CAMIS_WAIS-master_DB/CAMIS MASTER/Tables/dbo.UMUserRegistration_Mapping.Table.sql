USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRegistration_Mapping]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRegistration_Mapping](
	[UserRegistrationId] [int] IDENTITY(1,1) NOT NULL,
	[Master_UserRegistrationId] [int] NULL,
	[BEMS] [int] NULL,
	[FEMS] [int] NULL,
	[CLS] [int] NULL,
	[LLS] [int] NULL,
	[HWMS] [int] NULL,
 CONSTRAINT [PK_Master_UserRegistrationId] PRIMARY KEY CLUSTERED 
(
	[UserRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
