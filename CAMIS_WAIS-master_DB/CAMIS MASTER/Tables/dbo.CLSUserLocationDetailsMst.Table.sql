USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserLocationDetailsMst]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserLocationDetailsMst](
	[CLSUserLocationId] [int] IDENTITY(1,1) NOT NULL,
	[UserLocationId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[CLSUserAreaId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[EffectiveFromDate] [datetime] NOT NULL,
	[EffectiveToDate] [datetime] NULL,
	[ContactPerson] [nvarchar](150) NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[CleanableArea] [numeric](24, 2) NULL,
 CONSTRAINT [PK_CLSUserLocationDetailsMst] PRIMARY KEY CLUSTERED 
(
	[CLSUserLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
