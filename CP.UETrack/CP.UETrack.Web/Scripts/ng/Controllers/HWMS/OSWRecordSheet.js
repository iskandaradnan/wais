var WastetypeValues = "";
var MonthValues = "";
var YearValues = "";
var CollectionTypevalues = "";
var StatusValues = "";
var CollectionStatusvalues = "";
var QcValues = "";
var rowNum = 1;

var FileTypeValues = "";
var filePrefix = "OSWRS_";
var ScreenName = "OSWRecordSheet";
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/OSWRecordSheet/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            WastetypeValues = "<option value='' Selected>" + "Select" + "</option>";
            MonthValues = "<option value='' Selected>" + "Select" + "</option>";
            YearValues = "<option value='' Selected>" + "Select" + "</option>";
            CollectionTypevalues = "<option value='' Selected>" + "Select" + "</option>";
            CollectionStatusvalues = "<option value='' Selected>" + "Select" + "</option>";
            QcValues = "<option value='' Selected>" + "Select" + "</option>";


            for (var i = 0; i < loadResult.WasteTypeLovs.length; i++) {
                WastetypeValues += "<option value=" + loadResult.WasteTypeLovs[i].LovId + ">" + loadResult.WasteTypeLovs[i].FieldValue + "</option>"
            }
            $("#ddlWasteType").append(WastetypeValues)

            for (var i = 0; i < loadResult.OSWRMonthLovs.length; i++) {
                MonthValues += "<option value=" + loadResult.OSWRMonthLovs[i].LovId + ">" + loadResult.OSWRMonthLovs[i].FieldValue + "</option>"
            }
            $("#ddlMonth").append(MonthValues)

            for (var i = 0; i < loadResult.OSWRYearLovs.length; i++) {
                YearValues += "<option value=" + loadResult.OSWRYearLovs[i].LovId + ">" + loadResult.OSWRYearLovs[i].FieldValue + "</option>"
            }
            $("#ddlYear").append(YearValues)

            for (var i = 0; i < loadResult.OSWRCollectionTypeLovs.length; i++) {
                CollectionTypevalues += "<option value=" + loadResult.OSWRCollectionTypeLovs[i].LovId + ">" + loadResult.OSWRCollectionTypeLovs[i].FieldValue + "</option>"
            }
            $("#ddlCollectionType").append(CollectionTypevalues)

            for (var i = 0; i < loadResult.OSWRStatusLovs.length; i++) {
                StatusValues += "<option value=" + loadResult.OSWRStatusLovs[i].LovId + ">" + loadResult.OSWRStatusLovs[i].FieldValue + "</option>"
            }
            $("#ddlStatus").append(StatusValues)

            for (var i = 0; i < loadResult.OSWRCollectionStatusLovs.length; i++) {
                CollectionStatusvalues += "<option value=" + loadResult.OSWRCollectionStatusLovs[i].LovId + ">" + loadResult.OSWRCollectionStatusLovs[i].FieldValue + "</option>"
            }
            $("#ddlCollectionStatus1").append(CollectionStatusvalues)

            for (var i = 0; i < loadResult.QcLovs.length; i++) {
                QcValues += "<option value=" + loadResult.QcLovs[i].LovId + ">" + loadResult.QcLovs[i].FieldValue + "</option>"
            }
            $("#ddlQC1").append(QcValues)
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });


    var UserAreaFetchObj = {
        SearchColumn: 'txtUserAreaCode-UserAreaCode',//Id of Fetch field
        ResultColumns: ["DeptAreaId-Primary Key", 'UserAreaCode-UserAreaCode'],
        FieldsToBeFilled: ["hdnUserAreaId-DeptAreaId", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName", "txtCollectionFrequency-CollectionFrequency"]
    };
    $('#txtUserAreaCode').on('input propertychange paste keyup', function (event) {

        DisplayFetchResult('divUserAreaFetch', UserAreaFetchObj, "/Api/OSWRecordSheet/UserAreaCodeFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });


    /******************************************* Save AND SAVE@ADDNEW *****************************************/

    $("#btnSave, #btnSaveAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();

        
        var isFormValid = formInputValidation("formOSWRecordSheet", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
       
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var obj = {
            OSWRId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            OSWRSNo: $('#txtOSWRSNo').val(),
            TotalPackage: $('#txtTotalPackage').val(),
            WasteType: $('#ddlWasteType').val(),
            ConsignmentNo: $('#txtConsignmentNo').val(),
            UserAreaCode: $('#txtUserAreaCode').val(),
            UserAreaName: $('#txtUserAreaName').val(),
            Month: $('#ddlMonth').val(),
            Year: $('#ddlYear').val(),
            CollectionFrequency: $('#txtCollectionFrequency').val(),
            CollectionType: $('#ddlCollectionType').val(),
            Status: $('#ddlStatus').val(),

            OSWRecordSheetList: []
        }

        $("#tbodyOtherWaste tr").each(function () {
            var OSWRObj = {};

            OSWRObj.OSWRecordId = $(this).find("[id^=hdnOSWRecordId]")[0].value;
            OSWRObj.Date = $(this).find("[id^=txtDate]")[0].value;
            OSWRObj.CollectionTime = $(this).find("[id^=txtCollectionTime]")[0].value;
            OSWRObj.CollectionStatus = $(this).find("[id^=ddlCollectionStatus]")[0].value;
            OSWRObj.QC = $(this).find("[id^=ddlQC]")[0].value;
            OSWRObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.OSWRecordSheetList.push(OSWRObj);
        });


        $.post("/Api/OSWRecordSheet/Save", obj, function (response) {

            var result = JSON.parse(response);
            showMessage('OSWRecordSheet', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.OSWRID);
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveAddNew") {
                EmptyFields();
                AutoGen();
            }
            else {
                fillDetails(result);
            }
        },
            "json")
            .fail(function (response) {

                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
            });
    });

    //***************************************Reset Button Code******************************************//

   
    $("#btnCancel").click(function () {

        bootbox.confirm({
            message: Messages.Reset_Alert_CONFIRMATION,
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    EmptyFields();
                    AutoGen();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });


    $("#addOSWRecord").click(function () {

        rowNum = rowNum + 1;

        addOSWRecord(rowNum);

    });

    //****************************************************Mutliple rows delete button code****************************************//

    $("#deleteOtherWaste").click(function () {
        bootbox.confirm({
            message: 'Do you want to delete a row?',
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                
                    label: 'No',
                    className: 'btn-default'
                }
                 
            },
            callback: function (result) {
                if (result) {
                    if ($("input[type='checkbox']:checked").length > 0) {

                        $("#tbodyOtherWaste tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnOSWRecordId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });
                    }
                    else
                        bootbox.alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });

    $('body').on('change', '.CollectionStatus', function () {
       
        var id = event.target.id.slice(19, 21);

         var CollectionSatus = $("#ddlCollectionStatus" + id+" option:selected").text();
        if (CollectionSatus == "Not Done " || CollectionSatus == "Done Not to Schedule") {
            $("#ddlQC" + id + "").attr("required", true);
           
        }
        else {
            $("#ddlQC" + id + "").attr("required", false);
            $('#tbodyOtherWaste #qc').removeClass('has-error');
        }
    });

    $('#txtTotalPackage').keypress('change', function () {
        $('#total').removeClass('has-error');
    });
    $('#ddlWasteType').on('change', function () {
        $('#WasteType').removeClass('has-error');
    });
    //$('#txtUserAreaCode').keypress('change', function () {

    //    $('#UserareaCode').removeClass('has-error');
    //});
    $('#ddlMonth').on('change', function () {

        $('#month').removeClass('has-error');
    });
    $('#ddlYear').on('change', function () {

        $('#year').removeClass('has-error');
    });
    $('#ddlCollectionType').on('change', function () {

        $('#collect').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtDate1').keypress(function () {
        $('#date').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtCollectionTime1').keypress('change', function () {
        $('#collectiontime').removeClass('has-error');
    });
    $('#ddlCollectionStatus1').on('change', function () {

        $('#collectionstatus').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');
    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        LinkClicked(ID);
    }
    //************************************************** AutoGeneratedCode*******************************************//
    AutoGen();

});

function AutoGen() {
    $.get("/api/OSWRecordSheet/AutoGeneratedCode", function (response) {
        var result = JSON.parse(response);       
        $('#txtOSWRSNo').val(result.OSWRSNo);
    });
}

$("#jQGridCollapse1").click(function () {
    var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
});

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formOSWRecordSheet :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"
    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#formOSWRecordSheet :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/OSWRecordSheet/Get/" + primaryId)
            .done(function (result) {

                var getResult = JSON.parse(result);
                fillDetails(getResult);
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

function EmptyFields() {

    $("#primaryID").val(0);
    $('[id^=hdnOSWRecordId]').val(0);

    $('#formOSWRecordSheet')[0].reset();
    $('#total').removeClass('has-error');
    $('#WasteType').removeClass('has-error');
    $('#UserareaCode').removeClass('has-error');
    $('#month').removeClass('has-error');
    $('#year').removeClass('has-error');
    $('#collect').removeClass('has-error');
    $('#formOSWRecordSheet #date').removeClass('has-error');
    $('#formOSWRecordSheet #collectiontime').removeClass('has-error');
    $('#formOSWRecordSheet #collectionstatus').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');
    var i = 1;
    $("#tbodyOtherWaste").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
}
function getCustomDate(date) {

    if (date == '' || date == null) {
        return '';
    }
    else {
        let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
            "May", "Jun", "Jul", "Aug",
            "Sep", "Oct", "Nov", "Dec"];

        var day = date.slice(8, 10);
        var monthindex = date.slice(5, 7);        if (monthindex >= 10) {            var month = monthNames[date.slice(5, 7)];        }        else {            var month = monthNames[date.slice(6, 7)];        }
        var year = date.slice(0, 4);
        return day + "-" + month + "-" + year;
    }
}
function fillDetails(result) {

    if (result != undefined) {
        $('#primaryID').val(result.OSWRId);
        $('#txtOSWRSNo').val(result.OSWRSNo);
        $('#txtTotalPackage').val(result.TotalPackage);
        $('#ddlWasteType').val(result.WasteType);
        $('#txtConsignmentNo').val(result.ConsignmentNo);
        $('#txtUserAreaCode').val(result.UserAreaCode);
        $('#txtUserAreaName').val(result.UserAreaName);
        $('#ddlMonth').val(result.Month);
        $('#ddlYear').val(result.Year);
        $('#txtCollectionFrequency').val(result.CollectionFrequency);
        $('#ddlCollectionType').val(result.CollectionType);
        $('#ddlStatus').val(result.Status);

        $("#tbodyOtherWaste").html('');

        if (result.OSWRecordSheetList != null) {

            rowNum = 1;
            for (var i = 0; i < result.OSWRecordSheetList.length; i++) {

                addOSWRecord(rowNum);

                var Date = getCustomDate(result.OSWRecordSheetList[i].Date);
                var Collectiontime = result.OSWRecordSheetList[i].CollectionTime;
                $('#hdnOSWRecordId' + rowNum).val(result.OSWRecordSheetList[i].OSWRecordId);
                $('#txtDate' + rowNum).val(Date);
                $('#txtCollectionTime' + rowNum).val(Collectiontime);
                $('#ddlCollectionStatus' + rowNum).val(result.OSWRecordSheetList[i].CollectionStatus);
                $('#ddlQC' + rowNum).val(result.OSWRecordSheetList[i].QC);

                rowNum = rowNum + 1;
            }
        }
        else {
            addOSWRecord(rowNum);
        }

        fillAttachment(result.AttachmentList);
    }
}
function addOSWRecord(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" name="isDelete"  id="isDelete' + num + '" /> <input type="hidden" value="0" id="hdnOSWRecordId' + num + '"  /></td>';
    var Date = '<td id="date"><input type="text" required class="form-control datetime" id="txtDate' + num + '" autocomplete="off" name="Date" maxlength="25"  /></td>';
    var CollectionTime = '<td>  <input type="Time" required class="form-control" id="txtCollectionTime' + num + '"  autocomplete="off" name="CollectionTime" maxlength="25"  /></td>';
    var CollectionStatus = '<td id="collectionstatus"> <select required class="form-control CollectionStatus" id="ddlCollectionStatus' + num + '">' + CollectionStatusvalues + '</select></td>';
    var QC = '<td id="qc"><select  class="form-control" id="ddlQC' + num + '">' + QcValues + '</select></td>';

    $("#tbodyOtherWaste ").append('<tr>' + CheckBox + Date + CollectionTime + CollectionStatus + QC + '</tr>');
}