namespace UETrack.Application.Web.API.Models
{
    public class GridParamModel
    {
        public string sidx { get; set; }
        public string sord { get; set; }
        public int page { get; set; }
        public int rows { get; set; }
        public bool _search { get; set; }
        public string filters { get; set; }
    }
}
