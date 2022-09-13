var GlobalController = null;
$(function () {
    var StatusValues = "Active:Active;Inactive:Inactive;";
    var controllerName = '';
    var qs = window.location.href;
    var len = [];
    len = qs.split("/");
    controllerName = len[len.length - 1];
    GlobalController = controllerName;
    genarateGrid(StatusValues, controllerName);
});

function genarateGrid(statusValues, controllerName) {
    var isFromSave = false;
    var gridClicked = false;
    var StatusValues = statusValues.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/assetRegister/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Loaner / Test Asset No.', 'Asset Type Code', 'Asset Type Description', 'Current Department Name', 'Current Location Name', 'Model', 'Manufacturer', 'Serial No.', 'Status'],
        colModel: [
            { key: true, hidden: true,  name: 'AssetId', width: '0%' },
            { key: false, search: true, name: 'AssetNo', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'AssetNoOld', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AssetTypeCode', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AssetTypeDescription', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'UserAreaName', width: '12%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'UserLocationName', width: '11%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'Model', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'Manufacturer', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ key: false, search: true, name: 'ContractType', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'SerialNumber', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'Active', width: '5%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: StatusValues, defaultValue: "Active" } },
            //{ key: false, search: true, name: 'Authorization', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
           // { key: false, search: true, name: 'VariationStatus', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            //{ name: 'edit', search: false, index: 'AssetId', width: '5%', sortable: false, formatter: editLink },
            //{ name: 'delete', search: false, index: 'AssetId', width: '5%', sortable: false, formatter: deleteLink },
            //{ name: 'view', search: false, index: 'AssetId', width: '5%', sortable: false, formatter: viewLink },

        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        postData: {
            defaultFilters: JSON.stringify({
                groupop: "and",
                rules: [
                    { field: "IsLoaner", op: "eq", data: "true" }//, { field: "AccessLevel", op: "eq", data: ScreenValue }
                ]
            })
        },
        //caption: 'Loaner / Test Equipment',
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
          //  var rowData = $(this).jqGrid("getRowData", rowId);          
            LinkClicked(rowId);
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
            $("tr.jqgrow:odd").css("background", "#F0F8FF");
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

            if (!isFromSave && !FromNotification) {
                $(".content").scrollTop(3000);
                isFromSave = true;
                FromNotification = false;
            }
            else {
                if ((!gridClicked) &&(!isFromSave)){
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
            $('#fbox_grid_search, #fbox_grid_reset').click(function () {
                isFromSave = false;
            });
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            //setGridPermission(data);
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
        }
        )
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
    if (GlobalController == "external_loanerequipment") {
        $('#Add').hide();
    }

}

function editLink(cellValue, options, rowObject, action) {

    return "<a href='/bems/" + GlobalController + "/edit/" + rowObject.AssetId + "' class='glyphicon glyphicon-edit' style='color:#477ca9;font-size: 13px;'></a>";
}
function escapeShowTitle(title) {

    if (title != null) {
        title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
        title = escape(title)
    }
    return title
}

function deleteLink(cellValue, options, rowdata, action) {
    var gridID = 'gridTable';
    var assetNo = escapeShowTitle(rowdata.AssetNo);
    var typeCode = escapeShowTitle(rowdata.AssetTypeCode);

    return "<a href='javascript:confirmDelete(" + rowdata.AssetId + ',' + '"' + assetNo + '"' + ',' + '"'
     + typeCode + '"' + ',' + '"' + gridID + '"'
     + ")' class='glyphicon glyphicon-remove' style='color:red;font-size: 13px;'></a>";
}
function viewLink(cellValue, options, rowObject, action) {
    return "<a href='/bems/" + GlobalController + "/view/" + rowObject.AssetId + "' class='glyphicon glyphicon-eye-open' style='color:#477ca9;font-size: 13px;'></a>";
}

function confirmDelete(id, code, description, gridId) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION + code + " - " + description + " ?";
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/assetRegister/Delete/" + id)
             .done(function (result) {
                 filterGrid();
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
             })
             .fail(function () {
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DF);
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

    var defaultFilters = '{ "groupOp": "AND", "rules": [{ "field": "IsLoaner", "op": "eq", "data": "true" }] }'

    var $downloadForm = $("<form method='POST'>")
         .attr("action", "/api/common/Export")
         .append($("<input name='filters' type='text'>").val(filters))
        .append($("<input name='defaultFilters' type='text'>").val(defaultFilters))
         .append($("<input name='sortOrder' type='text'>").val(sortOrder))
         .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
         .append($("<input name='screenName' type='text'>").val("Loaner_Test_Equipment"))
         .append($("<input name='spName' type='text'>").val("uspFM_EngAsset_Export"))
         .append($("<input name='exportType' type='text'>").val(exportType));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');

    var totalrecords = $("#grid").getGridParam("reccount");
    var Curentpage = $('#grid').getGridParam('page');
    // grab all the filter ids and values and add to the post object
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });
    if (totalrecords <= 1) {
        Curentpage = Curentpage - 1;
    }
    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: Curentpage }).trigger('reloadGrid');
}