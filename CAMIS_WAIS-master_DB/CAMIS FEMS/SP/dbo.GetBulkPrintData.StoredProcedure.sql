USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetBulkPrintData]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE  [dbo].[GetBulkPrintData]                           

  @FacilityId	INT
 ,@CustomerId	INT
 ,@Year	INT
 ,@typeofplanner	INT
 ,@ModuleId INT
 ,@WorkGroup INT



AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	if(@ModuleId=1)
	begin 

	if(@typeofplanner=0)
	begin 

	select
	a.WeekLogId,
	isnull(c.fieldvalue,'')  Typeofplanner,
	isnull(a.Year,0)[Year],
	isnull(a.WeekNo,0)[WeekNo],
	isnull(a.WeekStartDate,getdate())[WeekStartDate],
	isnull(a.WeekEndDate,getdate())[WeekEndDate],
	isnull(a.GenerateDate,getdate()) GeneratedDate,
	isnull(a.FacilityId,0)[FacilityId],
	isnull(b.FileInfo,'NA')[Print_File],
	isnull(b.JobId,0)[uniq],
	iif((b.[Status] is null OR b.[Status]='Failed'),'NA',[Status])[Status]
	,a.typeofplanner 

	from EngScheduleGenerationWeekLog  a
	left join [EngScheduleGenerationFileJob] b on b.WeekLogId=a.WeekLogId and b.[status] not in ('Failed') and b.isdeleted=0
	left join [UetrackMasterdbPreProd]..fmlovmst c on c.lovid=a.typeofplanner

	where 
	a.FacilityId=@FacilityId 
	and a.CustomerId=@CustomerId 
	and a.[Year]=@Year  
	and a.ClassificationId=@WorkGroup
	
	
	end 

	else
	begin 

	
	select
	a.WeekLogId,
	isnull(c.fieldvalue,'')  Typeofplanner,
	isnull(a.Year,0)[Year],
	isnull(a.WeekNo,0)[WeekNo],
	isnull(a.WeekStartDate,getdate())[WeekStartDate],
	isnull(a.WeekEndDate,getdate())[WeekEndDate],
	isnull(a.GenerateDate,getdate()) GeneratedDate,
	isnull(a.FacilityId,0)[FacilityId],
	isnull(b.FileInfo,'NA')[Print_File],
	isnull(b.JobId,0)[uniq],
	iif((b.[Status] is null OR b.[Status]='Failed'),'NA',[Status])[Status]

	--,a.typeofplanner 

	from EngScheduleGenerationWeekLog  a
	left join [EngScheduleGenerationFileJob] b on b.WeekLogId=a.WeekLogId  and b.[status] not in ('Failed') 	and b.isdeleted=0
	left join [UetrackMasterdbPreProd]..fmlovmst c on c.lovid=a.typeofplanner

	where 
	a.FacilityId=@FacilityId 
	and a.CustomerId=@CustomerId 
	and a.[Year]=@Year  
	and a.TypeOfPlanner=@typeofplanner
	 and a.ClassificationId=@WorkGroup
	end






	end

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
