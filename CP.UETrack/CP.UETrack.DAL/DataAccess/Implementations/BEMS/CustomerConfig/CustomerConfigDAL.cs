using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess
{
    public class CustomerConfigDAL : ICustomerConfigDAL
    {
        private readonly string _FileName = nameof(CustomerConfigDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CustomerConfigLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CustomerConfigLovs customerConfigLovs = null;

                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "DateFormatValue,CurrencyFormatValue,CustomerThemeColor");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);

                    }
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                       // cmd.Parameters.AddWithValue("@pLovKey", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pTableName", "FMTimeMonth");
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);

                    }

                }
                customerConfigLovs = new CustomerConfigLovs();
                if (ds1.Tables.Count != 0)
                {
                    customerConfigLovs.DateFormatValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "DateFormatValue");
                    customerConfigLovs.CurrencyFormatValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CurrencyFormatValue");
                    customerConfigLovs.ThemeColorValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CustomerThemeColor");
                }
                if (ds2.Tables.Count != 0)
                {
                    customerConfigLovs.FMTimeMonth = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                }

                    Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return customerConfigLovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public CustomerConfig Save(CustomerConfig customerConfig, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMConfigCustomerValues_Save";

                        SqlParameter parameter = new SqlParameter();

                        if (customerConfig.ConfigurationValues != null)
                        {

                            DataTable dataTable = new DataTable("udt_FMConfigCustomerValues");
                            dataTable.Columns.Add("ConfigValueId", typeof(int));
                            dataTable.Columns.Add("CustomerId", typeof(int));
                            dataTable.Columns.Add("ConfigKeyId", typeof(int));
                            dataTable.Columns.Add("ConfigKeyLovId", typeof(int));
                            dataTable.Columns.Add("UserId", typeof(int));
                            //dataTable.Columns.Add("ThemeColorId",typeof(int));
                            foreach (var item in customerConfig.ConfigurationValues)
                            {
                                dataTable.Rows.Add(item.ConfigValueId, item.CustomerId, item.ConfigKeyId, item.ConfigKeyLovId,_UserSession.UserId);
                            }

                            parameter.ParameterName = "@pConfigCustomerValues";
                            parameter.SqlDbType = SqlDbType.Structured;
                            parameter.Value = dataTable;
                            cmd.Parameters.Add(parameter);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                //using (SqlConnection con = new SqlConnection(FdbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_FMConfigCustomerValues_Save";

                //        SqlParameter parameter = new SqlParameter();

                //        if (customerConfig.ConfigurationValues != null)
                //        {

                //            DataTable dataTable = new DataTable("udt_FMConfigCustomerValues");
                //            dataTable.Columns.Add("ConfigValueId", typeof(int));
                //            dataTable.Columns.Add("CustomerId", typeof(int));
                //            dataTable.Columns.Add("ConfigKeyId", typeof(int));
                //            dataTable.Columns.Add("ConfigKeyLovId", typeof(int));
                //            dataTable.Columns.Add("UserId", typeof(int));
                //            //dataTable.Columns.Add("ThemeColorId",typeof(int));
                //            foreach (var item in customerConfig.ConfigurationValues)
                //            {
                //                dataTable.Rows.Add(item.ConfigValueId, item.CustomerId, item.ConfigKeyId, item.ConfigKeyLovId, _UserSession.UserId);
                //            }

                //            parameter.ParameterName = "@pConfigCustomerValues";
                //            parameter.SqlDbType = SqlDbType.Structured;
                //            parameter.Value = dataTable;
                //            cmd.Parameters.Add(parameter);
                //        }

                //        var da = new SqlDataAdapter();
                //        da.SelectCommand = cmd;
                //        da.Fill(ds);
                //    }
                //}
                //using (SqlConnection con = new SqlConnection(BdbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_FMConfigCustomerValues_Save";

                //        SqlParameter parameter = new SqlParameter();

                //        if (customerConfig.ConfigurationValues != null)
                //        {

                //            DataTable dataTable = new DataTable("udt_FMConfigCustomerValues");
                //            dataTable.Columns.Add("ConfigValueId", typeof(int));
                //            dataTable.Columns.Add("CustomerId", typeof(int));
                //            dataTable.Columns.Add("ConfigKeyId", typeof(int));
                //            dataTable.Columns.Add("ConfigKeyLovId", typeof(int));
                //            dataTable.Columns.Add("UserId", typeof(int));
                //            //dataTable.Columns.Add("ThemeColorId",typeof(int));
                //            foreach (var item in customerConfig.ConfigurationValues)
                //            {
                //                dataTable.Rows.Add(item.ConfigValueId, item.CustomerId, item.ConfigKeyId, item.ConfigKeyLovId, _UserSession.UserId);
                //            }

                //            parameter.ParameterName = "@pConfigCustomerValues";
                //            parameter.SqlDbType = SqlDbType.Structured;
                //            parameter.Value = dataTable;
                //            cmd.Parameters.Add(parameter);
                //        }

                //        var da = new SqlDataAdapter();
                //        da.SelectCommand = cmd;
                //        da.Fill(ds);
                //    }
                //}


                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    customerConfig.ConfigurationValues = (from n in ds.Tables[0].AsEnumerable()
                                                          select new ConfigValues
                                                          {
                                                              ConfigValueId = n.Field<int>("ConfigValueId"),
                                                              ConfigKeyId = n.Field<int>("ConfigKeyId")
                                                          }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return customerConfig;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public CustomerConfig Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var customerConfig = new CustomerConfig();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMConfigCustomerValues_GetByCustomerId";
                        cmd.Parameters.AddWithValue("@pCustomerId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    customerConfig.ConfigurationValues = (from n in ds.Tables[0].AsEnumerable()
                                                          select new ConfigValues
                                                          {
                                                               ConfigValueId = n.Field<int>("ConfigValueId"),
                                                               ConfigKeyId = n.Field<int>("ConfigKeyId"),
                                                               ConfigKeyLovId = n.Field<int>("ConfigKeyLovId"),                                                               
                                                          }).ToList();
                    
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return customerConfig;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}