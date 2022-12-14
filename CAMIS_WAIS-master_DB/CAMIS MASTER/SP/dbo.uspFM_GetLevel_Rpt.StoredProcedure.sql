USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetLevel_Rpt]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_GetLevel_Rpt
Description			: 
Authors				: Hari Haran N
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_GetLevel_Rpt] @Level=134,@Option=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--exec [Asis_DS_Level] 'State',6
 
CREATE PROCEDURE [dbo].[uspFM_GetLevel_Rpt](@Level            VARCHAR (20),@Option        VARCHAR(20))
AS
BEGIN
Set NOCOUNT on

declare @MohLogo_Heart varbinary(max), @MohLogo_Lion varbinary(max)

SELECT @MohLogo_Heart = Logo FROM MstCustomer --WHERE LogoId = 1
SELECT @MohLogo_Lion = Logo FROM MstCustomer --WHERE LogoId = 2


if(@Level='National')
begin
Select 
		'National' as Level,
		'All' as "Option",
		@MohLogo_Heart AS MohHeart, 
		@MohLogo_Lion AS MohLion,
		'' as CompanyLogo
end
if(@Level='Consortia')
BEGIN
select 
		'Company' as Level,
		 CustomerName as "Option",
		 @MohLogo_Heart AS MohHeart, 
		 @MohLogo_Lion AS MohLion
		 --logo.Logo AS CompanyLogo
		 from MstCustomer a --left join AsisLogoMst logo on a.companyid = logo.CompanyId 
		 where a.CustomerId=@Option 
END
if(@Level='Facility')
BEGIN
select 
		'Facility' as Level,
		FacilityName as "Option", 
		@MohLogo_Heart AS MohHeart, 
		@MohLogo_Lion AS MohLion
		--logo.Logo AS CompanyLogo 
		from MstLocationFacility a --inner join AsisLogoMst logo on a.companyid = logo.CompanyId 
		where FacilityId = @Option 
END
end
GO
