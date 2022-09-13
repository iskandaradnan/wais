using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.FEMS
{
   public interface IFemsStockUpdateRegisterDAL
    {
        void save(ref StockUpdateRegister entity);
        Dropdownentity Load();
        void update(ref StockUpdateRegister model);
        StockUpdateRegister Get(int id, int pagesize, int pageindex);
        GridFilterResult Getall(SortPaginateFilter pageFilter);
        bool Delete(int id);
        StockUpdateRegister ImportValidation(StockUpdateRegister model);
    }
}
