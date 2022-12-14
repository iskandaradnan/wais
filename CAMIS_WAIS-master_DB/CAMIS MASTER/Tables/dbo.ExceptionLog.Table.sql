USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[ExceptionLog]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExceptionLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorProcedure] [nvarchar](128) NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[DateErrorRaised] [datetime] NULL
) ON [PRIMARY]
GO
