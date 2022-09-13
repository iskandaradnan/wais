using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.StateManagement;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class PPMChecklistBAL : IPPMChecklistBAL
    {
        #region Ctor/init
        private readonly IPPMChecklistDAL _pPMChecklistDAL;
        private readonly static string fileName = nameof(PPMChecklistBAL);
        public PPMChecklistBAL(IPPMChecklistDAL dal)
        {
            _pPMChecklistDAL = dal;

        }
        #endregion
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public PPMCheckListLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _pPMChecklistDAL.Load();
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

        public PPMCheckListModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _pPMChecklistDAL.Get(Id);
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
        public PPMCheckListModel GetHistory(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _pPMChecklistDAL.GetHistory(id);
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
        public PPMCheckListModel Save(PPMCheckListModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                PPMCheckListModel result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _pPMChecklistDAL.Save(obj, out ErrorMessage);
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
        public PPMCheckListModel GetPopupDetails(int primaryId, int version, int gridId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                var result = _pPMChecklistDAL.GetPopupDetails(primaryId, version, gridId);

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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _pPMChecklistDAL.Delete(Id, out ErrorMessage);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());

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
        private static bool IsValid(PPMCheckListModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (/*string.IsNullOrEmpty(model.AssetTypeCode)*/ model.AssetTypeCodeId == 0 || model.AssetTypeCodeId == null)

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public PPMCheckListModel SetDB(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SetDB), Level.Info.ToString());
                var result = _pPMChecklistDAL.SetDB(id);             
                Log4NetLogger.LogExit(fileName, nameof(SetDB), Level.Info.ToString());
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
    }
}
