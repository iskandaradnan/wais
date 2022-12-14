USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_DeptAreaDetails]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_DeptAreaDetails](
	[DeptAreaId] [int] IDENTITY(1,1) NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserAreaCode] [nvarchar](50) NOT NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[EffectiveFromDate] [datetime] NULL,
	[EffectiveToDate] [datetime] NULL,
	[OperatingDays] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[Category] [nvarchar](50) NULL,
	[Remarks] [nvarchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeptAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
