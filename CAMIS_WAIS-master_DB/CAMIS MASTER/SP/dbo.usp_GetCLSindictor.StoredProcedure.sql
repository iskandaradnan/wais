USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCLSindictor]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetCLSindictor]       
AS       
BEGIN       
    -- SET NOCOUNT ON added to prevent extra result sets from       
    -- interfering with SELECT statements.       
    SET NOCOUNT ON       
       
    -- Insert statements for procedure here       
    select IndicatorDetId as LovId,IndicatorNo as FieldValue ,'CLS' as LovKey,0 as IsDefault,IndicatorDesc as Description
 from  MstDedIndicatorDet       
END

GO
