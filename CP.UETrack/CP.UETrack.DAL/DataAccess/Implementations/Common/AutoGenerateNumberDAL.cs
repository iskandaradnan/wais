using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.Common
{
    public class AutoGenerateNumberDAL

    {
        static readonly string _fileName = nameof(AutoGenerateNumberDAL);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ViewModelEntity">view Model object</param>
        /// <param name="documentIdKeyFormat">documentIdKeyFormat object</param>
        /// <param name="bAutoGenerate">todo: describe bAutoGenerate parameter on AutoGenerateAndSave</param>
        /// <param name="yearWiseIncrement">todo: describe yearWiseIncrement parameter on AutoGenerateAndSave</param>
        /// <param name="CCLS">todo: describe CCLS parameter on AutoGenerateAndSave</param>
        /// <typeparam name="T">View Model Type</typeparam>
        /// <typeparam name="U">Domain Entity Type</typeparam>
        /// <returns></returns>
        public static string AutoGenerate(dynamic ViewModelEntity, DocumentIdKeyFormat documentIdKeyFormat, bool bAutoGenerate = true, bool yearWiseIncrement = false, dynamic CCLS = null, bool laundry = false)
        {
            var noOfAttempts = 0;
            var generatedNumber = string.Empty;
           // do
           // {
                var format = "Attempt - {0} , column - {1} , AutoGenerateNumber = {2} , Status - {3}";
                
                var _log = new Log4NetLogger();
                try
                {
                    #region AutoGenerateAndSave 
                    Log4NetLogger.LogEntry(_fileName, nameof(AutoGenerate), Level.Info.ToString());
                    var date = DateTime.Now;
                    var currentYear = date.Year;
                    var currentmonth = date.Month;
                    //if (documentIdKeyFormat.ModuleName != "DED")
                    //{
                    //    ViewModelEntity.GetType().GetProperty("CreatedDate").SetValue(ViewModelEntity, date, null);
                    //}
                    //ViewModelEntity.GetType().GetProperty("ModifiedDate").SetValue(ViewModelEntity, date, null);
                    AsisDocumentNumber asisDocumentNumber = null;

                    // using (var dbContext = new ASISWebDatabaseEntities()) /// Here exexcute this context separate scope for get and update auto generate number
                    //{

                    asisDocumentNumber = GetAutoGenerateNumber(ViewModelEntity, documentIdKeyFormat,bAutoGenerate, yearWiseIncrement);

                   // var relatedEntities = new List<object>();
                    //"SaveAndGetAutoGenerateNumber : CompanyId= " + ViewModelEntity.GetType().GetProperty("CompanyId").GetValue(ViewModelEntity, null) + " - HospitalId=" + ViewModelEntity.GetType().GetProperty("HospitalId").GetValue(ViewModelEntity, null)
                    //+ " - Screen Name=" + documentIdKeyFormat.ScreenName +/Commented Autogenerated Issue in company Id null/
                    generatedNumber = ViewModelEntity.GetType().GetProperty(documentIdKeyFormat.AutoGenarateProp).GetValue(ViewModelEntity, null);
                    var strLogMsg = " Auto column Name= " + documentIdKeyFormat.AutoGenarateProp + " - AutoGenerateNumber=" + generatedNumber;




                    // }

                    
                    #endregion
                }
                catch (DALException dalex)
                {
                    _log.LogMessage("Auto Generated number save method line 162 DALException Message =" + dalex.Message, Level.Error);
                    _log.LogMessage("Auto Generated number save method line 162 DALException StackTrace =" + dalex.StackTrace, Level.Error);

                    throw new DALException(dalex);
                }
                #region Unique Constrint Check
                catch (DbUpdateException dbUpdateEx)
                {
                    if (dbUpdateEx.InnerException != null && dbUpdateEx.InnerException.InnerException != null)
                    {
                        var sqlException = dbUpdateEx.InnerException.InnerException as SqlException;
                        if (sqlException != null)
                        {
                            switch (sqlException.Number)
                            {
                                case 2627:  // Unique constraint error
                                case 547:   // Constraint check violation
                                case 2601:  // Duplicated key row error
                                            // Constraint violation exception

                                    var msg = string.Format(format, noOfAttempts, documentIdKeyFormat.AutoGenarateProp, generatedNumber, "fail - Unique constraint error");
                                    _log.LogMessage(msg, Level.Error);
                                    noOfAttempts++;

                                    if (noOfAttempts > 5)
                                    {
                                        msg = string.Format(format, noOfAttempts, documentIdKeyFormat.AutoGenarateProp, generatedNumber, "fail - Exceeds max level");
                                        _log.LogMessage(msg, Level.Error);
                                        throw new Exception("Please Save again");
                                    }

                                    break;
                                default:
                                    // A custom exception of yours for other DB issues
                                    throw new DALException(dbUpdateEx);
                            }
                        }
                        else
                        {
                            noOfAttempts = 6;
                        }
                    }
                }
                #endregion
                catch (Exception ex)
                {
                    _log.LogMessage("Auto Generated number save method line 204 DALException Exception =" + ex.Message, Level.Error);
                    _log.LogMessage("Auto Generated number save method line 204 DALException StackTrace =" + ex.StackTrace, Level.Error);
                    throw new GeneralException(ex);
                }
                finally
                {
                    Log4NetLogger.LogExit(_fileName, nameof(AutoGenerate), Level.Info.ToString());
                }

            //} while (noOfAttempts <= 5);

            return generatedNumber+DateTime.Now.Millisecond;
        }

        public static AsisDocumentNumber GetAutoGenerateNumber(dynamic ViewModelEntity, DocumentIdKeyFormat documentIdKeyFormat, /*ASISWebDatabaseEntities dbContext, TransactionHelper tranHelper,*/ bool bAutoGenerate = true, bool yearWiseIncrement = false)
        {

            var date = CommonFormatHelper.getCommonDateFormat(DateTime.Now.Date);
            var autoGenNo = string.Empty;

            // Reset Year Wise Running Number 
            if (yearWiseIncrement && !string.IsNullOrEmpty(documentIdKeyFormat.Formatkey))
            {
                var yearFormats = new string[]
                {
                    "[Year]",
                    "[YearMonth]" ,
                    "[MonthYear]" ,
                    "[MonthYearFull]" ,
                    "[MonthNameYear]" ,
                    "[MonthNameYearFull]",
                    "[YearMonthDate]"
                };
                var splitedFormat = documentIdKeyFormat.Formatkey.Split(yearFormats, StringSplitOptions.RemoveEmptyEntries);

                if (splitedFormat != null && splitedFormat.Count() > 0)
                {
                    var formatUptoYear = splitedFormat[0].Trim() + "[Year]";

                    var formatForDocNo = AutoGenerateNumberDAL.ReplaceMetaTag(formatUptoYear, documentIdKeyFormat/*, dbContext*/);

                    AsisDocumentNumber asisDocumentNo = null;
                    documentIdKeyFormat.GeneratedDocNoFormat = formatForDocNo.TrimEnd('/');
                    //var isServiceRequest = ViewModelEntity is SrServiceRequestMstViewModel;


                    //  var codes = tranHelper.GetDcoumentnumber<AsisDocumentNumber>("IsDeleted = False and DocumentNumber= \"" + formatForDocNo.TrimEnd('/').ToString() + "\"", dbContext);


                    var dbAccessDAL = new DBAccessDAL();


                    using (var con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {

                        var cmd = new SqlCommand();
                        using (SqlDataAdapter da = new SqlDataAdapter())
                        {
                            using (DataTable dt = new DataTable())
                            {
                                var Conditionstr = "select * from FMDocumentNoGeneration  DocumentNumber= \"" + formatForDocNo.TrimEnd('/').ToString() + "\"";
                                using (cmd = new SqlCommand(Conditionstr, con))
                                {

                                    da.SelectCommand = cmd;
                                    da.Fill(dt);

                                    var myEnumerable = dt.AsEnumerable();
                                    asisDocumentNo =
                                        (from item in myEnumerable
                                         select new AsisDocumentNumber
                                         {
                                             DocumentNumberId = item.Field<int>("DocumentNumberId"),

                                             ScreenName = item.Field<string>("ScreenName"),
                                             DocumentNumber = item.Field<string>("DocumentNumber"),
                                             CodeNumber = item.Field<long>("CodeNumber"),
                                             CreatedBy = item.Field<int>("CreatedBy"),
                                             CreatedDate = item.Field<DateTime>("CreatedDate"),
                                             CreatedDateUTC = item.Field<DateTime>("CreatedDateUTC"),
                                             ModifiedBy = item.Field<int?>("ModifiedBy"),
                                             ModifiedDate = item.Field<DateTime?>("ModifiedDate"),
                                             ModifiedDateUTC = item.Field<DateTime?>("ModifiedDateUTC"),
                                             Timestamp = item.Field<byte[]>("Timestamp"),
                                             Active = item.Field<bool>("Active"),
                                             BuiltIn = item.Field<bool>("BuiltIn"),
                                         }).ToList().FirstOrDefault();

                                }
                            }
                        }




                    }








                    // asisDocumentNo = codes.FirstOrDefault();


                    var codenumber = default(long);

                    if (asisDocumentNo != null)
                    {
                        codenumber = asisDocumentNo.CodeNumber;
                        // if (!isServiceRequest)
                        //{
                        asisDocumentNo.CodeNumber++;
                        // }
                    }
                    else
                    {
                        asisDocumentNo = new AsisDocumentNumber
                        {
                            ScreenName = documentIdKeyFormat.ScreenName,
                            DocumentNumber = formatForDocNo.TrimEnd('/').ToString(),
                            CodeNumber = 1,
                            //CreatedBy = Convert.ToInt32(ViewModelEntity.GetType().GetProperty("CreatedBy").GetValue(ViewModelEntity, null)),
                            CreatedDate = date,
                           // ModifiedBy = Convert.ToInt32(ViewModelEntity.GetType().GetProperty("ModifiedBy").GetValue(ViewModelEntity, null)),
                            ModifiedDate = date,
                        };

                        //if (isServiceRequest)
                        //{
                        //    var parameters = new Dictionary<string, string>();
                        //    parameters.Add("@ScreenName", asisDocumentNo.ScreenName);
                        //    parameters.Add("@DocumentNumber", asisDocumentNo.DocumentNumber);
                        //    parameters.Add("@CodeNumber", asisDocumentNo.CodeNumber.ToString());
                        //    parameters.Add("@CreatedBy", asisDocumentNo.CreatedBy.ToString());
                        //    parameters.Add("@ModifiedBy", asisDocumentNo.ModifiedBy.ToString());
                        //    var ds = GetDataSet("CreateDocumentNo", parameters);
                        //}
                    }


                    var originalFormat = AutoGenerateNumberDAL.ReplaceMetaTag(documentIdKeyFormat.Formatkey, documentIdKeyFormat/*, dbContext*/);

                    //For SR screen changes TC 54
                    if (documentIdKeyFormat.ModuleName.ToUpper().Equals("SR", StringComparison.OrdinalIgnoreCase))
                    {
                        originalFormat = originalFormat.Substring(0, originalFormat.Length - 1);
                    }

                    autoGenNo = originalFormat + asisDocumentNo.CodeNumber.ToString().PadLeft(6, '0');
                    ViewModelEntity.GetType().GetProperty(documentIdKeyFormat.AutoGenarateProp).SetValue(ViewModelEntity, autoGenNo, null);

                    return asisDocumentNo;
                }
            }


            var currentFormat = AutoGenerateNumberDAL.ReplaceMetaTag(documentIdKeyFormat.Formatkey, documentIdKeyFormat/*, dbContext*/);
            documentIdKeyFormat.GeneratedDocNoFormat = currentFormat;

            // var documentCodes = tranHelper.GetDcoumentnumber<AsisDocumentNumber>("IsDeleted = False and DocumentNumber= \"" + currentFormat + "\"", dbContext);

            var documentCodes = new List<AsisDocumentNumber>();
            var dbAccessDAL1 = new DBAccessDAL();


            using (var con = new SqlConnection(dbAccessDAL1.ConnectionString))
            {

                var cmd = new SqlCommand();
                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    using (DataTable dt = new DataTable())
                    {
                        var Conditionstr = "select * from FMDocumentNoGeneration where  DocumentNumber= \'" + currentFormat + "\'";
                        using (cmd = new SqlCommand(Conditionstr, con))
                        {

                            da.SelectCommand = cmd;
                            da.Fill(dt);

                            var myEnumerable = dt.AsEnumerable();
                            documentCodes =
                                (from item in myEnumerable
                                 select new AsisDocumentNumber
                                 {
                                     DocumentNumberId = item.Field<int>("DocumentNumberId"),

                                     ScreenName = item.Field<string>("ScreenName"),
                                     DocumentNumber = item.Field<string>("DocumentNumber"),
                                     CodeNumber = item.Field<long>("CodeNumber"),
                                     CreatedBy = item.Field<int>("CreatedBy"),
                                     CreatedDate = item.Field<DateTime>("CreatedDate"),
                                     CreatedDateUTC = item.Field<DateTime>("CreatedDateUTC"),
                                     ModifiedBy = item.Field<int?>("ModifiedBy"),
                                     ModifiedDate = item.Field<DateTime?>("ModifiedDate"),
                                     ModifiedDateUTC = item.Field<DateTime?>("ModifiedDateUTC"),
                                     Timestamp = item.Field<byte[]>("Timestamp"),
                                     Active = item.Field<bool>("Active"),
                                     BuiltIn = item.Field<bool>("BuiltIn"),
                                 }).ToList();

                        }
                    }
                }




            }


            var asisDocumentNumber = documentCodes.FirstOrDefault();
            if (!bAutoGenerate)
            {
                asisDocumentNumber = new AsisDocumentNumber
                {
                    ScreenName = documentIdKeyFormat.ScreenName,
                    DocumentNumber = currentFormat.TrimEnd('/').ToString(),
                    CodeNumber = 1,
                    //CreatedBy = Convert.ToInt32(ViewModelEntity.GetType().GetProperty("CreatedBy").GetValue(ViewModelEntity, null)),
                    CreatedDate = date,
                   // ModifiedBy = Convert.ToInt32(ViewModelEntity.GetType().GetProperty("ModifiedBy").GetValue(ViewModelEntity, null)),
                   // ModifiedDate = date,
                    //Timestamp = BitConverter.GetBytes(DateTime.Now.Ticks)
                };
                ViewModelEntity.GetType().GetProperty(documentIdKeyFormat.AutoGenarateProp).SetValue(ViewModelEntity, asisDocumentNumber.DocumentNumber, null);
                return asisDocumentNumber;
            }

            if (documentCodes != null && documentCodes.Count() > 0)
            {
                asisDocumentNumber.CodeNumber++;

                if (documentIdKeyFormat.ScreenName != null)
                {
                    if (documentIdKeyFormat.ScreenName.ToUpper().Equals("EQUIPMENT&VEHICLES", StringComparison.OrdinalIgnoreCase)
                        || documentIdKeyFormat.ScreenName.ToUpper().Equals("SYSTEM", StringComparison.OrdinalIgnoreCase)
                        || documentIdKeyFormat.ScreenName.ToUpper().Equals("BUILDING", StringComparison.OrdinalIgnoreCase)
                        || documentIdKeyFormat.ScreenName.ToUpper().Equals("LAND", StringComparison.OrdinalIgnoreCase)
                        || documentIdKeyFormat.ScreenName.ToUpper().Equals("BINDETAILS", StringComparison.OrdinalIgnoreCase))
                    {
                        autoGenNo = asisDocumentNumber.DocumentNumber + asisDocumentNumber.CodeNumber.ToString().PadLeft(5, '0');
                    }
                    else if ((documentIdKeyFormat.ScreenName.ToUpper().Equals("IAQMonthlyWalkthroughInspections", StringComparison.OrdinalIgnoreCase)))
                    {
                        autoGenNo = asisDocumentNumber.DocumentNumber + asisDocumentNumber.CodeNumber.ToString().PadLeft(2, '0');
                    }
                    else
                    {
                        autoGenNo = asisDocumentNumber.DocumentNumber + asisDocumentNumber.CodeNumber.ToString().PadLeft(6, '0');
                    }

                    //if (documentIdKeyFormat.ModuleName == "LLS")
                    //{
                    //    autoGenNo = autoGenNo;
                    //}
                }
                else
                {
                    autoGenNo = asisDocumentNumber.DocumentNumber + asisDocumentNumber.CodeNumber.ToString().PadLeft(6, '0');
                }
            }
            else
            {
                var number = 1;
                if (documentIdKeyFormat.ScreenName != null)
                {
                    if (documentIdKeyFormat.ScreenName.ToUpper().Equals("EQUIPMENT", StringComparison.OrdinalIgnoreCase) || documentIdKeyFormat.ScreenName.ToUpper().Equals("SYSTEM", StringComparison.OrdinalIgnoreCase) || documentIdKeyFormat.ScreenName.ToUpper().Equals("BUILDING", StringComparison.OrdinalIgnoreCase) || documentIdKeyFormat.ScreenName.ToUpper().Equals("LAND", StringComparison.OrdinalIgnoreCase) || documentIdKeyFormat.ScreenName.ToUpper().Equals("BINDETAILS", StringComparison.OrdinalIgnoreCase))
                    {
                        autoGenNo = currentFormat + number.ToString().PadLeft(5, '0');
                    }
                    else if ((documentIdKeyFormat.ScreenName.ToUpper().Equals("IAQMonthlyWalkthroughInspections", StringComparison.OrdinalIgnoreCase)))
                    {
                        autoGenNo = currentFormat + number.ToString().PadLeft(2, '0');
                    }
                    else
                    {
                        autoGenNo = currentFormat + number.ToString().PadLeft(6, '0');
                    }
                }
                else
                {
                    autoGenNo = currentFormat + number.ToString().PadLeft(6, '0');
                }
                asisDocumentNumber = new AsisDocumentNumber
                {
                    ScreenName = documentIdKeyFormat.ScreenName,
                    DocumentNumber = currentFormat,
                    CodeNumber = number,
                   // CreatedBy = Convert.ToInt32(ViewModelEntity.GetType().GetProperty("CreatedBy").GetValue(ViewModelEntity, null)),
                   // CreatedDate = date,
                    //ModifiedBy = Convert.ToInt32(ViewModelEntity.GetType().GetProperty("ModifiedBy").GetValue(ViewModelEntity, null)),
                    //ModifiedDate = date,
                    //Timestamp = BitConverter.GetBytes(DateTime.Now.Ticks)
                };
            }

            ViewModelEntity.GetType().GetProperty(documentIdKeyFormat.AutoGenarateProp).SetValue(ViewModelEntity, autoGenNo, null);

            return asisDocumentNumber;
        }



        /// <summary>
        /// ReplaceMetaTag -Replace placehoder string .
        /// </summary>
        /// <param name="formatkey"></param>
        /// <param name="documentIdKeyFormat"></param>
        /// <param name="dbContext"></param>
        /// <returns></returns>
        public static string ReplaceMetaTag(string formatkey, DocumentIdKeyFormat documentIdKeyFormat/*, DbContext dbContext*/)
        {
            if (!string.IsNullOrEmpty(formatkey))
            {
                var val = formatkey;
                //while (val.IndexOf("[") != -1)
                //{
                    int start = val.IndexOf("[");
                    int end = val.IndexOf("]", start + 1);
                    string dataElement = val.Substring(start + 1, end - start - 1);

                    var keyValue = GetKeyValue(dataElement, documentIdKeyFormat/*, dbContext*/);
                    keyValue += "/";
                    formatkey = formatkey.Replace("[" + dataElement + "]", keyValue);
                    val = val.Substring(end + 1);
                //}
            }
            // Formatkey = Formatkey.TrimEnd('/');
            return formatkey;
        }

        private static string GetKeyValue(string KeyName, DocumentIdKeyFormat documentIdKeyFormat/*, DbContext dbContext*/)
        {
            var result = string.Empty;
            // var dbContextNew = (ASISWebDatabaseEntities)dbContext;
            var dbContextNew = new object();
            var ScreenName = string.Empty;

            var dbAccessDAL1 = new DBAccessDAL();

            switch (KeyName)
            {
                case "ScreenName":
            


                    using (var con = new SqlConnection(dbAccessDAL1.ConnectionString))
                    {

                        var cmd = new SqlCommand();
                        using (SqlDataAdapter da = new SqlDataAdapter())
                        {
                            using (DataTable dt = new DataTable())
                            {
                                var Conditionstr = "select ServiceKey from  MstService  where ServiceName =\'" + documentIdKeyFormat.ScreenName + "\'";
                                using (cmd = new SqlCommand(Conditionstr, con))
                                {

                                    da.SelectCommand = cmd;
                                    da.Fill(dt);

                                    var myEnumerable = dt.AsEnumerable();
                                    ScreenName =
                                        (from item in myEnumerable
                                         select new AsisDocumentNumber
                                         {
                                             ScreenName = item.Field<string>("ServiceKey")
                                         }).ToList().Select(x => x.ScreenName).SingleOrDefault();

                                }
                            }
                        }
                    }
                    result = ScreenName;
                    //result = ScreensShortName.GetScreenName(documentIdKeyFormat.ScreenName);
                    break;
                case "service":


               
                    using (var con = new SqlConnection(dbAccessDAL1.ConnectionString))
                    {

                        var cmd = new SqlCommand();
                        using (SqlDataAdapter da = new SqlDataAdapter())
                        {
                            using (DataTable dt = new DataTable())
                            {
                                var Conditionstr = "select ServiceKey from AsisServices where ServiceID =\"" + documentIdKeyFormat.service + "\"";
                                using (cmd = new SqlCommand(Conditionstr, con))
                                {

                                    da.SelectCommand = cmd;
                                    da.Fill(dt);

                                    var myEnumerable = dt.AsEnumerable();
                                    ScreenName =
                                        (from item in myEnumerable
                                         select new AsisDocumentNumber
                                         {
                                             ScreenName = item.Field<string>("ServiceKey")
                                         }).ToList().Select(x => x.ScreenName).SingleOrDefault();

                                }
                            }
                        }
                    }
                    //var ServiceName = (select ServiceName from AsisServices where ServiceID == documentIdKeyFormat.service ).SingleOrDefault();
                    result = ScreenName;
                    break;
                //case "VrcService":
                //    var CommonServiceName = (from Service in dbContextNew.AsisServices
                //                             where Service.ServiceID == documentIdKeyFormat.service
                //                             select Service.ServiceKey).SingleOrDefault();
                //    result = CommonServiceName.Length > 2 ? CommonServiceName.Substring(0, CommonServiceName.Length > 3 ? 4 : 3).ToUpper() : CommonServiceName.ToUpper();
                //    //  result = CommonServiceName.Substring(0, 3).ToUpper();
                //    break;
                //case "Commonservice":
                //    CommonServiceName = (from Service in dbContextNew.AsisServices
                //                         where Service.ServiceID == documentIdKeyFormat.service
                //                         select Service.ServiceKey).SingleOrDefault();
                //    result = CommonServiceName.Length > 2 ? CommonServiceName.Substring(0, 3).ToUpper() : CommonServiceName.ToUpper();
                //    break;
                //case "HospitalCode":
                //    var hospitalCode = (from Hospital in dbContextNew.GMHospitalMsts
                //                        where Hospital.HospitalId == documentIdKeyFormat.HospitalId
                //                        select Hospital.HospitalCode).SingleOrDefault();
                //    //result = hospitalCode.Substring(0, 3);
                //    result = hospitalCode;
                //    break;

                case "YearMonth":
                    result = documentIdKeyFormat.Year.ToString() + documentIdKeyFormat.Month.ToString().PadLeft(2, '0');
                    break;
                case "MonthYear":
                    result = documentIdKeyFormat.Month.ToString().PadLeft(2, '0') + DateTime.Now.Year.ToString().Substring(2, 2);
                    break;
                case "MonthYearFull":
                    result = documentIdKeyFormat.Month.ToString().PadLeft(2, '0') + DateTime.Now.Year.ToString();
                    break;
                case "MonthNameYear":
                    result = documentIdKeyFormat.MonthName.ToString() + DateTime.Now.Year.ToString().Substring(2, 2);
                    break;
                case "MonthNameYearFull":
                    result = documentIdKeyFormat.MonthName.ToUpper().ToString() + DateTime.Now.Year.ToString();
                    break;
                case "YearMonthDate":
                    result = documentIdKeyFormat.Year.ToString() + documentIdKeyFormat.Month.ToString().PadLeft(2, '0') + documentIdKeyFormat.Date.ToString().PadLeft(2, '0');

                    break;

                case "Year":
                    result = documentIdKeyFormat.Year.ToString();
                    break;

                case "Month":
                    result = documentIdKeyFormat.Month.ToString().PadLeft(2, '0');
                    break;

                case "Date":
                    result = documentIdKeyFormat.Date.ToString().PadLeft(2, '0');
                    break;

                case "Week":
                    result = documentIdKeyFormat.Week.ToString().PadLeft(2, '0');
                    break;

                case "MonthWeek":
                    result = documentIdKeyFormat.MonthWeek;
                    break;

                case "ModuleName":
                    result = documentIdKeyFormat.ModuleName;
                    break;

                //case "CompanyCode":
                //    var companyCode = (from Company in dbContextNew.GmCompanyMsts
                //                       where Company.CompanyId == documentIdKeyFormat.CompanyId
                //                       select Company.CompanyCode).SingleOrDefault();
                //    //result = companyCode.Substring(0, 3); ;
                //    result = companyCode;
                //    break;

                case "StateCode":
                    result = documentIdKeyFormat.StateCode;
                    break;
                case "DocumentCategory":

                    if (documentIdKeyFormat.DocumentCategory != null)
                    {
                        if (documentIdKeyFormat.DocumentCategory.Length == 2)
                        {
                            result = documentIdKeyFormat.DocumentCategory.Substring(0, 2).ToUpper();
                        }
                        else
                        {
                            result = documentIdKeyFormat.DocumentCategory.Substring(0, 3).ToUpper();
                        }
                    }

                    break;
                case "Company":
                    result = documentIdKeyFormat.Company;
                    break;
                case "Service":
                    result = documentIdKeyFormat.Service;
                    break;
                case "DefaultName":
                    result = documentIdKeyFormat.Defaultkey;
                    break;
                case "AssetPraNoCode":
                    result = documentIdKeyFormat.AssetPraNoCode;
                    break;
                case "PrefixPraNo":
                    result = documentIdKeyFormat.PrefixPraNo;
                    break;
                case "MonthName":
                    result = documentIdKeyFormat.MonthName;
                    break;
                case "SRServiceAutoNoVal":
                    result = documentIdKeyFormat.SRServiceAutoNoVal;
                    break;
            }
            return result;
        }

        //public static DataSet GetDataSet(string spName, Dictionary<string, string> parameters)
        //{
        //    // creates resulting dataset
        //    var result = new DataSet();

        //    // creates a data access context (DbContext descendant)
        //    using (var context = new ASISWebDatabaseEntities())
        //    {
        //        // creates a Command 
        //        var cmd = context.Database.Connection.CreateCommand();
        //        cmd.CommandTimeout = 600;
        //        var cmdType = CommandType.StoredProcedure;
        //        cmd.CommandType = cmdType;
        //        cmd.CommandText = spName;

        //        // adds all parameters
        //        foreach (var pr in parameters)
        //        {
        //            var p = cmd.CreateParameter();
        //            p.ParameterName = pr.Key;
        //            p.Value = pr.Value;
        //            cmd.Parameters.Add(p);
        //        }
        //        try
        //        {
        //            // executes
        //            context.Database.Connection.Open();
        //            var reader = cmd.ExecuteReader();

        //            // loop through all resultsets (considering that it's possible to have more than one)
        //            do
        //            {
        //                // loads the DataTable (schema will be fetch automatically)
        //                var tb = new DataTable();
        //                tb.Load(reader);
        //                result.Tables.Add(tb);
        //            } while (!reader.IsClosed);
        //        }
        //        catch (Exception ex)
        //        {
        //            throw new DALException(ex);
        //        }
        //        finally
        //        {
        //            // closes the connection
        //            context.Database.Connection.Close();
        //        }
        //    }
        //    // returns the DataSet
        //    return result;
        //}
    }






    public class DocumentIdKeyFormat
    {
        public int CompanyId { get; set; }

        public string AssetPraNoCode { get; set; }
        public int HospitalId { get; set; }
        public string ModuleName { get; set; }
        public int Month { get; set; }
        public string ScreenName { get; set; }
        public int Year { get; set; }
        public int Date { get; set; }
        public int Week { get; set; }
        public string AutoGenarateProp { get; set; }
        public string Formatkey { get; set; }
        public string CompanyName { get; set; }
        public string Defaultkey { get; set; }
        public int service { get; internal set; }
        public int DocumentCategoryId { get; set; }
        public string DocumentCategory { get; set; }
        public string StateCode { get; set; }
        public string Company { get; set; }
        public string Service { get; set; }
        public string MonthName { get; set; }
        public string PrefixPraNo { get; set; }
        public string MonthWeek { get; set; }
        public string SRServiceAutoNoVal { get; set; }

        public string GeneratedDocNoFormat { get; set; }

    }
}
