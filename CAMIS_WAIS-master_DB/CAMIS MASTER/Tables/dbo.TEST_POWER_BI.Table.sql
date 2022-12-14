USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[TEST_POWER_BI]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_POWER_BI](
	[AssetId] [int] NOT NULL,
	[AssetClassificationDescription] [nvarchar](100) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetClassificationCode] [nvarchar](25) NULL,
	[AssetClassification] [int] NULL,
	[WorkOrderId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserID] [int] NULL,
	[UserName] [nvarchar](75) NULL,
	[FacilityName] [nvarchar](100) NULL,
	[WorkOrderStatus] [int] NULL,
	[WorkOrderStatusName] [varchar](17) NULL,
	[FieldValue] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[NumberOfDaysReqd] [int] NULL,
	[NumberOfhoursReqd] [int] NULL,
	[NumberOfMintReqd] [int] NULL,
	[DownTimeDays] [int] NULL,
	[AgeingDays] [int] NULL,
	[MonthNo] [int] NULL,
	[MonthName] [varchar](6) NULL,
	[Year] [int] NULL,
	[PenaltyDays] [varchar](8) NOT NULL,
	[AgeingBucket] [varchar](9) NULL,
	[RN] [bigint] NULL
) ON [PRIMARY]
GO
