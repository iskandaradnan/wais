var OwnershipValues = "";
var StateValues = "";
var MethodofDisposalValues = "";
var StatusValues = "";
var UnitValues = "";
var rowNum1 = 1;
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/TreatmentPlant/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            OwnershipValues = "<option value='' Selected>" + "Select" + "</option>";
            StateValues = "<option value='' Selected>" + "Select" + "</option>";
            MethodofDisposalValues = "<option value='' Selected>" + "Select" + "</option>";
            StatusValues = "<option value='' Selected>" + "Select" + "</option>";
            UnitValues = "<option value='' Selected>" + "Select" + "</option>";

            for (var i = 0; i < loadResult.OwnershipLovs.length; i++) {
                OwnershipValues += "<option value=" + loadResult.OwnershipLovs[i].LovId + ">" + loadResult.OwnershipLovs[i].FieldValue + "</option>"
            }
            $("#ddlOwnership").append(OwnershipValues)
            for (var i = 0; i < loadResult.StateLovs.length; i++) {
                StateValues += "<option value=" + loadResult.StateLovs[i].LovId + ">" + loadResult.StateLovs[i].FieldValue + "</option>"
            }
            $("#ddlState").append(StateValues)
            for (var i = 0; i < loadResult.MethodofDisposalLovs.length; i++) {
                MethodofDisposalValues += "<option value=" + loadResult.MethodofDisposalLovs[i].LovId + ">" + loadResult.MethodofDisposalLovs[i].FieldValue + "</option>"
            }
            $("#ddlMethodofDisposal1").append(MethodofDisposalValues)
            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                StatusValues += "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>"
            }
            $("#ddlStatus1").append(StatusValues)
            for (var i = 0; i < loadResult.UnitLovs.length; i++) {
                UnitValues += "<option value=" + loadResult.UnitLovs[i].LovId + ">" + loadResult.UnitLovs[i].FieldValue + "</option>"
            }
            $("#ddlUnit1").append(UnitValues)

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });


 


   

    //var LicenseCodeObj = {
    //    SearchColumn: 'txtLicenseCode1-LicenseCode',//Id of Fetch field
    //    ResultColumns: ["LicenseTypeId-Primary Key ", 'LicenseCode-LicenseCode'],
    //    FieldsToBeFilled: ["hdnLicensecode-LicenseTypeId", "txtLicenseCode1-LicenseDescription"]
    //};

    //$('#txtLicenseCode1').on('input propertychange paste keyup', function (event) {
    //    DisplayFetchResult('divLicenseFetch', LicenseCodeObj, "/api/TreatmentPlant/LicenseCodeFetch", "UlFetch", event, 1);//1 -- pageIndex
    //});

    $(body).on('input propertychange paste keyup', '.HWMSLicence', function (event) {
        var controlld = event.target.id;
        var id = controlld.slice(14, 16);

        var LicenseCodeFetchObj = {
            SearchColumn: 'txtLicenseCode' + id + '-LicenseCode',//Id of Fetch field
            ResultColumns: ['LicenseId-Primary Key', 'LicenseCode-LicenseCode'],
            FieldsToBeFilled: ['hdnLicensecode' + id + '-LicenseId', 'txtLicenseCode' + id + '-LicenseCode', 'txtLicenseDescription' + id + '-LicenseDescription']
        };

        DisplayFetchResult('divLicenseFetch' + id, LicenseCodeFetchObj, "/api/HWMSDriverDetails/LicenseCodeFetch", 'UlFetch' + id, event, 1);//1 -- pageIndex
    });

    //********************************************* validation red border removal while giving value *********************************************
    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
    });

    $("#btnSave,#btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();

        var isFormValid = formInputValidation("formTreatmentPlant", 'save');

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var arr = [];
        var isDuplicateLicenseCode = 0;
        $("[id^=txtLicenseCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicateLicenseCode += 1;
            }
        });

        if (isDuplicateLicenseCode > 0) {
            $("div.errormsgcenter").text('Duplicate License Codes');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }


        var obj = {
            TreatmentPlantId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            TreatmentPlantCode: $('#txtTreatmentPlantCode').val(),
            TreatmentPlantName: $('#txtTreatmentPlantName').val(),
            RegistrationNo: $('#txtRegistrationNo').val(),
            AdressLine1: $('#txtAdressLine1').val(),
            AdressLine2: $('#txtAdressLine2').val(),
            City: $('#txtCity').val(),
            State: $('#ddlState').val(),
            PostCode: $('#txtPostsCode').val(),
            Ownership: $('#ddlOwnership').val(),
            ContactNumber: $('#txtContactNumber').val(),
            FaxNumber: $('#txtFaxNumber').val(),
            DOEFileNo: $('#txtDOEFileNo').val(),
            OwnerName: $('#txtOwnerName').val(),
            NumberOfStore: $('#txtNumberOfStore').val(),
            CapacityOfStorage: $('#txtCapacityOfStorage').val(),
            Remarks: $('#txtRemarks').val(),

            TreatmetPlantLicenseDetails: [],
            TreatmetPlantDisposalType: []
        }

        $('#tbodyLicenseCode tr').each(function () {

            var tbl = {};
            tbl.LicenseCodeId = $(this).find("[id^=hdnLicenseCodeId]")[0].value;
            tbl.LicenseCode = $(this).find("[id^=txtLicenseCode]")[0].value;
            tbl.LicenseDescription = $(this).find("[id^=txtLicenseDescription]")[0].value;
            tbl.LicenseNo = $(this).find("[id^=txtLicenseNo]")[0].value;
            tbl.Class = $(this).find("[id^=txtClass]")[0].value;
            tbl.IssueDate = $(this).find("[id^=txtIssueDate]")[0].value;
            tbl.ExpiryDate = $(this).find("[id^=txtExpiryDate]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.TreatmetPlantLicenseDetails.push(tbl);

        });

        $('#tbodyDisposalType tr').each(function () {

            var DisposalObj = {};
            DisposalObj.DisposalTypeId = $(this).find("[id^=hdnDisposalTypeId]")[0].value;
            DisposalObj.MethodofDisposal = $(this).find("[id^=ddlMethodofDisposal]")[0].value;
            DisposalObj.Status = $(this).find("[id^=ddlStatus]")[0].value;
            DisposalObj.DesignCapacity = $(this).find("[id^=txtDesignCapacity]")[0].value;
            DisposalObj.LicensedCapacity = $(this).find("[id^=txtLicensedCapacity]")[0].value;
            DisposalObj.Unit = $(this).find("[id^=ddlUnit]")[0].value;
            DisposalObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.TreatmetPlantDisposalType.push(DisposalObj);

        });

        
        $.post("/api/TreatmentPlant/Save", obj, function (response) {

            var result = JSON.parse(response)
            $("#primaryID").val(result.TreatmentPlantId);
            showMessage('Treatment Plant', CURD_MESSAGE_STATUS.SS);
            
            $("#grid").trigger('reloadGrid');

            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
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

    //Reset Functionality....
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
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }                
            }
        });       
    });

    //Reset Functionality..(Vechile Details)...
    $("#btnCancel1").click(function () {

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
                    $('#VichileDetails')[0].reset();
                    $('#tbodyVehicles').html('');                    
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }                
            }
        });
       
    });

    //Reset Functionality..(Driver Details)...
    $("#btnCancel2").click(function () {
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
                    $('#DriverDeatils')[0].reset();
                    $(".tablerowe").remove();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }                
            }
        });
    });


    //Delete Functionality....(Table-1)  
    $("#deleteLicenseCode").click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
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
                        $("#tbodyLicenseCode tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnLicenseCodeId]").val() == 0) {
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

    $("#deleteDisposalType").click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
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
                        $("#tbodyDisposalType tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {      
                                if ($(this).closest("tr").find("[id^=hdnDisposalTypeId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });
                    }
                    else
                        bootbox.alert("Please select atleast one row !");
                        var n3 = $("#table1").find("tbody tr").length;
                        $('#txtNoofBins').val((n3 - 1) + 1);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });
   
   
    $("#addLicenseCode").click(function () {
        rowNum1 += 1;
        addLicenseCode(rowNum1);
        
    })


    
    $("#addDisposalType").click(function () {
        rowNum2 += 1;
        addDisposalType(rowNum2);        
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
});

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
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
        $.get("/api/TreatmentPlant/Get/" + primaryId)
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

        $('#primaryID').val(result.TreatmentPlantId);
        $('#txtTreatmentPlantCode').val(result.TreatmentPlantCode);
        $('#txtTreatmentPlantName').val(result.TreatmentPlantName);
        $('#txtRegistrationNo').val(result.RegistrationNo);
        $('#txtAdressLine1').val(result.AdressLine1);
        $('#txtAdressLine2').val(result.AdressLine2);
        $('#txtCity').val(result.City);
        $('#ddlState').val(result.State);
        $('#txtPostsCode').val(result.PostCode);
        $('#ddlOwnership').val(result.Ownership);
        $('#txtContactNumber').val(result.ContactNumber);
        $('#txtFaxNumber').val(result.FaxNumber);
        $('#txtDOEFileNo').val(result.DOEFileNo);
        $('#txtOwnerName').val(result.OwnerName);
        $('#txtNumberOfStore').val(result.NumberOfStore);
        $('#txtCapacityOfStorage').val(result.CapacityOfStorage);
        $('#txtRemarks').val(result.Remarks);

        var rowNum1 = 1;
        $('#tbodyLicenseCode').html('');
        if (result.TreatmetPlantLicenseDetails != null) {

            for (var i = 0; i < result.TreatmetPlantLicenseDetails.length; i++) {

                addLicenseCode(rowNum1);

                $('#hdnLicenseCodeId' + rowNum1).val(result.TreatmetPlantLicenseDetails[i].LicenseCodeId);
                $('#txtLicenseCode' + rowNum1).val(result.TreatmetPlantLicenseDetails[i].LicenseCode);
                $('#txtLicenseDescription' + rowNum1).val(result.TreatmetPlantLicenseDetails[i].LicenseDescription);
                $('#txtLicenseNo' + rowNum1).val(result.TreatmetPlantLicenseDetails[i].LicenseNo);
                $('#txtClass' + rowNum1).val(result.TreatmetPlantLicenseDetails[i].Class);

                var issueDate = getCustomDate(result.TreatmetPlantLicenseDetails[i].IssueDate);
                var expiryDate = getCustomDate(result.TreatmetPlantLicenseDetails[i].ExpiryDate);

                $('#txtIssueDate' + rowNum1).val(issueDate);
                $('#txtExpiryDate' + rowNum1).val(expiryDate);

                rowNum1 += 1;
            }
        }
        else {
            addLicenseCode(rowNum1);
        }
       
        rowNum2 = 1;
        $('#tbodyDisposalType').html('');
        if (result.TreatmetPlantDisposalType != null) {

            for (var j = 0; j < result.TreatmetPlantDisposalType.length; j++) {

                addDisposalType(rowNum2);

                $('#hdnDisposalTypeId' + rowNum2).val(result.TreatmetPlantDisposalType[j].DisposalTypeId);
                $('#ddlMethodofDisposal' + rowNum2).val(result.TreatmetPlantDisposalType[j].MethodofDisposal);
                $('#ddlStatus' + rowNum2).val(result.TreatmetPlantDisposalType[j].Status);
                $('#txtDesignCapacity' + rowNum2).val(result.TreatmetPlantDisposalType[j].DesignCapacity);
                $('#txtLicensedCapacity' + rowNum2).val(result.TreatmetPlantDisposalType[j].LicensedCapacity);
                $('#ddlUnit' + rowNum2).val(result.TreatmetPlantDisposalType[j].Unit);

                rowNum2 = rowNum2 + 1;
            }
        }
        else {
            addDisposalType(rowNum2); 
        }

        $('#txtTreatmentPlantCode1').val(result.TreatmentPlantCode);
        $('#txtTreatmentPlantCode2').val(result.TreatmentPlantCode);
        $('#txtTreatmentPlantName1').val(result.TreatmentPlantName);
        $('#txtTreatmentPlantName2').val(result.TreatmentPlantName);

        getVehicleDetails(result.TreatmentPlantId);
        getDriverDetails(result.TreatmentPlantId);

    }
}

