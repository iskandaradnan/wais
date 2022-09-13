$(function () {
    var ServiceValues = "Draft:Draft;Submitted:Submitted;Clarification Sought By HD:Clarification Sought By HD;Clarification Sought By Liaison Officer:Clarification Sought By Liaison Officer;Approved:Approved;Forwarded to Liaison Officer:Forwarded to Liaison Officer;Recommended:Recommended;Clarified By Applicant:Clarified By Applicant;Rejected:Rejected;";
    genarateGrid(ServiceValues);
});

function genarateGrid(serviceValues) {
    var isFromSave = false;
    var gridClicked = false;
    var ServiceValues = serviceValues.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
        prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/BerOne/GetAllBER2",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['ApplicationId', 'BERStatusId', 'BER No.', 'BER Date', 'Condition Appraisal Reference No', 'Asset No.','Asset Name', 'Area Name','Location Name'],
        colModel: [
            { key: true, hidden: true, name: 'ApplicationId', width: '0%' },
            { key: true, hidden: true, name: 'BERStatus', width: '0%' },
            //{ key: false, search: true, name: 'FacilityCode', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'BERno', width: '15%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'BERDate', width: '10%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, name: 'ConditionAppraisalReferenceNo', width: '25%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AssetNo', width: '14%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'AssetName', width: '13%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'AreaName', width: '13%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'UserLocationCode', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'LocationName', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'Applicant', width: '9%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'BERStatusValue', width: '7%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: ServiceValues, defaultValue: "Draft" } },
        ],
        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        sortname: 'ModifiedDateUTC',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
        },
        onCellSelect: function (rowId, iCol, content, event) {
            var rowData = $(this).jqGrid("getRowData", rowId);
            LinkClicked(rowId, rowData);
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
            $("tr.jqgrow:odd").css("background", "#F0F8FF");
            $('#refresh_grid_top').hide();
            $('.ui-icon-csv').prop('title', 'Export To CSV');
            $('.ui-icon-excel').prop('title', 'Export To Excel');
            $('.ui-icon-refresh1').prop('title', 'Reload Grid');
            if (!isFromSave) {
                $(".content").scrollTop(3000);
                isFromSave = true;
            }
            else {
                if ((!gridClicked) && (!isFromSave)) {
                    $(".content").scrollTop(0);
                } else {
                    gridClicked = false;
                }
            }
            $('#fbox_grid_search, #fbox_grid_reset,#first_pager,#prev_pager,#next_pager,#last_pager,#refresh_grid_top').click(function () {
                gridClicked = true;
            });
            $('.ui-pg-selbox').change(function () {
                gridClicked = true;
            });
        },
        loadError: function (responce) {
            if (responce.status == 404) {
                $(this).clearGridData();
            }
            // if (responce.status === 406) {
            //        window.location.href = "/home?r=mts";
            //    }
            //if (responce.status === 409) {
            //        window.location.href = "/account/Logout";
            //    }
            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');

                $("#ExporttoExcel").addClass('ui-state-disabled');
                $("#ExporttoCSV").addClass('ui-state-disabled');
            }
            $('#refresh_grid_top').hide();
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            // setGridPermission(responce);
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
        toppager: true,
        toolbar: [true, "top"]
    }).navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: true },
        {
            multipleSearch: true,
            multipleGroup: true,
        })

        .navButtonAdd('#pager_left', {
            id: "refresh_grid_top",
            caption: "",
            buttonicon: "ui-icon-refresh1",
            onClickButton: function () {
                $('#grid').jqGrid().setGridParam({ page: 1 }).trigger('reloadGrid');
            }
        })
        .navButtonAdd('#pager_left', {
            id: "ExporttoExcel",
            caption: "",
            buttonicon: "ui-icon-excel",
            onClickButton: function () {
                Export("Excel");
            }
        })

        .navButtonAdd('#pager_left', {
            id: "ExporttoCSV",
            caption: "",
            buttonicon: "ui-icon-csv",
            onClickButton: function () {
                Export("CSV");
            }
        });



    $.jgrid.jqModal = $.jgrid.jqModal || {};
    $.extend(true, $.jgrid.jqModal, { toTop: true });

    // create the searching dialog
    grid.searchGrid(prmSearch);

    // find the div which contain the searching dialog
    var searchDialog = $("#searchmodfbox_" + grid[0].id);
    // make the searching dialog non-popup
    searchDialog.css({ position: "relative", "z-index": "auto", float: "left" });

    var gbox = $("#gbox_" + grid[0].id);
    gbox.before(searchDialog);
    gbox.css({ clear: "left" });
    $("#searchmodfbox_grid,#refresh_grid").hide();

}


