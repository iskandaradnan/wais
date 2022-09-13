using CP.UETrack.DAL.DataAccess.Contracts.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Model.Common;

namespace CP.UETrack.DAL.DataAccess.Implementations.Common
{
    public class AsisReportDAL : IAsisReportDAL
    {
        #region ExecuteDataSet
        /// <summary>
        /// Executes the stored procedure and returns the result as a <see cref="DataSet"/>.
        /// </summary>
        /// <param name="connectionStringName">The name of the connection string to use.</param>
        /// <param name="commandType">The command type.</param>
        /// <param name="spName">The stored procedure to execute.</param>
        /// <param name="sqlDictParams">todo: describe sqlDictParams parameter on ExecuteDataSet</param>
        /// <returns>A <see cref="DataSet"/> containing the results of the stored procedure execution.</returns>
        public AsisReportViewModel ExecuteDataSet(AsisReportViewModel rVM)
        {
            try
            {
                var connectionString = ConfigurationManager.ConnectionStrings[rVM.connectionStringName].ConnectionString;
                SqlParameter[] sqlParamArray = null;
                if (rVM.sqlDictParams != null && rVM.sqlDictParams.Count > 0)
                {
                    sqlParamArray = new SqlParameter[rVM.sqlDictParams.Count];
                    foreach (var item in rVM.sqlDictParams)
                    {
                        var idx = rVM.sqlDictParams.ToList().IndexOf(item);
                        var param = new SqlParameter(item.Key, item.Value);
                        sqlParamArray[idx] = param;
                    }
                }
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = this.CreateCommand(connection, rVM.commandType, rVM.spName, sqlParamArray))
                    {
                        //return this.CreateDataSet(command);
                        return rVM;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
        #endregion

        #region ToGetSqlParameter
        /// <summary>
        /// Executes the Input and returns SqlParameterList
        /// </summary>
        /// <param name="connectionStringName">The name of the connection string to use.</param>
        /// <param name="spName">The stored procedure to execute.</param>
        /// <param name="paraValue">The parameters of the stored procedure.</param>
        /// <returns></returns>
        public AsisReportViewModel GetSqlParmsList(AsisReportViewModel rVM)
        {
            //List<SqlParameter> spParameters = new List<SqlParameter>();
            var spParameters = new Dictionary<string, object>();
            try
            {
                var connectionString = ConfigurationManager.ConnectionStrings[rVM.connectionStringName].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    var cmd = new SqlCommand(rVM.spName, con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlCommandBuilder.DeriveParameters(cmd);
                    if (rVM.paraValue != null)
                    {
                        foreach (SqlParameter para in cmd.Parameters)
                        {
                            var idx = cmd.Parameters.IndexOf(para);
                            if (para.Direction == ParameterDirection.Input || para.Direction == ParameterDirection.Output || para.Direction == ParameterDirection.InputOutput)
                            {
                                para.Value = DbToCsTypeHelper.ConvertToCs(rVM.paraValue[idx], DbToCsTypeHelper.GetCsDataType(para.SqlDbType));
                                spParameters.Add(para.ParameterName, para.Value);
                            }
                        }
                    }
                    cmd.Parameters.Clear();
                    con.Close();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            //return spParameters.Count > 0 ? spParameters : null;
            return rVM;
        }
        #endregion

        #region GetDataTableForDdl
        public AsisReportViewModel GetDataTableForDdl(AsisReportViewModel rVM)
        {
            DataSet ds = null;
            try
            {
                if (rVM.sqlDictParams == null || rVM.sqlDictParams.Count <= 0)
                {
                    //ds = this.ExecuteDataSet(rVM.connectionStringName, CommandType.StoredProcedure, rVM.spName, null);
                }
                else
                {
                   // ds = this.ExecuteDataSet(rVM.connectionStringName, CommandType.StoredProcedure, rVM.spName, rVM.sqlDictParams);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            //return ds.Tables[0];
            return rVM;
        }
        #endregion
         
        #region CreateCommand
        /// <summary>
        /// Creates, initializes, and returns a <see cref="SqlCommand"/> instance.
        /// </summary>
        /// <param name="connection">The <see cref="SqlConnection"/> the <see cref="SqlCommand"/> should be executed on.</param>
        /// <param name="commandType">The command type.</param>
        /// <param name="spName">The name of the stored procedure to execute.</param>
        /// <param name="values">The values for each parameter of the stored procedure.</param>
        /// <returns>An initialized <see cref="SqlCommand"/> instance.</returns>
        SqlCommand CreateCommand(SqlConnection connection, CommandType commandType, string spName, params object[] values)
        {
            try
            {
                if (connection != null && connection.State == ConnectionState.Closed)
                {
                    connection.Open();
                }

                var command = new SqlCommand();
                command.Connection = connection;
                command.CommandText = spName;
                command.CommandType = commandType;

                // Append each parameter to the command
                if (values == null || values.Length == 0)
                {
                    if (values == null)
                    {
                        return command;
                    }
                    else
                    {
                        for (int i = 0; i < values.Length; i++)
                        {
                            command.Parameters[i].Value = DBNull.Value;
                        }
                    }
                }
                else
                {
                    for (int i = 0; i < values.Length; i++)
                    {
                        command.Parameters.Add(this.CheckValue(values[i]));
                    }
                }
                return command;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
        #endregion

        #region CreateDataSet
        DataSet CreateDataSet(SqlCommand command)
        {
            try
            {
                using (SqlDataAdapter dataAdapter = new SqlDataAdapter(command))
                {
                    command.ExecuteNonQuery();
                    var dataSet = new DataSet();
                    dataAdapter.Fill(dataSet);
                    command.Connection.Close();
                    return dataSet;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
        #endregion

        #region UtilityMethod
        /// <summary>
        /// Converts the specified value to <code>DBNull.Value</code> if it is <code>null</code>.
        /// </summary>
        /// <param name="value">The value that should be checked for <code>null</code>.</param>
        /// <returns>The original value if it is not null, otherwise <code>DBNull.Value</code>.</returns>
        object CheckValue(object value)
        {
            try
            {
                if (value == null)
                {
                    return DBNull.Value;
                }
                else
                {
                    return value;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
        #endregion     
    }

    public static class DbToCsTypeHelper
    {
        public static Type GetCsDataType(SqlDbType sqlType)
        {
            switch (sqlType)
            {
                case SqlDbType.BigInt:
                    return typeof(long?);

                case SqlDbType.Binary:
                case SqlDbType.Image:
                case SqlDbType.Timestamp:
                case SqlDbType.VarBinary:
                    return typeof(byte[]);

                case SqlDbType.Bit:
                    return typeof(bool?);

                case SqlDbType.Char:
                case SqlDbType.NChar:
                case SqlDbType.NText:
                case SqlDbType.NVarChar:
                case SqlDbType.Text:
                case SqlDbType.VarChar:
                case SqlDbType.Xml:
                    return typeof(string);

                case SqlDbType.DateTime:
                case SqlDbType.SmallDateTime:
                case SqlDbType.Date:
                case SqlDbType.Time:
                case SqlDbType.DateTime2:
                    return typeof(DateTime?);

                case SqlDbType.Decimal:
                case SqlDbType.Money:
                case SqlDbType.SmallMoney:
                    return typeof(decimal?);

                case SqlDbType.Float:
                    return typeof(double?);

                case SqlDbType.Int:
                    return typeof(int?);

                case SqlDbType.Real:
                    return typeof(float?);

                case SqlDbType.UniqueIdentifier:
                    return typeof(Guid?);

                case SqlDbType.SmallInt:
                    return typeof(short?);

                case SqlDbType.TinyInt:
                    return typeof(byte?);

                case SqlDbType.Variant:
                case SqlDbType.Udt:
                    return typeof(object);

                case SqlDbType.Structured:
                    return typeof(DataTable);

                case SqlDbType.DateTimeOffset:
                    return typeof(DateTimeOffset?);

                default:
                    throw new ArgumentOutOfRangeException("sqlType in DbToCsTypeHelper.");
            }
        }

        public static object ConvertToCs(string value, Type type)
        {
            object result = null;
            try
            {
                if (string.IsNullOrWhiteSpace(value))
                {
                    return null;
                }
                try
                {
                    var converter = TypeDescriptor.GetConverter(type);
                    result = converter.ConvertFromString(value);
                }
                catch (Exception ex)
                {
                    throw ;
                }
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
            return result;
        }
    }
}
