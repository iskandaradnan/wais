$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var AllLocations = [];
    var LeftLocations = [];
    var LocationRole = [];
    var userRoles = [];
    $("#jQGridCollapse1").click();
    $('#selCustomer').attr('disabled', true);
    $('#selUserRole').attr('disabled', true);

    $('#txtContractor').attr('disabled', true);
    $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#txtContractor').removeAttr("required");
    $('#hdnContractorId').removeAttr("required");
    $('#spnContractor').hide();
    $('#chkCentralPool').attr('disabled', true);

    $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);
   // $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').addClass('buttonDisabled');

    $.get("/api/unblockUser/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.Genders, function (index, value) {
                $('#selGender').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.UserTypes, function (index, value) {
                $('#selUserType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
              $.each(loadResult.Statuses, function (index, value) {
                  $('#selStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
              $.each(loadResult.Customers, function (index, value) {
                  $('#selCustomer').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

              $.each(loadResult.AccessLevels, function (index, value) {
                  $('#selAccessLevel').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              //$.each(loadResult.UserRoles, function (index, value) {
              //    $('#selRole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              //});
              $.each(loadResult.Competancies, function (index, value) {
                  $('#selCompetency').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              $.each(loadResult.Designations, function (index, value) {
                  $('#selDesignation').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              $.each(loadResult.Nationalities, function (index, value) {
                  $('#selNationality').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              $.each(loadResult.Grades, function (index, value) {
                  $('#selGrade').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              $.each(loadResult.Specialities, function (index, value) {
                  $('#selSpeciality').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              $.each(loadResult.Deparatments, function (index, value) {
                  $('#selDepartment').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });

              $('#selStatus').val(1);
              $('#selNationality').val(16);

              $('#selGrade').attr('disabled', true);
              $('#selCompetency').attr('disabled', true);
              $('#selDepartment').attr('disabled', true);
              $('#selSpeciality').attr('disabled', true);

            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/unblockUser/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);

                      // var existingStaff = $('#chkExistingStaff').is(":checked");
                      if (getResult.ExistingStaff) {
                          $('#chkExistingStaff').prop('checked', true);
                      }
                      else {
                          $('#chkExistingStaff').prop('checked', false);
                      }
                      $('#txtStaffName').val(getResult.StaffName);
                      $('#txtUserName').val(getResult.UserName);
                      $('#selGender').val(getResult.Gender);
                      $('#txtPhoneNumber').val(getResult.PhoneNumber);
                      $('#txtEmail').val(getResult.Email);
                      $('#txtMobileNumber').val(getResult.MobileNumber);
                      $("#txtDateOfJoining").val(moment(getResult.DateJoined).format("DD-MMM-YYYY"));
                      $('#selUserType').val(getResult.UserTypeId);
                      $('#selStatus').val(getResult.Status);
                      $('#selCustomer').val(getResult.CustomerId);
                      $('#selAccessLevel').val(getResult.AccessLevl);
                      //$('#selRole').val(getResult.UserRoleId);
                      $('#selDesignation').val(getResult.UserDesignationId == 0 ? "null" : getResult.UserDesignationId);
                      $('#selNationality').val(getResult.Nationality == 0 ? "null" : getResult.Nationality);
                      $('#selGrade').val(getResult.UserGradeId == 0 ? "null" : getResult.UserGradeId);
                      $('#selCompetency').val(getResult.UserCompetencyId == null ? [] : getResult.UserCompetencyId.split(','));
                      $('#selDepartment').val(getResult.UserDepartmentId == 0 ? "null" : getResult.UserDepartmentId),
                      $('#selSpeciality').val(getResult.UserSpecialityId == null ? [] : getResult.UserSpecialityId.split(','));

                      $('#hdnContractorId').val(getResult.ContractorId == 0 ? "null" : getResult.ContractorId);
                      $('#txtContractor').val(getResult.ContractorName);
                      $('#chkCentralPool').prop('checked', getResult.IsCenterPool);
                      var accessLevel = $('#selAccessLevel').val();
                      if (accessLevel == 9) {
                          $('#selGrade').attr('disabled', true);
                          $('#selCompetency').attr('disabled', true);
                          $('#selDepartment').attr('disabled', true);
                          $('#selSpeciality').attr('disabled', true);

                          $('#selCompetency').attr("required", true);
                          $('#selDepartment').removeAttr("required")
                          $('#selSpeciality').attr("required", true);

                          //$('#selDepartment').parent().removeClass('has-error');

                          $('#spnCompetency').show();
                          $('#spnDepartment').hide();
                          $('#spnSpeciality').show();
                      } else if (accessLevel == 10) {
                          $('#selGrade').attr('disabled', true);
                          $('#selCompetency').attr('disabled', true);
                          $('#selDepartment').attr('disabled', true);
                          $('#selSpeciality').attr('disabled', true);

                          $('#selCompetency').removeAttr("required");
                          $('#selDepartment').attr("required", true)
                          $('#selSpeciality').removeAttr("required");

                          //$('#selCompetency').parent().removeClass('has-error');
                          //$('#selSpeciality').parent().removeClass('has-error');

                          $('#spnCompetency').hide();
                          $('#spnDepartment').show();
                          $('#spnSpeciality').hide();
                      } else if (accessLevel == 308) {
                          $('#selGrade').attr('disabled', true);
                          $('#selCompetency').attr('disabled', true);
                          $('#selDepartment').attr('disabled', true);
                          $('#selSpeciality').attr('disabled', true);

                          $('#selDesignation').attr('disabled', true);
                          $('#selNationality').attr('disabled', true);

                          $('#selCompetency').removeAttr("required");
                          $('#selSpeciality').removeAttr("required");

                          $('#selDesignation').removeAttr("required");
                          $('#selNationality').removeAttr("required");
                          $('#selDepartment').removeAttr("required");

                          $('#spnCompetency').hide();
                          $('#spnSpeciality').hide();

                          $('#spnDesignation').hide();
                          $('#spnNationality').hide();
                          $('#spnDepartment').hide();

                          $('#spnContractor').show();
                      }

                      $('#Timestamp').val(getResult.Timestamp);

                      if (getResult.UserTypeId == 1) {
                          $('#btnAddEditMoveAllRight').attr('disabled', true);
                          $('#btnAddEditMoveOneRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);
                      }
                      else {
                          $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);
                      }

                      userRoles = getResult.UserRoles;
                      $.each(userRoles, function (index, value) {
                          $('#selUserRole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                      });
                      $('#selUserRole').val(getResult.SelectedUserRole);
                       
                      //if ($('#ActionType').val() == 'Edit') {
                      //    $('#selCustomer').attr('disabled', false);
                      //    $('#selUserRole').attr('disabled', false);
                      //}

                      AllLocations = getResult.AllLocations;
                      LeftLocations = getResult.LeftLocations;
                      LocationRole = getResult.LocationRole;
                      ReloadTables();

                      if ($('#ActionType').val() == 'View' || $('#ActionType').val() == 'Edit') {
                          $('#btnAddEditMoveOneRight').attr("disabled", true);
                          $('#btnAddEditMoveAllRight').attr("disabled", true);
                          $('#btnAddEditMoveAllLeft').attr("disabled", true);
                          $('#btnAddEditMoveOneLeft').attr("disabled", true);
                          $("#tblSelectedLocations").find("select").attr("disabled", true);
                     }
                      $("form :input:not(:button)").prop("disabled", true);
                      $('#myPleaseWait').modal('hide');
                  })
                 .fail(function (response) {
                     $('#myPleaseWait').modal('hide');
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                     $('#errorMsg').css('visibility', 'visible');
                 });
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#btnSave, #btnEdit").click(function () {
        $('#btnSave').attr('disabled', true);
        $('#btnEdit').attr('disabled', true);
        
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var existingStaff = $('#chkExistingStaff').is(":checked");
        var staffName = $('#txtStaffName').val();
        var userName = $('#txtUserName').val();
        var gender = $('#selGender').val();
        var phoneNumber = $('#txtPhoneNumber').val();
        var email = $('#txtEmail').val();
        var mobileNumber = $('#txtMobileNumber').val();
        var dateOfJoining = $("#txtDateOfJoining").val();
        var userType = $('#selUserType').val();
        var status = $('#selStatus').val();
        var customerId = $('#selCustomer').val();
        var timeStamp = $("#Timestamp").val();

        if (staffName == null || staffName == null || gender == "null" || email == null || email == "" || mobileNumber == null || mobileNumber == ""
            || phoneNumber == null || phoneNumber == "" || dateOfJoining == null || dateOfJoining == "" || userType == "null" || status == "null"
            || customerId == "null") {

            DisplayErrorMessage(Messages.INVALID_INPUT_MESSAGE);
            return false;
        }

        if (LocationRole.length == 0) {
            DisplayErrorMessage("Please select at least one location");
            return false;
        }
        else {
            var roleSelected = true;
            $.each($("select[id^='sels']"), function (index, value) {
                if ($('#' + value.id).val() == "null")
                    roleSelected = false;
            });
            if (!roleSelected)
            {
                DisplayErrorMessage("Please select User Role");
                return false;
            }
        } 
        $('#myPleaseWait').modal('show');

        
        var primaryId = $("#primaryID").val();
        var UMUserRegistration = {
            UserRegistrationId: primaryId
        };
        var jqxhr = $.post("/api/unblockUser/Save", UMUserRegistration, function (response) {
            document.cookie = 'unblock=true;path=/';
            window.location.href = "/um/unblockuser"
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
            $('#btnEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    function DisplayErrorMessage(msg) {
        $("div.errormsgcenter").text(msg);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
    }

    $("#selUserType").change(function () {
        $('#selCustomer').val("null");

        LeftLocations =[];
        LocationRole =[];
        $('#tblLocations > tbody').empty();
        $('#tblSelectedLocations > tbody').empty();

        var userTypeId = $('#selUserType').val();
        if ($('#selUserType').val() == "null") {
            $('#selUserRole').children('option:not(:first)').remove();
            $('#selCustomer').attr('disabled', true);
            $('#selUserRole').attr('disabled', true);
            $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);
            return false;
        }
        else {
            if (userTypeId == 1) {
                $('#btnAddEditMoveAllRight').attr('disabled', true);
                $('#btnAddEditMoveOneRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', false);
            }
            else {
                $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', false);
            }

            $('#selCustomer').attr('disabled', false);
            $('#selUserRole').attr('disabled', false);
        }

        $.get("/api/unblockUser/GetUserRoles/" +userTypeId)
        .done(function (result) {
            var getRolesResult = JSON.parse(result);
            userRoles = getRolesResult.UserRoles;
                $('#selUserRole').children('option:not(:first)').remove();
                $.each(userRoles, function (index, value) {
                    $('#selUserRole').append('<option value="' +value.LovId + '">' +value.FieldValue + '</option>');
        });
            $('#myPleaseWait').modal('hide');
        })
      .fail(function (response) {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
          $('#errorMsg').css('visibility', 'visible');
    });
    });

    $("#selCustomer").change(function () {

        LeftLocations =[];
        LocationRole =[];
        $('#tblLocations > tbody').empty();
        $('#tblSelectedLocations > tbody').empty();

        var customerId = $('#selCustomer').val();
        if (customerId == "null") {
            return false;
        }
        else {
            $.get("/api/unblockUser/GetLocations/" +customerId)
           .done(function (result) {
               var getLocationsResult = JSON.parse(result);
               AllLocations = getLocationsResult.Locations;
               LeftLocations = AllLocations;

               $.each(LeftLocations, function (index, value) {
                   value.IsVisible = true;
                   value.IsSelected = false;
            });

               var markup = "";
               $.each(LeftLocations, function (index, value) {
                   if ($('#ActionType').val() == 'View' || $('#ActionType').val() == 'Edit') {
                       markup += "<tr><td style='width:100%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td></tr>";
                   }
                   else {
                       markup += "<tr style='cursor:pointer;'><td style='width:100%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td></tr>";
                   }
           });

               $('#tblLocations > tbody').append(markup);
               BindClickForLocations();
               if ($("#selUserType").val() == 3)
               { 
                   $('#btnAddEditMoveAllRight').click()
                }
               $('#myPleaseWait').modal('hide');
            })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
        });

    }
    });
    function BindClickForLocations() {
        if ($('#ActionType').val() == 'View' || $('#ActionType').val() == 'Edit') {
            return false;
        }
        $('#tblLocations tr').bind('click', function (e) {
            $(e.currentTarget).children('td').toggleClass('green');
            var cssClass = $(e.currentTarget).children('td').attr('class');
            var lovId = $(e.currentTarget).children('td').children('span')[0].innerHTML;
            jQuery.grep(LeftLocations, function (n, i) {
                if (n.LovId == lovId) {
                    if (cssClass == "green")
                        n.IsSelected = true;
                    else n.IsSelected = false;
            }
        });
        });
    }
    function BindClickForSelectedLocations() {
        if ($('#ActionType').val() == 'View' || $('#ActionType').val() == 'Edit') {
            return false;
        }
        $('#tblSelectedLocations tr td:first-child').bind('click', function (e) {
            $(e.currentTarget).parent().toggleClass('pink');
            var cssClass = $(e.currentTarget).parent().attr('class');
            var lovId = $(e.currentTarget).children('span')[0].innerHTML;
            jQuery.grep(LocationRole, function (n, i) {
                if (n.LovId == lovId) {
                    if (cssClass == "pink")
                        n.IsSelected = true;
                    else n.IsSelected = false;
            }
        });
        });

        $("select[id^='sels']").change(function () {
            var selectedValue = $("select[id^='sels']").first().val();
            var allSame = true;
            $.each($("select[id^='sels']"), function (index, value) {
                var locationRoleItem = $.grep(LocationRole, function (value1, index1) {
                    return "sels" + value1.LovId == value.id;
                });
                locationRoleItem[0].UserRoleId = $('#' + value.id).val();

                if (selectedValue != $('#' + value.id).val())
                    allSame = false;
            });
            if (allSame) $('#selUserRole').val(selectedValue);
            else $('#selUserRole').val('null');
        });
    }

    $('#btnAddEditMoveOneRight').click(function () {
        var selectedLocations = (jQuery.grep(LeftLocations, function (n, i) {
            return (n.IsSelected);
        })).length;
        
        var locationsOnRight = LocationRole.length;

        if (selectedLocations == 0) {
            bootbox.alert("Please select at least one location");
            return false;
        }
        var userTypeId = $('#selUserType').val();
        if ((selectedLocations > 1 || locationsOnRight == 1) && userTypeId == 1) {
            bootbox.alert("Only one location can be added for a Facility User");
            return false;
    }
        $('#btnAddEditMoveOneRight').attr("disabled", true);
        var selectedValue = $('#selUserRole').val();
        $.each(LeftLocations, function (index, value) {
            if (value.IsSelected) {
                value.IsVisible = false;
                value.IsSelected = false;
                var obj = {
                        LovId: value.LovId,
                        FieldValue: value.FieldValue,
                        IsSelected: false,
                        UserRoleId: selectedValue
            };
                LocationRole.push(obj);
        }
    });
        ReloadTables();
        $('#btnAddEditMoveOneRight').attr("disabled", false);
    });

    $('#btnAddEditMoveAllRight').click(function () {

        var visibleLocations = (jQuery.grep(LeftLocations, function (n, i) {
            return (n.IsVisible);
        })).length;
        if (visibleLocations == 0) {
            return false;
    }

        $('#btnAddEditMoveAllRight').attr("disabled", true);
        $.each(LeftLocations, function (index, value) {
            if (value.IsVisible) value.IsSelected = true;
        });
        var selectedValue = $('#selUserRole').val();
        $.each(LeftLocations, function (index, value) {
            if (value.IsSelected) {
                value.IsVisible = false;
                value.IsSelected = false;
                var obj = {
                        LovId: value.LovId,
                        FieldValue: value.FieldValue,
                        IsSelected: false,
                        UserRoleId: selectedValue
            };
                LocationRole.push(obj);
        }
    });

        ReloadTables();
        $('#btnAddEditMoveAllRight').attr("disabled", false);
    });
    $('#btnAddEditMoveOneLeft').click(function () {
        var selectedLocations = (jQuery.grep(LocationRole, function (n, i) {
            return (n.IsSelected);
        })).length;
        if (selectedLocations == 0) {
            bootbox.alert("Please select at least one location");
            return false;
    }
        $('#btnAddEditMoveOneLeft').attr("disabled", true);

        $.each(LocationRole, function (index, value) {
            $.each(LeftLocations, function (index1, value1) {
                if (value.LovId == value1.LovId && value.IsSelected) {
                    value1.IsVisible = true;
                    value1.IsSelected = false;
            }
        });
    });

        LocationRole = $.grep(LocationRole, function (value, index) {
            return !value.IsSelected;
    });
        ReloadTables();
        $('#btnAddEditMoveOneLeft').attr("disabled", false);
    });
    $('#btnAddEditMoveAllLeft').click(function () {
        $('#btnAddEditMoveAllLeft').attr("disabled", true);

        $.each(LocationRole, function (index, value) {
            $.each(LeftLocations, function (index1, value1) {
                if (value.LovId == value1.LovId) {
                    value1.IsVisible = true;
                    value1.IsSelected = false;
                }
        });
    });
        LocationRole =[];
        ReloadTables();
        $('#btnAddEditMoveAllLeft').attr("disabled", false);
    });
        function ReloadTables() {
        $('#tblLocations > tbody').empty();
        $('#tblSelectedLocations > tbody').empty();
        var markup = "";
        $.each(LeftLocations, function (index, value) {
            if (value.IsVisible)
                if ($('#ActionType').val() == 'View' || $('#ActionType').val() == 'Edit') {
                    markup += "<tr><td style='width:100%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td></tr>";
                }
                else {
                    markup += "<tr style='cursor:pointer;'><td style='width:100%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td></tr>";
                }
            
        });
        if (markup != "") {
            $('#tblLocations > tbody').append(markup);
            BindClickForLocations();
        }
        var selString = "";
            markup = "";
        $.each(LocationRole, function (index, value) {
            selString = createSelect(value.LovId, value.UserRoleId);
            if ($('#ActionType').val() == 'View' || $('#ActionType').val() == 'Edit') {
                markup += "<tr><td style='width:50%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td><td style='width:50%'>" + selString + "</td></tr>";
            }
            else {
                markup += "<tr style='cursor:pointer;'><td style='width:50%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td><td style='width:50%'>" + selString + "</td></tr>";
            }
        });
        if (markup != "") {
            $('#tblSelectedLocations > tbody').append(markup);
            BindClickForSelectedLocations();
        }
    }

        function createSelect(lovId, UserRoleId) {
            //var selectedValue = $('#selUserRole').val();
            var selectedValue = UserRoleId;
        var selected = "";
        var selString = "<select id='sels" + lovId + "' class='form-control'><option value='null'>Select</option>";
        $.each(userRoles, function (index, value) {
            selected = ""
            if(value.LovId == selectedValue) selected = "selected"
            selString += "<option value='" +value.LovId + "' " + selected + ">" +value.FieldValue + "</option>";
        });
        selString += "</select>";

        return selString;
    }
    $('#selUserRole').change(function () {
        var selectedValue = $('#selUserRole').val();
        var id = "";
        $.each(LocationRole, function (index, value) {
            id = "sels" +value.LovId;
            $('#' + id).val(selectedValue);
            value.UserRoleId = selectedValue;
        });

    });

});


$("#btnSave").click(function () {
    var grid = $("#grid");
    var rowKey = grid.getGridParam("selrow");
    if (!rowKey) {
        bootbox.alert('Please select a record to unblock');
        //alert("No rows are selected");
        return false;
    }
    var message = Messages.Unblock_Alert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            getSelectedRows();
        }
        else {
            $('#myPleaseWait').modal('hide');
            
        }
    });
});


function getSelectedRows() {
        var grid = $("#grid");
        var rowKey = grid.getGridParam("selrow");

        //if (!rowKey)
        //    alert("No rows are selected");
        //else {
        var selectedIDs = grid.getGridParam("selarrrow");
        var IdList = "";
        for (var i = 0; i < selectedIDs.length; i++) {
            IdList += selectedIDs[i] + ",";
        }
        $.get("/api/unblockUser/BlockingList", { IdList: IdList })
        .done(function (result) {
            var getResult = JSON.parse(result);
            document.cookie = 'unblock=true;path=/';
            window.location.href = "/um/unblockuser"
                
        })
    .fail(function () {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
    });
            //}                
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


