USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt_From_TO]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author		: Aravinda Raja 
-- Create date	: 31-05-2018
-- Description	: EngAsset History
-- =============================================

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[uspFM_EngAsset_History_Rpt_From_TO](  @From_Date varchar(20),        
 @To_Date VARCHAR(20))
 as 
 begin
if len(@From_Date)>1 and len(@To_Date)>1

Select format(convert(date,@From_Date),'dd-MMM-yyyy')  Frm_Date,format(convert(date,@To_Date),'dd-MMM-yyyy') To_Date

else if len(@From_Date)>1 and len(@To_Date)=0
Select format(convert(date,@From_Date),'dd-MMM-yyyy')  Frm_Date,'' To_Date
else if len(@From_Date)=0 and len(@To_Date)>1
Select ''  Frm_Date,format(convert(date,@To_Date),'dd-MMM-yyyy') To_Date
else if len(@From_Date)=0 and len(@To_Date)=0
Select ''  Frm_Date,'' To_Date
end
GO
