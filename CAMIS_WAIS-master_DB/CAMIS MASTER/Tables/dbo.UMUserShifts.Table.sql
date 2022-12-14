USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserShifts]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserShifts](
	[UserShiftsId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[UserRegistrationId] [int] NOT NULL,
	[LunchTimeLovId] [int] NOT NULL,
	[LeaveFrom] [datetime] NULL,
	[LeaveTo] [datetime] NULL,
	[NoOfDays] [numeric](24, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
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
	[ShiftTimeLovId] [int] NULL,
	[ShiftStartTime] [nvarchar](10) NULL,
	[ShiftStartTimeMin] [nvarchar](10) NULL,
	[ShiftEndTime] [nvarchar](10) NULL,
	[ShiftEndTimeMin] [nvarchar](10) NULL,
	[ShiftBreakStartTime] [nvarchar](10) NULL,
	[ShiftBreakStartTimeMin] [nvarchar](10) NULL,
	[ShiftBreakEndTime] [nvarchar](10) NULL,
	[ShiftBreakEndTimeMin] [nvarchar](10) NULL,
 CONSTRAINT [PK_UMUserShifts] PRIMARY KEY CLUSTERED 
(
	[UserShiftsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMUserShifts] ADD  CONSTRAINT [DF_UMUserShifts_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMUserShifts] ADD  CONSTRAINT [DF_UMUserShifts_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMUserShifts] ADD  CONSTRAINT [DF_UMUserShifts_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMUserShifts]  WITH CHECK ADD  CONSTRAINT [FK_UMUserShifts_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[UMUserShifts] CHECK CONSTRAINT [FK_UMUserShifts_UMUserRegistration_UserRegistrationId]
GO
