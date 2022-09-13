using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IStockUpdateRegisterBAL
    {
        void save(ref StockUpdateRegister entity);
        Dropdownentity Load();
        void update(ref StockUpdateRegister model);
        StockUpdateRegister Get(int id , int pagesize, int pageindex);
        GridFilterResult Getall(SortPaginateFilter pageFilter);
        StockUpdateRegister Upload(ref Upload entity, out string ErrorMessage);
        bool Delete(int id);

    }
}
