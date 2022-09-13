﻿using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.UM
{
    public interface ISmartAssignDAL
    {
        void RunSmartAssign();
        GridFilterResult SmartAssignGetAll(SortPaginateFilter pageFilter);
        GridFilterResult PorteringSmartAssignGetAll(SortPaginateFilter pageFilter);
        
    }
}
