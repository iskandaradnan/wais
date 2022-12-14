USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSJointInspectionDetailTxnDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSJointInspectionDetailTxnDet](
	[JIInspectionDetId] [int] NOT NULL,
	[JIInspectionId] [int] NOT NULL,
	[UserLocationId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Floor] [int] NOT NULL,
	[WallsDoors] [int] NOT NULL,
	[Ceiling] [int] NOT NULL,
	[Windows] [int] NOT NULL,
	[Fixtures] [int] NOT NULL,
	[FurnituresFitting] [int] NOT NULL,
	[ReceptaclesContainers ] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[FloorReferenceNo] [nvarchar](25) NULL,
	[WallsDoorsReferenceNo] [nvarchar](25) NULL,
	[CeilingReferenceNo] [nvarchar](25) NULL,
	[FixturesReferenceNo] [nvarchar](25) NULL,
	[FurnituresFittingReferenceNo] [nvarchar](25) NULL,
	[ExternalHighRiseCeilingReferenceNo] [nvarchar](25) NULL,
	[WindowsReferenceNo] [nvarchar](25) NULL,
	[CLSUserLocationId] [int] NULL,
 CONSTRAINT [PK_CLSJointInspectionDetailTxnDet] PRIMARY KEY CLUSTERED 
(
	[JIInspectionDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
