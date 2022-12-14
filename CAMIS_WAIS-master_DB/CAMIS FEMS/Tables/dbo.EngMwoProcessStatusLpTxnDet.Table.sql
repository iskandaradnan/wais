USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngMwoProcessStatusLpTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngMwoProcessStatusLpTxnDet](
	[ProcessStatusLpId] [int] IDENTITY(1,1) NOT NULL,
	[ProcessStatusId] [int] NOT NULL,
	[ProvisionDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[AcceptedBy] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EngMwoProcessStatusLpTxnDet] PRIMARY KEY CLUSTERED 
(
	[ProcessStatusLpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusLpTxnDet] ADD  CONSTRAINT [DF_EngMwoProcessStatusLpTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusLpTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusLpTxnDet_EngMwoProcessStatusTxnDet_ProcessStatusId] FOREIGN KEY([ProcessStatusId])
REFERENCES [dbo].[EngMwoProcessStatusTxnDet] ([ProcessStatusId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusLpTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusLpTxnDet_EngMwoProcessStatusTxnDet_ProcessStatusId]
GO
ALTER TABLE [dbo].[EngMwoProcessStatusLpTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngMwoProcessStatusLpTxnDet_UMUserRegistration_AcceptedBy] FOREIGN KEY([AcceptedBy])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[EngMwoProcessStatusLpTxnDet] CHECK CONSTRAINT [FK_EngMwoProcessStatusLpTxnDet_UMUserRegistration_AcceptedBy]
GO
