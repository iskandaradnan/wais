
DROP PROCEDURE [dbo].[EngScheduleGenerationFileJobSave]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[EngScheduleGenerationFileJobSave] 0,19,'EngScheduleGenerationFileJob','EngScheduleGenerationFileJob','c59365e7-5372-4fb6-877e-83f1d20216d7','-',1,3,'-',2021,0
--[EngScheduleGenerationFileJobSave] 318,19,'EngScheduleGenerationFileJob','-','1a14bbbb-6d75-47c6-a614-33882a7f236e','-',1,0,'-',2021,34

--update EngScheduleGenerationFileJob set isdeleted=1 
--select * from EngScheduleGenerationFileJob where gid='1a14bbbb-6d75-47c6-a614-33882a7f236e'

CREATE PROC [dbo].[EngScheduleGenerationFileJobSave](	
	@WeekLogId int,
	@Service int,
	@JobName nvarchar(max),
	@JobDescription nvarchar(max),
	@Gid nvarchar(max),
	@Status nvarchar(max),
	@CreatedBy int,
	@Flag int,
	@FileInfo nvarchar(max),
	@Year int,
	@TypeOfPlanner int,
	@FacilityIds int,
	@CustomerIds int
	)

as 

Begin
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY


	Declare 
   @FacilityId		INT=(select top 1  FacilityId from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
  ,@WeekNo			INT=(select top 1  WeekNo from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
  ,@GenerateDate	datetime=(select top 1  GenerateDate from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)


 ,@CustomerId		INT=(select top 1  CustomerId from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@Years			INT =(select top 1  Year from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@typeofplanners	INT=(select top 1  TypeOfPlanner from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@Startdate		datetime=(select top 1  WeekStartDate from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 ,@EndDateTime		datetime=(select top 1  WeekEndDate from EngScheduleGenerationWeekLog where weeklogid=@WeekLogId)
 






if(@Flag=0)
begin
insert into EngScheduleGenerationFileJob
(FacilityId,CustomerId,Service,JobName,JobDescription,Gid,Status,CreatedBy,CreatedDate,TypeOfPlanner,[Year],WeekNo,WeekLogId,EngUserAreaId) 
values (@FacilityId,@CustomerId,@Service,@JobName,@JobDescription,@Gid,@Status,@CreatedBy,getdate(),@TypeOfPlanners,@Years,@WeekNo,@WeekLogId,0)
end


else if(@Flag=1)
begin


update EngScheduleGenerationFileJob set Status=@Status , FileInfo=@FileInfo,ModifiedDate=getdate() where Gid=@Gid

end



if(@Flag=3 and @WeekLogId=0)
Begin 


if(@TypeOfPlanner=0)

Begin 


select JobId,CustomerId,FacilityId,Service,JobName,JobDescription,
       Gid,Status,CreatedBy,CreatedDate, IsDeleted,
       TypeOfPlanner,Year,WeekNo,WeekLogId,EngUserAreaId,
	   FileInfo
from EngScheduleGenerationFileJob where IsDeleted=0 and FacilityId=@FacilityIds and CustomerId=@CustomerIds  --and Service=@Service 
and [Year]=@Year   
and Status!='Failed' --and Status!='Completed'
order by CreatedDate desc
End


else
Begin 

--select @FacilityId
--select @CustomerId
--select @Service


select JobId,CustomerId,FacilityId,Service,JobName,JobDescription,
       Gid,Status,CreatedBy,CreatedDate, IsDeleted,
       TypeOfPlanner,Year,WeekNo,WeekLogId,EngUserAreaId,
	   FileInfo
from EngScheduleGenerationFileJob where IsDeleted=0 and FacilityId=@FacilityIds and CustomerId=@CustomerIds  --and Service=@Service 
and [Year]=@Year  and TypeOfPlanner=@TypeOfPlanner 
and Status!='Failed' 


order by CreatedDate desc
end







End



else 
Begin 

select JobId,CustomerId,FacilityId,Service,JobName,JobDescription,
       Gid,Status,CreatedBy,CreatedDate, IsDeleted,
       TypeOfPlanner,Year,WeekNo,WeekLogId,EngUserAreaId,
	   FileInfo
 from EngScheduleGenerationFileJob where IsDeleted=0 and FacilityId=@FacilityId and CustomerId=@CustomerId  --and Service=@Service 
 and TypeOfPlanner=@TypeOfPlanner and [Year]=@Year --and WeekNo=@WeekNo --and WorkGroupId=@WorkGroupId and EngUserAreaId=@EngUserAreaId
 and Status!='Failed' and Status!='Completed'
 order by CreatedDate desc

End




END TRY


BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END


GO
