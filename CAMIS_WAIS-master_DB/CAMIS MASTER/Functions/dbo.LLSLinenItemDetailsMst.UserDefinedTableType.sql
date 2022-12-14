USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSLinenItemDetailsMst]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSLinenItemDetailsMst] AS TABLE(
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[LinenCode] [nvarchar](25) NULL,
	[LinenDescription] [nvarchar](255) NOT NULL,
	[UOM] [int] NULL,
	[Status] [int] NOT NULL,
	[Material] [int] NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[Size] [nvarchar](150) NOT NULL,
	[Colour] [int] NOT NULL,
	[IdentificationMark] [nvarchar](150) NULL,
	[Standard] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
