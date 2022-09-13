$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("formGMCompanyStaff");

    $("#EmpolyeeType").change(function () {
        if (this.value == 12) {
            $("#chk_SharedEmployee").prop({/*"disabled": false,*/"checked": true});
        }
        else {
            $("#chk_SharedEmployee").prop({ /*"disabled": true,*/ "checked": false});
        }
    });

    $("#Role").change(function () {
        if (this.value == 4) {
            $("#gradeLabelId").html("Grade <span class='red'>*</span>");
            $("#Grade").prop('required', true);
        }
        else {
            $("#gradeLabelId").text("Grade");
            $("#Grade").prop('required', false).parent().removeClass('has-error');
        }
    });

    $.get("/api/companystaffmst/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.RoleData, function (index, value) {
                $('#Role').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CompetencyData, function (index, value) {
                $('#Competency').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            //$('#Competency').multiselect('rebuild');
            $.each(loadResult.GradeData, function (index, value) {
                $('#Grade').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.SpecialityData, function (index, value) {
                $('#Speciality').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.EmployeeTypeData, function (index, value) {
                $('#EmpolyeeType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.GenderData, function (index, value) {
                $('#Gender').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.NationalityData, function (index, value) {
                $('#Nationality').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            
            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/companystaffmst/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $('#primaryID').val(getResult.StaffMasterId);
                      $('#StaffEmployeeID').val(getResult.StaffEmployeeId).prop('disabled', true);
                      $('#StaffName').val(getResult.StaffName).prop('disabled', true);
                      $('#Role option[value="' + getResult.UMUserRoleId + '"]').prop('selected', true);

                      var competencyData = getResult.StaffCompetencyId && getResult.StaffCompetencyId.split(',');
                      $.each(competencyData, function (i) {
                          $('#Competency option[value="' + competencyData[i] + '"]').prop('selected', true);
                      });

                      var SpecialityData = getResult.StaffSpecialityId && getResult.StaffSpecialityId.split(',');
                      $.each(SpecialityData, function (i) {
                          $('#Speciality option[value="' + SpecialityData[i] + '"]').prop('selected', true);
                      });
                      
                      $('#Grade option[value="' + getResult.GradeId + '"]').prop('selected', true);
                      $('#EmpolyeeType option[value="' + getResult.EmployeeTypeLovId + '"]').prop('selected', true);
                      $('#Gender option[value="' + getResult.GenderLovId + '"]').prop('selected', true);
                      $('#Nationality option[value="' + getResult.NationalityLovId + '"]').prop('selected', true);
                      $('#SelStatus option[value="' + getResult.Status + '"]').prop('selected', true);
                      $('#Email').val(getResult.Email);
                      $('#ContactNo').val(getResult.ContactNo);
                      $("#chk_SharedEmployee").prop('checked', getResult.IsEmployeeShared);

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

        function Multiselect(selectID){
            var selectedCompData = $.map(selectID, function (el, i) { return $(el).val(); })
            return selectedCompData.join();
        }

        var companyStaffMst = {
            StaffEmployeeId: $('#StaffEmployeeID').val(),
            StaffName : $('#StaffName').val(),
            UMUserRoleId: $('#Role option:selected').val(),
            StaffCompetencyId: Multiselect($("#Competency option:selected")),
            StaffSpecialityId: Multiselect($("#Speciality option:selected")),
            GradeId: $('#Grade option:selected').val(),
            EmployeeTypeLovId: $('#EmpolyeeType option:selected').val(),
            GenderLovId: $('#Gender option:selected').val(),
            NationalityLovId: $('#Nationality option:selected').val(),
            Email: $('#Email').val(),
            ContactNo: $('#ContactNo').val(),
            IsEmployeeShared: $('#chk_SharedEmployee').is(":checked"),//$("#chk_SharedEmployee").prop('checked'),
            Status: $("#SelStatus option:selected").val(),
            CreatedBy : 1
        }

        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("formGMCompanyStaff", 'save');
        if (!isFormValid) {
            errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        } else if (companyStaffMst.UMUserRoleId == 4 && companyStaffMst.GradeId == null) {
            errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        }else if (companyStaffMst.EmployeeTypeLovId == 12 && companyStaffMst.IsEmployeeShared == false) {
            errorMsg("Shared Employee must be checked If Employee Type is Shared.");
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
            companyStaffMst.StaffMasterId = primaryId;
            companyStaffMst.Timestamp = timeStamp;
        }
        else {
            companyStaffMst.StaffMasterId = 0;
            companyStaffMst.Timestamp = "";
        }

        var jqxhr = $.post("/api/companystaffmst/Save", companyStaffMst, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.StaffMasterId);
            $("#Timestamp").val(result.Timestamp);

            if (result.StaffMasterId)
                $('#StaffEmployeeID').prop('disabled', true);
                $('#StaffName').prop('disabled', true);

            showMessage('Company Staff', CURD_MESSAGE_STATUS.SS);
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
        window.location.href = "/gm/companystaffmst";
    });
});