using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model.LLS;
using CP.UETrack.DAL.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction;
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction;
using CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Transaction
{
    public class SoiledLinenCollectionBAL : ISoiledLinenCollectionBAL
    {
        private string _FileName = nameof(SoiledLinenCollectionBAL);
        ISoiledLinenCollectionDAL _SoiledLinenCollectionDAL;
        public SoiledLinenCollectionBAL(ISoiledLinenCollectionDAL SoiledLinenCollectionDAL)
        {
            _SoiledLinenCollectionDAL = SoiledLinenCollectionDAL;
        }
        public SoiledLinenCollectionModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _SoiledLinenCollectionDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public soildLinencollectionsModel Save(soildLinencollectionsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                soildLinencollectionsModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _SoiledLinenCollectionDAL.Save(model, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private bool IsValid(soildLinencollectionsModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.DocumentNo == " " || model.DocumentNo == null)
            {
                var guid = Guid.NewGuid().ToString();
                model.DocumentNo = guid;
            }
            if (string.IsNullOrEmpty(model.DocumentNo))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.SoiledLinenCollectionId == 0)
            {
                if (_SoiledLinenCollectionDAL.IsSoiledLinenCollectionCodeDuplicate(model))
                    ErrorMessage = "Driver Code should be unique";
                else
                    isValid = true;
            }
            //else if (_BlockDAL.IsRecordModified(block))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public soildLinencollectionsModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _SoiledLinenCollectionDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        //public soildLinencollectionsModel GetBy(soildLinencollectionsModel model)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetBy), Level.Info.ToString());
        //        var result = _SoiledLinenCollectionDAL.GetBy(model);
        //        Log4NetLogger.LogExit(_FileName, nameof(GetBy), Level.Info.ToString());
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
        //public soildLinencollectionsModel GetBySchedule(soildLinencollectionsModel model, out string ErrorMessage)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetBySchedule), Level.Info.ToString());

        //        ErrorMessage = string.Empty;
        //        soildLinencollectionsModel result = null;
        //        if (IsValid(model, out ErrorMessage))
        //        {
        //            result = _SoiledLinenCollectionDAL.GetBySchedule(model, out ErrorMessage);
        //        }

        //        Log4NetLogger.LogExit(_FileName, nameof(GetBySchedule), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}
        
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _SoiledLinenCollectionDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _SoiledLinenCollectionDAL.Delete(Id, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
