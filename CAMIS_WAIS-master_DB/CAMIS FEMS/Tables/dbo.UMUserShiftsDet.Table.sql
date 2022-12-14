USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMUserShiftsDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMUserShiftsDet](
	[UserShiftDetId] [int] IDENTITY(1,1) NOT NULL,
	[UserShiftsId] [int] NOT NULL,
	[LeaveFrom] [datetime] NULL,
	[LeaveTo] [datetime] NULL,
	[NoOfDays] [numeric](24, 2) NULL,
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
 CONSTRAINT [PK_UMUserShiftsDet] PRIMARY KEY CLUSTERED 
(
	[UserShiftDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMUserShiftsDet] ADD  CONSTRAINT [DF_UMUserShiftsDet_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMUserShiftsDet] ADD  CONSTRAINT [DF_UMUserShiftsDet_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMUserShiftsDet] ADD  CONSTRAINT [DF_UMUserShiftsDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UMUserShiftsDet]  WITH CHECK ADD  CONSTRAINT [FK_UMUserShiftsDet_UMUserShifts_UserShiftsId] FOREIGN KEY([UserShiftsId])
REFERENCES [dbo].[UMUserShifts] ([UserShiftsId])
GO
ALTER TABLE [dbo].[UMUserShiftsDet] CHECK CONSTRAINT [FK_UMUserShiftsDet_UMUserShifts_UserShiftsId]
GO
