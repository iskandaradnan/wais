USE uetrackMasterdbPreProd
GO

/****** Object:  Table [dbo].[GmMaintenanceYearDetailsMst]    Script Date: 26-08-2021 20:03:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GmMaintenanceYearDetailsMst](
	[MaintenanceId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Year] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[NoOfWeeks] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [FK_GMYDMaintenanceId] PRIMARY KEY CLUSTERED 
(
	[MaintenanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


