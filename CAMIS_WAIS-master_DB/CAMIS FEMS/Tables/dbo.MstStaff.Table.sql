USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstStaff]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstStaff](
	[StaffMasterId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserRegistrationId] [int] NULL,
	[AccessLevel] [int] NOT NULL,
	[StaffEmployeeId] [nvarchar](25) NOT NULL,
	[StaffName] [nvarchar](100) NOT NULL,
	[StaffRoleId] [int] NOT NULL,
	[DesignationId] [int] NULL,
	[StaffCompetencyId] [nvarchar](50) NULL,
	[StaffSpecialityId] [nvarchar](50) NULL,
	[StaffGraded] [int] NULL,
	[PersonalIdentityTypeLovId] [int] NOT NULL,
	[PersonalUniqueId] [nvarchar](30) NOT NULL,
	[EmployeeTypeLovId] [int] NULL,
	[IsEmployeeShared] [bit] NULL,
	[Gender] [int] NOT NULL,
	[Nationality] [int] NOT NULL,
	[Email] [nvarchar](100) NULL,
	[ContactNo] [nvarchar](30) NULL,
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
	[StaffDepartmentId] [int] NULL,
 CONSTRAINT [PK_MstStaff] PRIMARY KEY CLUSTERED 
(
	[StaffMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstStaff] ADD  CONSTRAINT [DF_MstStaff_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstStaff] ADD  CONSTRAINT [DF_MstStaff_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstStaff] ADD  CONSTRAINT [DF_MstStaff_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstStaff]  WITH CHECK ADD  CONSTRAINT [FK_MstStaff_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstStaff] CHECK CONSTRAINT [FK_MstStaff_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[MstStaff]  WITH CHECK ADD  CONSTRAINT [FK_MstStaff_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[MstStaff] CHECK CONSTRAINT [FK_MstStaff_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[MstStaff]  WITH CHECK ADD  CONSTRAINT [FK_MstStaff_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[MstStaff] CHECK CONSTRAINT [FK_MstStaff_UMUserRegistration_UserRegistrationId]
GO
