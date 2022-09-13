using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class ScheduledWorkOrderBAL : IScheduledWorkOrderBAL
    {
        #region Ctor/init
        private readonly IScheduledWorkOrderDAL _ScheduledWorkOrderDAL;
        private readonly static string fileName = nameof(ScheduledWorkOrderBAL);
        public ScheduledWorkOrderBAL(IScheduledWorkOrderDAL dal)
        {
            _ScheduledWorkOrderDAL = dal;

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
        public ScheduledWorkOrderLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.Load();
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

        public ScheduledWorkOrderModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.Get(Id);
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

        public ScheduledWorkOrderModel GetQC(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetQC(Id);
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

        public ScheduledWorkOrderModel GetCC(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetCC(Id);
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

        public ScheduledWorkOrderLovs GetCheckListDD(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetCheckListDD(Id);
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

        public ScheduledWorkOrderModel GetAssessment(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetAssessment(Id);
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

        public ScheduledWorkOrderModel GetCompletionInfo(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetCompletionInfo(Id,pagesize,pageindex);
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

        public ScheduledWorkOrderModel GetPartReplacement(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetPartReplacement(Id, pagesize, pageindex);
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

        public ScheduledWorkOrderModel GetPurchaseRequest(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetPurchaseRequest(Id);
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

        public ScheduledWorkOrderModel GetPPMCheckList(int Id , int CheckListId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetPPMCheckList(Id, CheckListId);
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
        public ScheduledWorkOrderModel GetTransfer(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetTransfer(Id, pagesize, pageindex);
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


        public ScheduledWorkOrderModel CalculateResponse(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.CalculateResponse(obj);
                //}
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

        public ScheduledWorkOrderModel GetReschedule(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetReschedule(Id, pagesize, pageindex);
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

        public ScheduledWorkOrderModel GetHistory(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.GetHistory(Id, pagesize, pageindex);
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

        public ScheduledWorkOrderModel FeedbackPopUp(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.FeedbackPopUp(Id);
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


        public ScheduledWorkOrderModel PartReplacementPopUp(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.PartReplacementPopUp(Id);
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

        public ScheduledWorkOrderModel Popup(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.Popup(Id,pagesize,pageindex);
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

        public ScheduledWorkOrderModel Summary(int Service, int WorkGroup, int Year,int TOP, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.Summary(Service, WorkGroup, Year, TOP, pagesize, pageindex);
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


        public ScheduledWorkOrderModel Save(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                    result = _ScheduledWorkOrderDAL.Save(obj);
                //}
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

        public ScheduledWorkOrderModel SaveReschedule(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SaveReschedule(obj);
                //}
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

        public ScheduledWorkOrderModel SaveAssessment(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SaveAssessment(obj);
                //}
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
        public ScheduledWorkOrderModel SaveTransfer(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SaveTransfer(obj);
                //}
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

        public ScheduledWorkOrderModel SaveCompletionInfo(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SaveCompletionInfo(obj);
                //}
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

        public ScheduledWorkOrderModel SavePartReplacement(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SavePartReplacement(obj);
                //}
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

        public ScheduledWorkOrderModel SavePurchaseRequest(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SavePurchaseRequest(obj);
                //}
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

        public ScheduledWorkOrderModel SavePPMCheckList(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.SavePPMCheckList(obj);
                //}
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
                var result = _ScheduledWorkOrderDAL.Delete(Id);
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

        public bool ApproveReject(int Id, string Remarks, string Type)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduledWorkOrderDAL.ApproveReject(Id, Remarks, Type);
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
        private static bool IsValid(ScheduledWorkOrderModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (/*string.IsNullOrEmpty(model.AssetTypeCode)*/ model.WorkOrderId == 0 || model.WorkOrderId == null)

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            //else if (_assetClassificationDAL.IsClassificationCodeDuplicate(model))
            //{
            //    ErrorMessage = "Asset Classication Code should be unique";
            //}
            //else if (_assetClassificationDAL.IsRecordModified(model))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public ScheduledWorkOrderModel VendorAssessProcess(ScheduledWorkOrderModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(VendorAssessProcess), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduledWorkOrderModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                result = _ScheduledWorkOrderDAL.VendorAssessProcess(obj);
                //}
                Log4NetLogger.LogExit(fileName, nameof(VendorAssessProcess), Level.Info.ToString());
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
    }
}
