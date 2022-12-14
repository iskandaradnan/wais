USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CorrectiveActionReport]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CorrectiveActionReport](
	[CARId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CARGeneration] [nvarchar](50) NULL,
	[CARNo] [nvarchar](50) NULL,
	[Indicator] [nvarchar](50) NULL,
	[CARDate] [datetime] NULL,
	[CARPeriodFrom] [datetime] NULL,
	[CARPeriodTo] [datetime] NULL,
	[FollowUpCAR] [nvarchar](50) NULL,
	[Assignee] [nvarchar](50) NULL,
	[ProblemStatement] [nvarchar](50) NULL,
	[RootCause] [nvarchar](50) NULL,
	[Solution] [nvarchar](50) NULL,
	[Priority] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[Issuer] [nvarchar](50) NULL,
	[CARTargetDate] [datetime] NULL,
	[VerifiedDate] [datetime] NULL,
	[VerifiedBy] [nvarchar](50) NULL,
	[Remarks] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CARId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
