using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.BER;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class ArpBAL : IARPApplicationBAL
    {
        #region Ctor/init
        private readonly IARPApplicationDAL _dal;
        private readonly static string fileName = nameof(ArpBAL);
        public ArpBAL(IARPApplicationDAL dal)
        {
            _dal = dal;

        }
        #endregion
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
                _dal.Delete(Id, out ErrorMessage);
                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());

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

        public Arp Get(int Id)
        {
            try
            {
                //ErrorMessage = string.Empty;
                //Arp result = null;
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                //if (IsValid(model, out ErrorMessage))
                //{
                //    result = _dal.ArpGet(model, out ErrorMessage);
                //}
                var result = _dal.Get(Id);
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

        public Arp ArpGet(int Id)
        {
            try
            {
                //ErrorMessage = string.Empty;
                //Arp result = null;
                Log4NetLogger.LogEntry(fileName, nameof(ArpGet), Level.Info.ToString());
                //if (IsValid(model, out ErrorMessage))
                //{
                //    result = _dal.ArpGet(model, out ErrorMessage);
                //}
                var result = _dal.ArpGet(Id);
                Log4NetLogger.LogExit(fileName, nameof(ArpGet), Level.Info.ToString());
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

        public ARPApplicationTxnLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.Load();
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

        public Arp Save(Arp model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                Arp result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _dal.Save(model, out ErrorMessage);
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

        public Arp ProposalSave(Arp model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ProposalSave), Level.Info.ToString());
                ErrorMessage = string.Empty;
                Arp result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _dal.ProposalSave(model, out ErrorMessage);
                }
                Log4NetLogger.LogExit(fileName, nameof(ProposalSave), Level.Info.ToString());
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
        public Arp Submit(Arp model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Submit), Level.Info.ToString());
                ErrorMessage = string.Empty;
                Arp result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _dal.Submit(model, out ErrorMessage);
                }
                Log4NetLogger.LogExit(fileName, nameof(Submit), Level.Info.ToString());
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


        private static bool IsValidAttachments(Arp model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.BERno =="")
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        private static bool IsValid(Arp model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            var currentDate = DateTime.Now.Date;

            //if (string.IsNullOrEmpty(model.AssetNo) || model.AssetId == 0)
            //{
            //    ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            //}
            ////else if (model.BERApplicationDate.Date > currentDate)
            ////{
            ////    ErrorMessage = "Application Date cannot be Future Date";
            ////}
            //else
            //{
            //    isValid = true;
            //}
            isValid = true;
            return isValid;
        }

        private static bool ValidateApplicationDate(Arp model)
        {
            var IsValid = true;
            var date = DateTime.Now;
            var currentDate = date.Date;

            if (model.BERApplicationId == 0)
            {
                if (model.BERApplicationDate > currentDate)
                {
                    IsValid = false;
                }
                else
                {
                    IsValid = true;
                }
            }

            return IsValid;

        }

        public Arp GetAttachmentDetails(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAttachmentDetails), Level.Info.ToString());
                var result = _dal.GetAttachmentDetails(id);
                Log4NetLogger.LogExit(fileName, nameof(GetAttachmentDetails), Level.Info.ToString());
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

        //public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
        //        var result = _dal.GetAll(pageFilter);
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

        public AssetRegisterModel GetBERNoDetails(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetBERNoDetails), Level.Info.ToString());
                var result = _dal.GetBERNoDetails(Id);
                Log4NetLogger.LogExit(fileName, nameof(GetBERNoDetails), Level.Info.ToString());
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _dal.GetAll(pageFilter);
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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
