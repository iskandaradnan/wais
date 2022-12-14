USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSPeriodicWorkRecordTxn]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSPeriodicWorkRecordTxn](
	[PeriodicWorkId] [int] NOT NULL,
	[UserAreaId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[NoOfUserLocations] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[DocumentNo] [nvarchar](50) NOT NULL,
	[RescheduledDate] [datetime] NULL,
	[CLSUserAreaId] [int] NULL,
 CONSTRAINT [PK_CLSPeriodicWorkRecordTxn] PRIMARY KEY CLUSTERED 
(
	[PeriodicWorkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
