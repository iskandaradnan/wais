using CP.UETrack.Model;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IAuditDAL
    {
        bool Save<T>(T viewModel);

        object GetChangedProperties<T>(T viewModel, string relatedTable1 = null) where T : class;
        object GetAddedProperties<T>(T viewModel, string relatedTable1 = null) where T : class;
        object GetDeletedProperties<T>(T viewModel, string relatedTable1 = null) where T : class;
    }
}


