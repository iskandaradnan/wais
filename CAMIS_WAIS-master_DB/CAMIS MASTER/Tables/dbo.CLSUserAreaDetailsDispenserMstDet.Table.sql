USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserAreaDetailsDispenserMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserAreaDetailsDispenserMstDet](
	[DispenserId] [int] IDENTITY(1,1) NOT NULL,
	[CLSUserAreaId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[HandPaperTowelHolder] [numeric](24, 2) NULL,
	[JumboRollToiletRollHolder] [numeric](24, 2) NULL,
	[HandSoapLiquidSoapDispenser] [numeric](24, 2) NULL,
	[DeodrantParaBlock] [numeric](24, 2) NULL,
	[FootPumpNonContactTypeDispenser] [numeric](24, 2) NULL,
	[HandDryers] [numeric](24, 2) NULL,
	[AutoTimeDeoderizerAirFreshenerDispenser] [numeric](24, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSUserAreaDetailsMstDispenserMstDet] PRIMARY KEY CLUSTERED 
(
	[DispenserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