function addLicenseCode(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /> <input type="hidden" id="hdnLicenseCodeId' + num + '" value="0" /></td>';
    var Licensecode = '<td id="LicCodeError"><input type="text" required class="form-control HWMSLicence" placeholder="Please Select" id="txtLicenseCode' + num + '" autocomplete="off" name="FailureType" maxlength="25" >   <input type = "hidden" id="hdnLicensecode ' + num + '" />   <div class="col-sm-12" style="position:absolute; width:160px;" id="divLicenseFetch' + num + '">   </div>   </td >';
    var LicenseDescription = '<td> <input type="text"  class="form-control" disabled id="txtLicenseDescription' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var LicenseNo = '<td> <input type="text" required class="form-control" id="txtLicenseNo' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var Class = '<td> <input type="text"  class="form-control" id="txtClass' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var Issuedate = '<td> <input type="text" required class="form-control datetime" id="txtIssueDate' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var Expirydate = '<td> <input type="text" required class="form-control datetime" id="txtExpiryDate' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';

    $("#tbodyLicenseCode").append('<tr>' + CheckBox + Licensecode + LicenseDescription + LicenseNo + Class + Issuedate + Expirydate + '</tr>');
}

function addDisposalType(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /> <input type="hidden" id="hdnDisposalTypeId' + num + '" value="0" /></td>';
    var MethodofDisposal = '<td> <select required class="form-control" id="ddlMethodofDisposal' + num + '"> ' + MethodofDisposalValues + ' </select></td>';
    var Status = '<td> <select required class="form-control" id="ddlStatus' + num + '">' + StatusValues + ' </select></td>';
    var DesignCapacity = '<td> <input type="text"  class="form-control" id="txtDesignCapacity' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var LicensedCapacity = '<td> <input type="text"  class="form-control" id="txtLicensedCapacity' + num + '" autocomplete="off" name="FailureType" maxlength="25"  /></td>';
    var Unit = '<td>  <select required class="form-control" id="ddlUnit' + num + '">' + UnitValues + '</select><d>';

    $("#tbodyDisposalType").append('<tr>' + CheckBox + MethodofDisposal + Status + DesignCapacity + LicensedCapacity + Unit + '</tr>');

}

