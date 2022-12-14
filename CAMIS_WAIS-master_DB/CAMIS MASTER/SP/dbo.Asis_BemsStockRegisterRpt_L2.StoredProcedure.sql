USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_BemsStockRegisterRpt_L2]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version			    : 1.0           
File Name		    : Asis_BemsStockRegisterRpt_L2       
Procedure Name		: Asis_BemsStockRegisterRpt_L2
Author(s) Name(s)	: Balaji M S
Date			    : 30/06/2016
Purpose			    : SP to generate report Stock Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC Asis_BemsStockRegisterRpt_L2 @FacilityId,@ItemId,@Year,,@Month,@MenuName


EXEC Asis_BemsStockRegisterRpt_L2 '1','1','2018-05-01 20:02:31.860','2018-05-31 20:02:31.860','ALL'
  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   
CREATE PROCEDURE [dbo].[Asis_BemsStockRegisterRpt_L2]
	-- Add the parameters for the stored procedure here
( @FacilityId int
 ,@ItemId int
 --,@Year int
 --,@Month varchar(100)
 ,@From_Date  VARCHAR(200),
  @To_Date    VARCHAR(200)
 ,@MenuName  varchar(100)
 )
AS
BEGIN
	
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

CREATE TABLE #RESULT
(  
 Row_Id				INT IDENTITY(1,1)  ,
 FacilityId			VARCHAR(50),
 FacilityName		VARCHAR(100),
 CustomerName		VARCHAR(100),
 Name_of_Hospital	VARCHAR(100), 
 Item_No			VARCHAR(50), 
 Part_No			VARCHAR(50), 
 Part_Description	VARCHAR(2000), 
 Item_Description	VARCHAR(2000), 
 UOM                VARCHAR(200),
 Stock_Type			VARCHAR(200), 
 Minimum_Stock		VARCHAR(50),
 Maximum_Stock		VARCHAR(50),
 Stock_Balance		INT,
 Cost				NUMERIC(24,2),
 InvoiceNo			VARCHAR(500),
 Item_Id			VARCHAR(50),
 AdjustedQuantity   INT,
 ReplaceQuantity    INT,
 SparePartStockRegisterId   VARCHAR(50)
 )

 INSERT INTO  #RESULT(FacilityId,FacilityName,CustomerName,Item_No,Part_No,Part_Description,Item_Description,UOM,Stock_Type,Minimum_Stock,Maximum_Stock,Stock_Balance,Cost,InvoiceNo,Item_Id,SparePartStockRegisterId)
 SELECT 
	STOCK_UPDATE.FacilityId,
	E.FacilityName,
	F.CustomerName,
	D.ItemNo,
	A.PartNo,
	A.PartDescription, 
	D.ItemDescription, 
	A.UnitOfMeasurement,
	A.SparePartType,
	A.MinLevel,
	A.MaxLevel,
	SUM(STOCK_UPDATE.quantity),
	STOCK_UPDATE.Cost,
	STOCK_UPDATE.InvoiceNo,
	D.ItemId,
    A.SparePartsId
FROM	dbo.EngSpareParts		AS A	with (nolock)
INNER JOIN EngStockUpdateRegisterTxnDet	AS STOCK_UPDATE		with (nolock)	ON	STOCK_UPDATE.SparePartsId=A.SparePartsId
INNER JOIN dbo.FMItemMaster			AS D  with (nolock)					ON A.ItemId=D.ItemId
INNER JOIN MstLocationFacility  AS E with (nolock)  ON E.FacilityId = STOCK_UPDATE.FacilityId
INNER JOIN MstCustomer  AS F with (nolock)  ON F.CustomerId= STOCK_UPDATE.CustomerId

WHERE 	STOCK_UPDATE.FacilityId = @FacilityId
AND		A.ServiceId = 2
--AND		a.StockType!=2278
AND		cast(STOCK_UPDATE.ModifiedDate as date) Between @From_Date AND  @To_Date
AND		a.SparePartsId  IN (SELECT SparePartsId FROM EngSpareParts WHERE ItemId = @ItemId )
AND		A.Active=1  
AND		D.Active=1 
--AND STOCK_UPDATE.IsDeleted=0
GROUP BY D.ItemNo,STOCK_UPDATE.FacilityId,E.FacilityName,F.CustomerName,D.ItemDescription,A.PartNo,A.PartDescription,A.UnitOfMeasurement, 
A.SparePartType,A.MinLevel,A.MaxLevel,D.ItemId, A.SparePartsId,STOCK_UPDATE.Cost,STOCK_UPDATE.InvoiceNo		
		


UPDATE TEMP
 SET AdjustedQuantity =  X.ADJQUA
 FROM 
	#RESULT AS TEMP 
	INNER JOIN ( SELECT SUM(Stadjdet.AdjustedQuantity) AS ADJQUA,Stadjdet.SparePartsId,Stadj.FacilityId
				FROM
				   EngStockAdjustmentTxnDet Stadjdet WITH(NOLOCK) 
				INNER JOIN 
					EngStockAdjustmentTxn Stadj WITH(NOLOCK) ON Stadj.StockAdjustmentId = Stadjdet.StockAdjustmentId 
				WHERE Stadj.ServiceId = 2
				AND Stadj.ApprovalStatus = 5443
				AND Stadj.ApprovedDate Between @From_Date AND  @To_Date
				--AND Stadj.IsDeleted = 0 
				--AND Stadjdet.IsDeleted = 0 
				GROUP BY Stadjdet.SparePartsId,Stadj.FacilityId	) X  
		ON	TEMP.SparePartStockRegisterId = X.SparePartsId
	    AND TEMP.FacilityId = X.FacilityId

	
	

UPDATE TEMP  SET ReplaceQuantity =  X.ADJQUA
FROM 	#RESULT AS TEMP 
INNER JOIN ( SELECT Parrep.SparePartStockRegisterId,sum(Parrep.Quantity) ADJQUA,Parrep.FacilityId
			from 	EngMwoPartReplacementTxn Parrep WITH(NOLOCK)
			INNER JOIN 	EngMaintenanceWorkOrderTxn WO WITH(NOLOCK) ON Parrep.WorkOrderId = Wo.WorkOrderId 
			WHERE  WO.ServiceId  = 2 
			AND Wo.WorkOrderStatus = 2314
			AND Parrep.ModifiedDate Between @From_Date AND  @To_Date
			--AND	Parrep.IsDeleted = 0 
			--AND WO.IsDeleted = 0 
			GROUP BY Parrep.SparePartStockRegisterId,Parrep.FacilityId) 	X
ON TEMP.SparePartStockRegisterId = X.SparePartStockRegisterId
AND TEMP.FacilityId = X.FacilityId
		

	SELECT 
			FacilityId,
			FacilityName,
			CustomerName,              
			Item_No,Part_No,
			Part_Description,
			Item_Description,
			(select fieldvalue from FMLovMst with(nolock) where lovid = UOM ) As 'UnitofMeasurement',
			(select fieldvalue from FMLovMst with(nolock)  where lovid = Stock_Type)as 'Stock_Type',
			Minimum_Stock,
			Maximum_Stock,
			Stock_Balance,
			Cost,
			InvoiceNo,
			Item_Id,
			((ISNULL(Stock_Balance,0) + ISNULL(AdjustedQuantity,0)) - ISNULL(ReplaceQuantity,0)) AS Calculations 
	FROM #RESULT

		

END TRY
BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
SET NOCOUNT OFF	
		
		
END
GO
