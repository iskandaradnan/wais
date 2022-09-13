using CP.UETrack.Models;
using System.Collections.Generic;
using System.Data;

namespace CP.UETrack.DAL.DataAccess.Contracts.Common
{
    interface IDBAccessDAL
    {
        List<LovValue> GetLovRecords(DataTable table);
        //int NonquerySP(string SPName);
        //void InNVarchar(string id, object value);
        //void InVarchar(string id, object value);
        //void InBool(string id, object value);
        //void InSmall_Int(string id, object value);
        //void InBigInt(string id, object value);
        //void InInt(string id, object value);
        //void InTinyInt(string id, object value);
        //void OutVarchar(string id, short size);
        //void OutNVarchar(string id, short size);
        //void OutLong(string id);
        //void OutInt(string id);
        //void OutByte(string id);
        //void OutReturn();
    }
    
}
