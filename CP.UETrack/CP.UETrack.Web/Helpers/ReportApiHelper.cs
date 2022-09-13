using CP.UETrack.Model.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Http;
using System.Web;

namespace UETrack.Application.Web.Helpers
{
    public class ReportApiHelper
    {
        AsisReportViewModel reportVM { get; }

        public ReportApiHelper()
        {
            this.reportVM = new AsisReportViewModel();
        }

        public List<SqlParameter> GetSqlParmsList(string ConnectionStringName, string SpName, List<string> paraValues)
        {
            List<SqlParameter> paramList = null;
            try
            {
                reportVM.connectionStringName = ConnectionStringName;
                reportVM.spName = SpName;
                reportVM.paraValue = paraValues;
                const string currentUrl = "AsisReport/GetSqlParmsList";
                var result = RestHelper.ApiPost(currentUrl, reportVM);
                var response = result.Result;
                if (response.IsSuccessStatusCode)
                {
                    paramList = new List<SqlParameter>();
                    // Parse the response body. Blocking!
                    var sqlParamDict = response.Content.ReadAsAsync<Dictionary<string, object>>().Result;
                    foreach (var item in sqlParamDict)
                    {
                        var p = new SqlParameter(item.Key, item.Value);
                        paramList.Add(p);
                    }
                }
                else
                {
                    Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
                }
                return paramList;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public DataSet ExecuteDataSet(string ConnectionStringName, CommandType CmdType, string SpName, SqlParameter[] SqlParamArray)
        {
            var ds = new DataSet();
            try
            {
                var sqlParamDict = new Dictionary<string, object>();
                reportVM.connectionStringName = ConnectionStringName;
                reportVM.commandType = CmdType;
                reportVM.spName = SpName;
                SqlParamArray.ToList().ForEach(p =>
                {
                    sqlParamDict.Add(p.ParameterName, p.Value);
                });
                reportVM.sqlDictParams = sqlParamDict;
                const string currentUrl = "AsisReport/ExecuteDataSet";
                var result = RestHelper.ApiPost(currentUrl, reportVM);
                var response = result.Result;
                if (response.IsSuccessStatusCode)
                {
                    // Parse the response body. Blocking!
                    ds = response.Content.ReadAsAsync<DataSet>().Result;
                }
                else
                {
                    Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
                }
                return ds;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public DataTable GetDataTableForDdl(string ConnectionStringName, string SpName, SqlParameter[] SqlParamArray)
        {
            var dt = new DataTable();
            try
            {
                Dictionary<string, object> sqlParamDict = null;
                reportVM.connectionStringName = ConnectionStringName;
                reportVM.spName = SpName;
                if (SqlParamArray != null)
                {
                    sqlParamDict = new Dictionary<string, object>();
                    SqlParamArray.ToList().ForEach(p =>
                    {
                        sqlParamDict.Add(p.ParameterName, p.Value);
                    });
                }
                reportVM.sqlDictParams = sqlParamDict;
                const string currentUrl = "AsisReport/GetDataTableForDdl";
                var result = RestHelper.ApiPost(currentUrl, reportVM);
                var response = result.Result;
                if (response.IsSuccessStatusCode)
                {
                    // Parse the response body. Blocking!
                    dt = response.Content.ReadAsAsync<DataTable>().Result;
                }
                else
                {
                    Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
                }
                return dt;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public string GetColumnFromDataRow(DataTable dt, string columnName)
        {
            try
            {
                if (dt.Rows.Count > 0)
                {
                    if (dt.Columns.Contains(columnName))
                    {
                        DataRow dr = dt.Rows[0];
                        return dr[columnName].ToString().Trim();
                    }
                    else
                    {
                        return null;
                    }
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

    }
}