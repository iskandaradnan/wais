USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CorrectiveActionReport_CARDetails]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CorrectiveActionReport_CARDetails](
	[CARDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[Activity] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[TargetDate] [datetime] NULL,
	[ActualCompletionDate] [datetime] NULL,
	[Responsibility] [varchar](50) NULL,
	[ResponsiblePerson] [varchar](50) NULL,
	[CARId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[isDeleted] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CARDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_CorrectiveActionReport_CARDetails]  WITH CHECK ADD FOREIGN KEY([CARId])
REFERENCES [dbo].[HWMS_CorrectiveActionReport] ([CARId])
GO
