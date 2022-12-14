USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CLSUserLocationDetailsDailyCleansingMstDet]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLSUserLocationDetailsDailyCleansingMstDet](
	[DailyCleansingId] [int] IDENTITY(1,1) NOT NULL,
	[CLSUserAreaId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[DustMop] [numeric](24, 2) NULL,
	[DumpMop] [numeric](24, 2) NULL,
	[Vacuum] [numeric](24, 2) NULL,
	[Washing] [numeric](24, 2) NULL,
	[Sweeping] [numeric](24, 2) NULL,
	[Wiping] [numeric](24, 2) NULL,
	[PaperHandTowel] [numeric](24, 2) NULL,
	[ToiletJumboRoll] [numeric](24, 2) NULL,
	[HandSoap] [numeric](24, 2) NULL,
	[Deodorisers] [numeric](24, 2) NULL,
	[DosmeticWaste] [numeric](24, 2) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_CLSUserLocationDetailsDailyCleansingMstDet] PRIMARY KEY CLUSTERED 
(
	[DailyCleansingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
