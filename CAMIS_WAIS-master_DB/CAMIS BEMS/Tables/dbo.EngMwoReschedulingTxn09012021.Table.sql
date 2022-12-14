USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoReschedulingTxn09012021]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoReschedulingTxn09012021](
	[WorkOrderReschedulingId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NOT NULL,
	[RescheduleDate] [datetime] NOT NULL,
	[RescheduleDateUTC] [datetime] NOT NULL,
	[RescheduleApprovedBy] [int] NULL,
	[Reasons] [int] NULL,
	[ImpactSchedulePlanner] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [varbinary](max) NULL,
	[Reason] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
