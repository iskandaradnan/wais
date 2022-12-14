USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FMMaintenanceYear]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMMaintenanceYear](
	[MaintenanceYearId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[Year] [int] NOT NULL,
	[TotWeeks] [int] NOT NULL,
	[YearStartDate] [int] NULL,
	[YearEndDate] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FMMaintenanceYear] PRIMARY KEY CLUSTERED 
(
	[MaintenanceYearId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMMaintenanceYear] ADD  CONSTRAINT [DF_FMMaintenanceYear_GuId]  DEFAULT (newid()) FOR [GuId]
GO
