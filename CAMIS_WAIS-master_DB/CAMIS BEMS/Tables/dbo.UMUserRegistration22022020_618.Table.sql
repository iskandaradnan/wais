USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserRegistration22022020_618]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserRegistration22022020_618](
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
	[LabourCostPerHour] [numeric](24, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
