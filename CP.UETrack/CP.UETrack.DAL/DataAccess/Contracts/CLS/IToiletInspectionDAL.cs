﻿using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface IToiletInspectionDAL
    {
        ToiletInspectionDropDown Load();
        ToiletInspection AutoGeneratedCode();
        ToiletInspection ToiletFetch(ToiletInspection toiletInspection);
        ToiletInspection Save(ToiletInspection toiletInspection, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ToiletInspection Get(int Id);
    }
}