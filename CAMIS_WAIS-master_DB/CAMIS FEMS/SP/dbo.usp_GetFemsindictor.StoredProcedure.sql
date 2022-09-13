USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetFemsindictor]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:      <Author, , Srinivas Gangula>  
-- Create Date: <19/9/2019, , >  
-- Description: <select IndicatorDetId,IndicatorNo,IndicatorDesc from  MstDedIndicatorDet>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_GetFemsindictor]  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
    SET NOCOUNT ON  
  
    -- Insert statements for procedure here  
    select IndicatorDetId as LovId,IndicatorNo as FieldValue ,'FEMS' as LovKey,0 as IsDefault,IndicatorDesc as Description from  MstDedIndicatorDet  
END
GO