function verifyLink(cellValue, options, rowObject, action) {
    if (rowObject.BERStatus == 207) // forwarded to liason officer
        return "<a href='/BER/BER2Application/verify/" + rowObject.ApplicationId + "'  class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a  href='#' onclick='NotificationAlert()' class='glyphicon glyphicon-ban-circle'></a>";
}
function approveLink(cellValue, options, rowObject, action) {
    if (rowObject.BERStatus == 203 || rowObject.BERStatus == 208 || rowObject.BERStatus == 209) // submitted and recommeneded, clarified
        return "<a href='/BER/BER2Application/approve/" + rowObject.ApplicationId + "'  class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a  href='#' onclick='NotificationAlert()' class='glyphicon glyphicon-ban-circle'></a>";
}
function rejectLink(cellValue, options, rowObject, action) {
    if (rowObject.BERStatus == 203 || rowObject.BERStatus == 209 || rowObject.BERStatus == 208)
        return "<a href='/BER/BER2Application/reject/" + rowObject.ApplicationId + "'  class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
    else
        return "<a  href='#' onclick='NotificationAlert()' class='glyphicon glyphicon-ban-circle'></a>";
}
function NotificationAlert() {
    bootbox.alert("Record cannot be deleted/modified");
}
function confirmDelete(Id, code, description, gridId) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION + code + " - " + description + "?";
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/BerOne/Delete/" + Id)

                .done(function (result) {
                    filterGrid();
                    showMessage('BER2', CURD_MESSAGE_STATUS.DS);

                    $("#top-notifications").modal('show');
                    setTimeout(function () {
                        $("#top-notifications").modal('hide');
                    }, 5000);

                    $('#myPleaseWait').modal('hide');
                })
                .fail(function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {
                        errorMessage = response.responseJSON;
                        showMessage('BER2', CURD_MESSAGE_STATUS.RAU);
                    }
                    $('#myPleaseWait').modal('hide');
                });
        }
    });
}
function Export(exportType) {

    var grid = $('#grid');
    var filters = grid.getGridParam('postData').filters;
    var sortColumnName = $("#grid").jqGrid('getGridParam', 'sortname');
    var sortOrder = $("#grid").jqGrid('getGridParam', 'sortorder');
    var mymodel = $("#grid").getGridParam('colModel')

    // this get the colModel array
    // loop the array and get the hideen columns
    var columnNames = [];
    $.each(mymodel, function (i) {
        if (this.hidden != true) {
            columnNames.push(this.name);
        }
    });

    columnNames.pop();
    columnNames.pop();

    var headercolumns = ['Customer Name', 'Customer Code', 'Address', 'Active From', 'Active To'];
    var columncolumns = ['Customer Name', 'Customer Code', 'Address', 'Active From', 'Active To'];
    //if (filters != undefined && filters != "") {
    //    filters = filters.replace("StatusName", "Status");
    //}
    var screenTitle = $("#menu").find("li.active:last").text();
    var $downloadForm = $("<form method='POST'>")
        .attr("action", "/api/common/Export")
        .append($("<input name='filters' type='text'>").val(filters))
        .append($("<input name='columnNames' type='text'>").val(columncolumns))
        .append($("<input name='sortOrder' type='text'>").val(sortOrder))
        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
        .append($("<input name='screenName' type='text'>").val("BER_Application_(BER2)"))
        .append($("<input name='headerColumnNames' type='text'>").val(headercolumns))
        .append($("<input name='spName' type='text'>").val("uspFM_BERApplicationTxnBER2_Export"))
        .append($("<input name='exportType' type='text'>").val(exportType));
    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}


//function filterGrid() {
//    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');

//    // grab all the filter ids and values and add to the post object
//    $('.filterItem').each(function (index, item) {
//        postDataValues[$(item).attr('id')] = $(item).val();
//    });

//    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: 1 }).trigger('reloadGrid');
//}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');
    var totalrecords = $("#grid").getGridParam("reccount");
    var Curentpage = $('#grid').getGridParam('page');
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });
    if (totalrecords <= 1) {
        Curentpage = Curentpage - 1;
    }
    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: Curentpage }).trigger('reloadGrid');
}
