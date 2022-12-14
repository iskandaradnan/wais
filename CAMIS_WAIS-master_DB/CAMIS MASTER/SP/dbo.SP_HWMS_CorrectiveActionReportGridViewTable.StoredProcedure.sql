USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_CorrectiveActionReportGridViewTable]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SP_HWMS_CorrectiveActionReportGridViewTable](
@Activity varchar(50),
	 @Startdate datetime,
	 @TargetDate datetime,
	 @Actualcompletiondate datetime,
	 @Responsibility varchar(50),
	 @Responsibleperson varchar(50),
	 @Idno int
		)
		 as
		begin
		insert into HWMS_CorrectiveActionReportGridViewTable values(@Activity,@Startdate,@TargetDate,@Actualcompletiondate,@Responsibility,
		@Responsibleperson,@Idno)
end
GO
