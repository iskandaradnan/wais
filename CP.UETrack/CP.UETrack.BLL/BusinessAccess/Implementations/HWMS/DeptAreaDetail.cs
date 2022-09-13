﻿using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Model.HWMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class DeptAreaDetailBAL : IDeptAreaDetail
    {
        private string _FileName = nameof(BlockBAL);
        IDeptAreaDetailDAL _deptAreaDetailDAL;
        public DeptAreaDetailBAL(IDeptAreaDetailDAL deptAreaDetail)
        {
            _deptAreaDetailDAL = deptAreaDetail;
        }
        public DeptAreaDetailsDropdownList Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _deptAreaDetailDAL.Load();
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

        public DeptAreaDetails Save(DeptAreaDetails block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                DeptAreaDetails result = null;
                result = _deptAreaDetailDAL.Save(block, out ErrorMessage);
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
                var result = _deptAreaDetailDAL.GetAll(pageFilter);
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
        public DeptAreaDetails Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _deptAreaDetailDAL.Get(Id);
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
        public List<ItemTable> ItemCodeFetch(ItemTable SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
                var result = _deptAreaDetailDAL.ItemCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
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
        public DeptAreaDetails UserAreaNameData(string UserAreaCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
                var result = _deptAreaDetailDAL.UserAreaNameData(UserAreaCode);
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
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
