USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSJointInspectionDetailTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSJointInspectionDetailTxn](
	[JIInspectionId] [int] IDENTITY(1,1) NOT NULL,
	[JIScheduleId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[JIDocumentNo] [nvarchar](50) NULL,
	[JIDate] [datetime] NULL,
	[UserAreaId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](50) NOT NULL,
	[UserAreaName] [nvarchar](100) NULL,
	[HospitalRepresentativeId] [int] NULL,
	[CompanyRepresentativeId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[ReferenceNo] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DefaultRating] [nvarchar](15) NULL,
	[IsDeductionGenerated] [bit] NOT NULL,
	[IsScheduleGeneration] [bit] NULL,
	[GeneratedBatch] [nvarchar](50) NULL,
	[RescheduleDate] [datetime] NULL,
	[Reason] [int] NULL,
	[CancelledReason] [int] NULL,
	[CancelDate] [datetime] NULL,
 CONSTRAINT [PK_CLSJointInspectionDetailTxn] PRIMARY KEY CLUSTERED 
(
	[JIInspectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
