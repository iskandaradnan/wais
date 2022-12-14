USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngPlannerTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngPlannerTxnDet](
	[PlannerDetId] [int] IDENTITY(1,1) NOT NULL,
	[PlannerId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ScheduleType] [int] NULL,
	[Year] [int] NULL,
	[Month] [nvarchar](200) NULL,
	[Date] [nvarchar](100) NULL,
	[Week] [nvarchar](100) NULL,
	[Day] [nvarchar](100) NULL,
	[PlannerDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngPlannerTxnDet] PRIMARY KEY CLUSTERED 
(
	[PlannerDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngPlannerTxnDet] ADD  CONSTRAINT [DF_EngPlannerTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