function getVehicleDetails(TreatmentPlantId) {

    $.get("/api/TreatmentPlant/VehicleDetailsFetch/" + TreatmentPlantId, function (response) {

        var result = JSON.parse(response);
        if (result != null) {
            for (var i = 0; i < result.length; i++) {

                var VehicleNo = '<td> <input type="text" class="form-control" id="txtVehicleNo' + i + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var Manufacturer = '<td> <input type="text" class="form-control" id="txtManufacturer' + i + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var LoadWeight = '<td>  <input type="text" class="form-control" id="txtLoadWeight' + i + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var EffectiveDate = '<td>  <input type="text"  class="form-control datetimeNoFuture" id="txtEffectiveDate' + i + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var Status = '<td>  <input type="text"  class="form-control" id="txtStatus' + i + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';

                $("#tbodyVehicles").append('<tr>' + VehicleNo + Manufacturer + LoadWeight + EffectiveDate + Status + '</tr>');

                $('#txtVehicleNo' + i).val(result[i].VehicleNo);
                $('#txtManufacturer' + i).val(result[i].Manufacturer);
                $('#txtLoadWeight' + i).val(result[i].LoadWeight);
                var effectiveDate = getCustomDate(result[i].EffectiveDate);
                $('#txtEffectiveDate' + i).val(effectiveDate);
                $('#txtStatus' + i).val(result[i].Status);

            }
        }
    });
}

