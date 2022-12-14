USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequestAssessment]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequestAssessment](
	[CRMAssesmentId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NULL,
	[CRMRequestWOId] [int] NOT NULL,
	[UserId] [int] NULL,
	[FeedBack] [nvarchar](500) NOT NULL,
	[AssessmentStartDateTime] [datetime] NOT NULL,
	[AssessmentStartDateTimeUTC] [datetime] NOT NULL,
	[AssessmentEndDateTime] [datetime] NOT NULL,
	[AssessmentEndDateTimeUTC] [datetime] NOT NULL,
	[ResponseDuration] [numeric](24, 2) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CRMRequestAssessment] PRIMARY KEY CLUSTERED 
(
	[CRMAssesmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRMRequestAssessment] ADD  CONSTRAINT [DF_CRMRequestAssessment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[CRMRequestAssessment]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestAssessment_CRMRequestWorkOrderTxn_CRMRequestWOId] FOREIGN KEY([CRMRequestWOId])
REFERENCES [dbo].[CRMRequestWorkOrderTxn] ([CRMRequestWOId])
GO
ALTER TABLE [dbo].[CRMRequestAssessment] CHECK CONSTRAINT [FK_CRMRequestAssessment_CRMRequestWorkOrderTxn_CRMRequestWOId]
GO
ALTER TABLE [dbo].[CRMRequestAssessment]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestAssessment_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[CRMRequestAssessment] CHECK CONSTRAINT [FK_CRMRequestAssessment_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[CRMRequestAssessment]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestAssessment_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[CRMRequestAssessment] CHECK CONSTRAINT [FK_CRMRequestAssessment_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[CRMRequestAssessment]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestAssessment_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[CRMRequestAssessment] CHECK CONSTRAINT [FK_CRMRequestAssessment_MstService_ServiceId]
GO
ALTER TABLE [dbo].[CRMRequestAssessment]  WITH CHECK ADD  CONSTRAINT [FK_CRMRequestAssessment_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[CRMRequestAssessment] CHECK CONSTRAINT [FK_CRMRequestAssessment_UMUserRegistration_UserId]
GO
