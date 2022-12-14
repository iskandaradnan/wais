USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[SmartAssignWorkOrderAssignmentWorkFlow]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmartAssignWorkOrderAssignmentWorkFlow](
	[WOAssignmentWorkFlowId] [int] IDENTITY(1,1) NOT NULL,
	[WOAssignmentId] [int] NOT NULL,
	[WorkFlowId] [int] NOT NULL,
	[ActionTaken] [nvarchar](500) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SmartAssignWorkOrderAssignmentWorkFlow] PRIMARY KEY CLUSTERED 
(
	[WOAssignmentWorkFlowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignmentWorkFlow] ADD  CONSTRAINT [DF_SmartAssignWorkOrderAssignmentWorkFlow_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignmentWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignmentWorkFlow_SmartAssignWorkFlow_WorkFlowId] FOREIGN KEY([WorkFlowId])
REFERENCES [dbo].[SmartAssignWorkFlow] ([WorkFlowId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignmentWorkFlow] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignmentWorkFlow_SmartAssignWorkFlow_WorkFlowId]
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignmentWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_SmartAssignWorkOrderAssignmentWorkFlow_SmartAssignWorkOrderAssignment_WOAssignmentId] FOREIGN KEY([WOAssignmentId])
REFERENCES [dbo].[SmartAssignWorkOrderAssignment] ([WOAssignmentId])
GO
ALTER TABLE [dbo].[SmartAssignWorkOrderAssignmentWorkFlow] CHECK CONSTRAINT [FK_SmartAssignWorkOrderAssignmentWorkFlow_SmartAssignWorkOrderAssignment_WOAssignmentId]
GO
