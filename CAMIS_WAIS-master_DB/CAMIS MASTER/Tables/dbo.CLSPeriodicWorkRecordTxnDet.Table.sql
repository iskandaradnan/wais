USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSPeriodicWorkRecordTxnDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSPeriodicWorkRecordTxnDet](
	[PeriodicWorkRecordId] [int] NOT NULL,
	[PeriodicWorkId] [int] NOT NULL,
	[UserLocationId] [int] NOT NULL,
	[ActivityDescription] [int] NULL,
	[NotCarriedOut] [numeric](24, 2) NULL,
	[NotToSchedule] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[IsPerodicWorkWeekly] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CLSUserLocationId] [int] NULL,
 CONSTRAINT [PK_CLSPeriodicWorkRecordTxnDet] PRIMARY KEY CLUSTERED 
(
	[PeriodicWorkRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
