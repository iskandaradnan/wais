using System;
using System.Configuration;
using System.Data.SqlClient;

namespace CP.ASIS.DAL.Helper
{
    public class DbHelper
    {
        public static Tuple<string, string> GetDbInfo()
        {            
            var dbServer = string.Empty;
            var dbName = string.Empty;

            //using (var x = new ASISWebDatabaseEntities())
            //{                
            //    dbServer = x.Database.Connection.DataSource;
            //    dbName = x.Database.Connection.Database;
            //}
            string connectString = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString();
            var builder = new SqlConnectionStringBuilder(connectString);
            dbServer = builder.DataSource;
            dbName = builder.InitialCatalog;

            return new Tuple<string, string>(dbServer, dbName);
        }
      
    }

}
