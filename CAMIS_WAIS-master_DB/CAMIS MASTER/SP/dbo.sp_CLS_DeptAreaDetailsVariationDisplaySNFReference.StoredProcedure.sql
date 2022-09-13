USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_DeptAreaDetailsVariationDisplaySNFReference]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_DeptAreaDetailsVariationDisplaySNFReference](@pSNFReference varchar(max))
   as
   begin
   select StartServiceDate,WarrantyEndDate,VariationDate from VmVariationTxn where SNFDocumentNo=@pSNFReference
   end
GO
