USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSUserAreaDetailsMst_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSUserAreaDetailsMst_Update] AS TABLE(
	[UserAreaId] [int] NOT NULL,
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
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL
)
GO
