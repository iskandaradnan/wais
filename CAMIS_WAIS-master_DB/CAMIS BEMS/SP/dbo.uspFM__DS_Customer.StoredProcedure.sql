USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM__DS_Customer]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author		:Aravinda Raja 
-- Create date	:04-06-2015
-- =============================================
--[uspFM__DS_Customer] 2
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[uspFM__DS_Customer]
(
@FacilityId VARCHAR (20)	-- like @pFacilityId
)
AS
BEGIN

Set NOCOUNT on

declare @MohLogo_Heart varbinary(max), @MohLogo_Lion varbinary(max)

SELECT @MohLogo_Heart = Logo FROM MstCustomer WHERE CustomerId = (select CustomerId from MstLocationFacility where FacilityId=@FacilityId)
SELECT @MohLogo_Lion = Logo FROM MstCustomer WHERE CustomerId = (select CustomerId from MstLocationFacility where FacilityId=@FacilityId)

	select 	b.CustomerName as Compy_Name,
			a.FacilityName as Hosp_Name,
			@MohLogo_Heart AS MohHeart, 
			@MohLogo_Lion AS MohLion,
			b.Logo AS CompanyLogo 
			from MstLocationFacility a 
			inner join MstCustomer b on a.CustomerId = b.CustomerId 
			where a.FacilityId = @FacilityId 
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
