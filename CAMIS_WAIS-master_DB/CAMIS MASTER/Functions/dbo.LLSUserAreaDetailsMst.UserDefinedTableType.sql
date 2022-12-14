USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSUserAreaDetailsMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSUserAreaDetailsMst] AS TABLE(
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
	[LAADStartTime] [datetime2](7) NULL,
	[CleaningSanitizing] [nvarchar](20) NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
