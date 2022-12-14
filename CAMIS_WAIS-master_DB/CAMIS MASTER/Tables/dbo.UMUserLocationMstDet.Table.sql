USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserLocationMstDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserLocationMstDet](
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[UserRoleId] [int] NOT NULL,
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
 CONSTRAINT [PK_UMUserLocationMstDet] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] ADD  CONSTRAINT [DF_UMUserLocationMstDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] ADD  CONSTRAINT [DF_UMUserLocationMstDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] ADD  CONSTRAINT [DF_UMUserLocationMstDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet]  WITH CHECK ADD  CONSTRAINT [FK_UMUserLocationMstDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] CHECK CONSTRAINT [FK_UMUserLocationMstDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet]  WITH CHECK ADD  CONSTRAINT [FK_UMUserLocationMstDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] CHECK CONSTRAINT [FK_UMUserLocationMstDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet]  WITH CHECK ADD  CONSTRAINT [FK_UMUserLocationMstDet_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] CHECK CONSTRAINT [FK_UMUserLocationMstDet_UMUserRegistration_UserRegistrationId]
GO
ALTER TABLE [dbo].[UMUserLocationMstDet]  WITH CHECK ADD  CONSTRAINT [FK_UMUserLocationMstDet_UMUserRole_UserRoleId] FOREIGN KEY([UserRoleId])
REFERENCES [dbo].[UMUserRole] ([UMUserRoleId])
GO
ALTER TABLE [dbo].[UMUserLocationMstDet] CHECK CONSTRAINT [FK_UMUserLocationMstDet_UMUserRole_UserRoleId]
GO
