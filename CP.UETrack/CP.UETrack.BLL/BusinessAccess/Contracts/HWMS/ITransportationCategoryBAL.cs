using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
   public interface ITransportationCategoryBAL
   {

        TransportationCategoryDropDown Load();
        TransportationCategory Save(TransportationCategory userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TransportationCategory Get(int Id);
        List<TransportationCategoryTable> HospitalCodeFetch(TransportationCategoryTable SearchObject);
        TransportationCategory HospitalNameData(string HospitalCode);
        
   }
}
