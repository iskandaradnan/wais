using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CP.Framework.Data
{
    /// <summary>
    /// For stored proc parameter
    /// type vs dbtype mapping is yet to be completed-AV
    /// </summary>
    public class StoredProcedureParm
    {
        public string ParameterName { get; set; }
        public readonly string ParameterType;
        public readonly object ParameterValue;
        public StoredProcedureParm(string sparmName,object value,string ptype)
        {
            ParameterName = sparmName;
            ParameterValue = value;
            ParameterType = ptype;
        }
        public SqlParameter MapSPParm()
        {
            var outType = SqlDbType.VarChar;
            switch (ParameterType)

            {
                case "int": outType = SqlDbType.Int; break;
                case "string": outType = SqlDbType.VarChar; break;
                case "bool": outType = SqlDbType.Bit; break;
                default: outType = SqlDbType.VarChar; break;
            }
            return new SqlParameter(ParameterName, outType) { Value = ParameterValue };
        }
        public string FormatSQLCmd(string sqlcmd,bool firsttime = true)
        {
            if (firsttime)
            {
                sqlcmd = "EXEC " + sqlcmd;
                return sqlcmd + " " + "@" + ParameterName;
            }
            return sqlcmd + "," + "@" + ParameterName;

        }
    }
    /// <summary>
    /// for list of sp parms
    /// </summary>
    public class StoredProcedureParmList
    {
        public List<StoredProcedureParm> sprocList { get; set; }
        public StoredProcedureParmList()
        {
            sprocList = new List<StoredProcedureParm>();
        }
        public SqlParameter[] MapSPParmList()
        {
            var i =0;
            var paramList = new SqlParameter[sprocList.Count];
            sprocList.ForEach(x => {
                paramList[i] =x.MapSPParm();
                ++i;
            });
            return paramList;
        }
        public string FormatSSQLcmd(string sqlcmd)
        {
            var i = 0;
            sprocList.ForEach(x =>
            {

                sqlcmd = x.FormatSQLCmd(sqlcmd,i == 0? true:false);
                ++i;
            });
            return sqlcmd;
        }
    }
}
