USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BemsStockRegisterRpt_L2]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                
Application Name : ASIS                
Version       : 1.0             
File Name      : Asis_BemsStockRegisterRpt_L2         
Procedure Name  : Asis_BemsStockRegisterRpt_L2  
Author(s) Name(s) : Balaji M S  
Date       : 30/06/2016  
Purpose       : SP to generate report Stock Register  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
EXEC uspFM_BemsStockRegisterRpt_L2 @FacilityId,@ItemId,@Year,,@Month,@MenuName  

EXEC uspFM_BemsStockRegisterRpt_L2 '1','1','2017-01-01 20:02:31.860','2018-05-31 20:02:31.860','ALL'  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
Modification History      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/     
CREATE PROCEDURE [dbo].[uspFM_BemsStockRegisterRpt_L2]  -- Add the parameters for the stored procedure here  
	( @FacilityId	int =null  
	,@ItemId		int  = null 
	--,@Year int  
	--,@Month varchar(100)  
	,@From_Date		VARCHAR(200),  
	@To_Date		VARCHAR(200),
	@SparePartType	INT = NULL,
	@Location		INT	= NULL,
	@PartNo			NVARCHAR(60) = NULL
	)  
AS  
BEGIN  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
BEGIN TRY  

	declare @@RESULT TABLE(
		Row_Id				INT IDENTITY(1,1), 
		FacilityId			VARCHAR(50), 
		FacilityName		VARCHAR(100), 
		CustomerName		VARCHAR(100), 
		Name_of_Hospital	VARCHAR(100), 
		Item_No				VARCHAR(50), 
		Part_No				VARCHAR(50), 
		Part_Description	VARCHAR(2000), 
		Item_Description	VARCHAR(2000), 
		UOM					VARCHAR(200), 
		Stock_Type			VARCHAR(200), 
		Minimum_Stock		VARCHAR(50),  
		Maximum_Stock		VARCHAR(50),  
		Stock_Balance		INT,  
		Cost				NUMERIC(24,2),  
		InvoiceNo			VARCHAR(500),  
		Item_Id				VARCHAR(50),  
		AdjustedQuantity	INT,  
		ReplaceQuantity		INT,  
		SparePartStockRegisterId	VARCHAR(50),
		SparePartTypeName		VARCHAR(100),
		LocationName			VARCHAR(100),
		LifespanOptions			VARCHAR(100),
		ERPPurchaseCost			VARCHAR(100)
	)  
  
	INSERT INTO  @@RESULT(FacilityId, FacilityName, CustomerName, Item_No, Part_No, Part_Description, Item_Description, 
	UOM, Stock_Type, Minimum_Stock, Maximum_Stock, Stock_Balance, Cost, InvoiceNo, Item_Id, SparePartStockRegisterId, 
	SparePartTypeName, LocationName, LifespanOptions, ERPPurchaseCost)  

	SELECT STOCK_UPDATE.FacilityId, E.FacilityName, F.CustomerName, D.ItemNo, A.PartNo, A.PartDescription, D.ItemDescription,
	A.UnitOfMeasurement, A.SparePartType, A.MinLevel, A.MaxLevel, SUM(STOCK_UPDATE.quantity), STOCK_UPDATE.Cost,
	STOCK_UPDATE.InvoiceNo, D.ItemId, A.SparePartsId, FML.FieldValue, FMLL.FieldValue, Lifespan.FieldValue,  STOCK_UPDATE.PurchaseCost
	FROM dbo.EngSpareParts  AS A with (nolock)  
	INNER JOIN EngStockUpdateRegisterTxnDet AS STOCK_UPDATE  with (nolock) ON STOCK_UPDATE.SparePartsId=A.SparePartsId  
	INNER JOIN dbo.FMItemMaster   AS D  with (nolock)     ON A.ItemId=D.ItemId  
	INNER JOIN MstLocationFacility  AS E with (nolock)  ON E.FacilityId = STOCK_UPDATE.FacilityId  
	INNER JOIN MstCustomer  AS F with (nolock)  ON F.CustomerId= STOCK_UPDATE.CustomerId  
	LEFT JOIN	FMLovMst AS FML WITH (NOLOCK) ON FML.lovid = STOCK_UPDATE.SparePartType
	LEFT JOIN	FMLovMst AS FMLL WITH (NOLOCK) ON FMLL.lovid = STOCK_UPDATE.LocationId
	LEFT JOIN	FMLovMst AS Lifespan WITH (NOLOCK) ON Lifespan.lovid = a.LifeSpanOptionId
	WHERE  STOCK_UPDATE.FacilityId = @FacilityId  
	AND  A.ServiceId = 2  
	--AND  a.StockType!=2278  
	AND  cast(STOCK_UPDATE.ModifiedDate as date) Between CONVERT(DATE,@From_Date, 111)  AND CONVERT(DATE,@To_Date, 111)   
	--AND  a.SparePartsId  IN (SELECT SparePartsId FROM EngSpareParts WHERE ItemId = @ItemId ) 
	AND  ((D.ItemId = @ItemId) OR (@ItemId IS NULL)  OR (@ItemId = ''))
	AND  ((A.PartNo = @PartNo) OR (@PartNo IS NULL) OR (@PartNo = ''))
	AND	 ((STOCK_UPDATE.Locationid = @Location) OR (@Location IS NULL) OR (@Location = ''))
	AND	 ((STOCK_UPDATE.SparePartType = @SparePartType) OR (@SparePartType IS NULL) OR (@SparePartType = ''))
	AND  A.Active=1    
	AND  D.Active=1   
	--AND STOCK_UPDATE.IsDeleted=0  
	GROUP BY D.ItemNo,STOCK_UPDATE.FacilityId,E.FacilityName,F.CustomerName,D.ItemDescription,A.PartNo,A.PartDescription,A.UnitOfMeasurement,   
	A.SparePartType,A.MinLevel,A.MaxLevel,D.ItemId, A.SparePartsId,STOCK_UPDATE.Cost,STOCK_UPDATE.InvoiceNo, FML.FieldValue, FMLL.FieldValue
	, Lifespan.FieldValue,  STOCK_UPDATE.PurchaseCost

	UPDATE	TEMP  
			SET AdjustedQuantity =  X.ADJQUA  
	FROM	@@RESULT AS TEMP   
	INNER JOIN ( SELECT SUM(Stadjdet.AdjustedQuantity) AS ADJQUA,Stadjdet.SparePartsId,Stadj.FacilityId  
				FROM EngStockAdjustmentTxnDet Stadjdet WITH(NOLOCK)   
				INNER JOIN EngStockAdjustmentTxn Stadj WITH(NOLOCK) ON Stadj.StockAdjustmentId = Stadjdet.StockAdjustmentId   
				WHERE Stadj.ServiceId = 2  
				AND Stadj.ApprovalStatus = 5443  
				AND Stadj.ApprovedDate Between CONVERT(DATE,@From_Date, 111)  AND CONVERT(DATE,@To_Date, 111)     
				GROUP BY Stadjdet.SparePartsId,Stadj.FacilityId ) X    
	ON TEMP.SparePartStockRegisterId = X.SparePartsId  
	AND TEMP.FacilityId = X.FacilityId  

	UPDATE	TEMP	
			SET ReplaceQuantity =  X.ADJQUA  
	FROM	@@RESULT AS TEMP   
	INNER JOIN (	SELECT Parrep.SparePartStockRegisterId,sum(Parrep.Quantity) ADJQUA,Parrep.FacilityId  
					FROM  EngMwoPartReplacementTxn Parrep WITH(NOLOCK)  
					INNER JOIN  EngMaintenanceWorkOrderTxn WO WITH(NOLOCK) ON Parrep.WorkOrderId = Wo.WorkOrderId   
					WHERE  WO.ServiceId  = 2   
					AND Wo.WorkOrderStatus = 2314  
					AND Parrep.ModifiedDate Between CONVERT(DATE,@From_Date, 111) AND  CONVERT(DATE,@To_Date, 111)   
					GROUP BY Parrep.SparePartStockRegisterId,Parrep.FacilityId)  X  
	ON TEMP.SparePartStockRegisterId = X.SparePartStockRegisterId  
	AND TEMP.FacilityId = X.FacilityId  
	
	DECLARE @Item NVARCHAR(512)
	DECLARE @LocationnAME NVARCHAR(512)
	DECLARE @SparePartTypeName	NVARCHAR(512)
	SELECT @Item = ITEMNO FROM FMItemMaster  WITH (NOLOCK) WHERE ITEMID = @ItemId
	
	IF ISNULL(@SparePartType,'') <> ''
	SELECT @SparePartTypeName = FieldValue FROM FMLovMst WHERE lovid =  @SparePartType

	IF ISNULL(@Location,'') <>''
	SELECT @LocationnAME = FieldValue FROM FMLovMst WHERE lovid = @Location 	

