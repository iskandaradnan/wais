﻿using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IPPMChecklistBAL
    {       
        PPMCheckListLovs Load();
        void Delete(int Id, out string ErrorMessage);
        PPMCheckListModel Get(int Id);
        PPMCheckListModel Save(PPMCheckListModel model, out string ErrorMessage);
        PPMCheckListModel GetHistory(int id);
        PPMCheckListModel GetPopupDetails(int primaryId, int version, int gridId);
        PPMCheckListModel SetDB(int Id);
        
    }
}
