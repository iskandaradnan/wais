//-----------------------------------------------------------------------
// <copyright company="Microsoft Corporation">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace CP.Framework.ReportHelper
{
    /// <summary>
    /// Helper class for passing the toolbar state to the client side.
    /// </summary>
    public sealed class ToolBarState
    {
        public ToolBarState()
        {
            CurrentPageNumber = string.Empty;
            TotalPageNumber = string.Empty;
        }

        public bool IsbtnFirstPageEnabled
        {
            get;
            set;
        }

        public bool IsbtnPreviousPageEnabled
        {
            get;
            set;
        }

        public bool IstxtPageNumberEnabled
        {
            get;
            set;
        }

        public string CurrentPageNumber
        {
            get;
            set;
        }

        public string TotalPageNumber
        {
            get;
            set;
        }

        public bool IsbtnNextPageEnabled
        {
            get;
            set;
        }

        public bool IsbtnLastPageEnabled
        {
            get;
            set;
        }

        public bool IsbtnRefreshEnabled
        {
            get;
            set;
        }

        public bool IsbtnBackToParentEnabled
        {
            get;
            set;
        }

        public bool IsExportEnabled
        {
            get;
            set;
        }

    }
}