function getDriverDetails(TreatmentPlantId) {

    $.get("/api/TreatmentPlant/DriverDetailsFetch/" + TreatmentPlantId, function (response) {

        var result = JSON.parse(response);
        if (result != null) {
            for (var j = 0; j < result.length; j++) {

                var DriverCode = '<td>  <input type="text" required class="form-control" id="txtDriverCode' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var DriverName = '<td> <input type="text" required class="form-control" id="txtDriverName' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var ClassGrade = '<td>  <input type="text" required class="form-control" id="txtGrade' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var IssuedBy = '<td>  <input type="text" required class="form-control" id="txtIssuedBy' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var IssuedDate = '<td>  <input type="text" required class="form-control datetimeNoFuture" id="txtIssuedDate' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var EffectiveDatee = '<td> <input type="text" required class="form-control datetimeNoFuture" id="txtDriverEffectiveDate' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';
                var Statuss = '<td>   <input type="text" required class="form-control" id="ddlDriverStatus' + j + '" disabled autocomplete="off" name="FailureType" maxlength="25"  /></td>';

                $("#tbodyDrivers").append('<tr class="tablerowe">' + DriverCode + DriverName + ClassGrade + IssuedBy + IssuedDate + EffectiveDatee + Statuss + '</tr>');

                $('#txtDriverCode' + j).val(result[j].DriverCode);
                $('#txtDriverName' + j).val(result[j].DriverName);
                $('#txtGrade' + j).val(result[j].ClassGrade);
                $('#txtIssuedBy' + j).val(result[j].IssuedBy);
                var issuedDate = getCustomDate(result[j].IssuedDate);
                $('#txtIssuedDate' + j).val(issuedDate);
                var effectiveDate = getCustomDate(result[j].EffectiveDate);
                $('#txtDriverEffectiveDate' + j).val(effectiveDate);
                $('#ddlDriverStatus' + j).val(result[j].Status);

            }
        }
    });
}


