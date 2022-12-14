USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FEClock]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEClock](
	[ClockId] [int] IDENTITY(1,1) NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[DateTimeUTC] [datetime] NOT NULL,
	[ClockIn] [datetime] NOT NULL,
	[ClockInUTC] [datetime] NOT NULL,
	[ClockInLatitude] [numeric](24, 15) NOT NULL,
	[ClockInLongitude] [numeric](24, 15) NOT NULL,
	[ClockOut] [datetime] NULL,
	[ClockOutUTC] [datetime] NULL,
	[ClockOutLatitude] [numeric](24, 15) NULL,
	[ClockOutLongitude] [numeric](24, 15) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FEClock] PRIMARY KEY CLUSTERED 
(
	[ClockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FEClock] ADD  CONSTRAINT [DF_FEClock_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FEClock]  WITH CHECK ADD  CONSTRAINT [FK_FEClock_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[FEClock] CHECK CONSTRAINT [FK_FEClock_UMUserRegistration_UserRegistrationId]
GO
