USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[migrationsWO]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[migrationsWO](
	[WORK_ORDER_NO] [varchar](500) NULL,
	[datetime] [datetime] NULL
) ON [PRIMARY]
GO
