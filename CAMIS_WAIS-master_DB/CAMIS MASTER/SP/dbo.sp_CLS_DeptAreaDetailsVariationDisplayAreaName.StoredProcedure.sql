USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_DeptAreaDetailsVariationDisplayAreaName]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_DeptAreaDetailsVariationDisplayAreaName](@pAreaCode varchar(max))
   as
   begin
   select Userareaname from CLS_DeptAreaDetails where Userareacode=@pAreaCode
   end
GO
