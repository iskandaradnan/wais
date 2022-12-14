USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRegistration]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRegistration](
	[UserRegistrationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[StaffName] [nvarchar](75) NOT NULL,
	[UserName] [nvarchar](75) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[Gender] [int] NOT NULL,
	[PhoneNumber] [nvarchar](30) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[DateJoined] [datetime] NOT NULL,
	[DateJoinedUTC] [datetime] NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[IsMailSent] [bit] NULL,
	[MailSentTime] [datetime] NULL,
	[MailSentTimeUTC] [datetime] NULL,
	[ExpiryDuration] [int] NULL,
	[LoginAttempt] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[IsBlocked] [bit] NULL,
	[InvalidAttempts] [int] NULL,
	[InvalidAttemptDateTime] [datetime] NULL,
	[InvalidAttemptDateTimeUTC] [datetime] NULL,
	[LoginDateTime] [datetime] NULL,
	[LoginDateTimeUTC] [datetime] NULL,
	[PasswordChangedDateTime] [datetime] NULL,
	[PasswordChangedDateTimeUTC] [datetime] NULL,
	[MobileNumber] [nvarchar](30) NULL,
	[ExistingStaff] [bit] NOT NULL,
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
	[UserDesignationId] [int] NULL,
	[UserCompetencyId] [nvarchar](100) NULL,
	[UserSpecialityId] [nvarchar](100) NULL,
	[Nationality] [int] NULL,
	[UserDepartmentId] [int] NULL,
	[UserGradeId] [int] NULL,
	[FacilityId] [int] NULL,
	[IsClockIn] [bit] NULL,
	[ContractorId] [int] NULL,
	[IsCenterPool] [bit] NULL,
	[IsUserEngaged] [bit] NULL,
	[LabourCostPerHour] [numeric](24, 2) NULL,
	[Employee_ID] [varchar](20) NULL,
	[MigratedData] [int] NULL,
 CONSTRAINT [PK_UMUserRegistration] PRIMARY KEY CLUSTERED 
(
	[UserRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMUserRegistration] ADD  CONSTRAINT [DF_UMUserRegistration_ExistingStaff]  DEFAULT ((0)) FOR [ExistingStaff]
GO
ALTER TABLE [dbo].[UMUserRegistration] ADD  CONSTRAINT [DF_UMUserRegistration_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMUserRegistration] ADD  CONSTRAINT [DF_UMUserRegistration_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMUserRegistration] ADD  CONSTRAINT [DF_UMUserRegistration_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMUserRegistration] ADD  CONSTRAINT [DF_UMUserRegistration_IsUserEngaged]  DEFAULT ((0)) FOR [IsUserEngaged]
GO
ALTER TABLE [dbo].[UMUserRegistration]  WITH CHECK ADD  CONSTRAINT [FK_UMUserRegistration_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[UMUserRegistration] CHECK CONSTRAINT [FK_UMUserRegistration_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[UMUserRegistration]  WITH CHECK ADD  CONSTRAINT [FK_UMUserRegistration_UMUserType_UserTypeId] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UMUserType] ([UserTypeId])
GO
ALTER TABLE [dbo].[UMUserRegistration] CHECK CONSTRAINT [FK_UMUserRegistration_UMUserType_UserTypeId]
GO
