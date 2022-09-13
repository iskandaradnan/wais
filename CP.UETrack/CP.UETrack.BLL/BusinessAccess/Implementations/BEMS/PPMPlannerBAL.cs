using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class PPMPlannerBAL: IPPMPlannerBAL
    {
        #region Ctor/init
        private readonly IPPMPlannerDAL _PPMPlannerDAL;
        private readonly static string fileName = nameof(PPMPlannerBAL);
        public PPMPlannerBAL(IPPMPlannerDAL dal)
        {
            _PPMPlannerDAL = dal;

        }
        #endregion
        //public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
        //        var result = _PPMRegisterDAL.GetAll(pageFilter);
        //        Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        public PPMPlannerLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _PPMPlannerDAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public EngPlannerTxn Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _PPMPlannerDAL.Get(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public EngPlannerTxn AssetFrequencyTaskCode(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _PPMPlannerDAL.AssetFrequencyTaskCode(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public EngPlannerTxn AssetTypeCodeFrequency(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _PPMPlannerDAL.AssetTypeCodeFrequency(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public EngPlannerTxn Popup(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _PPMPlannerDAL.Popup(Id,pagesize,pageindex);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public EngPlannerTxn Summary(int Service, int WorkGroup, int Year,int TOP, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _PPMPlannerDAL.Summary(Service, WorkGroup, Year, TOP, pagesize, pageindex);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }


        public EngPlannerTxn Save(EngPlannerTxn obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                EngPlannerTxn result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _PPMPlannerDAL.Save(obj, out ErrorMessage);
                }
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _PPMPlannerDAL.Delete(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        private static bool IsValid(EngPlannerTxn model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            var currentDate = DateTime.Now.Date;
            if (model.FirstDate != null && ((DateTime)model.FirstDate).Date < currentDate)
            {
                ErrorMessage = "First Date cannot be a past date.";
            }
            else if (!isValidDate(model))
            {
                ErrorMessage = "Cannot plan for past date.";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public static bool isValidDate(EngPlannerTxn model)
        {
            bool isValid = true;
            var schedule = model.Schedule;
            var year = model.Year;
            var currentDate = DateTime.Now.Date;
            if (model.TaskCodeType==365)
            {
                isValid = true;
            } else
            {
            
            if (schedule == 78)
            {
                var months = model.Month.Split(',');
                var dates = model.Date.Split(',');
                for (int i = 0; i < months.Length; i++)
                {
                    for (int j = 0; j < dates.Length; j++)
                    {
                        var selectedDate = new DateTime(year, Convert.ToInt32(months[i]), Convert.ToInt32(dates[j]));
                        if (selectedDate < currentDate)
                        {
                            isValid = false;
                        }
                    }
                }

            }
            else if (schedule == 79)
            {
                var days = model.Day.Split(',');
                var weeks = model.Week.Split(',');
                var months = model.Month.Split(',');

                if (year == DateTime.Now.Year)
                {
                    for (int k = 0; k < months.Length; k++)
                    {
                        var selectedMonth = Convert.ToInt32(months[k]);
                        var currentMonth = DateTime.Now.Month;
                        if (selectedMonth < currentMonth)
                        {
                            isValid = false;
                        }
                        else if (selectedMonth == currentMonth)
                        {

                            for (int i = 0; i < weeks.Length; i++)
                            {
                                var selectedWeek = Convert.ToInt32(weeks[i]);
                                var currentWeek = currentDate.GetWeekOfMonth();
                                if (selectedWeek < currentWeek)
                                {
                                    isValid = false;
                                }
                                else if (selectedWeek == currentWeek)
                                {
                                    for (int j = 0; j < days.Length; j++)
                                    {
                                        var currentDayOfWeek = (int)currentDate.DayOfWeek + 1;
                                        var selectedDayOfWeek = Convert.ToInt32(days[j]);
                                        if (selectedDayOfWeek < currentDayOfWeek)
                                        {
                                            isValid = false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            }
            return isValid;
        }

        public PlannerUpload Upload(ref PlannerUpload FileModel, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(fileName, nameof(Upload), Level.Info.ToString());
                var filePath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "App_Data\\Temp\\FileUploads");
                var fullFilePath = System.IO.Path.Combine(filePath, FileModel.fileResponseName);
                if (File.Exists(fullFilePath))
                {
                    File.Delete(fullFilePath);
                }
                var bytes = Convert.FromBase64String(FileModel.contentAsBase64String);
                using (FileStream file = File.Create(fullFilePath))
                {
                    file.Write(bytes, 0, bytes.Length);
                    file.Close();
                }
                var FileData = ConvertCSVtoDataTable(fullFilePath);
                var pPMStockUpdateResultModel = new PlannerUpload();
                foreach (DataRow row in FileData.Rows)
                {
                    var PPM = new EngPlannerTxn
                    {
                        WorkOrderTypeName = row["Work Order Type"] == DBNull.Value ? null : Convert.ToString(row["Work Order Type"].ToString()),
                        YearName = row["Year"] == DBNull.Value ? 0 : Convert.ToInt32(row["Year"].ToString()),
                        Assignee = row["Assignee"] == DBNull.Value ? null : Convert.ToString(row["Assignee"].ToString()),
                        AssetClarificationName = row["Asset Classification"] == DBNull.Value ? null : Convert.ToString(row["Asset Classification"].ToString()),
                        TypeOfPlannerName = row["PPM Type"] == DBNull.Value ? null : Convert.ToString(row["PPM Type"].ToString()),
                        AssetTypeCode = row["Type Code"] == DBNull.Value ? null : Convert.ToString(row["Type Code"].ToString()),
                        AssetNo = row["Asset No."] == DBNull.Value ? null : Convert.ToString(row["Asset No."].ToString()),
                        PPMTaskCode = row["PPM Task Code"] == DBNull.Value ? null : Convert.ToString(row["PPM Task Code"].ToString()),
                        ScheduleType = row["Schedule"] == DBNull.Value ? null : Convert.ToString(row["Schedule"].ToString()),
                        StatusType = row["Status"] == DBNull.Value ? null : Convert.ToString(row["Status"].ToString()),
                        Month = row["Month"] == DBNull.Value ? null : Convert.ToString(row["Month"].ToString()),
                        Date = row["Date"] == DBNull.Value ? null : Convert.ToString(row["Date"].ToString()),
                        Week = row["Week"] == DBNull.Value ? null : Convert.ToString(row["Week"].ToString()),
                        Day = row["Day"] == DBNull.Value ? null : Convert.ToString(row["Day"].ToString())
                    };
                    if (PPM.Month != null)
                    {
                        PPM.Month = PPM.Month.Replace("|", ",").Replace("Jan","1").Replace("Feb", "2").Replace("Mar", "3").Replace("Apr", "4")
                        .Replace("May", "5").Replace("Jun", "6").Replace("Jul", "7").Replace("Aug", "8").Replace("Sep", "9").Replace("Oct", "10")
                        .Replace("Nov", "11").Replace("Dec", "12");
                    }
                    if (PPM.Date != null) { PPM.Date = PPM.Date.Replace("|", ","); }
                    if (PPM.Week != null) { PPM.Week = PPM.Week.Replace("|", ","); }
                    if (PPM.Day != null) { PPM.Day = PPM.Day.Replace("|", ","); }
                    pPMStockUpdateResultModel.PlannerId = PPM.PlannerId;

                    if (IsUploadValid(PPM, out ErrorMessage))
                    {
                        var importOut = _PPMPlannerDAL.ImportValidation(ref PPM);
                        if (importOut.ErrorMessage != null && importOut.ErrorMessage != "")
                        {
                            ErrorMessage = importOut.ErrorMessage.Split(',')[0];
                        }
                        else
                        {
                            PPM.TypeOfPlanner = 34;
                            PPM.AssigneeId = importOut.AssigneeId;
                            PPM.WorkOrderType = importOut.WorkOrderType;
                            PPM.AssetClarification = importOut.AssetClarification;
                            PPM.AssetRegisterId = importOut.AssetRegisterId;
                            PPM.StandardTaskDetId = importOut.StandardTaskDetId;
                            PPM.AssetTypeCodeId = importOut.AssetTypeCodeId;
                            PPM.WarrentyType = importOut.WarrentyType;
                            PPM.Schedule = importOut.Schedule;
                            PPM.Status = importOut.Status;
                            PPM.WorkGroup = 1;
                            PPM.ServiceId = 2;
                            PPM.Year = Convert.ToInt32(PPM.YearName);
                            Save(PPM,out ErrorMessage);
                        }
                    }
                }
                return pPMStockUpdateResultModel;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.Replace(".", "") + " or Invalid CSV File has been uploaded");
            }
        }

        private static bool IsUploadValid(EngPlannerTxn model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.WorkOrderTypeName == null)
            {
                ErrorMessage = "Work Order Type is required.";
            }
            else if (model.YearName == null || model.YearName == 0)
            {
                ErrorMessage = "Year is required.";
            }
            else if (model.Assignee == null)
            {
                ErrorMessage = "Assignee is required.";
            }
            else if (model.AssetClarificationName == null)
            {
                ErrorMessage = "Asset Clarification is required.";
            }
            else if (model.TypeOfPlannerName == null)
            {
                ErrorMessage = "PPM Type is required.";
            }
            else if (model.AssetNo == null)
            {
                ErrorMessage = "Asset No is required.";
            }
            else if (model.PPMTaskCode == null)
            {
                ErrorMessage = "PPM Task Code is required.";
            }
            else if (model.ScheduleType == null)
            {
                ErrorMessage = "Schedule is required.";
            }
            else if (model.Month == null)
            {
                ErrorMessage = "Month is required.";
            }
            else if (model.ScheduleType == "Monthly-Date")
            {
                if (model.Date == null)
                {
                    ErrorMessage = "Date is required.";
                }
                else
                {
                    isValid = true;
                }
            }
            else if (model.ScheduleType == "Monthly-Day")
            {
                if (model.Week == null)
                {
                    ErrorMessage = "Week is required.";
                }
                else if (model.Day == null)
                {
                    ErrorMessage = "Day is required.";
                }
                else
                {
                    isValid = true;
                }
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public static DataTable ConvertCSVtoDataTable(string strFilePath)
        {
            using (var sr = new StreamReader(strFilePath))
            {
                var t = "";
                var headers = sr.ReadLine().Split(',');
                var dt = new DataTable();
                foreach (string header in headers)
                {
                    if (header.Contains('"'))
                    {
                        t = header.Substring(1, header.Length - 2);
                    }
                    else
                    {
                        t = header;
                    }
                    dt.Columns.Add(t);
                }
                while (!sr.EndOfStream)
                {
                    var rows = sr.ReadLine().Split(',');
                    var dr = dt.NewRow();
                    try
                    {
                        for (int i = 0; i < headers.Length; i++)
                        {
                            if (rows[i].Contains('"'))
                            {
                                t = rows[i].Substring(1, rows[i].Length - 2);
                            }
                            else
                            {
                                t = rows[i];
                            }
                            if (t.ToString().Trim() != "")
                            {
                                dr[i] = t;
                            }
                        }
                    }
                    catch (IndexOutOfRangeException ex)
                    {
                        throw new BALException(ex);
                    }
                    dt.Rows.Add(dr);
                }
                return dt;
            }
        }
    }
    static class DateTimeExtensions
    {
        static GregorianCalendar _gc = new GregorianCalendar();
        public static int GetWeekOfMonth(this DateTime time)
        {
            var first = new DateTime(time.Year, time.Month, 1);
            return time.GetWeekOfYear() - first.GetWeekOfYear() + 1;
        }

        static int GetWeekOfYear(this DateTime time)
        {
            return _gc.GetWeekOfYear(time, CalendarWeekRule.FirstDay, DayOfWeek.Sunday);
        }
    }
}
