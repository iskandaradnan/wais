USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[Common_Data_Master]    Script Date: 20-09-2021 17:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Common_Data_Master](
	[Common_Id] [int] IDENTITY(1,1) NOT NULL,
	[BlockId] [int] NULL,
	[LevelId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NOT NULL,
	[ActiveToDateUTC] [datetime] NOT NULL,
	[BlockCode] [nvarchar](500) NOT NULL,
	[BlockName] [nvarchar](500) NOT NULL,
	[B_ShortName] [nvarchar](500) NOT NULL,
	[LevelCode] [nvarchar](500) NOT NULL,
	[LevelName] [nvarchar](500) NOT NULL,
	[L_ShortName] [nvarchar](500) NOT NULL,
	[UserAreaCode] [nvarchar](500) NOT NULL,
	[UserAreaName] [nvarchar](500) NOT NULL,
	[U_ShortUserAreaName] [nvarchar](500) NOT NULL,
	[UserLocationCode] [nvarchar](500) NOT NULL,
	[UserLocationName] [nvarchar](500) NOT NULL,
	[U_UserLocationName] [nvarchar](500) NOT NULL,
	[TypeOfRequest] [int] NOT NULL,
	[Remarks_BlockId] [nvarchar](500) NULL,
	[Remarks_LevelId] [nvarchar](500) NULL,
	[Remarks_UserAreaId] [nvarchar](500) NULL,
	[Remarks_UserLocationId] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[BuiltIn] [datetime] NULL,
 CONSTRAINT [PK_Common_Id] PRIMARY KEY CLUSTERED 
(
	[Common_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
