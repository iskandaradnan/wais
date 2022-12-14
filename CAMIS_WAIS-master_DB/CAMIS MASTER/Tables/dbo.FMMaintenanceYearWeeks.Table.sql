USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FMMaintenanceYearWeeks]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMMaintenanceYearWeeks](
	[MaintenanceYearWeekId] [int] IDENTITY(1,1) NOT NULL,
	[MaintenanceYearId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Year] [int] NOT NULL,
	[Weeks] [int] NOT NULL,
	[WeekStartDate] [int] NULL,
	[WeekEndDate] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FMMaintenanceYearWeeks] PRIMARY KEY CLUSTERED 
(
	[MaintenanceYearWeekId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMMaintenanceYearWeeks] ADD  CONSTRAINT [DF_FMMaintenanceYearWeeks_GuId]  DEFAULT (newid()) FOR [GuId]
GO
