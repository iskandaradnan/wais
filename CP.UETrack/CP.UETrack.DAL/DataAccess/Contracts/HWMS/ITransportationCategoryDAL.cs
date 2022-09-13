using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface ITransportationCategoryDAL
   {
        TransportationCategoryDropDown Load();
        TransportationCategory Save(TransportationCategory block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TransportationCategory Get(int Id);
        List<TransportationCategoryTable> HospitalCodeFetch(TransportationCategoryTable SearchObject);
        TransportationCategory HospitalNameData(string HospitalCode);        
   }
}