--EXEC uspFM_BemsStockRegisterRpt_L2 '1','1','2017-01-01 20:02:31.860','2018-05-31 20:02:31.860'
	
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
   Item_Id, SparePartTypeName,LocationName, ERPPurchaseCost,LifespanOptions,
((ISNULL(Stock_Balance,0) + ISNULL(AdjustedQuantity,0)) - ISNULL(ReplaceQuantity,0)) AS Calculations
, ISNULL(@SparePartTypeName,'')	AS SparePartTypePARAM
, ISNULL(@LocationnAME,'')	AS LocationPARAM
, ISNULL(@PartNo,'')		AS PartNoPARAM
, ISNULL(@Item,'')			AS ItemIdPARAM
, FORMAT(convert(date,@From_Date),'dd-MMM-yyyy')		AS From_DatePARAM
, FORMAT(convert(date,@To_Date),'dd-MMM-yyyy')		AS To_DatePARAM
FROM @@RESULT  

--Select format(convert(date,@From_Date),'dd-MMM-yyyy')  Frm_Date,format(convert(date,@To_Date),'dd-MMM-yyyy') To_Date  
END TRY
BEGIN CATCH

	INSERT INTO ErrorLog( Spname, ErrorMessage, createddate)  
	VALUES(  OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(), getdate())
 
END CATCH  

SET NOCOUNT OFF


END
GO