function EmptyFields() {

    $('#formTreatmentPlant')[0].reset();

    $('#primaryID').val(0);
    $('[id^=hdnLicenseCodeId]').val(0);
    $('[id^=hdnDisposalTypeId]').val(0);
    
    $('#code').removeClass('has-error');
    $('#plantname').removeClass('has-error');
    $('#address').removeClass('has-error');
    $('#state').removeClass('has-error');
    $('#postcode').removeClass('has-error');
    $('#ownership').removeClass('has-error');
    $('#contactnumber').removeClass('has-error');
    $('#doefile').removeClass('has-error');
    $('#ownername').removeClass('has-error');
    $('#ownership').removeClass('has-error');
    $('#city').removeClass('has-error');

    $('#licensecode').removeClass('has-error');
    $('#description').removeClass('has-error');
    $('#licenseno').removeClass('has-error');
    $('#failuretype').removeClass('has-error');
    $('#issuedate').removeClass('has-error');
    $('#expirydate').removeClass('has-error');

    $('#disposal').removeClass('has-error');
    $('#status').removeClass('has-error');
    $('#type').removeClass('has-error');
    $('#unit').removeClass('has-error');
    $('#capacity').removeClass('has-error');

    $('#errorMsg').css('visibility', 'hidden');

    var i = 1;
    $("#tbodyLicenseCode").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

    i = 1;
    $("#tbodyDisposalType").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

}


$("#jQGridCollapse1").click(function () {
    // $(".jqContainer").toggleClass("hide_container");
    var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
})

 $(".nav-tabs > li:not(:first-child)").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert("Save the details before moving on to Other!");
            return false;
        }
 });

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