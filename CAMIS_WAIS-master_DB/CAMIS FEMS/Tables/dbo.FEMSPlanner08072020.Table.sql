USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FEMSPlanner08072020]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEMSPlanner08072020](
	[PlannerId] [nvarchar](255) NULL,
	[CustomerId] [float] NULL,
	[FacilityId] [float] NULL,
	[ServiceId] [float] NULL,
	[WorkGroupId] [float] NULL,
	[TypeOfPlanner] [float] NULL,
	[Year] [float] NULL,
	[UserAreaId] [nvarchar](255) NULL,
	[AssigneeCompanyUserId] [nvarchar](255) NULL,
	[AssigneeCompanyUser] [nvarchar](255) NULL,
	[FacilityUserId] [nvarchar](255) NULL,
	[AssetClassificationId] [nvarchar](255) NULL,
	[AssetTypeCodeId] [nvarchar](255) NULL,
	[AssetId] [nvarchar](255) NULL,
	[AssetNo] [nvarchar](255) NULL,
	[StandardTaskDetId] [float] NULL,
	[WarrantyType] [float] NULL,
	[ContactNo] [nvarchar](255) NULL,
	[EngineerUserId] [nvarchar](255) NULL,
	[Engineer] [nvarchar](255) NULL,
	[ScheduleType] [nvarchar](255) NULL,
	[Month] [nvarchar](255) NULL,
	[Date] [nvarchar](255) NULL,
	[Week] [nvarchar](255) NULL,
	[Day] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [nvarchar](255) NULL,
	[CreatedDateUTC] [nvarchar](255) NULL,
	[ModifiedBy] [nvarchar](255) NULL,
	[ModifiedDate] [nvarchar](255) NULL,
	[ModifiedDateUTC] [nvarchar](255) NULL,
	[Timestamp] [nvarchar](255) NULL,
	[GuId] [nvarchar](255) NULL,
	[Status] [float] NULL,
	[WorkOrderType] [float] NULL,
	[GenerationType] [float] NULL,
	[FirstDate] [datetime] NULL,
	[NextDate] [datetime] NULL,
	[LastDate] [nvarchar](255) NULL,
	[IntervalInWeeks] [float] NULL
) ON [PRIMARY]
GO
