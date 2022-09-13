using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class UserLocationQRCodePrintingModel
    {
        public int BlockId { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public string GroupOp { get; set; }
        public string QueryWhereCondition { get; set; }
        public string strOrderBy { get; set; }
        public List<ItemLocationQRCodeList> LocationQRCodeListData { get; set; }
        public List<sqlQueryExpressionList> sqlQueryExpressionListData { get; set; }       
       
    }

    public class ItemLocationQRCodeList
    {
        public int BlockId { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string GroupOp { get; set; }
        public string QueryWhereCondition { get; set; }
        public string strOrderBy { get; set; }
        public int QRCodeUserLocationId { get; set; }
        public string UserLocationQRCode { get; set; }
        public string QRCodeSize2 { get; set; }
        public string QRCodeSize3 { get; set; }
        public string QRCodeSize4 { get; set; }
        public string QRCodeSize5 { get; set; }
        public string BatchGenerated { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }        
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
}
