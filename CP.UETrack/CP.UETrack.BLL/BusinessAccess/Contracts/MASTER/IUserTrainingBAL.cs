using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.UserTraining;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IUserTrainingBAL
    {
        UserTrainingDropdown Load();
        UserTrainingCompletion Save(UserTrainingCompletion userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UserTrainingCompletion Get(int Id, int pagesize, int pageindex);
        void Delete(int Id);
        TrainingFeedback SaveFeedback(TrainingFeedback feedback, out string ErrorMessage);
        TrainingFeedback GetFeedback(int Id);
    }
}
