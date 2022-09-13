using System.Configuration;

namespace CP.Framework.Common.Audit
{
    public static class AuditFactory
    {
        public static  IAudit GetAudit()
        {

            var configValue = ConfigurationManager.AppSettings["AuditStore"].ToString();

            switch (configValue)
            {
                case "DB":
                    return new Audit();
                default:
                    return new Audit();
            }
        }
    }
}
