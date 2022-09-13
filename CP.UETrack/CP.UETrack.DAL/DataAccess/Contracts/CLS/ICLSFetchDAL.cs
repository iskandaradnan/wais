using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface ICLSFetchDAL
    {
        List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject);
    }
}
