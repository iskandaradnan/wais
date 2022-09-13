using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
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
    public class ConsignmentNoteCWCNBAL : IConsignmentNoteCWCNBAL
    {
        private string _FileName = nameof(BlockBAL);
        IConsignmentNoteCWCNDAL _consignmentNoteDAL;
        public ConsignmentNoteCWCNBAL(IConsignmentNoteCWCNDAL consignmentNoteDAL)
        {
            _consignmentNoteDAL = consignmentNoteDAL;
        }
        public ConsignmentCWCNDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _consignmentNoteDAL.Load();
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
        public List<ConsignmentNoteCWCN> AutoDisplaying()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
                var result = _consignmentNoteDAL.AutoDisplaying();
                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
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
        public ConsignmentNoteCWCN Save(ConsignmentNoteCWCN Plant, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ConsignmentNoteCWCN result = null;
                result = _consignmentNoteDAL.Save(Plant, out ErrorMessage);            
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
                var result = _consignmentNoteDAL.GetAll(pageFilter);
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
        public ConsignmentNoteCWCN Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _consignmentNoteDAL.Get(Id);
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

        public List<VehicleDetails> VehicleNoFetch(VehicleDetails SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(VehicleNoFetch), Level.Info.ToString());
                var result = _consignmentNoteDAL.VehicleNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(VehicleNoFetch), Level.Info.ToString());
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
        public List<DriverDetails> DriverCodeFetch(DriverDetails SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DriverCodeFetch), Level.Info.ToString());
                var result = _consignmentNoteDAL.DriverCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(DriverCodeFetch), Level.Info.ToString());
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
        public List<DailyWeighingRecord> AutoDisplayDWRSNO()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
                var result = _consignmentNoteDAL.AutoDisplayDWRSNO();
                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
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
        public ConsignmentNoteCWCN_BinDetails DWRSNOData(int DWRId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DWRSNOData), Level.Info.ToString());
                var result = _consignmentNoteDAL.DWRSNOData(DWRId);
                Log4NetLogger.LogExit(_FileName, nameof(DWRSNOData), Level.Info.ToString());
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
        public ConsignmentNoteCWCN TreatmentPlantData(string TreatmentPlantName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
                var result = _consignmentNoteDAL.TreatmentPlantData(TreatmentPlantName);
                Log4NetLogger.LogExit(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
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
