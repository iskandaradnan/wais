using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CP.Framework.Common.Email
{
    public class DBAccess 
    {
        //private SqlConnection Connection = null;
        //private string ConnectionString = string.Empty;
        //public SqlCommand Command { get; private set; }
        public string ConnectionString { get; private set; }
        public DBAccess()
        {
            ConnectionString = ConfigurationManager.ConnectionStrings["EmailEntitiesB"].ConnectionString;
        }

        //public List<LovValue> GetLovRecords(DataTable table)
        //{
        //    var convertedList = (from n in table.AsEnumerable()
        //                         select new LovValue
        //                         {
        //                             LovId = Convert.ToInt32(n["LovId"]),
        //                             FieldValue = Convert.ToString(n["FieldValue"])
        //                         }).ToList();
        //    return convertedList;
        //}
        //public List<LovValue> GetLovRecords(DataTable table, string LovKey)
        //{
        //    var convertedList = (from n in table.AsEnumerable()
        //                         where Convert.ToString(n["LovKey"]) == LovKey
        //                         select new LovValue
        //                         {
        //                             LovId = Convert.ToInt32(n["LovId"]),
        //                             FieldValue = Convert.ToString(n["FieldValue"])
        //                         }).ToList();
        //    return convertedList;
        //}

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
        //public List<MultiSelectDD> GetMultiSelectDDRecords(DataTable table)
        //{
        //    var convertedList = (from n in table.AsEnumerable()
        //                         select new MultiSelectDD
        //                         {
        //                             LovId = Convert.ToInt32(n["LovId"]),
        //                             FieldValue = Convert.ToString(n["FieldValue"]),
        //                             Active = false                                 
        //                         }).ToList();
        //    return convertedList;
        //}
        //public int NonquerySP(string SPName)
        //{
        //    try
        //    {
        //        using (Connection = new SqlConnection(ConnectionString))
        //        {
        //            Command.CommandText = SPName;
        //            Command.CommandType = CommandType.StoredProcedure;
        //            Command.Connection = Connection;
        //            Connection.Open();
        //            int result = Command.ExecuteNonQuery();
        //            return result;
        //        }
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        if (Connection != null) Connection.Close();
        //        if (Command != null) Command.Dispose();
        //    }

        //}
        //public void InNVarchar(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.NVarChar;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void InVarchar(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.VarChar;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void InBool(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.Bit;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void InSmall_Int(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.SmallInt;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void InBigInt(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.BigInt;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void InInt(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.Int;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void InTinyInt(string id, object value)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.TinyInt;
        //    Parameter.Direction = ParameterDirection.Input;
        //    Parameter.Value = value;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void OutVarchar(string id, short size)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.VarChar;
        //    Parameter.Direction = ParameterDirection.Output;
        //    Parameter.Value = null;
        //    Parameter.Size = size;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void OutNVarchar(string id, short size)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.NVarChar;
        //    Parameter.Direction = ParameterDirection.Output;
        //    Parameter.Value = null;
        //    Parameter.Size = size;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void OutLong(string id)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.BigInt;
        //    Parameter.Direction = ParameterDirection.Output;
        //    Parameter.Value = 0;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void OutInt(string id)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.Int;
        //    Parameter.Direction = ParameterDirection.Output;
        //    Parameter.Value = 0;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void OutByte(string id)
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = id;
        //    Parameter.SqlDbType = SqlDbType.TinyInt;
        //    Parameter.Direction = ParameterDirection.Output;
        //    Parameter.Value = 0;
        //    Command.Parameters.Add(Parameter);
        //}
        //public void OutReturn()
        //{
        //    SqlParameter Parameter = new SqlParameter();
        //    Parameter.ParameterName = "@ReturnValue";
        //    Parameter.SqlDbType = SqlDbType.Int;
        //    Parameter.Direction = ParameterDirection.ReturnValue;
        //    Parameter.Value = 0;
        //    Command.Parameters.Add(Parameter);
        //}
    }
}
