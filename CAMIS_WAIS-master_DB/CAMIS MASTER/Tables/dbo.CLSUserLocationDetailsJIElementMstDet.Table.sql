USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserLocationDetailsJIElementMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserLocationDetailsJIElementMstDet](
	[JointInspectionId] [int] IDENTITY(1,1) NOT NULL,
	[CLSUserLocationId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Floor] [bit] NULL,
	[Walls] [bit] NULL,
	[Ceiling] [bit] NULL,
	[WindowsDoors] [bit] NULL,
	[ReceptaclesContainers] [bit] NULL,
	[FurnitureFixtureEquipment] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSUserLocationDetailsMstJIElementMstDet] PRIMARY KEY CLUSTERED 
(
	[JointInspectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
