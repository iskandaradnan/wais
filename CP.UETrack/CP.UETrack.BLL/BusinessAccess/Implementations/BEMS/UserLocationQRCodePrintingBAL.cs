using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class UserLocationQRCodePrintingBAL : IUserLocationQRCodePrintingBAL
    {
        private string _FileName = nameof(UserLocationQRCodePrintingBAL);
        IUserLocationQRCodePrintingDAL _UserLocationQRCodePrintingDAL;

        public UserLocationQRCodePrintingBAL(IUserLocationQRCodePrintingDAL UserLocationQRCodePrintingDAL)
        {
            _UserLocationQRCodePrintingDAL = UserLocationQRCodePrintingDAL;
        }

        public UserLocationQRCodePrintingModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserLocationQRCodePrintingDAL.Load();
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

        public UserLocationQRCodePrintingModel Get(UserLocationQRCodePrintingModel LocationQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _UserLocationQRCodePrintingDAL.Get(LocationQR);
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

        public UserLocationQRCodePrintingModel GetModal(UserLocationQRCodePrintingModel LocationQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
                var result = _UserLocationQRCodePrintingDAL.GetModal(LocationQR);
                Log4NetLogger.LogExit(_FileName, nameof(GetModal), Level.Info.ToString());
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

        public UserLocationQRCodePrintingModel Save(UserLocationQRCodePrintingModel LocationQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                UserLocationQRCodePrintingModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _UserLocationQRCodePrintingDAL.Save(LocationQR);
                //}

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _UserLocationQRCodePrintingDAL.GetAll(pageFilter);
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


    }
}
