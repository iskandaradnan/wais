﻿using CP.UETrack.Model.CLS;
using System.Collections.Generic;


namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface ICorrectiveActionReportBAL
    {
        CorrectiveActionReportLovs Load();
        CorrectiveActionReport AutoGeneratedCode();
        List<CorrectiveActionReport> CARNoFetch(CorrectiveActionReport SearchObject);
        CorrectiveActionReport Save(CorrectiveActionReport userRole, out string ErrorMessage);
        CARHistoryDetails GetCARHistoryDetails(int Id);
        List<CARAttachment> AttachmentSave(CorrectiveActionReport userRole, out string ErrorMessage);
        CP.UETrack.Model.GridFilterResult GetAll(CP.UETrack.Model.SortPaginateFilter pageFilter);
        CorrectiveActionReport Get(int Id);


    }
}