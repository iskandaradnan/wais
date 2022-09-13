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
    public class DepartmentQRCodePrintingBAL : IDepartmentQRCodePrintingBAL
    {
        private string _FileName = nameof(DepartmentQRCodePrintingBAL);
        IDepartmentQRCodePrintingDAL _DepartmentQRCodePrintingDAL;

        public DepartmentQRCodePrintingBAL(IDepartmentQRCodePrintingDAL DepartmentQRCodePrintingDAL)
        {
            _DepartmentQRCodePrintingDAL = DepartmentQRCodePrintingDAL;
        }

        public DepartmentQRCodePrintingModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _DepartmentQRCodePrintingDAL.Load();
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

        public DepartmentQRCodePrintingModel Get(DepartmentQRCodePrintingModel DepartmentQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _DepartmentQRCodePrintingDAL.Get(DepartmentQR);
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

        public DepartmentQRCodePrintingModel GetModal(DepartmentQRCodePrintingModel DepartmentQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
                var result = _DepartmentQRCodePrintingDAL.GetModal(DepartmentQR);
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

        public DepartmentQRCodePrintingModel Save(DepartmentQRCodePrintingModel DepartmentQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                DepartmentQRCodePrintingModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _DepartmentQRCodePrintingDAL.Save(DepartmentQR);
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
                var result = _DepartmentQRCodePrintingDAL.GetAll(pageFilter);
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
