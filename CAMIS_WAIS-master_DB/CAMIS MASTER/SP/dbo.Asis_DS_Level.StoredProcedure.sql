USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_DS_Level]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [Asis_DS_Level] 'State',6
CREATE PROCEDURE [dbo].[Asis_DS_Level](@Level            VARCHAR (20),@Option        VARCHAR(20))
AS
BEGIN
Set NOCOUNT on

declare @Logo_UEM varbinary(max)

--SELECT @MohLogo_Heart = Logo FROM AsisLogoMst WHERE LogoId = 1
--SELECT @MohLogo_Lion = Logo FROM AsisLogoMst WHERE LogoId = 2

if(@Level='National')
begin
Select 
		'National' as Level,
		'All' as "Option",
		@Logo_UEM AS UEMEdgenta, 
		Logo as CompanyLogo 
		from MstCustomer 
end
if(@Level='Customer')
BEGIN
select 
		'Customer' as Level,
		 CustomerName as "Option",
		 @Logo_UEM AS EdgentaUEM, 
		 Logo AS CustomerLogo
		 from MstCustomer a  
		 where a.CustomerId=@Option 
END
if(@Level='Hospital')
BEGIN
select 
		'Facility' as Level,
		FacilityName as "Option", 
		 @Logo_UEM AS EdgentaUEM, 
		logo.Logo AS CompanyLogo 
		from V_MstLocationFacility a inner join MstCustomer logo on a.CustomerName = logo.CustomerName 
		where FacilityId = @Option  
END
--if(@Level ='State')
--BEGIN
--select distinct 
--		'State' as Level,
--		st.StateName as "Option", 
--		@MohLogo_Heart AS MohHeart, 
--		@MohLogo_Lion AS MohLion,
--		logo.Logo AS CompanyLogo 
--		from GMHospitalMst a inner join AsisLogoMst logo on a.companyid = logo.CompanyId inner join AsisStateMst st on a.StateId = st.StateId
--		where a.StateId = @Option 

	--select top 1 'State' as Level,StateName as "Option",
	--MohLogo,CompanyLogo 
	--from FmsHospitalProfileMst hp
	--inner join AsisStateMst s on s.StateId =hp.State 
	--inner join GmCompanyMst  c on c.CompanyId =hp.ConsortiaId
	--where state=@Option and hp.IsDeleted=0 and s.IsDeleted =0
END
GO
