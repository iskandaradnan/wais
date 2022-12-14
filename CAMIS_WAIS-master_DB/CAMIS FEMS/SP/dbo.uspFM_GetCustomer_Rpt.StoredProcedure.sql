USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetCustomer_Rpt]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspFM_GetCustomer_Rpt](@Facility_Id VARCHAR (20))
AS
BEGIN
Set NOCOUNT on

declare @MohLogo_Heart varbinary(max), @MohLogo_Lion varbinary(max)

--SELECT @MohLogo_Heart = Logo FROM MstCustomer --WHERE LogoId = 1
--SELECT @MohLogo_Lion = Logo FROM MstCustomer --WHERE LogoId = 2

	select 	b.CustomerName as Compy_Name,
			--st.StateName as Stat_Name, 
			a.FacilityName as Hosp_Name,
			b.Logo AS MohHeart, 
			@MohLogo_Lion AS MohLion,
			a.Logo AS CompanyLogo 
			from MstLocationFacility a inner join MstCustomer b on a.CustomerId = b.CustomerId --inner join AsisLogoMst logo on a.companyid = logo.CompanyId
			-- inner join AsisStateMst st on a.StateId = st.StateId
			where a.FacilityId = @Facility_Id --and st.IsDeleted = 0 and a.IsDeleted = 0



end
GO
