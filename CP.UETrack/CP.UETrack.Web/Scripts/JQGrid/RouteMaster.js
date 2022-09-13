/// <reference path="StudentList.js" />
$(function () {

    var grid = $("#grid"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/Api/personalDetails/getAllRecords",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'Name', 'Age', 'Username', 'EMail Id', 'Location', 'Edit', 'Delete'],
        colModel: [
            { key: true, hidden: true, name: 'ID', index: 'ID' },
            { key: false, name: 'NAME', index: 'NAME' },
            { key: false, name: 'AGE', index: 'AGE' },
            { key: false, name: 'USERNAME', index: 'USERNAME' },
            { key: false, name: 'MAILID', index: 'MAILID' },
            { key: false, name: 'LOCATION', index: 'LOCATION' },
              {
                  name: 'edit', search: false, index: 'Id', width: 30, sortable: false, formatter: editLink
              },
              { name: 'delete', search: false, index: 'Id', width: 30, sortable: false, formatter: deleteLink },
        ],

        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 30, 40],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        caption: 'Personal Details',
        loadonce: false,
        excel: true,
        subGrid: true, // set the subGrid property to true to show expand buttons for each row
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            // load the subgrid data only once // and the just show/hide
            "reloadOnExpand": false,
            // select the row when the expand column is clicked
            "selectOnExpand": true
        },
        subGridRowExpanded: showChildGrid, // javascript function that will take care of showing the child grid
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
        toolbar: [true, "top"] //THIS IS IMPORTANT!
        //    beforeRequest: function() {
        //    responsive_jqgrid($(".jqGrid"));
        //}
    }).navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: true },
        {
            // edit options
            zIndex: 100,
            url: '/servicerequest/Edit',
            closeOnEscape: true,
            closeAfterEdit: true,
            recreateForm: true,

            width: '100%',
            afterComplete: function (response) {
                if (response.responseText) {
                    alert(response.responseText);
                }
            }
        },
        {
            // add options
            zIndex: 100,
            url: "/student/Add",
            closeOnEscape: true,
            width: '100%',
            closeAfterAdd: true,
            afterComplete: function (response) {
                if (response.responseText) {
                    alert(response.responseText);
                }
            }
        },
        {
            // delete options
            zIndex: 100,
            url: "/Api/servicerequest/Delete",
            closeOnEscape: true,
            closeAfterDelete: true,
            recreateForm: true,
            msg: "Are you sure you want to delete this task?",
            afterComplete: function (response) {
                if (response.responseText) {
                    alert(response.responseText);
                }
            }
        }
        //, prmSearch
        ,
        {
            multipleSearch: true,
            multipleGroup: true,
        }
        ).navButtonAdd('#grid_toppager', {
            caption: "Add",
            buttonicon: "ui-icon-disk",
            onClickButton: function () {
                window.location.href = "/PersonalDetails/add/";
            }
        }
        )
        .navButtonAdd('#grid_toppager', {
            caption: "Export to Excel",
            buttonicon: "ui-icon-disk",
            onClickButton: function () {
                ExportToExcel();
            }
        })
    .navButtonAdd('#grid_toppager', {
        caption: "Export to Pdf",
        buttonicon: "ui-icon-disk",
        onClickButton: function () {
            ExportToPDF();
        }
    })
    .navButtonAdd('#grid_toppager', {
        caption: "Export to CSV",
        buttonicon: "ui-icon-disk",
        onClickButton: function () {
            ExportToCSV();
        }
    })
    ;
    //$('#filterButton').click(function (event) {
    //    event.preventDefault();
    //    filterGrid();
    //});

    //$('#TargetDate').datepicker({d[0]
    //    dateFormat: 'mm/dd/yy'
    //});
    //$("#t_grid").append("<input type='button' value='Click Me' style='height:12px;font-size:10px;float:right'/>");

    var topPagerDiv = $("#grid_toppager")[0];


    $("#grid_toppager_center", topPagerDiv).remove();
    $(".ui-paging-info", topPagerDiv).remove();
    $("#edit_grid_top", topPagerDiv).remove();
    $("#del_grid_top", topPagerDiv).remove();


    var bottomPagerDiv = $("div#pager")[0];
    $("#add_grid", bottomPagerDiv).remove();
    $("#edit_grid", bottomPagerDiv).remove();
    $("#del_grid", bottomPagerDiv).remove();
    $("#search_grid", bottomPagerDiv).remove();
    $("#refresh_grid", bottomPagerDiv).remove();

    $.jgrid.jqModal = $.jgrid.jqModal || {};
    $.extend(true, $.jgrid.jqModal, { toTop: true });

    // create the searching dialog
    grid.searchGrid(prmSearch);

    // find the div which contain the searching dialog
    var searchDialog = $("#searchmodfbox_" + grid[0].id);
    //searchDialog.addClass("ui-jqgrid ui-widget ui-widget-content ui-corner-all");
    // make the searching dialog non-popup
    searchDialog.css({ position: "relative", "z-index": "auto", float: "left" });

    var gbox = $("#gbox_" + grid[0].id);
    gbox.before(searchDialog);
    gbox.css({ clear: "left" });


    //$('#searchmodfbox_grid').attr("style","width:958px;position:absolute;");
    $('#searchmodfbox_grid').css('width', '100%');
    $('#searchhdfbox_grid').css('display', 'none');

    $("#grid_toppager_center").hide();
    $("#grid_toppager_right").hide();
    $("#grid_toppager_left").attr("colspan", "3");
    $("#grid_toppager_left").css("float", "right");
    //$('#searchmodfbox_grid').css('position', 'absolute');
});

