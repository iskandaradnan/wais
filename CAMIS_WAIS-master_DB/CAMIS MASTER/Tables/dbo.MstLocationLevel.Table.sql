USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationLevel]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationLevel](
	[LevelId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockId] [int] NOT NULL,
	[previouscode] [nvarchar](25) NULL,
	[previousname] [nvarchar](200) NULL,
	[LevelCode] [nvarchar](25) NOT NULL,
	[LevelName] [nvarchar](100) NOT NULL,
	[ShortName] [nvarchar](50) NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
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
 CONSTRAINT [PK_MstLocationLevel] PRIMARY KEY CLUSTERED 
(
	[LevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstLocationLevel] ADD  CONSTRAINT [DF_MstLocationLevel_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstLocationLevel] ADD  CONSTRAINT [DF_MstLocationLevel_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstLocationLevel] ADD  CONSTRAINT [DF_MstLocationLevel_GuId]  DEFAULT (newid()) FOR [GuId]
GO
