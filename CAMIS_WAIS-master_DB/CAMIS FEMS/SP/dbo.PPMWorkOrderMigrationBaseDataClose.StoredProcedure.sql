USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PPMWorkOrderMigrationBaseDataClose]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      





--EXEC PPMWorkOrderMigrationBaseDataClose      
      
CREATE PROCEDURE [dbo].[PPMWorkOrderMigrationBaseDataClose]      
AS      
      
BEGIN      
      
DECLARE @STARTDATE DATETIME      
DECLARE @ENDDATE DATETIME      
      
SET @STARTDATE='2020-07-18 00:00:00.000'      
SET @ENDDATE='2020-12-11 00:00:00.000'--CONVERT(DATETIME,CAST(GETDATE() AS DATE))      
      
DELETE FROM PPMWorkOrderMigrationBaseData WHERE FLAG='Close'      
      
      
;WITH CTE AS      
(      
SELECT       
A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.target_date AS CurrentTargetDate      
,B.target_date AS PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.timestamp      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att      
,ROW_NUMBER() OVER(PARTITION BY A.WR_NO ORDER BY A.WR_NO) AS RN      
FROM [10.249.116.8].[eng_ipoh].[DBO].ENG_WORK_REQUEST_HDR A WITH(NOLOCK)      
LEFT OUTER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_rescheduling_det B WITH(NOLOCK)      
ON A.WR_NO COLLATE SQL_Latin1_General_CP1_CI_AS =B.WR_NO  COLLATE SQL_Latin1_General_CP1_CI_AS    
WHERE WG_CODE IN ('CIVL'      
,'MECH'      
,'ELEC'      
,'eFEMS'      
,'INVT')      
--WHERE WG_CODE IN ('BMED','INVB')      
AND STATUS IN ('C','P')      
--AND STATUS IN ('O')      
AND TYPE='PM'      
AND A.target_date>=@STARTDATE AND A.target_date<=@ENDDATE       
--AND A.wr_no='PMWWAC/20/011169'--'MWRWAC/20/002534'--'PMWWAC/20/013856'      
--AND A.wr_no IN (      
-- 'PMWWAC/20/011164' --,'PMWWAC/20/011165' --,'PMWWAC/20/011166' --,'PMWWAC/20/011167'      
--)      
      
--SELECT * FROM [10.249.116.8].[eng_ipoh].[DBO].eng_wr_rescheduling_det      
)      
,CTE_MAX AS      
(      
SELECT WR_NO,MAX(RN) AS RN FROM CTE WHERE RN>=2 GROUP BY WR_NO      
)      
      
--SELECT * FROM CTE_MAX      
      
-----RESCHDEULE MORE THAN 2      
      
,CTE_RESC AS       
(      
SELECT A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.CurrentTargetDate      
,A.PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.timestamp      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att      
FROM CTE A      
INNER JOIN CTE_MAX  B      
ON A.WR_NO=B.WR_NO      
AND A.RN=B.RN      
)      
      
-----RESCHDEULE ONLY ONCE            
,CTE_RESC_ONCE AS      
(      
      
SELECT A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.CurrentTargetDate      
,A.PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.timestamp      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att       
FROM CTE A      
WHERE RN=1      
AND ISNULL(PreviousTargetDate,'') <>''      
AND WR_NO NOT IN (SELECT WR_NO FROM CTE_MAX)      
)      
,CTE_UNIONALL AS      
(      
SELECT A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.CurrentTargetDate      
,A.PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.timestamp      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att        
FROM CTE_RESC A      
UNION ALL      
SELECT A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.CurrentTargetDate      
,A.PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.timestamp      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att        
FROM CTE_RESC_ONCE A      
)      
      
      
--DROP TABLE PPMWorkOrderMigrationBaseData      
-----NO RESCHEDULE      
      
INSERT INTO PPMWorkOrderMigrationBaseData      
(      
company_code      
,location_code      
,wr_no      
,wr_date      
,requestor      
,CurrentTargetDate      
,PreviousTargetDate      
,contact_no      
,designation      
,asset_no      
,priority_flag      
,type      
,category      
,temp_asset_flag      
,reference      
,details      
,wg_code      
,parts_req_flag      
,ppm_shortclosed_flag      
,reason      
,status      
,ppm_flag      
,created_by      
,created_date      
,modified_by      
,modified_date      
,start_date      
,handover_date      
,end_date      
,accepted_by      
,acc_designation      
,asset_required      
,qc_outstanding      
,downtime_hours      
,qc_ppm_rt      
,qc_uptime      
,resource_type      
,contractor_code      
,contractor_cost      
,contractor_hours      
,pc_purchase_cost      
,pc_purchase_parts      
,action_taken      
,pr_po_no      
,pr_po_value      
,sr_no      
,parts_cost      
,labour_cost      
,mri_flag      
,ppm_agreed_date      
,asset_status_flag      
,justification      
,safety_flag      
,performance_flag      
,rate_service      
,rate_comm      
,rate_att      
,FLAG      
)      
      
      
      
SELECT A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.CurrentTargetDate      
,A.PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att        
,'Close' AS FLAG      
FROM CTE A      
WHERE WR_NO NOT IN (SELECT WR_NO FROM CTE_UNIONALL)      
--AND WR_NO='PMWWAC/20/011167'      
UNION ALL      
      
---RESCHEDULE      
      
SELECT A.company_code      
,A.location_code      
,A.wr_no      
,A.wr_date      
,A.requestor      
,A.CurrentTargetDate      
,A.PreviousTargetDate      
,A.contact_no      
,A.designation      
,A.asset_no      
,A.priority_flag      
,A.type      
,A.category      
,A.temp_asset_flag      
,A.reference      
,A.details      
,A.wg_code      
,A.parts_req_flag      
,A.ppm_shortclosed_flag      
,A.reason      
,A.status      
,A.ppm_flag      
,A.created_by      
,A.created_date      
,A.modified_by      
,A.modified_date      
,A.start_date      
,A.handover_date      
,A.end_date      
,A.accepted_by      
,A.acc_designation      
,A.asset_required      
,A.qc_outstanding      
,A.downtime_hours      
,A.qc_ppm_rt      
,A.qc_uptime      
,A.resource_type      
,A.contractor_code      
,A.contractor_cost      
,A.contractor_hours      
,A.pc_purchase_cost      
,A.pc_purchase_parts      
,A.action_taken      
,A.pr_po_no      
,A.pr_po_value      
,A.sr_no      
,A.parts_cost      
,A.labour_cost      
,A.mri_flag      
,A.ppm_agreed_date      
,A.asset_status_flag      
,A.justification      
,A.safety_flag      
,A.performance_flag      
,A.rate_service      
,A.rate_comm      
,A.rate_att        
,'Close' AS FLAG      
FROM CTE_UNIONALL A      
      
    
UPDATE A    
SET A.EmployeeID=B.EMPLOYEE_ID    
FROM PPMWorkOrderMigrationBaseData A    
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_completion_det B    
ON A.wr_no COLLATE SQL_Latin1_General_CP1_CI_AS=B.WR_NO  COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE A.FLAG='CLOSE'    
      
  
    
    
    
END 
GO
