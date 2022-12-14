USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstWorkingCalender]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstWorkingCalender](
	[CalenderId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Year] [int] NOT NULL,
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
 CONSTRAINT [PK_MstWorkingCalender] PRIMARY KEY CLUSTERED 
(
	[CalenderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstWorkingCalender] ADD  CONSTRAINT [DF_MstWorkingCalender_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstWorkingCalender] ADD  CONSTRAINT [DF_MstWorkingCalender_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstWorkingCalender] ADD  CONSTRAINT [DF_MstWorkingCalender_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstWorkingCalender]  WITH CHECK ADD  CONSTRAINT [FK_MstWorkingCalender_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstWorkingCalender] CHECK CONSTRAINT [FK_MstWorkingCalender_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[MstWorkingCalender]  WITH CHECK ADD  CONSTRAINT [FK_MstWorkingCalender_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[MstWorkingCalender] CHECK CONSTRAINT [FK_MstWorkingCalender_MstLocationFacility_FacilityId]
GO
