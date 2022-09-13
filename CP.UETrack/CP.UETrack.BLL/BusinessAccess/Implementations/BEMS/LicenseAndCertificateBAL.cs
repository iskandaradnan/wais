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
   public class LicenseAndCertificateBAL: ILicenseAndCertificateBAL
    {

        private readonly ILicenseAndCertificateDAL _ILicenseAndCertificateDAL;
        private readonly static string fileName = nameof(LicenseAndCertificateBAL);
        public LicenseAndCertificateBAL(ILicenseAndCertificateDAL ILicenseAndCertificateDAL)
        {
            _ILicenseAndCertificateDAL = ILicenseAndCertificateDAL;

        }

        public void save(ref LicenseAndCertificateEntity entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(save), Level.Info.ToString());
                _ILicenseAndCertificateDAL.save(ref entity);
                Log4NetLogger.LogExit(fileName, nameof(save), Level.Info.ToString());
                // return result;
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
        public void update(ref LicenseAndCertificateEntity entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(update), Level.Info.ToString());
                _ILicenseAndCertificateDAL.update(ref entity);
                Log4NetLogger.LogExit(fileName, nameof(update), Level.Info.ToString());
                // return result;
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
        public LicenseAndCertificateEntity Get(int id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return _ILicenseAndCertificateDAL.Get(id, pagesize, pageindex);
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
        public bool Delete(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());
                return _ILicenseAndCertificateDAL.Delete(id);
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
        public GridFilterResult Getall(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Getall), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Getall), Level.Info.ToString());
                return _ILicenseAndCertificateDAL.Getall(pageFilter);
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
        public LCDropdownentity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _ILicenseAndCertificateDAL.Load();
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
