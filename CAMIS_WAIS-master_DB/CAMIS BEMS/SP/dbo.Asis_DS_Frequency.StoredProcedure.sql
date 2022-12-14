USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_DS_Frequency]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Asis_DS_Frequency](  @Frequency varchar(20),        
 @Frequency_Key VARCHAR(15), -- month                
 @Year  varchar(10)=2016,    
 @From_Date  varchar(10),  
 @To_Date  varchar(10))
 as 
 begin
if(@Frequency='yearly')
begin
Select 'Yearly'+', '+@year Frequency
end
if(@Frequency='halfyear')
begin
if(@Frequency_key='h1')
select 'Half-Yearly'+', '+ upper(@Frequency_key)+' '+ '(Jan - Jun)'+', '+@year Frequency
if(@Frequency_key='h2')
select 'Half-Yearly'+', '+ upper(@Frequency_key)+' '+ '(Jul - Dec)'+', '+@year Frequency
end


if(@Frequency='monthly')

select 'Monthly'+', '+datename(month,convert(datetime2, cast(@Frequency_Key+'-01-'+@year as date), 113) )+', '+@year Frequency
--select 'Monthly'+','+@Frequency_Key+','+@year Frequency
if(@Frequency ='quarter')

select 'Quarterly'+', '+upper(@Frequency_key)+', '+@year Frequency
if(@Frequency ='range')
select 'Range'+' : '+format(convert(date,@From_Date),'dd-MMM-yyyy')+' To '+format(convert(date,@To_Date),'dd-MMM-yyyy') Frequency
end
GO
