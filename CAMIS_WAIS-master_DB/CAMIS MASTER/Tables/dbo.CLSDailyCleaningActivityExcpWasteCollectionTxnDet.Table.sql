USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSDailyCleaningActivityExcpWasteCollectionTxnDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSDailyCleaningActivityExcpWasteCollectionTxnDet](
	[DomesticWasteId] [int] NOT NULL,
	[CleaningActivityId] [int] NOT NULL,
	[UserLocationId] [int] NOT NULL,
	[TotalException] [numeric](24, 2) NULL,
	[CauseCode] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[IsWasteCollected] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CLSUserLocationId] [int] NULL,
 CONSTRAINT [PK_CLSDailyCleaningActivityExcpWasteCollectionTxnDet] PRIMARY KEY CLUSTERED 
(
	[DomesticWasteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
