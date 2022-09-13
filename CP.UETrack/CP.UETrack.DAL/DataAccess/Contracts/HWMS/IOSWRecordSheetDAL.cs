﻿using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IOSWRecordSheetDAL
    {
        OSWRecordSheetDropDown Load();
        OSWRecordSheet AutoGeneratedCode();
        OSWRecordSheet Save(OSWRecordSheet block, out string ErrorMessage);
        List<OSWRecordSheet> UserAreaCodeFetch(OSWRecordSheet SearchObject);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        OSWRecordSheet Get(int Id);
    }
}
