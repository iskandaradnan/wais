using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CP.Framework.Common.Common
{
    public class DBAccess 
    {
        public string ConnectionString { get; private set; }
        public DBAccess()
        {
            ConnectionString = ConfigurationManager.ConnectionStrings["EmailEntities"].ConnectionString;
        }

        public  DataTable GetDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                        foreach (var item in parameters)
                        {

                            if (item.Key == "@pTimestamp")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : Convert.FromBase64String(item.Value)));
                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                            }

                           
                        }
                        foreach (var item in DataSetparameters)
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                        }
                        cmd.CommandType = CommandType.StoredProcedure;
                        da.SelectCommand = cmd;
                        da.Fill(objDataTable);
                    }
                }
            }
            return objDataTable;
        }
        public DataSet GetDataSet(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataSet ds = new DataSet();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                        foreach (var item in parameters)
                        {
                            if (item.Key == "@pTimestamp")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : Convert.FromBase64String(item.Value)));
                            }
                            else {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                            }
                        }
                        foreach (var item in DataSetparameters)
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                        }
                        cmd.CommandType = CommandType.StoredProcedure;
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        
    }
}
