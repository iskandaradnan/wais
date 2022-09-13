var ListModel = "";     //image Logo
var customerList = null;

$(document).ready(function () {
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnEditVariation').hide();
    $("#jQGridCollapse1").click();
    $('#myPleaseWait').modal('show');
    formInputValidation("facilityform");
    var Id = $('#primaryID').val();
    if (Id == null || Id == "0") {
        AddFirstGridRow();
    }
    var optionHtml = "";
    optionHtml += '<option value="' + 1 + '">' + "Sunday" + '</option>';
    optionHtml += '<option value="' + 2 + '">' + "Monday" + '</option>';
    optionHtml += '<option value="' + 3 + '">' + "Tuesday" + '</option>';
    optionHtml += '<option value="' + 4 + '">' + "Wednesday" + '</option>';
    optionHtml += '<option value="' + 5 + '">' + "Thursday" + '</option>';
    optionHtml += '<option value="' + 6 + '">' + "Friday" + '</option>';
    optionHtml += '<option value="' + 7 + '">' + "Saturday" + '</option>';
    $("#WeekHoliday").html(optionHtml);
    $("#WeekHoliday").html(optionHtml);
    $('#MasterFEMSId').prop('disabled', false);
    $('#MasterBEMSId').prop('disabled', false);
    $('#MasterCLSId').prop('disabled', false);
    $('#MasterLLSId').prop('disabled', false);
    $('#MasterHWMSId').prop('disabled', false);
    setTimeout(multiSelectshow, 10);


    $.get("/api/Facility/Load")
        .done(function (result) {
            //$('#txtAssetClassificationCode,#AssetTypeCode,#AssetTypeDescription').prop('disabled', false);
            var loadResult = JSON.parse(result);
            //$("#jQGridCollapse1").click();           
            $.each(loadResult.TypeofNomenclatureLovs, function (index, value) {
                $('#TypeOfNomenclature').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Customers, function (index, value) {
                $('#selFacilityCustomer').append('<option value="' + value.CustomerId + '">' + value.CustomerName + '</option>');
            });

            customerList = loadResult.Customers;
            //$('#hdnCustomerId').val(loadResult.CustomerId);
            //$('#txtCustomerName').val(loadResult.CustomerName);
            //$('#txtCustomerCode').val(loadResult.CustomerCode);
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    $('#selFacilityCustomer').change(function () {
        $('#txtCustomerCode').val('');
        var customerId = $(this).val();
        if (customerId != 'null') {
            var selectedCustomer = $.grep(customerList, function (value, index) {
                return value.CustomerId == customerId;
            });
            $('#txtCustomerCode').val(selectedCustomer[0].CustomerCode);
        }
    });

    function CheckDuplicateRecords(list) {
        var isValid = true;

        list = Enumerable.From(list).Where(function (x) { return x.Active == true }).ToArray();

        var isNameDuplicate = false;
        var isEmailDuplicate = false;
        var iscontactNoDuplicate = false;
        for (i = 0; i < list.length; i++) {
            //   var name = list[i].Name;
            var email = list[i].Email;
            var contactNo = list[i].ContactNo;
            for (j = i + 1; j < list.length; j++) {


                if (email != null && email != "" && list[j].Email != null && list[j].Email != "") {
                    if (email.toLowerCase() == list[j].Email.toLowerCase()) {
                        isEmailDuplicate = true;
                    }
                }
                //if (contactNo != null && contactNo != "" && list[j].ContactNo != null && list[j].ContactNo != "") {
                //    if (contactNo == list[j].ContactNo) {
                //        iscontactNoDuplicate = true;
                //    }
                //}


            }
        }
        if (isEmailDuplicate) {
            isValid = false;
        }
        return isValid;
    }

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var _index;        // var _indexThird;
        var result = [];
        $('#ContactGrid tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeleted = $('#chkContactDelete_' + i).prop('checked');
            //  var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
            //var pPmCategoryDetId = $('#PPmCategoryDetId_' + i).val();

            //  if (!isDeleted && pPmCategoryDetId != "0")
            //  {
            var _tempObj = {
                FacilityContactInfoId: $('#FacilityContactInfoId_' + i).val(),
                Name: $('#Name_' + i).val(),
                Designation: $('#Designation_' + i).val(),
                ContactNo: $('#ContactNo_' + i).val(),
                Email: $('#Email_' + i).val(),
                Active: isDeleted ? false : true,
            }
            result.push(_tempObj);
        }


        var deleteCount = 0;
        if (result != null && result != '') {

            deleteCount = Enumerable.From(result).Where(function (x) { return x.Active == false }).Count();
        }

        if (deleteCount > 0) {
            var message = "Record(s) selected for deletion. Do you want to proceed?";
            bootbox.confirm(message, function (result) {
                if (result) {

                    SubmitData(CurrentbtnID);

                }
                else {
                    bootbox.hideAll();
                    return false;
                }

            });
        }
        else {

            SubmitData(CurrentbtnID);
        }

    });

    function SubmitData(CurrentbtnID) {
        $('#myPleaseWait').modal('show');
        var MasterFEMSId = 0;
        var MasterBEMSId = 0;
        var MasterCLSId = 0;
        var MasterLLSId = 0;
        var MasterHWMSId = 0;
        var ServicesList = $("#Services").val();
        //remove red color border
        var facilityId = $('#primaryID').val();
        //var customerId = $('#hdnCustomerId').val();
        var customerId = $('#selFacilityCustomer').val();
        var facilityName = $('#FacilityName').val();
        var FacilityCode = $('#FacilityCode').val();
        var address = $('#Address').val();
        var latitude = $('#Latitude').val();
        var longitude = $('#Longitude').val();
        var ActiveFrom = $('#ActiveFrom').val();
        var ActiveFromUTC = $('#ActiveFromUTC').val();
        var ActiveTo = $('#ActiveTo').val();
        var ActiveToUTC = $('#ActiveToUTC').val();
        var timestamp = $('#Timestamp').val();
        var selectidList = [];
        var WeekHoliday = $("#WeekHoliday").val();
        var cpimonths = $('#ContractPeriodInMonths').val();
        if ($('#MasterBEMSId').prop('checked') == true) {
            MasterBEMSId = 1;
        }
        if ($('#MasterFEMSId').prop('checked') == true) {
            MasterFEMSId = 1;
        }
        if ($('#MasterCLSId').prop('checked') == true) {
            MasterCLSId = 1;
        }
        if ($('#MasterLLSId').prop('checked') == true) {
            MasterLLSId = 1;
        }
        if ($('#MasterHWMSId').prop('checked') == true) {
            MasterHWMSId = 1;
        }
        // .multiselect("getChecked") can also be used.
        //if (WeekHoliday != null) {
        //    for (var i = 0; i < WeekHoliday.length; i++) {
        //        selectidList.push(WeekHoliday[i]);
        //    }
        //}
        //MasterBEMSId = ServicesList[0];
        //MasterBEMSId = ServicesList[1];
        //MasterCLSId = ServicesList[2];
        //MasterLLSId = ServicesList[4];
        //MasterHWMSId = ServicesList[3];
        var _index;        // var _indexThird;
        var result = [];
        $('#ContactGrid tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeleted = $('#chkContactDelete_' + i).prop('checked');
            //  var isDeletedcat = $('#IsDeletedCategory_' + i).prop('checked');
            //var pPmCategoryDetId = $('#PPmCategoryDetId_' + i).val();

            //  if (!isDeleted && pPmCategoryDetId != "0")
            //  {
            var _tempObj = {
                FacilityContactInfoId: $('#FacilityContactInfoId_' + i).val(),
                Name: $('#Name_' + i).val(),
                Designation: $('#Designation_' + i).val(),
                ContactNo: $('#ContactNo_' + i).val(),
                Email: $('#Email_' + i).val(),
                Active: isDeleted ? false : true,
            }
            result.push(_tempObj);
        }

        var count = 0;
        if (result != null && result != '') {
            count = Enumerable.From(result).Where(function (x) { return x.Active == true && x.Name != null && x.Name != '' }).Count();
        }
        var isFormValid = formInputValidation("facilityform", 'save');
        if (!isFormValid || (longitude == 0 || longitude == "0") || latitude == 0 || latitude == "0" || address.trim() == "" || facilityName.trim() == ""
            ) {


            if (longitude == 0 || longitude == "0") {
                $('#Longitude').parent().addClass('has-error');
            }
            if (latitude == 0 || latitude == "0") {
                $('#Latitude').parent().addClass('has-error');
            }
            if (address.trim() == "") {
                $('#Address').parent().addClass('has-error');
            }
            if (facilityName.trim() == "") {
                $('#FacilityName').parent().addClass('has-error');
            }
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (count == 0) {
            //  alert('dam 2');
            bootbox.alert("Contact Info grid should contain atleast one record");
            $('#chkContactDeleteAll').prop('checked', false);
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (!CheckDuplicateRecords(result)) {
            // alert('dam 3');
            $("div.errormsgcenter").text("Contact Person email already exists");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (ActiveFrom == null || ActiveFrom == "") {
            // alert('dam 4');
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#ActiveFrom').parent().addClass('has-error');
            $('#myPleaseWait').modal('hide');
            //show red color border
            return false;
        }
        else if (parseInt(cpimonths) <= 0 || cpimonths == "0") {
            // alert('dam 6');
            $("div.errormsgcenter").text("Contract Period In Months should be greater than Zero");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            // $('#ContractPeriodInMonths').parent().addClass('has-error');
            return false;
        }
        else if (ActiveFrom != null && ActiveFrom != "" && ActiveTo != null && ActiveTo != "") {

            var ActiveFromDate = getDateToCompare($('#ActiveFrom').val());
            var ActiveToDate = getDateToCompare($('#ActiveTo').val());
            if (ActiveFromDate > ActiveToDate) {
                // alert('dam 5');
                $("div.errormsgcenter").text("Active To Date Should be greater than Active From Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#btnlogin').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                $('#ActiveTo').parent().addClass('has-error');
                return false;
            }
        }


        var initialProjectCost = $('#InitialProjectCost').val();
        initialProjectCost = initialProjectCost.split(',').join('');


        var FacilityData = {};
        //  ContractorVendor.ContractorId = contractorId;
        FacilityData.CustomerId = customerId;
        FacilityData.FacilityName = facilityName;
        FacilityData.FacilityCode = FacilityCode;
        FacilityData.Address = address;
        FacilityData.Latitude = latitude;
        FacilityData.Longitude = longitude;
        FacilityData.ActiveFrom = ActiveFrom;
        FacilityData.ActiveFromUTC = ActiveFrom;
        FacilityData.ActiveTo = ActiveTo;
        FacilityData.ActiveToUTC = ActiveTo;
        FacilityData.Timestamp = timestamp;
        FacilityData.Address2 = $('#Address2').val();
        FacilityData.Postcode = $('#Postcode').val();
        FacilityData.State = $('#State').val();
        FacilityData.Country = $('#Country').val();
        FacilityData.ContractPeriodInYears = cpimonths;
        FacilityData.InitialProjectCost = initialProjectCost;
        FacilityData.ContactNo = $('#ContactNo').val();
        FacilityData.FaxNo = $('#FaxNo').val();
        FacilityData.WeeklyHolidays = WeekHoliday;
        FacilityData.ContactInfoList = result;
        FacilityData.TypeOfNomenclature = $('#TypeOfNomenclature').val();
        FacilityData.WarrantyRenewalNoticeDays = $('#WarrantyRenewalNoticeDays').val();
        FacilityData.BEMS = MasterBEMSId;
        FacilityData.FEMS = MasterFEMSId;
        FacilityData.CLS = MasterCLSId;
        FacilityData.LLS = MasterLLSId;
        FacilityData.HWMS = MasterHWMSId;

        //  FacilityData.LifeExpectancy = $('#LifeExpectancy').val();

        FacilityData.Base64StringLogo = ListModel;     // image Logo

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            FacilityData.FacilityId = primaryId;
            FacilityData.Timestamp = timestamp;
        }
        else {
            FacilityData.FacilityId = 0;
            FacilityData.FacilityData = "";
        }

        var jqxhr = $.post("/api/Facility/Add", FacilityData, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.FacilityId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.FacilityId != 0) {
                $("#FacilityName,#FacilityCode").attr("disabled", "disabled");
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $('#primaryID').val(result.FacilityId);
            $('#FacilityId,#primaryID').val(result.FacilityId);
            $('#selFacilityCustomer').attr('disabled', true);
            $('#FacilityName').val(result.FacilityName);
            $('#FacilityCode').val(result.FacilityCode);
            $('#Address').val(result.Address);
            $('#Latitude').val(result.Latitude);
            $('#Longitude').val(result.Longitude);
            $('#hdnAttachId').val(result.HiddenId);
            if (result.ActiveFrom != null) {
                $('#ActiveFrom').val(DateFormatter(result.ActiveFrom));
            }
            if (result.ActiveTo != null) {
                $('#ActiveTo').val(DateFormatter(result.ActiveTo));
            }
            $('#Timestamp').val(result.Timestamp);
            $("#FacilityName,#FacilityCode").attr("disabled", "disabled");
            $('#Address2').val(result.Address2);
            $('#State').val(result.State);
            $('#Postcode').val(result.Postcode);
            $('#Country').val(result.Country);
            $('#ContractPeriodInMonths').val(result.ContractPeriodInYears);
            $('#InitialProjectCost').val(addCommas(result.InitialProjectCost));
            if (result.MonthlyServiceFee != null) {
                $('#MonthlyServiceFee').val(addCommas(result.MonthlyServiceFee));
            }
            else {
                $('#MonthlyServiceFee').val(result.MonthlyServiceFee);
            }

            $('#TypeOfNomenclature').val(result.TypeOfNomenclature);
            $('#WarrantyRenewalNoticeDays').val(result.WarrantyRenewalNoticeDays);  
            if ( result.IsContractPeriodChanged == "1" || result.IsContractPeriodChanged == 1) {
                $('#btnEditVariation').show();
            }
            else {
                $('#btnEditVariation').hide();
            }

            //*********************** Image Logo Start ****************************

            if (result.Base64StringLogo != "" && result.Base64StringLogo != null) {

                $('#showModalImg').show();
                $("#facilityImageUpload").val("");
                var str = 'data:image/png;base64,' + result.Base64StringLogo;
                document.getElementById('imgvid1').setAttribute('src', str);
            }
            else {
                $('#showModalImg').hide();
            }

            //*********************** Image Logo End ****************************


            if (result.ContactInfoList != null) {
                $('#ContactGrid').empty();
                $.each(result.ContactInfoList, function (index, data) {
                    AddFirstGridRow();
                    $('#FacilityContactInfoId_' + index).val(data.FacilityContactInfoId);
                    $('#Name_' + index).val(data.Name);
                    $('#Designation_' + index).val(data.Designation);
                    $('#ContactNo_' + index).val(data.ContactNo);
                    $('#Email_' + index).val(data.Email);
                });
            }
            setTimeout(multiSelectshow, 10);
            $("#WeekHoliday").val(result.WeeklyHolidays);
            $(".content").scrollTop(0);
            showMessage('Facility', CURD_MESSAGE_STATUS.SS);
            //$("#top-notifications").show();
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
                // $("#top-notifications").hide();
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                //  window.location.reload();
                ClearFields();
            }
        },
       "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
            if (errorMessage == "1") {
                errorMessage = "Active From Date cannot be Future Date";
                $('#ActiveFrom').parent().addClass('has-error');
            }
            if (errorMessage == "2") {
                errorMessage = "Contract Period In Months should be greater than 0";
                $('#ContractPeriodInYears').parent().addClass('has-error');
            }

            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    }



    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
});

$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    $('#ContactGrid tr').each(function (index, value) {
        if (isChecked) {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#Name_' + index).removeAttr('required');
            $('#Name_' + index).parent().removeClass('has-error');
        }
        else {
            $('#Name_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
});
function DeleteContact(currentindex) {


    var rowCount = $('#ContactGrid tr:last').index() + 1;
    var _index;        // var _indexThird;
    var result = [];
    $('#ContactGrid tr').each(function () {
        _index = $(this).index();
    });


    for (var i = 0; i <= _index; i++) {
        var active = true;
        var isDeleted = $('#chkContactDelete_' + i).prop('checked');
        var _tempObj = {
            CustomerContactInfoId: $('#CustomerContactInfoId_' + i).val(),
            Name: $('#Name_' + i).val(),
            Designation: $('#Designation_' + i).val(),
            ContactNo: $('#ContactNo_' + i).val(),
            Email: $('#Email_' + i).val(),
            Active: isDeleted ? false : true,
        }
        result.push(_tempObj);
    }

    var count = Enumerable.From(result).Where(function (x) { return x.Active == false }).Count();
    if (count == rowCount) {
        $('#chkContactDeleteAll').prop('checked', true);
    }
    else {
        $('#chkContactDeleteAll').prop('checked', false);
    }
    //else {
    if ($('#chkContactDelete_' + currentindex).is(":checked")) {
        $('#Name_' + currentindex).removeAttr('required');
        $('#Name_' + currentindex).parent().removeClass('has-error');
        $('#chkContactDelete_' + currentindex).parent().addClass('bgDelete');
    }
    else {
        $('#Name_' + currentindex).attr('required', true);
        $('#chkContactDelete_' + currentindex).parent().addClass('bgDelete');
        //$('#Name_' + currentindex).attr('required', true);
        $('#chkContactDelete_' + currentindex).parent().removeClass('bgDelete');
    }
    // }
}
function AddFirstGridRow() {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="checkbox" onchange="DeleteContact(maxindexval)" id="chkContactDelete_maxindexval" /></td>' +
            '<td width="25%" style="text-align: center;" ><div><input type="hidden" id= "FacilityContactInfoId_maxindexval">  ' +
            ' <input type="text" id="Name_maxindexval" name="Name" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><td width="20%" style="text-align: center;" ><div> ' +
            '<input id="Designation_maxindexval" type="text" class="form-control " maxlength="100"  name="Designation" autocomplete="off" tabindex="0" ></div></td><td width="20%" style="text-align: center;" ><div>' +
            ' <input id="ContactNo_maxindexval" type="text" class="form-control " maxlength="15"  name="ContactNo" autocomplete="off" tabindex="0" ></div></td><td width="30%" style="text-align: center;" ><div>' +
            ' <input id="Email_maxindexval" type="text" class="form-control " maxlength="50"  name="Email" autocomplete="off" ></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("input[id^='Name_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='Designation_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');
    $("input[id^='ContactNo_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='Email_']").attr('pattern', '^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$');
    formInputValidation("facilityform");

}


$('#contactBtn').click(function () {

    var rowCount = $('#ContactGrid tr:last').index();
    var name = $('#Name_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && name == "") {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    var action = "";
    $("#facilityform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#spnPopup-Customer').hide();
    $('#errorMsg').css('visibility', 'hidden');
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
        $("#UAform :input:not(:button)").prop("disabled", true);
        $('#levlcodepopup,#hospStaffpopup,#companypopup').hide();
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $("#UAform :input:not(:button)").prop("disabled", false);
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Facility/get/" + primaryId)
            .done(function(result)
            {
              var result = JSON.parse(result);
              $('#chkContactDeleteAll').prop('checked', false);
              $('#primaryID').val(result.FacilityId);
              $('#FacilityId,#primaryID').val(result.FacilityId);
              $('#selFacilityCustomer').attr('disabled', true);
              //$('#hdnCustomerId').val(result.CustomerId);
              //$('#txtCustomerName').val(result.CustomerName);
              $('#selFacilityCustomer').val(result.CustomerId);
              $('#txtCustomerCode').val(result.CustomerCode);
              $('#FacilityName').val(result.FacilityName);
              $('#FacilityCode').val(result.FacilityCode);
              $('#Address').val(result.Address);
              $('#Latitude').val(result.Latitude);
              $('#Longitude').val(result.Longitude);
              $('#hdnAttachId').val(result.HiddenId);
              $('#ContactNo').val(result.ContactNo);
              $('#btnDelete').show();
              $('#FaxNo').val(result.FaxNo);
              if (result.ActiveFrom != null) {
                  $('#ActiveFrom').val(DateFormatter(result.ActiveFrom));
              }
              if (result.ActiveTo != null) {
                  $('#ActiveTo').val(DateFormatter(result.ActiveTo));
              }
              $('#Timestamp').val(result.Timestamp);
              $("#FacilityName,#FacilityCode").attr("disabled", "disabled");
              $('#Address2').val(result.Address2);
              $('#State').val(result.State);
              $('#Postcode').val(result.Postcode);
              $('#Country').val(result.Country);
              $('#ContractPeriodInMonths').val(result.ContractPeriodInYears);
              $('#InitialProjectCost').val(addCommas(result.InitialProjectCost));

              if (result.IsContractPeriodChanged == "1" || result.IsContractPeriodChanged == 1) {
                  $('#btnEditVariation').show();
              }
              else {
                  $('#btnEditVariation').hide();
              }
              //-------------binding services-------------
                $('#MasterFEMSId').prop('disabled', true);
                $('#MasterBEMSId').prop('disabled', true);
                $('#MasterCLSId').prop('disabled', true);
                $('#MasterLLSId').prop('disabled', true);
                $('#MasterHWMSId').prop('disabled', true);
              if (result.FEMS == 1)
              {
                  $("#MasterFEMSId").prop("checked", true);
              } else
              {
                  $("#MasterFEMSId").prop("checked", false);
              }

              if (result.BEMS == 1) {
                  $("#MasterBEMSId").prop("checked", true);
              } else
              {
                  $("#MasterBEMSId").prop("checked", false);
              }

              if (result.CLS == 1) {
                  $("#MasterCLSId").prop("checked", true);
              } else {
                  $("#MasterCLSId").prop("checked", false);
              }

                if (result.LLS == 1)
                {
                  $("#MasterLLSId").prop("checked", true);
              } else
              {
                    $("#MasterLLSId").prop("checked", false);
              }

              if (result.HWMS == 1) {
                  $("#MasterHWMSId").prop("checked", true);
              } else
              {
                  $("#MasterHWMSId").prop("checked", false);
              }
              
              //--------------------------------------------










              //   $('#LifeExpectancy').val(result.LifeExpectancy);
              $('#TypeOfNomenclature').val(result.TypeOfNomenclature);

              if (result.MonthlyServiceFee != null) {
                  $('#MonthlyServiceFee').val(addCommas(result.MonthlyServiceFee));
              }
              else {
                  $('#MonthlyServiceFee').val(result.MonthlyServiceFee);
              }
              // $('#MonthlyServiceFee').val(result.MonthlyServiceFee);
              $('#WarrantyRenewalNoticeDays').val(result.WarrantyRenewalNoticeDays);

              //*********************** Image Logo Start ****************************

              if (result.Base64StringLogo != "" && result.Base64StringLogo != null) {
                  ListModel = result.Base64StringLogo;
                  $('#showModalImg').show();
                  $("#facilityImageUpload").val("");
                  var str = 'data:image/png;base64,' + result.Base64StringLogo;
                  document.getElementById('imgvid1').setAttribute('src', str);
              }
              else {
                  $('#showModalImg').hide();
              }

              //*********************** Image Logo End ****************************

              if (result.ContactInfoList != null) {
                  $('#ContactGrid').empty();
                  $.each(result.ContactInfoList, function (index, data) {
                      AddFirstGridRow();
                      $('#FacilityContactInfoId_' + index).val(data.FacilityContactInfoId);
                      $('#Name_' + index).val(data.Name);
                      $('#Designation_' + index).val(data.Designation);
                      $('#ContactNo_' + index).val(data.ContactNo);
                      $('#Email_' + index).val(data.Email);
                  });
              }
              setTimeout(multiSelectshow, 10);
              $("#WeekHoliday").val(result.WeeklyHolidays);




              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $("#FacilityName,#FacilityCode").removeAttr("disabled");

        $('#myPleaseWait').modal('hide');
    }
}




$('#btnEditVariation').click(function () {
    var primaryId = $('#primaryID').val();
    var obj = {};
    obj.FacilityId = primaryId;
    var message = "Do you want to calculate Variation?";
    bootbox.confirm(message, function (result) {
        if (result) {
            if (primaryId != null && primaryId != "0") {

                var jqxhr = $.post("/api/Facility/AddVariation", obj, function (response) {
                    var result = JSON.parse(response);
                    $('#Timestamp').val(result.Timestamp);
                    if (result.varationAssetCount == 0 || result.varationAssetCount == "0") {
                        bootbox.alert("No Assets available for Variation calculation");
                        $('#btnEditVariation').show();
                    }
                    else {
                        bootbox.alert("New Variation calculated for all the assets in the facility");
                        $('#btnEditVariation').hide();
                    }                  
                    
                },
                    "json")
                     .fail(function (response) {
                         var errorMessage = "";
                         if (response.status == 400) {
                             errorMessage = response.responseJSON;
                         }
                         else {
                             errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                         }
                        
                         $('#myPleaseWait').modal('hide');
                     });
            }
        }
        else {
            bootbox.hideAll();
        }
    });








});



function multiSelectshow() {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

}
$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/Facility/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Facility', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 //window.location.reload();
                 ClearFields();
             })
             .fail(function () {
                 showMessage('Facility', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function ClearFields() {
    $(".content").scrollTop(0);
    $('#chkContactDeleteAll').prop('checked', false);
    $('#btnEditVariation').hide();
    $('#hdnAttachId').val('');
    $("#facilityImageUpload").val("");
    $('#imgvid1').attr('src', '');
    $('#showModalImg').hide();
    $('#ContactNo').val(''),
    $('#FaxNo').val(''),
    $('#FacilityName').val('');
    $('#FacilityCode').val('');
    $('#FacilityName').removeAttr("disabled");
    $('#FacilityCode').removeAttr("disabled");
    $('#Address').val('');
    $('#Latitude').val('');
    $('#Longitude').val('');
    $('#ActiveFrom').val('');
    $('#ActiveTo').val('');
    $('#Address2').val('');
    $('#State').val('');
    $('#Postcode').val('');
    $('#Country').val('');
    $('#WarrantyRenewalNoticeDays').val('');
    $('#ContractPeriodInMonths').val('');
    $('#InitialProjectCost').val('');
    $('#MonthlyServiceFee').val('');
    $('#ContactGrid').empty();
    $('#TypeOfNomenclature').val(116);
    // $('#LifeExpectancy').val('null');
    $('#spnActionType').text('Add');
    $('#primaryID').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#selFacilityCustomer').attr('disabled', false);
    $('#selFacilityCustomer').val('null');
    $('#txtCustomerCode').val('');
    AddFirstGridRow();
    $("#grid").trigger('reloadGrid');
    $("#facilityform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    $('#sparePartImageUpload').val('');
    var optionHtml = "";

    optionHtml += '<option value="' + 1 + '">' + "Sunday" + '</option>';
    optionHtml += '<option value="' + 2 + '">' + "Monday" + '</option>';
    optionHtml += '<option value="' + 3 + '">' + "Tuesday" + '</option>';
    optionHtml += '<option value="' + 4 + '">' + "Wednesday" + '</option>';
    optionHtml += '<option value="' + 5 + '">' + "Thursday" + '</option>';
    optionHtml += '<option value="' + 6 + '">' + "Friday" + '</option>';
    optionHtml += '<option value="' + 7 + '">' + "Saturday" + '</option>';
    $("#WeekHoliday").html(optionHtml);
    $('#MasterFEMSId').prop('disabled', false);
    $('#MasterBEMSId').prop('disabled', false);
    $('#MasterCLSId').prop('disabled', false);
    $('#MasterLLSId').prop('disabled', false);
    $('#MasterHWMSId').prop('disabled', false);
    setTimeout(multiSelectshow, 10);
}


//***************************** Image Logo Upoad *******************************************

function getfacilityLogoImageDetails(e) {

    var primaryId = $("#primaryID").val();
    var FacilityId = $("#FacilityId").val();

    for (var i = 0; i < e.files.length; i++) {
        var f = e.files[i];
        var file = f;
        var blob = e.files[i].slice();
        var filetype = file.type;
        var filesize = file.size;
        var FileName = file.name;
        var filewidth = file.filewidth;
        var fileheight = file.fileheight;
        var extension = FileName.replace(/^.*\./, '');
        var reader = new FileReader();

        var ImgappType = ['image/jpeg', 'image/jpg', 'image/png'];
        var ImgMaxSize = 4194304;   //  - 4Mb;

        if (filetype == "image/png") {
            if (ImgMaxSize >= filesize) {

                function getB64Str(buffer) {
                    var binary = '';
                    var bytes = new Uint8Array(buffer);
                    var len = bytes.byteLength;
                    for (var i = 0; i < len; i++) {
                        binary += String.fromCharCode(bytes[i]);
                    }
                    return window.btoa(binary);
                }

                reader.onloadend = function (evt) {
                    if (evt.target.readyState == FileReader.DONE) {
                        var cont = evt.target.result;
                        var base64String = getB64Str(cont);
                        if (primaryId == 0 || primaryId == null) {
                            ListModel = base64String;
                        }
                        else {
                            if (FacilityId == primaryId) {
                                ListModel = base64String;
                            }
                        }
                    }
                };
                reader.readAsArrayBuffer(blob);
                $('#showModalImg').show();
                var Ioutput = document.getElementById('imgvid1');
                Ioutput.src = URL.createObjectURL(event.target.files[0]);
            }
            else {
                bootbox.alert("File size must be less than 4MB.");
                $("#facilityImageUpload").val("");
            }
        }
        else {
            bootbox.alert("Please upload png format Only.");
            $("#facilityImageUpload").val("");
        }

    }
}


window.multiSelectshow = function () {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

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