function editLink(cellValue, options, rowObject, action) {
    return "<a href='/personalDetails/Edit/" + rowObject.ID + "' class='ui-icon ui-icon-pencil' ></a>";
}
function deleteLink(cellValue, options, rowdata, action) {
    return "<a href='javascript:deleteRecord(" + rowdata.ID + ")' class='ui-icon ui-icon-closethick'></a>";
}
function deleteRecord(id) {


    var result = confirm("Are you sure you Want to delete?");
    if (result == true) {

        angular.element(document.getElementById('gridTable')).scope().Delete(id)
    }
}

function ExportToExcel() {

    var grid = $('#grid');
    var filter = grid.getGridParam('postData').filters;

    $.ajax({
        type: 'POST',
        url: '/Api/personalDetails/ExcelPost/',
        data: {
            '': filter
        },
        error: function (err) {
            alert('Saved');
            //alert("AJAX error in request: " + JSON.stringify(err, null, 2));
        },
        success: function (msg) {
            alert('Saved');

        }
    });
}

function ExportToCSV() {

    var grid = $('#grid');
    var filter = grid.getGridParam('postData').filters;

   var screenTitle = $("#menu").find("li.active:last").text(); var $downloadForm = $("<form method='POST'>")
		.attr("action", "/Api/personalDetails/CSVPost/")
	    .append($("<input name='filters' type='text'>").val(filter));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

function ExportToPDF() {
    var grid = $('#grid');
    var filter = grid.getGridParam('postData').filters;

   var screenTitle = $("#menu").find("li.active:last").text(); var $downloadForm = $("<form method='POST'>")
		.attr("action", "/Api/personalDetails/PDFPost/")
	    .append($("<input name='filters' type='text'>").val(filter));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');

    // grab all the filter ids and values and add to the post object
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });

    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: 1 }).trigger('reloadGrid');
}

// the event handler on expanding parent row receives two parameters
// the ID of the grid tow  and the primary key of the row
//

function showChildGrid(parentRowID, parentRowKey) {
    //alert('a');
    var childGridID = parentRowID + "_table";
    var childGridPagerID = parentRowID + "_pager";

    // send the parent row primary key to the server so that we know which grid to show
    var childGridURL = "/api/personalDetails/get/" + parentRowKey;

    // add a table and pager HTML elements to the parent grid row - we will render the child grid here
    $('#' + parentRowID).append('<table id=' + childGridID + '></table><div id=' + childGridPagerID + ' class=scroll></div>');


    $.ajax({
        url: childGridURL,
        type: "GET",
        success: function (html) {
            var result = $.parseJSON(JSON.stringify(html));

            var htmlFormat = '<span><b>City : </b></span><span>' + result.USERNAME + '</span><br/>';
            htmlFormat = htmlFormat + '<span><b>Country : </b></span><span>' + result.PASSWORD + '</span><br/>';

            $("#" + childGridID).append(htmlFormat);
        }
    });



}


//$(window).on("resize", function () {
//    var $grid = $("#grid"),
//        newWidth = $grid.closest(".ui-jqgrid").parent().width();
//    $grid.jqGrid("setGridWidth", newWidth, true);
//});

