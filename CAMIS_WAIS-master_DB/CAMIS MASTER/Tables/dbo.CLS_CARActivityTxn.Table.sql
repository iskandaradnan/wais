USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_CARActivityTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_CARActivityTxn](
	[CARActivityId] [int] IDENTITY(1,1) NOT NULL,
	[Activity] [nvarchar](50) NULL,
	[StartDate] [datetime] NULL,
	[TargetDate] [datetime] NULL,
	[ActualCompletionDate] [datetime] NULL,
	[Responsibility] [nvarchar](50) NULL,
	[ResponsiblePerson] [nvarchar](50) NULL,
	[CARId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CLS_CARActivityTxn]  WITH CHECK ADD FOREIGN KEY([CARId])
REFERENCES [dbo].[CLS_CorrectiveActionReport] ([CARId])
GO
ALTER TABLE [dbo].[CLS_CARActivityTxn]  WITH CHECK ADD FOREIGN KEY([CARId])
REFERENCES [dbo].[CLS_CorrectiveActionReport] ([CARId])
GO
