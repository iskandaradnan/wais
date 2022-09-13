using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace CP.UETrack.DAL.DataAccess.Implementations.Common
{
    public class ReportCommonDAL : IReportCommonDAL
    {
        private readonly string _FileName = nameof(ReportCommonDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public dynamic GetReportData(string whereCondition, string viewModelName)
        {
            throw new NotImplementedException();
            //try
            //{
            //    Log4NetLogger.LogEntry(_FileName, (string.Concat(nameof(ReportCommonDAL), string.Empty, viewModelName)), Level.Info.ToString());
            //    if (string.IsNullOrEmpty(whereCondition))
            //    {
            //        return string.Empty;
            //    }
            //    using (var context = new ASISWebDatabaseEntities())
            //    {
            //        context.Configuration.ProxyCreationEnabled = false;
            //        viewModelName = "S_" + viewModelName;
            //        var parametersList = whereCondition.Split('|');
            //        var pList = new object[parametersList.Length];
            //        for (int i = 0; i < parametersList.Length; i++)
            //        {
            //            var item = parametersList[i];
            //            var itemType = parametersList[i].Split('$')[0];
            //            var itemValue = parametersList[i].Split('$')[1];

            //            switch (itemType)
            //            {
            //                case nameof(i):
            //                    pList[i] = Convert.ToInt32(itemValue);
            //                    break;
            //                case "s":
            //                    pList[i] = itemValue;
            //                    break;
            //                default:
            //                    break;
            //            }
            //        }
            //        var method = typeof(ASISWebDatabaseEntities).GetMethod(viewModelName);
            //        var result = method.Invoke(context, pList);
            //        var types = typeof(CommonDAL).Assembly.GetTypes().Where(t => t.Name == viewModelName + "_Result");
            //        var CastMethod = typeof(Enumerable).GetMethod("Cast");
            //        var ToListMethod = typeof(Enumerable).GetMethod("ToList");
            //        var castItems = CastMethod.MakeGenericMethod(new Type[] { types.FirstOrDefault() })
            //              .Invoke(null, new object[] { result });
            //        var resultList = ToListMethod.MakeGenericMethod(new Type[] { types.FirstOrDefault() })
            //                                  .Invoke(null, new object[] { castItems });
            //        Log4NetLogger.LogExit(_FileName, (string.Concat(nameof(ReportCommonDAL), string.Empty, viewModelName)), Level.Info.ToString());
            //        return resultList;
            //    }
            //}
            //catch (DALException dalException)
            //{
            //    throw new DALException(dalException);
            //}
            //catch (Exception ex)
            //{
            //    throw new DALException(ex);
            //}
        }

        public string GetReportDataSet(string spName, Dictionary<string, string> parameters)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetReportDataSet), Level.Info.ToString());
                if (parameters == null)
                {
                    return string.Empty;
                }
                var ds = GetDataSet(spName, parameters);
                var result = ToXml(ds);
                Log4NetLogger.LogExit(_FileName, nameof(GetReportDataSet), Level.Info.ToString());
                return result;
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }

        public static DataSet GetDataSet(string spName, Dictionary<string, string> parameters)
        {
            throw new NotImplementedException();
            // creates resulting dataset
            //var result = new DataSet();

            //// creates a data access context (DbContext descendant)
            //using (var context = new ASISWebDatabaseEntities())
            //{
            //    // creates a Command 
            //    var cmd = context.Database.Connection.CreateCommand();
            //    var cmdType = CommandType.StoredProcedure;
            //    cmd.CommandType = cmdType;
            //    cmd.CommandText = spName;

            //    // adds all parameters
            //    foreach (var pr in parameters)
            //    {
            //        var p = cmd.CreateParameter();
            //        p.ParameterName = pr.Key;
            //        p.Value = pr.Value;
            //        cmd.Parameters.Add(p);
            //    }

            //    try
            //    {
            //        // executes
            //        context.Database.Connection.Open();
            //        var reader = cmd.ExecuteReader();

            //        // loop through all resultsets (considering that it's possible to have more than one)
            //        do
            //        {
            //            // loads the DataTable (schema will be fetch automatically)
            //            var tb = new DataTable();
            //            tb.Load(reader);
            //            result.Tables.Add(tb);

            //        } while (!reader.IsClosed);
            //    }
            //    finally
            //    {
            //        // closes the connection
            //        context.Database.Connection.Close();
            //    }
            //}

            //// returns the DataSet
            //return result;
        }

        private static string ToXml(DataSet ds)
        {
            using (var memoryStream = new MemoryStream())
            {
                using (TextWriter streamWriter = new StreamWriter(memoryStream))
                {
                    var xmlSerializer = new XmlSerializer(typeof(DataSet));
                    xmlSerializer.Serialize(streamWriter, ds);
                    return Encoding.UTF8.GetString(memoryStream.ToArray());
                }
            }
        }
    }
}
