USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSJointInspectionScheduleMst]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSJointInspectionScheduleMst](
	[JIScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserAreaId] [int] NULL,
	[UserAreaCode] [nvarchar](50) NOT NULL,
	[UserAreaName] [nvarchar](100) NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Week] [int] NOT NULL,
	[Day] [varchar](50) NOT NULL,
	[TargetDate] [date] NOT NULL,
	[Status] [int] NOT NULL,
	[IsScheduleGeneration] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSJointInspectionScheduleMst] PRIMARY KEY CLUSTERED 
(
	[JIScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
