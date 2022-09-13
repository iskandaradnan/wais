using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.UserTraining;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.MASTER
{
    public interface IUserTrainingDAL
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
