USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMSCARAttach1]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMSCARAttach1]  
(@FileType varchar(max),@FileName varchar(max),@Attachment varchar(max))  
as  
begin  
insert into HWMS_CARAttach1 values(@FileType,@FileName,@Attachment)  
end  
GO
