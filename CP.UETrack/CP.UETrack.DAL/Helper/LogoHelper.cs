using CP.UETrack.DAL.Model;
using CP.UETrack.Models.Common;
using System.Linq;

namespace CP.UETrack.DAL.Helper
{
    public class LogoHelper
    {
        public static LogoModel GetLogo(int CompanyId)
        {
            var Logo = new LogoModel();
            //using (var context = new ASISWebDatabaseEntities())
            //{
            //    if (CompanyId != 0)
            //    {
            //        Logo = (from o in context.GmCompanyMsts.Where(x => !x.IsDeleted && x.CompanyId == CompanyId)
            //                select new LogoModel
            //                {
            //                    CompanyId = CompanyId,
            //                    CompanyLogo = o.CompanyLogo,
            //                    MohLogo = o.MohLogo
            //                }).FirstOrDefault();
            //    }
            //    else
            //    {
            //        Logo = (from o in context.GmCompanyMsts.Where(x => !x.IsDeleted && x.MohLogo != null)
            //                select new LogoModel
            //                {
            //                    MohLogo = o.MohLogo
            //                }).FirstOrDefault();
            //    }
            //}
            return Logo;
        }
        
    }
    
}
