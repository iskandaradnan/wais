USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstWorkingCalenderDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstWorkingCalenderDet](
	[CalenderDetId] [int] IDENTITY(1,1) NOT NULL,
	[CalenderId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[IsWorking] [bit] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
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
 CONSTRAINT [PK_MstWorkingCalenderDet] PRIMARY KEY CLUSTERED 
(
	[CalenderDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstWorkingCalenderDet] ADD  CONSTRAINT [DF_MstWorkingCalenderDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstWorkingCalenderDet] ADD  CONSTRAINT [DF_MstWorkingCalenderDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstWorkingCalenderDet] ADD  CONSTRAINT [DF_MstWorkingCalenderDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstWorkingCalenderDet]  WITH CHECK ADD  CONSTRAINT [FK_MstWorkingCalenderDet_MstWorkingCalender_CalenderId] FOREIGN KEY([CalenderId])
REFERENCES [dbo].[MstWorkingCalender] ([CalenderId])
GO
ALTER TABLE [dbo].[MstWorkingCalenderDet] CHECK CONSTRAINT [FK_MstWorkingCalenderDet_MstWorkingCalender_CalenderId]
GO
