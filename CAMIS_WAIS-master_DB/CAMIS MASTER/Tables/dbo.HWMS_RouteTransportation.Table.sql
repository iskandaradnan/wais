USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RouteTransportation]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RouteTransportation](
	[RouteTransportationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[RouteCode] [nvarchar](100) NULL,
	[RouteDescription] [nvarchar](100) NULL,
	[RouteCategory] [varchar](100) NULL,
	[Status] [int] NULL,
 CONSTRAINT [Transportation_PK_Id] PRIMARY KEY CLUSTERED 
(
	[RouteTransportationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
