USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[UMUserRegistrationTypeS]    Script Date: 20-09-2021 16:50:20 ******/
CREATE TYPE [dbo].[UMUserRegistrationTypeS] AS TABLE(
	[UserRegistrationId] [int] NOT NULL,
	[ExistingStaff] [bit] NOT NULL,
	[StaffName] [nvarchar](75) NOT NULL,
	[UserName] [nvarchar](75) NOT NULL,
	[Gender] [int] NOT NULL,
	[PhoneNumber] [nvarchar](30) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[MobileNumber] [nvarchar](30) NULL,
	[DateJoined] [datetime] NOT NULL,
	[DateJoinedUTC] [datetime] NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[StaffMasterId] [int] NULL,
	[UserId] [int] NOT NULL,
	[UserDesignationId] [int] NULL,
	[UserCompetencyId] [nvarchar](100) NULL,
	[UserSpecialityId] [nvarchar](100) NULL,
	[UserGradeId] [int] NULL,
	[Nationality] [int] NULL,
	[UserDepartmentId] [int] NULL,
	[FacilityId] [int] NULL,
	[Password] [nvarchar](max) NULL,
	[ContractorId] [int] NULL,
	[IsCenterPool] [bit] NULL,
	[LabourCostPerHour] [numeric](24, 2) NULL,
	[ServicesID] [int] NULL,
	[Employee_ID] [varchar](50) NULL
)
GO
