USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstDedPenaltyDet]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstDedPenaltyDet](
	[PenaltyDetId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[PenaltyId] [int] NOT NULL,
	[CriteriaId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MstDedPenaltyDet] PRIMARY KEY CLUSTERED 
(
	[PenaltyDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstDedPenaltyDet] ADD  CONSTRAINT [DF_MstDedPenaltyDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstDedPenaltyDet] ADD  CONSTRAINT [DF_MstDedPenaltyDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstDedPenaltyDet] ADD  CONSTRAINT [DF_MstDedPenaltyDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstDedPenaltyDet]  WITH CHECK ADD  CONSTRAINT [FK_MstDedPenaltyDet_MstDedCriteria_CriteriaId] FOREIGN KEY([CriteriaId])
REFERENCES [dbo].[MstDedCriteria] ([CriteriaId])
GO
ALTER TABLE [dbo].[MstDedPenaltyDet] CHECK CONSTRAINT [FK_MstDedPenaltyDet_MstDedCriteria_CriteriaId]
GO
ALTER TABLE [dbo].[MstDedPenaltyDet]  WITH CHECK ADD  CONSTRAINT [FK_MstDedPenaltyDet_MstDedPenalty_PenaltyId] FOREIGN KEY([PenaltyId])
REFERENCES [dbo].[MstDedPenalty] ([PenaltyId])
GO
ALTER TABLE [dbo].[MstDedPenaltyDet] CHECK CONSTRAINT [FK_MstDedPenaltyDet_MstDedPenalty_PenaltyId]
GO
ALTER TABLE [dbo].[MstDedPenaltyDet]  WITH CHECK ADD  CONSTRAINT [FK_MstDedPenaltyDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[MstDedPenaltyDet] CHECK CONSTRAINT [FK_MstDedPenaltyDet_MstService_ServiceId]
GO
