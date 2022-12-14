USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_Services_byFacilityAndCustomerId]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Exec [Get_Services_byFacilityAndCustomerId] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetServicesbyFacilityAndCustomerId
--AUTHORS			: Srinivas Gangula
--DATE				: 11-Sep-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--SRINIVAS GANGULA           : 11-SEP-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[Get_Services_byFacilityAndCustomerId](
    @Services int,
	@CustomerId int,
	@FacilityId int	
)
as
BEGIN
BEGIN TRAN
DECLARE @ID int;
DECLARE @RCustomerId int;
DECLARE @RFacilityId int;

DECLARE	 @CustomerId_Service int ;
DECLARE	 @FacilityId_Service int ;


CREATE TABLE #service_mapping (ID INT IDENTITY(1,1),[RCustomerId] [int],[RFacilityId] [int])


IF (@Services =1)
begin
 select @CustomerId_Service=  [BEMS_ID] FROM [MstCustomer_Mapping] WHERE [CustomerId] = @CustomerId;
 select @FacilityId_Service=  [BEMS_ID] FROM [MstLocationFacility_Mapping] WHERE [FacilityId] = @FacilityId;
 end

   IF (@Services = 2)
   begin
 select @CustomerId_Service=  [FEMS_ID] FROM [MstCustomer_Mapping] WHERE [CustomerId] = @CustomerId;
 select @FacilityId_Service=  [FEMS_ID] FROM [MstLocationFacility_Mapping] WHERE [FacilityId] = @FacilityId;
   end

 IF (@Services = 3)
 begin
 select @CustomerId_Service=  [CLS_ID] FROM [MstCustomer_Mapping] WHERE [CustomerId] = @CustomerId;
 select @FacilityId_Service=  [CLS_ID] FROM [MstLocationFacility_Mapping] WHERE [FacilityId] = @FacilityId;
 end

 IF (@Services = 4)
 begin
 select @CustomerId_Service=  [LLS_ID] FROM [MstCustomer_Mapping] WHERE [CustomerId] = @CustomerId;
 select @FacilityId_Service=  [LLS_ID] FROM [MstLocationFacility_Mapping] WHERE [FacilityId] = @FacilityId;
end

 IF (@Services = 5)
 begin
 select @CustomerId_Service=  [HWMS_ID] FROM [MstCustomer_Mapping] WHERE [CustomerId] = @CustomerId;
 select @FacilityId_Service=  [HWMS_ID] FROM [MstLocationFacility_Mapping] WHERE [FacilityId] = @FacilityId;
 end

 insert into #service_mapping([RCustomerId],[RFacilityId]) values(@CustomerId_Service,@FacilityId_Service)
 Select * from #service_mapping
 drop table #service_mapping
 COMMIT TRAN

END
GO
