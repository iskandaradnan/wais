USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSUserAreaDetailsLinenItemMstDet]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSUserAreaDetailsLinenItemMstDet] AS TABLE(
	[LLSUserAreaId] [int] NOT NULL,
	[UserLocationId] [int] NULL,
	[LinenItemId] [int] NOT NULL,
	[Par1] [numeric](24, 2) NOT NULL,
	[Par2] [numeric](24, 2) NOT NULL,
	[DefaultIssue] [int] NOT NULL,
	[AgreedShelfLevel] [numeric](24, 2) NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL
)
GO
