var MonthValues = "";
var YearValues = "";
var CollectionTypevalues = "";
var CollectionStatusvalues = "";
var StatusValues = "";
var CollectionFrequency = "";
var QcValues = "";
var WasteCodeValues = "";
var rowNum = 1;

var FileTypeValues = "";
var filePrefix = "CSWRS_";
var ScreenName = "CSWRecordSheet";
var rowNum2 = 1;

$(document).ready(function () {

    //****************************************** Changing dropdown values *********************************************
    $.get("/api/CSWRecordSheet/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);

            $("#ddlWasteType").append("<option value='' Selected>" + "Select" + "</option>");
            MonthValues = "<option value='' Selected>" + "Select" + "</option>"; 
            YearValues = "<option value='' Selected>" + "Select" + "</option>";
            CollectionTypevalues = "<option value='' Selected>" + "Select" + "</option>";
            CollectionStatusvalues = "<option value='' Selected>" + "Select" + "</option>";
            CollectionFrequency = "<option value='' Selected>" + "Select" + "</option>";
            QcValues = "<option value='' Selected>" + "Select" + "</option>";
         
            for (var i = 0; i < loadResult.WasteTypeLovs.length; i++) {
                $("#ddlWasteType").append(
                   "<option value=" + loadResult.WasteTypeLovs[i].LovId + ">" + loadResult.WasteTypeLovs[i].FieldValue + "</option>"
                );
            }           
            for (var i = 0; i < loadResult.CSWRMonthLovs.length; i++) {
                MonthValues += "<option value=" + loadResult.CSWRMonthLovs[i].LovId + ">" + loadResult.CSWRMonthLovs[i].FieldValue + "</option>"
            }
            $("#ddlMonth").append(MonthValues)            
            for (var i = 0; i < loadResult.CSWRYearLovs.length; i++) {
                YearValues += "<option value=" + loadResult.CSWRYearLovs[i].LovId + ">" + loadResult.CSWRYearLovs[i].FieldValue + "</option>"
            }
            $("#ddlYear").append(YearValues)            
            for (var i = 0; i < loadResult.CSWRCollectionTypeLovs.length; i++) {
                CollectionTypevalues += "<option value=" + loadResult.CSWRCollectionTypeLovs[i].LovId + ">" + loadResult.CSWRCollectionTypeLovs[i].FieldValue + "</option>"
            }
            $("#ddlCollectionType").append(CollectionTypevalues) 
            for (var i = 0; i < loadResult.CSWRCollectionStatusLovs.length; i++) {

                CollectionStatusvalues += "<option value=" + loadResult.CSWRCollectionStatusLovs[i].LovId + ">" + loadResult.CSWRCollectionStatusLovs[i].FieldValue + "</option>"
            }
            $("#ddlCollectionStatus1").append(CollectionStatusvalues)          
            for (var i = 0; i < loadResult.CSWRStatusLovs.length; i++) {

                StatusValues += "<option value=" + loadResult.CSWRStatusLovs[i].LovId + ">" + loadResult.CSWRStatusLovs[i].FieldValue + "</option>"
            }
            $("#ddlStatus").append(StatusValues)
            for (var i = 0; i < loadResult.CSWRCollectionFrequencyLovs.length; i++) {

                CollectionFrequency += "<option value=" + loadResult.CSWRCollectionFrequencyLovs[i].LovId + ">" + loadResult.CSWRCollectionFrequencyLovs[i].FieldValue + "</option>"
            }
            $("#ddlCollectionFrequency1").append(CollectionFrequency)
            for (var i = 0; i < loadResult.QcLovs.length; i++) {
                QcValues += "<option value=" + loadResult.QcLovs[i].LovId + ">" + loadResult.QcLovs[i].FieldValue + "</option>"
            }
            $("#ddlQC1").append(QcValues)   

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "CSWRS" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    //***********************************AutoGeneratecode*******************************//
    AutoGen();

    //******************Enable WasteCode********************************//

    $('#ddlWasteCode').append("<option value='' Selected>" + "Select" + "</option>");

    $('#ddlMonth').change(function () {

        var monthVal = $('#ddlMonth').val();
        var monthText = $("#ddlMonth option:selected").text();

        if (monthVal != "") {

            $('.datetime').each(function () {

                var selectedMonth = $(this).val().slice(3, 6);

                if (monthText.indexOf(selectedMonth, 0) == -1) {

                    $(this).val("");

                }
            });
        }

    });

    $('body').on('change', '.WasteType', function () {

        var WasteType = $("#ddlWasteType").val();
        $("#ddlWasteCode option").remove();

        $.get("/api/CSWRecordSheet/WasteCodeGet/" + WasteType, function (response) {
            var result = JSON.parse(response);

            if (result.WasteTypeList.length != 0) {

                $('#ddlWasteCode').prop("disabled", false);
                WasteCodeValues = "<option value='' Selected>" + "Select" + "</option>"

                for (var i = 0; i < result.WasteTypeList.length; i++) {
                    WasteCodeValues += "<option value=" + result.WasteTypeList[i].WasteCode + ">" + result.WasteTypeList[i].WasteCode + "</option>"
                }
                $('#ddlWasteCode').append(WasteCodeValues);

            }
            else {
                $('#ddlWasteCode').append("<option value='0' Selected>" + "Select" + "</option>");
                $('#ddlWasteCode').prop("disabled", true);
            }
        })
    });


    $('body').on('change', '.datetime', function () {
        
        if ($(this).val() != "") {

            var monthVal = $('#ddlMonth').val();
            var yearVal = $('#ddlYear').val();
            var monthText = $("#ddlMonth option:selected").text();
            var yearText = $("#ddlYear option:selected").text();

            var selectedDate = $(this).val();

            if (monthVal == "" || yearVal == "") {
                bootbox.alert("Please select month and year !");
                $(this).val("");
            }
            else {

                //"29-Dec-2020"
                var selectedMonth = selectedDate.slice(3, 6);
                var selectedYear = selectedDate.slice(7, 11);

                if (monthText.indexOf(selectedMonth, 0) == -1 || yearText.indexOf(selectedYear, 0) == -1) {
                    bootbox.alert("Please select valid date !");
                    $(this).val("");
                }
                
            }
        }
        

        

    });

    $(body).on('input propertychange paste keyup', '.HwmsUserAreaCode', function (event) {

        var controlId = event.target.id;
        var id = controlId.slice(15, 17);

        var UserAreaFetchObj = {
            SearchColumn: 'txtUserAreaCode' + id + '-UserAreaCode',//Id of Fetch field
            ResultColumns: ['DeptAreaId-Primary Key', 'UserAreaCode-UserAreaCode'],
            FieldsToBeFilled: ['hdnUserAreaId' + id + '-DeptAreaId', 'txtUserAreaCode' + id + '-UserAreaCode', 'txtUserAreaName' + id + '-UserAreaName']
        };
        DisplayFetchResult('divUserAreaFetch' + id, UserAreaFetchObj, "/Api/CollectionCategory/UserAreaCodeFetch", 'UlFetch1' + id, event, 1); //1 -- pageIndex
    }); 

    /******************************************* Save *****************************************/

    $("#btnSave, #btnSaveAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();

        var isFormValid = formInputValidation("formCSWRecordSheet", 'save');
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
            CSWRecordSheetId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            DocumentNo: $('#txtDocumentNo').val(),
            RRWNo: $('#txtRRWNo').val(),
            WasteType: $('#ddlWasteType').val(),
            WasteCode: $('#ddlWasteCode').val(),
            UserAreaCode: $('#txtUserAreaCode').val(),
            UserAreaName: $('#txtUserAreaName').val(),
            Month: $('#ddlMonth').val(),
            Year: $('#ddlYear').val(),
            CollectionType: $('#ddlCollectionType').val(),
            Status: $('#ddlStatus').val(),
            TotalWeight: $('#txtTotalWeight').val(),            
            CollectionDetailsList: []
        }  
        
        $("#tbodyCollection tr").each(function () {
            var objCollection = {};

            objCollection.CSWId = $(this).find("[id^=hdnCSWId]")[0].value;
            objCollection.Date = $(this).find("[id^=txtDate]")[0].value;
            objCollection.NoOfBin = $(this).find("[id^=txtNoOfBin]")[0].value;
            objCollection.Weight = $(this).find("[id^=txtWeight]")[0].value;
            objCollection.CollectionFrequency = $(this).find("[id^=ddlCollectionFrequency]")[0].value;
            objCollection.CollectionTime = $(this).find("[id^=txtCollectionTime]")[0].value;
            objCollection.CollectionStatus = $(this).find("[id^=ddlCollectionStatus]")[0].value;
            objCollection.QC = $(this).find("[id^=ddlQC]")[0].value;
            objCollection.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.CollectionDetailsList.push(objCollection);
        });
      
        $.post("/api/CSWRecordSheet/Save", obj, function (response) {  
            
            var result = JSON.parse(response);
            showMessage('CSW Record Sheet', CURD_MESSAGE_STATUS.SS); 

            $("#primaryID").val(result.CSWRecordSheetId);
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

    //**********************************Reset Button Code***************************//

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
                    getTotalWeight();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });

    $("body").on('input', '.clsWeight', function () {
        getTotalWeight();
    });
    $("#addCollection").click(function () {

        rowNum = rowNum + 1;

        addCollection(rowNum);

    });

    //***************************************Mutliple rows delete button code*********************************//

    $("#deleteCSWRecordSheetRows").click(function () {
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
                        $("#tbodyCollection tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnCSWId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                    getTotalWeight();
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
        $("#ddlQC" + id + " option").remove();
        var CollectionSatus = $("#ddlCollectionStatus" + id + " option:selected").text();

        if (CollectionSatus == " Not Done " || CollectionSatus == " Done Not to Schedule") {

            $("#ddlQC" + id + "").append(CollectionStatusvalues)

        }
        else {
          
            $("#ddlQC" + id + " option").remove();
            $("#ddlQC" + id+"").append("<option value='' Selected>" + "Select" + "</option>");
           
        }
    });

    $('#ddlWasteType').on('change', function () {
        $('#WasteType').removeClass('has-error');
    });
    $('#ddlWasteCode').on('change', function () {
        $('#WasteCode').removeClass('has-error');
    });
    $('#txtUserAreaCode').on('change', function () {
        $('#UserAreaCode').removeClass('has-error');
    });
    $('#ddlMonth').on('change', function () {
        $('#Month').removeClass('has-error');
    });
    $('#ddlYear').on('change', function () {
        $('#Year').removeClass('has-error');
    });
    $('#ddlCollectionType').on('change', function () {
        $('#CollectionType').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtDate1').keypress(function () {
        $('#Date').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlCollectionType1').on('change', function () {
        $('#CollectionType').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlCollectionFrequency1').on('change', function () {
        $('#CollectionFrequency').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtCollectionTime1').keypress(function () {
        $('#CollectionTime').removeClass('has-error');
    });
    $('#ddlCollectionStatus1').on('change', function () {
        $('#CollectionStatus').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });  

    //********************************* Get By ID ************************************

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

  
});

function AutoGen() {
    $.get("/api/CSWRecordSheet/AutoGeneratedCode", function (response) {
        var result = JSON.parse(response);
        $('#txtDocumentNo').val(result.DocumentNo);
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
    $("#formCSWRecordSheet :input:not(:button)").parent().removeClass('has-error');
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
        $("#formCSWRecordSheet :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();

    if (primaryId != null && primaryId != "0") {
        $.get("/api/CSWRecordSheet/Get/" + primaryId)
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

function fillDetails(result) {

    if (result != undefined) {

        var WasteCode = result.WasteCode;

        $('#primaryID').val(result.CSWRecordSheetId);
        $('#txtDocumentNo').val(result.DocumentNo);
        $('#txtRRWNo').val(result.RRWNo);
        $('#ddlWasteType').val(result.WasteType);
        if (WasteCode != 0) {
            $('#ddlWasteCode option').remove();
            $('#ddlWasteCode').prop("disabled", false);

            $('#ddlWasteCode').append("<option value=" + WasteCode + ">" + WasteCode + "</option>");

        }
        else {
            $('#ddlWasteCode').prop("disabled", true);
        }
        $('#txtUserAreaCode').val(result.UserAreaCode);
        $('#txtUserAreaName').val(result.UserAreaName);
        $('#ddlMonth').val(result.Month);
        $('#ddlYear').val(result.Year);

        $('#ddlCollectionType').val(result.CollectionType);
        $('#txtCollectionFrequency').val(result.CollectionFrequency);
        $('#ddlStatus').val(result.Status);
        $('#txtTotalWeight').val(result.TotalWeight);

        $("#tbodyCollection").html('');

        if (result.CollectionDetailsList != null) {

            rowNum = 1;
            for (var i = 0; i < result.CollectionDetailsList.length; i++) {

                addCollection(rowNum);

                var Date = getCustomDate(result.CollectionDetailsList[i].Date);
                var Collectiontime = result.CollectionDetailsList[i].CollectionTime;

                $('#hdnCSWId' + rowNum).val(result.CollectionDetailsList[i].CSWId);
                $('#txtDate' + rowNum).val(Date);
                $('#txtNoOfBin' + rowNum).val(result.CollectionDetailsList[i].NoofBin)
                $('#txtWeight' + rowNum).val(result.CollectionDetailsList[i].Weight);
                $('#ddlCollectionFrequency' + rowNum).val(result.CollectionDetailsList[i].CollectionFrequency);
                $('#txtCollectionTime' + rowNum).val(Collectiontime);
                $('#ddlCollectionStatus' + rowNum).val(result.CollectionDetailsList[i].CollectionStatus);
                $('#ddlQC' + rowNum).val(result.CollectionDetailsList[i].QC);

                rowNum = rowNum + 1;
            }
        }
        else {
            addCollection(rowNum);
        }

        fillAttachment(result.AttachmentList);
    }
}

//*****************Reset Fields and Delete Rows*****************//

    function EmptyFields() {
        $("#primaryID").val('0');
        $('[id^=hdnCSWId]').val(0);

        $('#formCSWRecordSheet')[0].reset();
        $('#formCSWRecordSheet #WasteType').removeClass('has-error');
        $('#formCSWRecordSheet #WasteCode').removeClass('has-error');
        $('#formCSWRecordSheet #UserAreaCode').removeClass('has-error');
        $('#formCSWRecordSheet #Month').removeClass('has-error');
        $('#formCSWRecordSheet #Year').removeClass('has-error');
        $('#formCSWRecordSheet #CollectionType').removeClass('has-error');
        $('#formCSWRecordSheet #Date').removeClass('has-error');
        $('#formCSWRecordSheet #CollectionFrequency').removeClass('has-error');
        $('#formCSWRecordSheet #CollectionTime').removeClass('has-error');
        $('#formCSWRecordSheet #CollectionStatus').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
        $('#ddlWasteCode option').remove();
        $('#ddlWasteCode').prop("disabled", true);

        $('#ddlWasteCode').append("<option value='' Selected>" + "Select" + "</option>");
        var i = 1;
        $("#tbodyCollection").find('tr').each(function () {
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

function getTotalWeight() {

    var calculated_total_sum1 = 0;

    $("#tbodyCollection .clsWeight").each(function () {
        var get_textbox_value1 = $(this).val();
        if ($.isNumeric(get_textbox_value1)) {
            calculated_total_sum1 += parseFloat(get_textbox_value1);
        }

    });
    $("#txtTotalWeight").val(calculated_total_sum1);
}

function addCollection(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" name="isDelete"  id="isDelete' + num + '" /> <input type="hidden" value="0" id="hdnCSWId' + num + '"  /></td>';
    var Date = '<td> <input type="text" required class="form-control datetime" id="txtDate' + num + '" autocomplete="off" name="Date" maxlength="25"  /></td>';
    var NoOfBin = '<td> <input type="text" class="form-control" id="txtNoOfBin' + num + '" autocomplete="off" name="NoOfBin" maxlength="25"  /></td>';
    var Weight = '<td> <input type="text" class="form-control clsWeight" id="txtWeight' + num + '" autocomplete="off" name="Weight" maxlength="25"  /></td>';
    var CollectionFrequenc = '<td>  <select type="text" required class="form-control" id="ddlCollectionFrequency' + num + '" autocomplete="off" name="CollectionFrequency" maxlength="25" >' + CollectionFrequency + '</td>';
    var CollectionTime = '<td> <input type="time" required class="form-control" id="txtCollectionTime' + num + '" autocomplete="off" name="CollectionTime" maxlength="25"  /></td>';
    var CollectionStatus = '<td> <select type="text" required class="form-control CollectionStatus" id="ddlCollectionStatus' + num + '" autocomplete="off" name="CollectionStatus" maxlength="25" >' + CollectionStatusvalues + '</td>';
    var QC = '<td> <select type="text" class="form-control"  id="ddlQC' + num + '" autocomplete="off" name="QC" maxlength="25" >' + QcValues + '</td>';

    $("#tbodyCollection").append('<tr>' + CheckBox + Date + NoOfBin + Weight + CollectionFrequenc + CollectionTime + CollectionStatus + QC + '</tr>');
}