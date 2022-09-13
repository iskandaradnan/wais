using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class DriverDetailsBAL : IDriverDetailsBAL
    {
        private string _FileName = nameof(BlockBAL);
        IDriverDetailsDAL _driverDetailsDAL;

        public DriverDetailsBAL(IDriverDetailsDAL driverDetailsDAL)
        {
            _driverDetailsDAL = driverDetailsDAL;
        }
        public DriverDetailsDropdownList Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _driverDetailsDAL.Load();
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

        public DriverDetails Save(DriverDetails model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DriverDetails result = null;


                result = _driverDetailsDAL.Save(model, out ErrorMessage);


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
                var result = _driverDetailsDAL.GetAll(pageFilter);
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


        public DriverDetails Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _driverDetailsDAL.Get(Id);
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
        
        public DriverDetails DescriptionData(string LicenseCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DescriptionData), Level.Info.ToString());
                var result = _driverDetailsDAL.DescriptionData(LicenseCode);
                Log4NetLogger.LogExit(_FileName, nameof(DescriptionData), Level.Info.ToString());
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
        public List<LicCodeDes> LicenseCodeFetch(LicCodeDes SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
                var result = _driverDetailsDAL.LicenseCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
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
