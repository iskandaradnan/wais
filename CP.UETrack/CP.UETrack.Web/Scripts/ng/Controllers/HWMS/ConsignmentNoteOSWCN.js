var FileTypeValues = "";
var rowNum = 0;
var rowNum3 = 2;

var FileTypeValues = "";
var filePrefix = "OSWCN_";
var ScreenName = "ConsignmentNoteOSWCN";
var rowNum2 = 1;

$(document).ready(function () {

    //AutoDisplay
    var OSWRepresentativeFetchObj = {
        SearchColumn: 'txtOSWRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtOSWRepresentative-StaffName", "txtOSWRepresentativeDesignation-Designation"]//id of element - the model property
    };
    $('#txtOSWRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch1', OSWRepresentativeFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });
     
    var HospitalStaffFetchObj = {
        SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-Designation"]//id of element - the model property
    };
    $('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', HospitalStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    //AutoDisplay for Vehicle no 

    var VehicleNoFetchObj = {
        SearchColumn: 'txtVehicleNo-VehicleNo',//Id of Fetch field
        ResultColumns: ['VehicleId-Primary Key', 'VehicleNo-VehicleNo'],
        FieldsToBeFilled: ['hdnVehicleNoId-VehicleId', 'txtVehicleNo-VehicleNo']
    };
    $('#txtVehicleNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetchVehicleNo', VehicleNoFetchObj, "/Api/ConsignmentNoteCWCN/VehicleNoFetch", 'UlFetchVehicleNo', event, 1); //1 -- pageIndex
    });

    //AutoDisplay for Driver Name

    var DriverCodeFetchObj = {
        SearchColumn: 'txtDriverName-DriverName',//Id of Fetch field
        ResultColumns: ['DriverId-Primary Key', 'DriverName-DriverName'],
        FieldsToBeFilled: ['hdnDriverNameId-DriverId', 'txtDriverName-DriverName']
    };
    $('#txtDriverName').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divDriverNameFetch', DriverCodeFetchObj, "/Api/ConsignmentNoteCWCN/DriverCodeFetch", 'UlFetch2', event, 1); //1 -- pageIndex
    });

    $.get("/api/ConsignmentNoteOSWCN/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            var TransportationCategory = "<option value='' Selected>" + "Select" + "</option>"
            var WasteTypevalues = "<option value=''>" + "Select" + "</option>";
            //FileTypeValues = "<option value=''>" + "Select" + "</option>";

            for (var i = 0; i < loadResult.TransportationLov.length; i++) {
                TransportationCategory += "<option value=" + loadResult.TransportationLov[i].LovId + ">" + loadResult.TransportationLov[i].FieldValue + "</option>"
            }
            $("#ddlTransportationCategory").html(TransportationCategory);

            for (var i = 0; i < loadResult.WasteTypeLov.length; i++) {
                WasteTypevalues += "<option value=" + loadResult.WasteTypeLov[i].LovId + ">" + loadResult.WasteTypeLov[i].FieldValue + "</option>"
            }
            $("#ddlWasteType").html(WasteTypevalues);

            //for (var i = 0; i < loadResult.FileTypeLovs.length; i++) {
            //    FileTypeValues += "<option value=" + loadResult.FileTypeLovs[i].LovId + ">" + loadResult.FileTypeLovs[i].FieldValue + "</option>"
            //}
            //$("#tblAttachment tbody #ddlFileType1").append(FileTypeValues);
            //$("#hdnAttachmentId1").val();

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "Consignment Note (OSWCN)" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);


            $('#myPleaseWait').modal('hide');
           
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    //***************************** Getting TreatmentPlant DropDown from HWMS_TreatmentPlant ***********************
    $.get("/api/ConsignmentNoteCWCN/AutoDisplaying", function (response) {
        var result = JSON.parse(response);
        Dropdownvalues = "<option value=''>" + "Select" + "</option>";
        if (result.length > 0) {
            for (var i = 0; i < result.length; i++) {
                Dropdownvalues += "<option value=" + result[i].TreatmentPlantId + ">" + result[i].TreatmentPlantName + "</option>"
            }
        }
        $("#ddlTreatmentPlant").html(Dropdownvalues);

    })

    $('body').on('change', '.TreatmentplantName', function (e) {
        var controlId = event.target.id;

        var TreatmentPlantName = $('#' + controlId + '').val();

        var jqxhr = $.get("/api/ConsignmentNoteCWCN/TreatmentPlantData/" + TreatmentPlantName, function (response) {
            var result = JSON.parse(response);

            var Ownership = result.Ownership;

            $('#txtOwnership').val(Ownership);

        })
    });

    $('#ddlWasteType').on('change', function () {
        var controlId = event.target.id;
        var Wastetype = $('#' + controlId + '').val();
        var WasteCodeOptn = "";
        var WasteCodeVal = "";
        $.get("/api/ConsignmentNoteOSWCN/WasteTypeData/" + Wastetype, function (response) {
            var result = JSON.parse(response);

            for (var i = 0; i < result.WasteDropDownList.length; i++) {
                WasteCodeOptn += "<option value=" + result.WasteDropDownList[i].WasteCode + ">" + result.WasteDropDownList[i].WasteCode + "</option>"
            }
            if (result.WasteDropDownList.length != 0) {
                $("[name='WasteCode']").prop("disabled", false);
                WasteCodeVal = "<option value='0' Selected>" + "Select" + "</option>" + WasteCodeOptn;
                $('#ddlWasteCode').html(WasteCodeVal);

            } else {
                $("[name='WasteCode']").prop("disabled", true);
                WasteCodeVal = "<option value='0' Selected>" + "Select" + "</option>" + WasteCodeOptn;
                $('#ddlWasteCode').html(WasteCodeVal);
            }
        })
    });
 
    $("#btnSave, #btnSaveandAddNew").click(function () {
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();       
        var isFormValid = formInputValidation("formConsignmentNoteOSWCN", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        //$('#myPleaseWait').modal('show');

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        } 
        var obj = {
            ConsignmentOSWCNId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,           
            ConsignmentNoteNo: $('#txtConsignmentNoteNo').val(),
            DateTime: $('#txtDateTime').val(),
            TotalEst: $('#txtTotalEst').val(),
            TotalNoofPackaging: $('#txtTotalNoofPackaging').val(),
            OSWRepresentative: $('#txtOSWRepresentative').val(),
            OSWRepresentativeDesignation: $('#txtOSWRepresentativeDesignation').val(),
            HospitalRepresentative: $('#txtHospitalRepresentative').val(),
            HospitalRepresentativeDesignation: $('#txtHospitalRepresentativeDesignation').val(),
            TreatmentPlant: $('#ddlTreatmentPlant').val(),
            Ownership: $('#txtOwnership').val(),
            VehicleNo: $('#txtVehicleNo').val(),
            DriverName: $('#txtDriverName').val(),
            WasteType: $('#ddlWasteType').val(),
            WasteCode: $('#ddlWasteCode').val(),
            ChargeRM: $('#txtChargeRM').val(),
            ReturnValueRM: $('#txtReturnValueRM').val(),
            TransportationCategory: $('#ddlTransportationCategory').val(),
            TotalWeight: $('#txtTotalWeight').val(),
            Remarks: $('#txtRemarks').val(),
            StartDate: $('#txtStartDate').val(),
            EndDate: $('#txtEndDate').val(),                       
            ConsignmentSWRSNoDetailsList: []
        }


        $("#tbodySWRSNo tr").each(function () {
           
            var Consign = {};
            Consign.SWRSNoId = $(this).find("[id^=hdnConsignmentOSWCNId]")[0].value;
            Consign.UserAreaCode = $(this).find("[id^=txtUserAreaCode]")[0].value;
            Consign.UserAreaName = $(this).find("[id^=txtUserAreaName]")[0].value;
            Consign.OSWRSNo = $(this).find("[id^=txtSWRSNo]")[0].value;     
            Consign.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.ConsignmentSWRSNoDetailsList.push(Consign);
        });
                
        $.post("/api/ConsignmentNoteOSWCN/Save", obj, function (response) {

            $('#myPleaseWait').modal('hide');
            var result = JSON.parse(response);
            $("#primaryID").val(result.ConsignmentOSWCNId);            
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
            }  
            else {
                fillDetails(result);
            }
                        
            showMessage('Consignment Note OSWCN', CURD_MESSAGE_STATUS.SS);
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

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#SWRSNoFetch").click(function () {

        var StartDate = $("#txtStartDate").val();
        var EndDate = $("#txtEndDate").val();
        if (StartDate != 0 & EndDate != 0) {
            var obj = {                ConsignmentOSWCNId: $("#primaryID").val(),                StartDate: StartDate,                EndDate: EndDate            }
            $('#myPleaseWait').modal('show');
            $.post("/api/ConsignmentNoteOSWCN/FetchConsign", obj, function (response) {
                var result = JSON.parse(response);
                var UserAreas = result.ConsignmentSWRSNoDetailsList.length;
                $("#tbodySWRSNo").html('');
                if (result.ConsignmentSWRSNoDetailsList != null) {

                    $('#table_data1').hide();
                    var RowNum2 = 1;
                    for (var j = 0; j < result.ConsignmentSWRSNoDetailsList.length; j++) {

                        var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + RowNum2 + '" name="isDelete" /><input type="hidden" id="hdnConsignmentOSWCNId' + RowNum2 + '" value="0"</td>';
                        var UserAreaCode = '<td> <input type="text" required class="form-control" id="txtUserAreaCode' + RowNum2 + '"  autocomplete="off" name="UserAreaCode" maxlength="25" tabindex="2" /></td>';
                        var UserAreaName = '<td> <input type="text" required class="form-control" id="txtUserAreaName' + RowNum2 + '"  autocomplete="off" name="UserAreaName" maxlength="25" tabindex="2" /></td>';
                        var OSWRSNo = '<td> <input type="text" required class="form-control" id="txtSWRSNo' + RowNum2 + '"  autocomplete="off" name="OSWRSNo" maxlength="25" tabindex="2" /></td>';

                        $("#tbodySWRSNo").append('<tr>' + CheckBox + UserAreaCode + UserAreaName + OSWRSNo + '</tr>');

                        $('#hdnConsignmentOSWCNId' + RowNum2).val(result.ConsignmentSWRSNoDetailsList[j].SWRSNoId);
                        $('#txtUserAreaCode' + RowNum2).val(result.ConsignmentSWRSNoDetailsList[j].UserAreaCode);
                        $('#txtUserAreaName' + RowNum2).val(result.ConsignmentSWRSNoDetailsList[j].UserAreaName);
                        $('#txtSWRSNo' + RowNum2).val(result.ConsignmentSWRSNoDetailsList[j].OSWRSNo);

                        RowNum2 = RowNum2 + 1;
                    }
                }
            },
                "json")                .fail(function (response) {                    var errorMessage = "";                    if (response.status == 400) {                        errorMessage = response.responseJSON;                    }                    else {                        errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);                    }                });
            $('#myPleaseWait').modal('hide');
        }
        else {            var message = "Please Select Start Date & End Date";
            bootbox.confirm(message, function (result) {
                if (result) {
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });
        }
    });     

    $("#addRowSWRSNo").click(function () {
        rowNum += 1;
        addRowSWRSNo(rowNum);
    })
   
    //Mutliple rows delete button code....
    $("#deleteSWRSNo").click(function () {
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
                        $("#tbodySWRSNo").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnConsignmentOSWCNId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }                              
                            }
                        });
                       
                    }
                    else
                        alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });
    });
   
    $('#txtConsignmentNoteNo').change(function () {
        $('#formConsignmentNoteOSWCN #ConsignmentNo').removeClass('has-error');
    });
    $('#txtDateTime').change(function () {
        $('#formConsignmentNoteOSWCN #Date').removeClass('has-error');
    });
    $('#txtTotalEst').change(function () {
        $('#formConsignmentNoteOSWCN #TotalEst').removeClass('has-error');
    });
    $('#txtTotalNoofPackaging').change(function () {
        $('#formConsignmentNoteOSWCN #Totalpack').removeClass('has-error');
    });
    $('#ddlTreatmentPlant').change(function () {
        $('#formConsignmentNoteOSWCN #Treatmentplant').removeClass('has-error');        
    });
    $('#ddlWasteType').change(function () {
        $('#formConsignmentNoteOSWCN #waste').removeClass('has-error');  
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


function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formConsignmentNoteOSWCN :input:not(:button)").parent().removeClass('has-error');
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
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();

        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ConsignmentNoteOSWCN/Get/" + primaryId)
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

        //var Date = getCustomDate(result.DateTime);
        var StartDate = getCustomDate(result.StartDate);
        var EndDate = getCustomDate(result.EndDate);
        var wasteCode = result.WasteCode;
        $("#primaryID").val(result.ConsignmentOSWCNId)
        $('#txtConsignmentNoteNo').val(result.ConsignmentNoteNo);
        $('#txtDateTime').val(result.DateTime);
        $('#txtTotalEst').val(result.TotalEst);
        $('#txtTotalNoofPackaging').val(result.TotalNoofPackaging);
        $('#txtOSWRepresentative').val(result.OSWRepresentative);
        $('#txtOSWRepresentativeDesignation').val(result.OSWRepresentativeDesignation);
        $('#txtHospitalRepresentative').val(result.HospitalRepresentative);
        $('#txtHospitalRepresentativeDesignation').val(result.HospitalRepresentativeDesignation);
        $('#ddlTreatmentPlant').val(result.TreatmentPlant);
        $('#txtOwnership').val(result.Ownership);
        $('#txtVehicleNo').val(result.VehicleNo);
        $('#txtDriverName').val(result.DriverName);
        $('#ddlWasteType').val(result.Wastetype);
        if (wasteCode != 0) {
            $('#ddlWasteCode option').remove();        
            $('#ddlWasteCode').prop("disabled", false);
            $('#ddlWasteCode').append("<option value=" + wasteCode + ">" + wasteCode + "</option>");

        }
        else {
            $('#ddlWasteCode').prop("disabled", true);
        }

        $('#txtChargeRM').val(result.ChargeRM);
        $('#txtReturnValueRM').val(result.ReturnValueRM);
        $('#ddlTransportationCategory').val(result.TransportationCategory);
        $('#txtTotalWeight').val(result.TotalWeight);
        $('#txtRemarks').val(result.Remarks);
        $('#txtStartDate').val(StartDate);
        $('#txtEndDate').val(EndDate);

        var rowNum1 = 1;
        
        $('#tbodySWRSNo').html('');
        $('#table_data1').hide();
        if (result.ConsignmentSWRSNoDetailsList != null) {
            for (i = 0; i < result.ConsignmentSWRSNoDetailsList.length; i++) {

                addRowSWRSNo(rowNum1);
                                
                $('#hdnConsignmentOSWCNId' + rowNum1).val(result.ConsignmentSWRSNoDetailsList[i].SWRSNoId);
                $('#txtUserAreaCode' + rowNum1).val(result.ConsignmentSWRSNoDetailsList[i].UserAreaCode);
                $('#txtUserAreaName' + rowNum1).val(result.ConsignmentSWRSNoDetailsList[i].UserAreaName);
                $('#txtSWRSNo' + rowNum1).val(result.ConsignmentSWRSNoDetailsList[i].OSWRSNo);

                rowNum1 += 1;
            }
        }
        else {
            addRowSWRSNo(rowNum1);
        }

        fillAttachment(result.AttachmentList);

       
    }
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#formConsignmentNoteOSWCN')[0].reset();
    $('#primaryID').val('');
    $('[id^=hdnConsignmentOSWCNId]').val(0);
   // $('#txtDate').val('');
    $('#ConsignmentNo').removeClass('has-error');
    $('#Date').removeClass('has-error');
    $('#TotalEst').removeClass('has-error');
    $('#Totalpack').removeClass('has-error');
    $('#OSWReprent').removeClass('has-error');
    $('#HospitalReprent').removeClass('has-error');
    $('#Treatmentplant').removeClass('has-error');
    $('#Vehicle').removeClass('has-error');
    $('#Driver').removeClass('has-error');
    $('#waste').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');
    var i = 1;
    $("#tbodySWRSNo").find('tr').each(function () {
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

function addRowSWRSNo(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /><input type="hidden" id="hdnConsignmentOSWCNId' + num + '" value="0"</td>';
    var UserAreaCode = '<td>  <input type="text" required class="form-control" id="txtUserAreaCode' + num + '"  autocomplete="off" name="UserAreaCode" maxlength="25" tabindex="2" /></td>';
    var UserAreaName = '<td> <input type="text" required class="form-control" id="txtUserAreaName' + num + '"  autocomplete="off" name="UserAreaName" maxlength="25" tabindex="2" /></td>';
    var OSWRSNo = '<td>  <input type="text" required class="form-control" id="txtSWRSNo' + num + '"  autocomplete="off" name="SWRSNo" maxlength="25" tabindex="2" /></td>';
    $("#tbodySWRSNo").append('<tr>' + CheckBox + UserAreaCode + UserAreaName + OSWRSNo + '</tr>');

    $('#display').hide();
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

$(".nav-tabs > li:not(:first-child)").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0) {
        bootbox.alert("Save the details before moving on to Other!");
        return false;
    }
});


