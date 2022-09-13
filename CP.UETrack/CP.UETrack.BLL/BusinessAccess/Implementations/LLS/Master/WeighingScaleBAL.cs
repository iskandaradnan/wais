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
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Master
{
  public  class WeighingScaleBAL:IWeighingScaleBAL
    {
        private string _FileName = nameof(WeighingScaleBAL);
        IWeighingScaleDAL _WeighingScaleDAL;
        public WeighingScaleBAL(IWeighingScaleDAL WeighingScaleDAL)
        {
            _WeighingScaleDAL = WeighingScaleDAL;
        }
        public WeighingScaleEquipmentModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _WeighingScaleDAL.Load();
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
        public WeighingScaleEquipmentModel Save(WeighingScaleEquipmentModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                WeighingScaleEquipmentModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _WeighingScaleDAL.Save(model, out ErrorMessage);
                }


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
        public WeighingScaleEquipmentModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _WeighingScaleDAL.Get(Id);
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _WeighingScaleDAL.GetAll(pageFilter);
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
                _WeighingScaleDAL.Delete(Id, out ErrorMessage);
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
        
        private bool IsValid(WeighingScaleEquipmentModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            // List<LweighingLinenItemList> LweighingLinenItemGridList = new List<LweighingLinenItemList>();
            //LweighingLinenItemGridList.AddRange(model.LweighingLinenItemGridList);
            //foreach (var jjj in LweighingLinenItemGridList)
            //{
                //foreach (var item in jjj.SerialNo)
                //{
                    if (string.IsNullOrEmpty(model.SerialNo))
                    {
                        ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
                    }
                else if (model.WeighingScaleId == 0)
                {
                    if (_WeighingScaleDAL.IsWeighingCodeDuplicate(model))
                        ErrorMessage = "Serial No should be unique";
                    else
                        isValid = true;
                }
                else
                {
                    isValid = true;
                }
               
                //}
            //}
            return isValid;

        }
    }
}
