using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts;
using CP.UETrack.DAL.DataAccess;
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
   public class AssertregisterVariationDetailsTabBAL : IAssertregisterVariationDetailsTabBAL
    {
        private readonly IAssertregisterVariationDetailsTabDAL __VariationDetailsTabDALDAL;
        private readonly static string fileName = nameof(AssetClassificationBAL);
        public AssertregisterVariationDetailsTabBAL(IAssertregisterVariationDetailsTabDAL _VariationDetailsTabDALDAL)
        {
            __VariationDetailsTabDALDAL = _VariationDetailsTabDALDAL;

        }
        public List<Varabledetails> FetchSNFRef(Varabledetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(FetchSNFRef), Level.Info.ToString());
                var result = __VariationDetailsTabDALDAL.FetchSNFRef(entity);
                Log4NetLogger.LogExit(fileName, nameof(FetchSNFRef), Level.Info.ToString());
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
        public VaritableDetailsList FetchSNFRef1(Varabledetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(FetchSNFRef1), Level.Info.ToString());
                var result = __VariationDetailsTabDALDAL.FetchSNFRef1(entity);
                Log4NetLogger.LogExit(fileName, nameof(FetchSNFRef1), Level.Info.ToString());
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
        public VariationSaveEntity Save(VariationSaveEntity VariationSaveEntitymodel/*, out string ErrorMessage*/)

        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                var result = __VariationDetailsTabDALDAL.Save(VariationSaveEntitymodel);
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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
