USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserAreaDetailsMst]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserAreaDetailsMst](
	[CLSUserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[CategoryofArea] [int] NULL,
	[Status] [int] NOT NULL,
	[OperatingDays] [int] NOT NULL,
	[WorkingHours] [int] NOT NULL,
	[TotalReceptacles] [numeric](24, 2) NOT NULL,
	[CleanableAreasqm] [numeric](24, 2) NULL,
	[NoofHandWashingFacility] [int] NOT NULL,
	[NoofBeds] [int] NOT NULL,
	[FmsHospitalStaffId] [int] NULL,
	[FmsCompanyStaffId] [int] NULL,
	[EffectiveFromDate] [datetime] NOT NULL,
	[EffectiveToDate] [datetime] NOT NULL,
	[JISchedule] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_CLSUserAreaDetailsMst] PRIMARY KEY CLUSTERED 
(
	[CLSUserAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
