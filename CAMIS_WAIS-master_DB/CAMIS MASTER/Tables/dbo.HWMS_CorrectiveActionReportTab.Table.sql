USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_CorrectiveActionReportTab]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_CorrectiveActionReportTab](
	[Idno] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[CARGeneration] [varchar](100) NULL,
	[CARNo] [varchar](100) NULL,
	[Indicator] [varchar](30) NULL,
	[CARDate] [datetime] NULL,
	[CARPeriod] [varchar](30) NULL,
	[CARPeriodTo] [varchar](100) NULL,
	[Followupcar] [varchar](100) NULL,
	[Assignee] [varchar](50) NULL,
	[Problemstatement] [varchar](100) NULL,
	[Rootcause] [varchar](50) NULL,
	[Solution] [varchar](100) NULL,
	[Priority] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[Issuer] [varchar](100) NULL,
	[CARTargetdate] [datetime] NULL,
	[Verfieddate] [datetime] NULL,
	[Verifiedby] [varchar](100) NULL,
	[Remarks] [varchar](100) NULL,
 CONSTRAINT [HWMSCar_Id] PRIMARY KEY CLUSTERED 
(
	[Idno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
