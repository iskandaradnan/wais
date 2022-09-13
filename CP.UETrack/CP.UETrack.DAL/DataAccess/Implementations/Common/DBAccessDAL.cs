using CP.UETrack.DAL.DataAccess.Contracts.Common;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.IO;
using QRCoder;
using System.Drawing;
using System.Drawing.Imaging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.DAL.DataAccess;
using CP.Framework.Common.StateManagement;
using System.Web.SessionState;
using CP.UETrack.DAL.Helper;

namespace UETrack.DAL
{
    public class DBAccessDAL : IDBAccessDAL
    {
        //private SqlConnection Connection = null;
        //private string ConnectionString = string.Empty;
        //public SqlCommand Command { get; private set; }
        public virtual string ConnectionString { get; protected set; }
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public DBAccessDAL()
        {
            string conn = "UETrackConnectionString";
            try
            {
                ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
                // var Testsession = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
                var Testsession = _UserSession.UserDB;
                if (Testsession == 0)
                {
                    conn = "UETrackConnectionString";//Master
                }
                else
                {
                    if (Testsession == 2)
                    {
                        conn = "FEMSUETrackCommonConnectionString";//FEMS
                    }
                    else
                    {
                        conn = "UETrackCommonConnectionString";//BEMS
                    }

                    
                }
            }
            catch
            {
                conn = "UETrackConnectionString";
            }
            // UserDetailsModel _UserSession = new SessionHelper().UserSession();
            // Command = new SqlCommand();
            //BEMS
            //will make it as MASTER
            ConnectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;

            //ConnectionString = ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ConnectionString;
        }

        public string DBAccessDALByServiceId()
        {
            string conn = "UETrackConnectionString";
            try
            {
                ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
                // var Testsession = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
                var Testsession = _UserSession.UserDB;
                if (Testsession == 0)
                {
                    conn = "UETrackConnectionString";//Master
                }
                else
                {
                    if (Testsession == 2)
                    {
                        conn = "FEMSUETrackCommonConnectionString";//FEMS
                    }
                    else
                    {
                        conn = "UETrackCommonConnectionString";//BEMS
                    }


                }
            }
            catch
            {
                conn = "UETrackConnectionString";
            }
           return ConnectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;

           
        }

        public string DBAccessDALByServiceId_Param(int ServiceId)
        {
            string conn = "UETrackConnectionString";
            try
            {

                if (ServiceId == 1)
                {
                    conn = "FEMSUETrackCommonConnectionString";//FEMS
                }
                else if (ServiceId == 2)
                {
                    conn = "UETrackCommonConnectionString";//BEMS
                }
                else
                {

                    conn = "UETrackConnectionString";//Master
                }
            }
            catch
            {
                conn = "UETrackConnectionString";
            }
            return ConnectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;


        }

        //public DBAccessDAL(int i)
        //{
        //    // Command = new SqlCommand();
        //    ConnectionString = ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ConnectionString;
        //}


        //public DBAccessDAL(bool IsDb)
        //{
        //    ConnectionString = ConfigurationManager.ConnectionStrings["UETrackFemsConnectionString"].ConnectionString;
        //}

