$(function () {
  //  var ServiceValues = "1:Active;0:Inactive;";
    var ServiceValues = "Active:Active;Inactive:Inactive;";
    var PartSourceValues = "Genuine (compatible):Genuine (compatible);OEM:OEM;";
    genarateGrid(ServiceValues, PartSourceValues);
});

function genarateGrid(serviceValues, PartSourceValues) {
    var isFromSave = false;
    var gridClicked = false;
    var ServiceValues = serviceValues.replace(/[,;]$/, '').toString();
    var PartSoruceVal = PartSourceValues.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/SpareParts/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Item Code', 'Item Description', 'Part No.', 'Part Description','Part Source', 'Asset Type Code', 'Asset Type Description', 'Model', 'Manufacturer', 'Status'],
        colModel: [

            
            { key: true, hidden: true, name: 'SparePartsId', width: '0%' },
            { key: false, search: true, name: 'ItemCode', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'ItemDescription', width: '14%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'PartNo', width: '8%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },

            { key: false, search: true, name: 'PartDescription', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'PartSource', width: '8%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: PartSoruceVal } },
            { key: false, search: true, name: 'AssetTypeCode', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AssetTypeDescription', width: '12%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
                        { key: false, search: true, name: 'ModelName', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'ManufacturerName', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
           
{ key: false, name: 'StatusValue', width: '8%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: ServiceValues, defaultValue: "Active" } },

        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        //caption: 'Spare Parts List',
        sortname: 'ModifiedDateUTC',
        sortorder: 'DESC',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
        },
        onCellSelect: function (rowId, iCol, content, event) {
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
            curPage = $(".ui-pg-input").val();// current page
            $("#ExporttoExcel").removeClass('ui-state-disabled');
            $("#ExporttoCSV").removeClass('ui-state-disabled');

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
            } $("tr.jqgrow:odd").css("background", "#F0F8FF");
            $('#refresh_grid_top').hide();
            $('.ui-icon-csv').prop('title', 'Export To CSV');
            $('.ui-icon-excel').prop('title', 'Export To Excel');
            $('.ui-icon-refresh1').prop('title', 'Reload Grid');
            if (!isFromSave) {
                $(".content").scrollTop(3000);
                isFromSave = true;
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
        //.navButtonAdd('#grid_toppager', {
        //    id: "Add",
        //    caption: "",
        //    buttonicon: "ui-icon-add",
        //    onClickButton: function () {
        //        window.location.href = "/BEMS/SparepartRegister/add";
        //    }
        //}
        //)

        .navButtonAdd('#pager_left', {
            id: "refresh_grid_top",
            caption: "",
            buttonicon: "ui-icon-refresh1",
            onClickButton: function () {
                //$("#grid").trigger('reloadGrid');
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

    var headercolumns = ['Facility', 'Facility Code', 'Address', 'Active From', 'Active To'];
    var columncolumns = ['Facility', 'FacilityCode', 'Address', 'ActiveFrom', 'ActiveTo'];
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
         .append($("<input name='screenName' type='text'>").val("Spare_Parts"))
        //.append($("<input name='screenName' type='text'>").val(screenTitle.split(" ").join('_')))
           .append($("<input name='headerColumnNames' type='text'>").val(headercolumns))
          .append($("<input name='spName' type='text'>").val("uspFM_EngSpareParts_Export"))
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
