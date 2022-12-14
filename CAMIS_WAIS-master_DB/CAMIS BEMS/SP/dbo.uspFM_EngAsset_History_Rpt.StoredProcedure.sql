USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_History_Rpt]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- =============================================

-- Author		: Aravinda Raja 

-- Create date	: 31-05-2018

-- Description	: EngAsset History

-- =============================================



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- EXEC uspFM_EngAsset_History_Rpt '','','2017-01-01','2019-04-12',''



CREATE  PROCEDURE [dbo].[uspFM_EngAsset_History_Rpt]                                  

( --@MenuName					varchar(200) null ,                                               

  @Option					VARCHAR (20) null ,

  @Group_By					VARCHAR (20) null ,

  @From_Date				VARCHAR(20) null ,

  @To_Date					VARCHAR(20) null ,

  @Asset_Status				varchar(20)  null 

 )           



AS                                              

BEGIN                                

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY                                  

DECLARE @Asset_status_tmp varchar(50) ,@Asset_status_name varchar(50)





CREATE  table #Hospital_Master (HospitalId int)    

 --IF (@Level='national')         

 --BEGIN        

     insert into  #Hospital_Master(HospitalId)         

     Select  FacilityId HospitalId FROM MstLocationFacility Where Active=1   group by FacilityId                         

 --END 

 --IF (@Level='consortia')         

 --BEGIN        

 --   insert into  #Hospital_Master(HospitalId)          

 --   Select  HospitalId FROM FmsHospitalProfileMst Where ConsortiaId=@Option and IsDeleted=0 group by HospitalId 

                    

 --END 

 --IF (@Level='State')         

 --BEGIN        

 --    insert into  #Hospital_Master(HospitalId)          

 --    Select  HospitalId FROM FmsHospitalProfileMst Where State=@Option and IsDeleted=0 group by HospitalId                    

 --END 

 --IF (@Level='hospital')         

 --BEGIN     

 --    insert into  #Hospital_Master(HospitalId)  values (@Option)

 --END    



CREATE  table #Tmp

	(

		 RowId               Int IDENTITY(1,1)

		,HospitalId			 Int

		,Asset_No	         Varchar(200)

		,Asset_Id            INT

		,AssetTypeCodeId	 INT

		,Classification      VARCHAR(200)

		,Description         VARCHAR(1000)

		,Asset_Status        VARCHAR(100)

		,Type_Code		     varchar(50)

		,assetage			 varchar(50)

		,Obselete_status     INT

		,RealTimeStatus      Varchar(50)

		,ProcessStatus		 Varchar(500)

	);





with CTE_AssetProcess as

(

--select 

--history.AdvisoryHistoryId as processid,

--SRMST.AssetRegisterId as AssetRegisterId,

--'Advisory Process' as ProcessName, 

--CONVERT(datetime,history.CreatedDate ) as DoneDate,

--CASE 

--	WHEN  history.StakeholderType=4012 and ADSDET.Objective=2999 THEN 'Applied for RW'

--	WHEN  history.StakeholderType=4012 and ADSDET.Objective=3000 THEN 'Applied for Exemption'

--	WHEN  history.StakeholderType=4012 and ADSDET.Objective not in (3000) THEN 'Applied for Advisory Services'

--	WHEN  history.StakeholderType=4014 and ADSDET.Objective=2999 THEN 'Verified  for RW'

--	WHEN  history.StakeholderType=4014 and ADSDET.Objective=3000 THEN 'Verified  for Exemption'

--	WHEN  history.StakeholderType=4014 and ADSDET.Objective not in (2999,3000) THEN 'Verified  for Advisory Services'

--	WHEN  history.StakeholderType=4016 and Conclusion.Conclusion=4009 THEN 'Approved  for Exemption'

--	WHEN  history.StakeholderType=4016 and Conclusion.Conclusion=4010 THEN 'Approved  for RW'

--	WHEN  history.StakeholderType=4016 and Conclusion.Conclusion not in (4009,4010) THEN 'Approved  for Advisory Services'

--END 'ProcessStatus'  

--from Dbo.EngAdvisoryTxn ADSMST

--inner Join Dbo.EngAdvisoryTxnDet ADSDET on ADSMST.AdvisoryId = ADSDET.AdvisoryId

--inner join Dbo.EngAdvisoryHistoryTxn history       on ADSMST.AdvisoryId = history.AdvisoryId

--inner join Dbo.SrServiceRequestMst SRMST           on ADSDET.ServiceRequestId = SRMST.ServiceRequestId

--left outer join Dbo.EngAdvisoryConclusionTxnDet  Conclusion on ADSDET.AdvisoryDetId = Conclusion.AdvisoryDetId

--where history.StakeholderType in (4012,4014,4016) 



--Union all



select 

history.VariationDetId as processid,

VMMST.AssetId as AssetRegisterId,

'Variation Process' as ProcessName, 

CONVERT(datetime,history.DoneDate ) as DoneDate ,

CASE 

	WHEN history.VariationWFStatus =  233 THEN 'Variation Verified'

	WHEN history.VariationWFStatus =  230 THEN 'Variation Approved'

END 'Process Status'

from DBO.VmVariationTxn VMMST

inner join DBO.VmVariationTxnDet history  on VMMST.VariationId = history.VariationId

where history.VariationWFStatus in (233,230)



union all



select 

max(history.VariationDetId) as processid, 

VMMST.AssetId as AssetRegisterId,

'Variation Process' as ProcessName,

max( CONVERT(datetime,history.DoneDate )) as DoneDate ,

CASE 

	WHEN history.VariationWFStatus =  232 THEN 'Variation Applied'

END 'Process Status'

from DBO.VmVariationTxn VMMST

inner join DBO.VmVariationTxnDet history on VMMST.VariationId = history.VariationId 

where history.VariationWFStatus in (232)

group by VMMST.AssetId,history.VariationWFStatus



union all



select 

his.ApplicationHistoryId as processid,

MST.AssetId,

'BER' as Process, 

convert(datetime,HIS.CreatedDate) [Date],

'BER '+LOV.FieldValue [Status]

from Dbo.BerApplicationTxn MST 

INNER JOIN Dbo.BerApplicationHistoryTxn HIS on HIS.ApplicationId=MST.ApplicationId

INNER JOIN Dbo.FmLovMst LOV on LOV.LovId=HIS.[Status] 

),



