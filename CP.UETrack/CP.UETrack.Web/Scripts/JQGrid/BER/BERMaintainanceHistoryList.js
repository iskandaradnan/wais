
$("#aMaintenanceHistab").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0) {
        bootbox.alert(Messages.SAVE_FIRST_TABALERT);
        return false;
    }
    else {
        $("div.errormsgcenter1").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        var ApplicationId = $('#primaryID').val();
        $('#HistoryBerNo').val($('#berNo').val());
        $('#HistoryApplicationDate').val($('#ApplicationDate').val());
        genarateGridMaintanence(primaryId);
    }
});

function genarateGridMaintanence(primaryId) {
    var gridM = $("#gridMH"),
    prmSearch = { multipleSearch: true, overlay: false };
    gridM.jqGrid({
        url: "/api/BerOne/getMaintainanceHistory",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Maintenance Work No.', 'Work Order Date', 'Work Category', 'Type', 'Total Down Time', 'Total Cost (RM)'],
        colModel: [
            { key: true, hidden: true, name: 'ApplicationId', width: '0%' },
            { key: false, search: true, name: 'MaintenanceWorkNo', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'MaintenanceWorkDateTime', width: '15%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'MaintenanceWorkCategory', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'MaintenanceWorkType', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'DowntimeHoursMin', width: '25%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'TotalCost', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },

        ],
        pager: jQuery('#pagerMH'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
       // caption: 'BER1 Application',
        sortname: 'ModifiedDateUTC',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        postData: {
            defaultFilters: JSON.stringify({
                groupop: "and",
                rules: [
                    { field: "ApplicationId", op: "eq", data: primaryId },
                ]
            })
        },
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
        },
        onPaging: function (pgButton) {
            curPage = $(".ui-pg-input").val();// current page
            if (pgButton == "user") {
                if (parseInt(totalPage) < parseInt(curPage) || parseInt(curPage) == 0) {
                    bootbox.alert(Messages.PAGE_NUMBER_ALERT_MESSAGE);
                    return "stop";
                }
            }
        },
        loadComplete: function (data) {
            totalPage = $("#sp_1_pager").text();// total pages
            curPage = $(".ui-pg-input").val();// current page
            $("#ExporttoExcel").removeClass('ui-state-disabled');
            $("#ExporttoCSV").removeClass('ui-state-disabled');

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
            }
            $(".content").scrollTop(3000);
        },
        loadError: function (responce) {
            if (responce.status == 404) {
                $(this).clearGridData();
            }
            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');

                $("#ExporttoExcel").addClass('ui-state-disabled');
                $("#ExporttoCSV").addClass('ui-state-disabled');
            }
        },
        gridComplete: function () {
            var objRows = $("#gridMH tr");
            //var objHeader = $("#gridCV .jqgfirstrow td");
            var objHeader = $("#gbox_gridMH .ui-jqgrid-labels th");

            if (objRows.length > 1) {
                var objFirstRowColumns = $(objRows[1]).children("td");
                for (i = 0; i < objFirstRowColumns.length; i++) {
                    $(objFirstRowColumns[i]).css("width", $(objHeader[i]).css("width"));
                }
            }
        },
        emptyrecords: 'No records to display',
        jsonReader: {
            root: "rows",
            page: "page",
            total: "total",
            records: "records",
            repeatitems: false,
            Id: "0"
        },
        autowidth: true,
        multiselect: false,
       // toppager: true,
        toolbar: [true, "top"]
    })
        //.navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: true },
        //{
        //    multipleSearch: true,
        //    multipleGroup: true,
        //}
        //)


    $.jgrid.jqModal = $.jgrid.jqModal || {};
    $.extend(true, $.jgrid.jqModal, { toTop: true });

    // create the searching dialog
    //gridM.searchGrid(prmSearch);

    // find the div which contain the searching dialog
   // var searchDialog = $("#searchmodfbox_" + gridM[0].id);
    // make the searching dialog non-popup
   // searchDialog.css({ position: "relative", "z-index": "auto", float: "left" });

    //var gbox = $("#gbox_" + grid[0].id);
    //gbox.before(searchDialog);
    //gbox.css({ clear: "left" });
    var gbox = $("#gbox_" + gridM[0].id);
    //gbox.before(searchDialog);
    gbox.css({ width: "100%" });
    gbox.find('div,table').css({ width: "100%" });
    gbox.find('#pagerMH').css({ height: "auto" });
    $("#searchmodfbox_grid,#refresh_grid").hide();

}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');

    // grab all the filter ids and values and add to the post object
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });

    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: 1 }).trigger('reloadGrid');
}
