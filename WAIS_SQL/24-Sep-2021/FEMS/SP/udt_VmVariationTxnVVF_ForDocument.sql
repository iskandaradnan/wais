CREATE TYPE [dbo].[udt_VmVariationTxnVVF_ForDocument] AS TABLE(
	[VariationId] [int] NULL,
	[SNFDocumentNo] [nvarchar](50) NULL,
	[AssetId] [int] NULL,
	[WorkFlowStatus] [int] NULL,
	[CountingDays] [numeric](24, 2) NULL,
	[Action] [nvarchar](100) NULL,
	[Remarks] [nvarchar](500) NULL,
	[MonthlyProposedFeePW] [numeric](24, 2) NULL,
	[MonthlyProposedFeeDW] [numeric](24, 2) NULL,
	[MaintenanceRatePW] [numeric](24, 2) NULL,
	[MaintenanceRateDW] [numeric](24, 2) NULL,
	[UserId] [int] NULL,
	[DocumentId] [int] NULL
)
GO


