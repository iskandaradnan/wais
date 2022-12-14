USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoProcessStatusAspTxnDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoProcessStatusAspTxnDet](
	[ProcessStatusAspId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProcessStatusId] [int] NOT NULL,
	[StartDateTime] [datetime] NULL,
	[ReferenceNo] [nvarchar](50) NULL,
	[PatientName] [nvarchar](75) NULL,
	[PatientICNo] [nvarchar](50) NULL,
	[Treatment] [nvarchar](50) NULL,
	[EndDateTime] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngMwoProcessStatusAspTxnDet_ProcessStatusAspId] PRIMARY KEY CLUSTERED 
(
	[ProcessStatusAspId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusAspTxnDet] ADD  CONSTRAINT [DF_EngMwoProcessStatusAspTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusAspTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusAspTxnDet_EngMwoProcessStatusTxnDet_ProcessStatusId] FOREIGN KEY([ProcessStatusId])
REFERENCES [dbo].[EngMwoProcessStatusTxnDet] ([ProcessStatusId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusAspTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusAspTxnDet_EngMwoProcessStatusTxnDet_ProcessStatusId]
GO
