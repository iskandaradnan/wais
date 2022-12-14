USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSUserAreaDetailsMst]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSUserAreaDetailsMst](
	[LLSUserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](25) NOT NULL,
	[HospitalRep] [int] NULL,
	[EffectiveFromDate] [datetime] NOT NULL,
	[EffectiveToDate] [datetime] NULL,
	[OperatingDays] [nvarchar](25) NULL,
	[Status] [int] NOT NULL,
	[WhiteBag] [int] NOT NULL,
	[RedBag] [int] NOT NULL,
	[GreenBag] [int] NOT NULL,
	[BrownBag] [int] NOT NULL,
	[AlginateBag] [int] NOT NULL,
	[SoiledLinenBagHolder] [int] NOT NULL,
	[RejectBagHolder] [int] NOT NULL,
	[SoiledLinenRack] [int] NOT NULL,
	[LAADStartTime] [time](7) NULL,
	[LAADEndTime] [time](7) NULL,
	[CleaningSanitizing] [nvarchar](20) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]
GO
