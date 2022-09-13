$(function () {
    $('#Specialization').multiselect();
})
$(function () {
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("candvform");

    var Id = $('#primaryID').val();
    if (Id == null || Id == "0") {
        AddFirstGridRow();
    }
    //  $("#Remarks").attr('pattern', '^[a-zA-Z0-9'.'",:;/\(\),\-\s\!@\#\$\%\&\*]+$');

    $('#SSMRegistrationCode,#ContractorName').prop('disabled', false);
    setTimeout(multiSelectshow, 10);
    $.get("/api/ContractorandVendor/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.CountryList, function (index, value) {
                $('#CountryId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            var optionHtml = "";
            for (var i = 0; i < loadResult.SpecializationList.length; i++) {
                optionHtml += '<option value="' + loadResult.SpecializationList[i].LovId + '">' + loadResult.SpecializationList[i].FieldValue + '</option>';
            }
            $("#Specialization").html(optionHtml);
            // $("#Specialization").multiselect("refresh");
            setTimeout(multiSelectshow, 10);

        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });
    //function multiSelectshow() {
    //    $('select[name=Flag]').multiselect('destroy');
    //    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

    //}
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

    function isEmail(email) {
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        return regex.test(email);
    }
    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#SSMRegistrationCode').parent().removeClass('has-error')
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var _index;        // var _indexThird;
        var result = [];
        $('#ContactGrid tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeleted = $('#chkContactDelete_' + i).prop('checked');           
            var _tempObj = {
                ContractorContactInfoId: $('#ContractorContactInfoId_' + i).val(),
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

    function SubmitData(CurrentbtnID)
    {
        $('#myPleaseWait').modal('show');
        
       
        //remove red color border
        var contractorId = $('#primaryID').val();
        var sMRegistrationCode = $('#SSMRegistrationCode').val();
        var contractorName = $('#ContractorName').val();
        var selectidList = [];
        var specialization = $("#Specialization").val();
        // .multiselect("getChecked") can also be used.
        if (specialization != null) {
            for (var i = 0; i < specialization.length; i++) {
                selectidList.push(specialization[i]);
            }
        }
        var Active = $('#Active').val();
        var status = true;
        if (Active == 1) {
            status = true;
        }
        else {
            status = false;
        }
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
                ContractorContactInfoId: $('#ContractorContactInfoId_' + i).val(),
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
        var address = $('#Address').val();
        var state = $('#State').val();
        var contactPerson = $('#ContactPerson').val();
        var contactNo = $('#ContactNo').val();
        var designation = $('#Designation').val();
        var email = $('#Email').val();
        var faxNo = $('#FaxNo').val();
        var remarks = $('#Remarks').val();
        var timestamp = $('#Timestamp').val();

        var isFormValid = formInputValidation("candvform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (count == 0) {
            bootbox.alert("Contact Info grid should contain atleast one record");
            $('#chkContactDeleteAll').prop('checked', false);
            //$("div.errormsgcenter").text("Contact Info grid should contain atleast one record");
            // $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }
        else if (!CheckDuplicateRecords(result)) {
            $("div.errormsgcenter").text("Duplicate Record Exists");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        var ContractorVendor = {};
        //  ContractorVendor.ContractorId = contractorId;
        ContractorVendor.SSMRegistrationCode = sMRegistrationCode;
        ContractorVendor.ContractorName = contractorName;
        ContractorVendor.Active = status;
        ContractorVendor.Specialization = specialization;
        ContractorVendor.Address = address;
        ContractorVendor.State = state;
        ContractorVendor.ContactNo = $('#ContactNo').val();;

        //ContractorVendor.ContactPerson = contactPerson;

        //ContractorVendor.ContactNo = contactNo;
        //ContractorVendor.Designation = designation;
        //ContractorVendor.Email = email;
        ContractorVendor.FaxNo = faxNo;
        ContractorVendor.Remarks = remarks;
        ContractorVendor.Timestamp = timestamp;
        ContractorVendor.Address2 = $('#Address2').val();
        ContractorVendor.Postcode = $('#Postcode').val(),
        ContractorVendor.NoOfUserAccess = $('#NoofUsersAccess').val();
        ContractorVendor.CountryId = $('#CountryId').val();
        //ContractorVendor.Country= $('#Country').val();
        ContractorVendor.ContactInfoList = result;
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            ContractorVendor.ContractorId = primaryId;
            ContractorVendor.Timestamp = timestamp;
        }
        else {
            ContractorVendor.ContractorId = 0;
            ContractorVendor.Timestamp = "";
        }

        var jqxhr = $.post("/api/ContractorandVendor/Add", ContractorVendor, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.ContractorId);
            $("#Timestamp").val(result.Timestamp);
            BindData(result);
            $('#hdnAttachId').val(result.HiddenId);
            $("#grid").trigger('reloadGrid');
            if (result.ContractorId != 0) {
                $('#SSMRegistrationCode,#ContractorName').prop('disabled', true);
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
                $('#chkContactDeleteAll').prop('checked', false);
            }
            $(".content").scrollTop(0);
            showMessage('Contractor and Vendor', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);


            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
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
            if (errorMessage == 'Contractor / Vendor Registration Number should be unique') {
                $('#SSMRegistrationCode').parent().addClass('has-error');
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#SSMRegistrationCode,#ContractorName').prop('disabled', false);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });

    }
    $('#btnAddNew').click(function () {
        window.location.reload();
    });

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
});
function LinkClicked(id) {
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $('#candvform').animate({ scrollTop: 0 }, 'slow');
    $("#candvform :input:not(:button)").parent().removeClass('has-error');
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
        $.get("/api/ContractorandVendor/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              BindData(getResult);
              $('#hdnAttachId').val(getResult.HiddenId);
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $('#SSMRegistrationCode,#ContractorName').prop('disabled', false);
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/ContractorandVendor/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('ContractorandVendor', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 //  window.location.reload();
                 ClearFields();
             })
             .fail(function () {
                 showMessage('ContractorandVendor', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }
    });
}

function ClearFields() {
    $(".content").scrollTop(0);
    $('#chkContactDeleteAll').prop('checked', false);
    $('.nav-tabs a:first').tab('show');
    $("input[type=text],textarea").val("");
    $("textarea").val("");
    $('#SSMRegistrationCode').removeAttr("disabled");
    $('#ContractorName').removeAttr("disabled");
    $('#spnActionType').text('Add');
    $('#primaryID').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#CountryId').val('null');
    $('#Active').val(1);
    $('#ContactNo').val('');
    setTimeout(multiSelectshow, 10);
    $("#Specialization").val(null);
    $("#grid").trigger('reloadGrid');
    $('#ContactGrid').empty();
    AddFirstGridRow();
    $("#candvform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
}

$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    //var index1; $('#chkContactDeleteAll').prop('checked', true);
    // var count = 0;
    $('#ContactGrid tr').each(function (index, value) {
        // if (index == 0) return;
        // index1 = index - 1;
        if (isChecked) {
            // if(!$('#chkContactDelete_' +index1).prop('disabled'))
            // {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#Name_' + index).removeAttr('required');
            $('#Name_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
            //{
            $('#Name_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            // }
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
var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="checkbox" onchange="DeleteContact(maxindexval)" id="chkContactDelete_maxindexval" /></td>' +
            ' <td width="25%" style="text-align: center;" ><div><input type="hidden" id= "ContractorContactInfoId_maxindexval">  ' +
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
    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("candvform");

}

window.BindData = function (getResult) {
    $('#chkContactDeleteAll').prop('checked', false);
    $('#primaryID').val(getResult.ContractorId);
    $('#SSMRegistrationCode').val(getResult.SSMRegistrationCode);
    $('#ContractorName').val(getResult.ContractorName);
    if (getResult.Active) {
        //$("#ContractorStatus").prop('checked', true);
        $('#Active').val(1);
    }
    else {
        $('#Active').val(0);
    }
    $('#Address').val(getResult.Address);
    $('#State').val(getResult.State);
    $('#ContactPerson').val(getResult.ContactPerson);
    $('#ContactNo').val(getResult.ContactNo);
    $('#Designation').val(getResult.Designation);
    $('#Email').val(getResult.Email);
    $('#FaxNo').val(getResult.FaxNo);
    $('#Remarks').val(getResult.Remarks);
    $('#Timestamp').val(getResult.Timestamp);
    $('#Address2').val(getResult.Address2);
    $('#Postcode').val(getResult.Postcode);
    //  $('#Country').val(getResult.Country);
    $('#CountryId').val(getResult.CountryId);
    $('#ContactNo').val(getResult.ContactNo);
    $('#NoofUsersAccess').val(getResult.NoOfUserAccess);
    if (getResult.ContactInfoList != null) {
        $('#ContactGrid').empty();
        $.each(getResult.ContactInfoList, function (index, data) {
            AddFirstGridRow();
            $('#ContractorContactInfoId_' + index).val(data.ContractorContactInfoId);
            $('#Name_' + index).val(data.Name);
            $('#Designation_' + index).val(data.Designation);
            $('#ContactNo_' + index).val(data.ContactNo);
            $('#Email_' + index).val(data.Email);
            linkCliked1 = true;
        });
    }
    $('#myPleaseWait').modal('hide');
    $('#SSMRegistrationCode,#ContractorName').prop('disabled', true);
    setTimeout(multiSelectshow, 10);
    $("#Specialization").val(getResult.Specialization);
}



$('#contactBtn').click(function () {

    var rowCount = $('#ContactGrid tr:last').index();
    var name = $('#Name_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && name.trim() == "") {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});

window.multiSelectshow = function () {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

}