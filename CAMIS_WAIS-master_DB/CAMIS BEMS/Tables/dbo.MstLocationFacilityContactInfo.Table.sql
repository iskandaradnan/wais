USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationFacilityContactInfo]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationFacilityContactInfo](
	[FacilityContactInfoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Designation] [nvarchar](200) NULL,
	[ContactNo] [nvarchar](200) NULL,
	[Email] [nvarchar](200) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MstLocationFacilityContactInfo] PRIMARY KEY CLUSTERED 
(
	[FacilityContactInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo] ADD  CONSTRAINT [DF_MstLocationFacilityContactInfo_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo] ADD  CONSTRAINT [DF_MstLocationFacilityContactInfo_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo] ADD  CONSTRAINT [DF_MstLocationFacilityContactInfo_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationFacilityContactInfo_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo] CHECK CONSTRAINT [FK_MstLocationFacilityContactInfo_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationFacilityContactInfo_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[MstLocationFacilityContactInfo] CHECK CONSTRAINT [FK_MstLocationFacilityContactInfo_MstLocationFacility_FacilityId]
GO
