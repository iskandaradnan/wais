USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequest_Priority]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequest_Priority](
	[CRMRequest_PriorityId] [int] IDENTITY(1,1) NOT NULL,
	[Priority_Type_Description] [nvarchar](200) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[Requester] [int] NULL,
	[Completed_By] [int] NULL,
	[RequestDateTime] [datetime] NULL,
	[RequestDateTimeUTC] [datetime] NULL,
	[TypeOfRequest] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CRMRequest_Priority] PRIMARY KEY CLUSTERED 
(
	[CRMRequest_PriorityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