CTE_AssetProcess_final

as 

(

select 

AssetRegisterId,

ProcessName,

[Process Status],

Row_number() over (partition by AssetRegisterId,ProcessName order by processid desc) as sno  

from CTE_AssetProcess

where donedate <= @To_Date

)

INSERT INTO #Tmp (HospitalId,Asset_No,Asset_Id,AssetTypeCodeId,Classification,Description,Asset_Status,Type_Code,RealTimeStatus,ProcessStatus)	







select 

A.FacilityId HospitalId, 

a.AssetNo,

A.AssetId AssetRegisterId,

a.AssetTypeCodeId,

(select fieldvalue from FmLovMst where lovid = A.AssetClassification),

a.AssetDescription,

(select fieldvalue from FmLovMst where lovid = a.AssetStatusLovId),

D.AssetTypeCode,

(select fieldvalue from FmLovMst where lovid = a.RealTimeStatusLovId),

'Good' [ProcessStatus]

FROM EngAsset  A  

inner join  #Hospital_Master h  on a.FacilityId		=	h.HospitalId

left join	CTE_AssetProcess_final  B	   on a.AssetId =	b.AssetRegisterId and b.sno = 1

left JOIN	MstLocationUserArea AM ON a.UserAreaId =AM.UserAreaId

left join	EngAssetTypeCode D on D.AssetTypeCodeId=a.AssetTypeCodeId and D.Active=1

where A.Active=1 AND (A.ServiceStartDate IS NULL OR A.ServiceStartDate <= @To_Date )

--AND [ProcessStatus] = @typeid

--AND AM.UserDepartmentId = @DepartmentID

GROUP BY  A.FacilityId, a.AssetNo,A.AssetId,a.AssetTypeCodeId,A.AssetClassification,a.AssetDescription,a.AssetStatusLovId,D.AssetTypeCode,a.RealTimeStatusLovId





select 

Asset_Id , 

cast((DATEDIFF(m, a.PurchaseDate, GETDATE())/12) as varchar) + '.' + CASE WHEN DATEDIFF(m, a.PurchaseDate, GETDATE())%12 = 0 THEN '0' ELSE cast((DATEDIFF(m, a.PurchaseDate, GETDATE())%12) as varchar) END   as age 

into #age from DBO.EngAsset a join #Tmp b on  Asset_Id=Asset_Id   



;with CTE_model

as 

(

select  



AssetId AssetRegisterId, 

b.AssetTypeCodeId,  

isnull(C.MODEL,'No Values Defined'  ) as MODEL,

row_number() over (partition by b.AssetId,B.AssetTypeCodeId order by b.AssetId,a.AssetTypeCodeId desc)  'sno'

from DBO.EngAssetStandardization A 

JOIN DBO.EngAsset B ON A.AssetTypeCodeId=B.AssetTypeCodeId      

JOIN DBO.EngAssetStandardizationModel C ON C.ModelId=B.Model    

JOIN #Tmp d on b.AssetId = d.Asset_Id 

)

select AssetRegisterId as Asset_Id, AssetTypeCodeId,  MODEL into  #model from CTE_model where sno = 1









select 

cc.CustomerName as 'Company_Name',

h.FacilityName as 'Hospital_Name',

t.HospitalId,

Asset_No,Description,Type_Code as 'Type_Code',

t.Asset_Id,

m.Model As 'Model',

ISNULL(t.ProcessStatus,'Good') As 'Process_Status',

RealTimeStatus as 'RealTime_Status',

age as age,

@Asset_status_name as 'Asset_Status',

'' as 'Menu_Name',

Row_Number() Over ( Order By cc.CustomerName,h.FacilityName,Asset_No ) as 'Line_Item_No'

from #Tmp t 

join MstLocationFacility h on t.HospitalId = h.FacilityId  

join MstCustomer cc on h.CustomerId=cc.CustomerId

left join #age ag on t.Asset_Id = AG.Asset_Id

left join #model m on t.Asset_Id = m.Asset_Id and t.AssetTypeCodeId = m.AssetTypeCodeId

order by	Company_Name,Hospital_Name,Asset_No	





DROP TABLE #Tmp

END TRY

BEGIN CATCH



insert into ErrorLog(Spname,ErrorMessage,createddate)

values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())



END CATCH

SET NOCOUNT OFF                                         

END
GO
