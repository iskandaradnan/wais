$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("formGMFacilityStaff");

    $.get("/api/facilitystaffmst/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            loadResult.RoleData = loadResult.RoleData.filter(function (obj) {
                return obj.FieldValue == 'User' || obj.FieldValue == 'Hospital Director';
            });

            $.each(loadResult.RoleData, function (index, value) {
                $('#Role').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.DepartmentData, function (index, value) {
                $('#Department').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.DesignationData, function (index, value) {
                $('#Designation').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.GenderData, function (index, value) {
                $('#Gender').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.NationalityData, function (index, value) {
                $('#Nationality').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/facilitystaffmst/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $('#primaryID').val(getResult.StaffMasterId);
                      $('#StaffEmployeeID').val(getResult.StaffEmployeeId).prop('disabled', true);
                      $('#StaffName').val(getResult.StaffName).prop('disabled', true);
                      $('#Role option[value="' + getResult.UMUserRoleId + '"]').prop('selected', true);
                      $('#Department option[value="' + getResult.DepartmentId + '"]').prop('selected', true);
                      $('#Designation option[value="' + getResult.DesignationId + '"]').prop('selected', true);
                      $('#Gender option[value="' + getResult.GenderLovId + '"]').prop('selected', true);
                      $('#Nationality option[value="' + getResult.NationalityLovId + '"]').prop('selected', true);
                      $('#SelStatus option[value="' + getResult.Status + '"]').prop('selected', true);
                      $('#Email').val(getResult.Email);
                      $('#ContactNo').val(getResult.ContactNo);

                      $('#myPleaseWait').modal('hide');
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
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });


    $("#btnSave, #btnEdit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var facilityStaffMst = {
            StaffEmployeeID: $('#StaffEmployeeID').val(),
            StaffName : $('#StaffName').val(),
            UMUserRoleId: $('#Role option:selected').val(),
            DepartmentId: $('#Department option:selected').val(),
            DesignationId: $('#Designation option:selected').val(),
            GenderLovId: $('#Gender option:selected').val(),
            NationalityLovId: $('#Nationality option:selected').val(),
            Email: $('#Email').val(),
            ContactNo: $('#ContactNo').val(),
            Status: $("#SelStatus option:selected").val(),
            CreatedBy : 1
        }

        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("formGMFacilityStaff","save");
        if (!isFormValid) {
            errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        }

        function errorMsg(errMsg) {
            $("div.errormsgcenter").text((!Messages[errMsg]) ? errMsg : Messages[errMsg]);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            facilityStaffMst.StaffMasterId = primaryId;
            facilityStaffMst.Timestamp = timeStamp;
        }
        else {
            facilityStaffMst.StaffMasterId = 0;
            facilityStaffMst.Timestamp = "";
        }

        var jqxhr = $.post("/api/facilitystaffmst/Save", facilityStaffMst, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.StaffMasterId);
            $("#Timestamp").val(result.Timestamp);

            if(result.StaffMasterId)
                $('#StaffEmployeeID').prop('disabled', true);
                $('#StaffName').prop('disabled', true);

            showMessage('facility Staff', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
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
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/gm/facilitystaffmst";
    });
});