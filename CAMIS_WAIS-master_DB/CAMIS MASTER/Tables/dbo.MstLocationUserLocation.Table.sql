USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationUserLocation]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationUserLocation](
	[UserLocationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockId] [int] NOT NULL,
	[LevelId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[UserLocationCode] [nvarchar](50) NOT NULL,
	[UserLocationName] [nvarchar](100) NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
	[AuthorizedUserId] [int] NOT NULL,
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
	[QRCode] [varbinary](max) NULL,
	[CompanyStaffId] [int] NULL,
	[MigratedDate] [date] NULL,
 CONSTRAINT [PK_MstLocationUserLocation] PRIMARY KEY CLUSTERED 
(
	[UserLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_location] UNIQUE NONCLUSTERED 
(
	[BlockId] ASC,
	[LevelId] ASC,
	[UserAreaId] ASC,
	[UserLocationCode] ASC,
	[UserLocationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
