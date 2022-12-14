USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationUserLocationHistory]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationUserLocationHistory](
	[UserLocationHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserLocationId] [int] NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
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
 CONSTRAINT [PK_MstLocationUserLocationHistory] PRIMARY KEY CLUSTERED 
(
	[UserLocationHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstLocationUserLocationHistory] ADD  CONSTRAINT [DF_MstLocationUserLocationHistory_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstLocationUserLocationHistory] ADD  CONSTRAINT [DF_MstLocationUserLocationHistory_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstLocationUserLocationHistory] ADD  CONSTRAINT [DF_MstLocationUserLocationHistory_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstLocationUserLocationHistory]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocationHistory_MstLocationUserLocation_UserLocationId] FOREIGN KEY([UserLocationId])
REFERENCES [dbo].[MstLocationUserLocation] ([UserLocationId])
GO
ALTER TABLE [dbo].[MstLocationUserLocationHistory] CHECK CONSTRAINT [FK_MstLocationUserLocationHistory_MstLocationUserLocation_UserLocationId]
GO
