USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetBEMSindictor]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:      <Author, , Srinivas Gangula>  
-- Create Date: <19/9/2019, , >  
-- Description: <select IndicatorDetId,IndicatorNo,IndicatorDesc from  MstDedIndicatorDet>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_GetBEMSindictor]  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
    SET NOCOUNT ON  
  
    -- Insert statements for procedure here  
    select IndicatorDetId as LovId,IndicatorNo as FieldValue ,'BEMS' as LovKey,0 as IsDefault,IndicatorDesc as Description from  MstDedIndicatorDet  
END
GO
