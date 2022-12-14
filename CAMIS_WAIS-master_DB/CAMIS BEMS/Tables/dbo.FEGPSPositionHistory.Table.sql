USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[FEGPSPositionHistory]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEGPSPositionHistory](
	[GPSPositionHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[DateTimeUTC] [datetime] NOT NULL,
	[Latitude] [numeric](24, 15) NOT NULL,
	[Longitude] [numeric](24, 15) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FEGPSPositionHistory] PRIMARY KEY CLUSTERED 
(
	[GPSPositionHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FEGPSPositionHistory] ADD  CONSTRAINT [DF_FEGPSPositionHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FEGPSPositionHistory]  WITH CHECK ADD  CONSTRAINT [FK_FEGPSPositionHistory_UMUserRegistration_UserRegistrationId] FOREIGN KEY([UserRegistrationId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[FEGPSPositionHistory] CHECK CONSTRAINT [FK_FEGPSPositionHistory_UMUserRegistration_UserRegistrationId]
GO
