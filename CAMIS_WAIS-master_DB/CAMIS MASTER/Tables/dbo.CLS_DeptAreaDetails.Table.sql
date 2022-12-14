USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLS_DeptAreaDetails]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLS_DeptAreaDetails](
	[DeptAreaId] [int] IDENTITY(1,1) NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserAreaCode] [nvarchar](50) NOT NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[CategoryOfArea] [nvarchar](30) NULL,
	[Status] [int] NULL,
	[OperatingDays] [nvarchar](30) NULL,
	[WorkingHours] [int] NULL,
	[TotalReceptacles] [int] NULL,
	[CleanableArea] [int] NULL,
	[NoOfHandWashingFacilities] [int] NULL,
	[NoOfbeds] [int] NULL,
	[TotalNoOfUserLocations] [int] NULL,
	[HospitalRepresentative] [nvarchar](75) NULL,
	[HospitalRepresentativeDesignation] [nvarchar](75) NULL,
	[CompanyRepresentative] [nvarchar](75) NULL,
	[CompanyRepresentativeDesignation] [nvarchar](75) NULL,
	[EffectiveFromDate] [datetime] NULL,
	[EffectiveToDate] [datetime] NULL,
	[JISchedule] [nvarchar](30) NULL,
	[Remarks] [nvarchar](100) NULL,
 CONSTRAINT [PK_DeptAreaId] PRIMARY KEY CLUSTERED 
(
	[DeptAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UNQ_UserAreaCode] UNIQUE NONCLUSTERED 
(
	[UserAreaCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
