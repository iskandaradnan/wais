USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_PeriodicWorkRecordTable]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_PeriodicWorkRecordTable](
	[UserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[PeriodicId] [int] NULL,
	[UserAreaCode] [varchar](30) NULL,
	[Status] [varchar](30) NULL,
	[A1] [varchar](30) NULL,
	[A2] [varchar](30) NULL,
	[A3] [varchar](30) NULL,
	[A4] [varchar](30) NULL,
	[A5] [varchar](30) NULL,
	[A6] [varchar](30) NULL,
	[A7] [varchar](30) NULL,
	[A8] [varchar](30) NULL,
	[A9] [varchar](30) NULL,
	[A10] [varchar](30) NULL,
	[A11] [varchar](30) NULL,
	[A12] [varchar](30) NULL,
	[A13] [varchar](30) NULL,
	[A14] [varchar](30) NULL,
	[A15] [varchar](30) NULL,
	[A16] [varchar](30) NULL,
	[A17] [varchar](30) NULL,
	[A18] [varchar](30) NULL,
	[A19] [varchar](30) NULL,
	[A20] [varchar](30) NULL,
	[A21] [varchar](30) NULL,
	[A22] [varchar](30) NULL,
	[A23] [varchar](30) NULL,
	[A24] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_PeriodicWorkRecordTable]  WITH CHECK ADD  CONSTRAINT [FK_PeriodicId] FOREIGN KEY([PeriodicId])
REFERENCES [dbo].[CLS_PeriodicWorkRecord] ([PeriodicId])
GO
ALTER TABLE [dbo].[CLS_PeriodicWorkRecordTable] CHECK CONSTRAINT [FK_PeriodicId]
GO
