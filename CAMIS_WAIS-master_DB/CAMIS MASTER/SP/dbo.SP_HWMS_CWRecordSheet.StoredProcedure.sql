USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_CWRecordSheet]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMS_CWRecordSheet]
as
begin
select UserAreaCode,CollectionFequency,CollectionTime,CollectionStatus,QC,NoofBags,NoofReceptaclesOnsite,NoofReceptacleSanitize,Sanitize
from HWMS_CWRecordSheet where Id=1
end
GO
