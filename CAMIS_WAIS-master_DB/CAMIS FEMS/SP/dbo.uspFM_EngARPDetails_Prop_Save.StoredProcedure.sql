USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngARPDetails_Prop_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /****** Object:  StoredProcedure [dbo].[TEST_BlockMst_Save]    Script Date: 19/11/2019 5:45:06 PM ******/            
            
            
            
  -- Exec [SaveUserRole]             
       
  CREATE PROCEDURE  [dbo].[uspFM_EngARPDetails_Prop_Save]                                       
  (          
            
  --@ARPProposalID int,       
  @ARPID int,       
  @CustomerID  int,       
  @FacilityID int,       
  @PROP_ID1 int,          
  @Model1 nvarchar(50),               
  @Brand1 nvarchar(50),            
  @Manufacturer1 nvarchar(50) ,            
  @EstimationPrice1 nvarchar(100) ,         
  @SupplierName1 nvarchar(50) ,           
  @ContactNo1  nvarchar(500),         
        
  @PROP_ID2 int,          
  @Model2 nvarchar(50),               
  @Brand2 nvarchar(50),            
  @Manufacturer2 nvarchar(50) ,            
  @EstimationPrice2 nvarchar(200) ,         
  @SupplierName2 nvarchar(50) ,           
  @ContactNo2  nvarchar(500),       
        
  @PROP_ID3 int,          
  @Model3 nvarchar(50),               
  @Brand3 nvarchar(50),            
  @Manufacturer3 nvarchar(50) ,            
  @EstimationPrice3 nvarchar(100) ,         
  @SupplierName3 nvarchar(50) ,           
  @ContactNo3  nvarchar(500)         
        
               
  )            
  AS  
  begin    
  if (@ARPID > 0)  
  BEGIN  
  UPDATE  EngARP_Propsal SET          
  Model=@Model1,          
  Brand=@Brand1 ,       
  Manufacturer=@Manufacturer1 ,       
  EstimationPrice = @EstimationPrice1,    
  SupplierName =  @SupplierName1,  
  ContactNo  =@ContactNo1  
  where ARPID =@ARPID   and PROP_ID=@PROP_ID1  
  
  UPDATE EngARP_Propsal SET          
  Model=@Model2,          
  Brand=@Brand2,       
  Manufacturer=@Manufacturer2,       
  EstimationPrice = @EstimationPrice2,    
  SupplierName =  @SupplierName2,  
  ContactNo  =@ContactNo2  
  where ARPID = @ARPID   and PROP_ID=@PROP_ID1  
  UPDATE EngARP_Propsal SET          
  Model=@Model3,    
  Brand=@Brand3,       
  Manufacturer=@Manufacturer3,       
  EstimationPrice = @EstimationPrice3,    
  SupplierName =  @SupplierName3,  
  ContactNo  =@ContactNo3  
  where ARPID =@ARPID and PROP_ID=@PROP_ID1  
  
  END    
  Else   
  
  BEGIN  
  
  INSERT INTO EngARP_Propsal (       
  CustomerID ,       
  FacilityID,      
  ARPID   ,             
  PROP_ID ,        
  Model,              
  Brand,            
  Manufacturer,            
  EstimationPrice ,         
  SupplierName ,           
  ContactNo       
    
  )             
  values            
  (        
  @ARPID,      
  @CustomerID ,       
  @FacilityID,           
  @PROP_ID1 ,        
  @Model1,              
  @Brand1,            
  @Manufacturer1,            
  @EstimationPrice1 ,         
  @SupplierName1 ,           
  @ContactNo1          
     
  )            
            
  INSERT INTO EngARP_Propsal (                   
  ARPID,      
  PROP_ID,      
  Model,              
  Brand,            
  Manufacturer,            
  EstimationPrice,         
  SupplierName ,           
  ContactNo       
   
  )             
  values            
  (            
  @ARPID,      
  @PROP_ID2 ,        
  @Model2,              
  @Brand2,            
  @Manufacturer2,            
  @EstimationPrice2 ,         
  @SupplierName2 ,           
  @ContactNo2          
       
  )            
            
               
  INSERT INTO EngARP_Propsal (        
  ARPID,                 
  PROP_ID ,        
  Model,              
  Brand,            
  Manufacturer,            
  EstimationPrice,         
  SupplierName ,           
  ContactNo       
   
  )             
  values            
  (            
  @ARPID,      
  @PROP_ID3 ,        
  @Model3,              
  @Brand3,            
  @Manufacturer3,            
  @EstimationPrice3 ,         
  @SupplierName3 ,           
  @ContactNo3          
          
  )            
   
  END  
  
  BEGIN             
  INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
  VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
  SET NOCOUNT OFF            
  END            
  END
GO