        public DataTable GetDataTable_ByServiceID(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters,int ServiceId)
        {
            string conn = "UETrackConnectionString";
            if (ServiceId == 1)
            {
                conn = "FEMSUETrackCommonConnectionString";//FEMS
            }
            else if (ServiceId == 2)
            {
                conn = "UETrackCommonConnectionString";//BEMS
            }
            else
            {

                conn = "UETrackConnectionString";//Master
            }
            ConnectionString = ConfigurationManager.ConnectionStrings[conn].ConnectionString;
            DataTable objDataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spName;

                    //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                    //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                    foreach (var item in parameters)
                    {

                        if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                        }
                        //else if (item.Key == "@pCustomerLogo")
                        //{
                        //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                        //}
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                        }


                    }
                    foreach (var item in DataSetparameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                    }
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                    da.Fill(objDataTable);

                }
            }
            return objDataTable;
        }
        public List<LovValue> GetLovRecords(DataTable table)

        {
            var convertedList = (from n in table.AsEnumerable()
                                 select new LovValue
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                     DefaultValue = Convert.ToBoolean(n["IsDefault"])
                                 }).ToList();
            return convertedList;
        }
        public List<LovValue> GetLovRecords(DataTable table, string LovKey)
        {
            var convertedList = (from n in table.AsEnumerable()
                                 where Convert.ToString(n["LovKey"]) == LovKey
                                 select new LovValue
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                     DefaultValue = Convert.ToBoolean(n["IsDefault"])
                                 }).ToList();
            return convertedList;
        }
        public List<LovValueDesc> GetLovDescRecords(DataTable table, string LovKey)
        {
            var convertedList = (from n in table.AsEnumerable()
                                 where Convert.ToString(n["LovKey"]) == LovKey
                                 select new LovValueDesc
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                     DefaultValue = Convert.ToBoolean(n["IsDefault"]),
                                     Description = Convert.ToString(n["Description"])
                                 }).ToList();
            return convertedList;
        }

        public DataTable GetDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spName;
                   
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                        foreach (var item in parameters)
                        {

                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")
                            //{
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                            //}
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                            }


                        }
                        foreach (var item in DataSetparameters)
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                        }
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                        da.Fill(objDataTable);
                    
                }
            }
            return objDataTable;
        }
        public DataTable FEMSGetDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spName;

                    //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                    //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                    foreach (var item in parameters)
                    {

                        if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                        }
                        //else if (item.Key == "@pCustomerLogo")
                        //{
                        //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                        //}
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                        }


                    }
                    foreach (var item in DataSetparameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                    }
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                    da.Fill(objDataTable);

                }
            }
            return objDataTable;
        }
        public DataTable BEMSGetDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spName;

                    //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                    //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                    foreach (var item in parameters)
                    {

                        if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                        }
                        //else if (item.Key == "@pCustomerLogo")
                        //{
                        //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                        //}
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                        }


                    }
                    foreach (var item in DataSetparameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                    }
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                    da.Fill(objDataTable);

                }
            }
            return objDataTable;
        }
        public DataTable MASTERGetDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MASTERUETrackCommonConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spName;

                    //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                    //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                    foreach (var item in parameters)
                    {

                        if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                        }
                        //else if (item.Key == "@pCustomerLogo")
                        //{
                        //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                        //}
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                        }


                    }
                    foreach (var item in DataSetparameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                    }
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                    da.Fill(objDataTable);

                }
            }
            return objDataTable;
        }

        public DataTable MasterGetDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ToString()))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                        foreach (var item in parameters)
                        {

                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")
                            //{
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                            //}
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

        //public byte[] GenerateQRCode(string Code)
        //{
        //    using (MemoryStream ms = new MemoryStream())
        //    {
        //        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        //        QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(Code, QRCodeGenerator.ECCLevel.Q);
        //        using (Bitmap bitMap = qrCode.GetGraphic(20))
        //        {
        //            bitMap.Save(ms, ImageFormat.Png);
        //            return ms.ToArray();
        //        }
        //    }
        //}

        public DataSet GetDataSetUsingServiceId(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters, int serviceid)
        {
            DataSet ds = new DataSet();
            using (var con = new SqlConnection(ModuleConnectionHelper.GetModuleConnectionKey(serviceid)))
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
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }


        public DataTable GetDataTableUsingServiceId(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters, int serviceid)
        {
            DataTable objDataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ModuleConnectionHelper.GetModuleConnectionKey(serviceid)))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = spName;

                    //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                    //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                    foreach (var item in parameters)
                    {

                        if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                        }
                        //else if (item.Key == "@pCustomerLogo")
                        //{
                        //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                        //}
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" ? null : item.Value));
                        }


                    }
                    foreach (var item in DataSetparameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                    }
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                    da.Fill(objDataTable);

                }
            }
            return objDataTable;
        }



        public DataSet GetDataSet(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataSet ds = new DataSet();
            using (var con = new SqlConnection(ConnectionString))
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
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
          public List<MultiSelectDD> GetMultiSelectDDRecords(DataTable table)
        {
            var convertedList = (from n in table.AsEnumerable()
                                 select new MultiSelectDD
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                     Active = false
                                 }).ToList();
            return convertedList;
        }
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
    public class BEMSDBAccessDAL : DBAccessDAL
    {
        public BEMSDBAccessDAL()
        {
           // Bems
           // ConnectionString = ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ConnectionString;
        }

        public DataTable GetMasterDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ToString()))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                        foreach (var item in parameters)
                        {

                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")
                            //{
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                            //}
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
    }
    public class FEMSDBAccessDAL : DBAccessDAL
    {
        public FEMSDBAccessDAL()
        {
          //  ConnectionString = ConfigurationManager.ConnectionStrings["FEMSUETrackCommonConnectionString"].ConnectionString;
        }

        public DataTable GetFEMSDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (var con = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                        foreach (var item in parameters)
                        {

                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")
                            //{
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                            //}
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
    }
    public class MASTERDBAccessDAL 
    {
        public String ConnectionString="";
        public MASTERDBAccessDAL()
        {
            ConnectionString = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
        }

        public DataTable GetMASTERDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
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

                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")
                            //{
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));
                            //}
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
        public List<LovValue> GetLovRecords(DataTable table)

        {
            var convertedList = (from n in table.AsEnumerable()
                                 select new LovValue
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                     DefaultValue = Convert.ToBoolean(n["IsDefault"])
                                 }).ToList();
            return convertedList;
        }

        //==========Added by Pranay on 21/10/2019 for GetLovRecords with parameters ======
        public List<LovValue> GetLovRecords(DataTable table, string LovKey)
        {
            var convertedList = (from n in table.AsEnumerable()
                                 where Convert.ToString(n["LovKey"]) == LovKey
                                 select new LovValue
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                     DefaultValue = Convert.ToBoolean(n["IsDefault"])
                                 }).ToList();
            return convertedList;
        }

        public List<LovValue> GetRecords(DataTable table)

        {
            var convertedList = (from n in table.AsEnumerable()
                                 select new LovValue
                                 {
                                     LovId = Convert.ToInt32(n["LovId"]),
                                     FieldValue = Convert.ToString(n["FieldValue"]),
                                    // DefaultValue = Convert.ToBoolean(n["IsDefault"])
                                 }).ToList();
            return convertedList;
        }

        //==========End Here======
        public DataSet MasterGetDataSet(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
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
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        //public byte[] GenerateQRCode(string Code)
        //{
        //    using (MemoryStream ms = new MemoryStream())
        //    {
        //        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        //        QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(Code, QRCodeGenerator.ECCLevel.Q);
        //        using (Bitmap bitMap = qrCode.GetGraphic(20))
        //        {
        //            bitMap.Save(ms, ImageFormat.Png);
        //            return ms.ToArray();
        //        }
        //    }
        //}
    }
    public class MASTERBEMSDBAccessDAL
    {
        // Bems		
        public string ConnectionString = ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ConnectionString;
        public DataTable GetMasterDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (var con = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));		
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));		
                        foreach (var item in parameters)
                        {
                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")		
                            //{		
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));		
                            //}		
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
        //public byte[] GenerateQRCode(string Code)
        //{
        //    using (MemoryStream ms = new MemoryStream())
        //    {
        //        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        //        QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(Code, QRCodeGenerator.ECCLevel.Q);
        //        using (Bitmap bitMap = qrCode.GetGraphic(20))
        //        {
        //            bitMap.Save(ms, ImageFormat.Png);
        //            return ms.ToArray();
        //        }
        //    }
        //}
        public DataSet GetDataSet(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataSet ds = new DataSet();
            using (var con = new SqlConnection(ConnectionString))
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
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

    }
    public class MASTERFEMSDBAccessDAL
    {
        // Bems		
        public string ConnectionString = ConfigurationManager.ConnectionStrings["FEMSUETrackCommonConnectionString"].ConnectionString;
        public DataTable GetMasterDataTable(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataTable objDataTable = new DataTable();
            using (var con = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand(spName, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));		
                        //cmd.Parameters.Add(new SqlParameter("@Version_No", version));		
                        foreach (var item in parameters)
                        {
                            if (item.Key == "@pTimestamp" || item.Key == "@pQRCode" || item.Key == "@pLogo")
                            {
                                cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.FromBase64String(item.Value)));
                            }
                            //else if (item.Key == "@pCustomerLogo")		
                            //{		
                            //    cmd.Parameters.Add(new SqlParameter(item.Key, item.Value == "" || item.Value == null ? null : Convert.ToBase64String(item.Value)));		
                            //}		
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
        //public byte[] GenerateQRCode(string Code)
        //{
        //    using (MemoryStream ms = new MemoryStream())
        //    {
        //        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        //        QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(Code, QRCodeGenerator.ECCLevel.Q);
        //        using (Bitmap bitMap = qrCode.GetGraphic(20))
        //        {
        //            bitMap.Save(ms, ImageFormat.Png);
        //            return ms.ToArray();
        //        }
        //    }
        //}
        public DataSet GetDataSet(string spName, Dictionary<string, string> parameters, Dictionary<string, DataTable> DataSetparameters)
        {
            DataSet ds = new DataSet();
            using (var con = new SqlConnection(ConnectionString))
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
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

    }


}
