USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[get_table]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[get_table]
@find_str varchar(50)
as 
begin
  declare @col_name varchar(500), @tab_name varchar(500);
  declare @find_tab TABLE(table_name varchar(100), column_name varchar(100));

  DECLARE tab_col cursor for 
  select C.name as 'col_name', T.name as tab_name
  from sys.tables as T
  left outer join sys.columns as C on  C.object_id=T.object_id
  left outer join sys.types as TP on  C.system_type_id=TP.system_type_id
  where type='U' 
  and TP.name in('text','ntext','varchar','char','nvarchar','nchar');

  open tab_col
  fetch next from tab_col into @col_name, @tab_name

  while @@FETCH_STATUS = 0
  begin        
    insert into @find_tab 
    exec('select ''' +  @tab_name + ''',''' + @col_name + ''' from ' + @tab_name + 
    ' where ' + @col_name + '=''' + @find_str + ''' group by ' + 
    @col_name + ' having count(*)>0');

    fetch next from tab_col into @col_name, @tab_name;
  end
  CLOSE tab_col;  
  DEALLOCATE tab_col; 
  select table_name, column_name from @find_tab;

end
GO
