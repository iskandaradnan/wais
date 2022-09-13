using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class AssetQRCodePrintModel
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public string GroupOp { get; set; }
        public string QueryWhereCondition { get; set; }
        public string strOrderBy { get; set; }
        public List<ItemAssetQRCodeList> AssetQRCodeListData { get; set; }
        public List<sqlQueryExpressionList> sqlQueryExpressionListData { get; set; }        

    }

    public class sqlQueryExpressionList
    {
        public string ModelName { get; set; }
        public string ConditionName { get; set; }
        public string TextName { get; set; }
        public string GroupOp { get; set; }
    }

    public class ItemAssetQRCodeList
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationName { get; set; }
        public int AssetTypeCodeId { get; set; }
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string AssetTypeCode { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string ContractType { get; set; }
        public int QRCodeAssetId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }                
        public string AssetQRCode { get; set; }
        public string QRCodeSize2 { get; set; }
        public string QRCodeSize3 { get; set; }
        public string QRCodeSize4 { get; set; }
        public string QRCodeSize5 { get; set; }
        public string GroupOp { get; set; }
        public string QueryWhereCondition { get; set; }
        public string strOrderBy { get; set; }
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

