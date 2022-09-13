$(function () {
    $('#selCompetency, #selSpeciality').multiselect();
    //$('#selCompetency').multiselect();
    //$('#selSpeciality').multiselect({
    //    includeSelectAllOption: false
    //});
})

var AllLocations = [];
var LeftLocations = [];
var LocationRole = [];
var userRoles = [];
var nationalityDefaultValue = 'null';
UserTypeIdGlobal = null;
UserTypesGlobal = null;

$(document).ready(function () {

    $('#myPleaseWait').modal('show');
    $('#txtEmail').attr('pattern', '^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$');
    formInputValidation("frmUserRegistration");
    $('#btnDelete').hide();
    $('#btnEdit').hide();

    $('#selCustomer').attr('disabled', true);
    $('#selUserRole').attr('disabled', true);
    $('#txtStaffId').attr('disabled', false);
    $('#txtContractor').attr('disabled', true);
    $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#txtContractor').removeAttr("required");
    $('#hdnContractorId').removeAttr("required");
    $('#spnContractor').hide();
    $('#chkCentralPool').attr('disabled', true);

    $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);

    $.get("/api/userRegistration/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            $.each(loadResult.Genders, function (index, value) {
                $('#selGender').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            UserTypeIdGlobal = loadResult.UserTypeId;
            UserTypesGlobal = loadResult.UserTypes;

            $.each(loadResult.UserTypes, function (index, value) {
                var disabled = '';
                if(loadResult.UserTypeId == 1 || loadResult.UserTypeId == 2 || loadResult.UserTypeId == 4){
                    disabled = 'disabled';
                }
                if (loadResult.UserTypeId == 3) {
                    if(value.LovId == 3 || value.LovId == 5){
                        disabled = 'disabled';
                    }
                }
                if (loadResult.UserTypeId == 5) {
                    if (value.LovId == 5) {
                        disabled = 'disabled';
                    }
                }
                $('#selUserType').append('<option value="' + value.LovId + '" ' + disabled + '>' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Statuses, function (index, value) {
                $('#selStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Customers, function (index, value) {
                $('#selCustomer').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
          
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
            $.each(loadResult.Services, function (index, value) {
                $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#selNationality').attr('disabled', true);
            $('#selDesignation').attr('disabled', true);

            $('#selStatus').val(1);
            //$('#selNationality').val(16);

            $('#selGrade').attr('disabled', true);
            $('#selDepartment').attr('disabled', true);
            $('#txtLabourCostPerHour').attr('disabled', true);

            var genderArr = $.grep(loadResult.Genders, function (element, index) {
                return element.DefaultValue == true;

            });
            if (genderArr.length > 0) {
                $('#selGender').val(genderArr[0].LovId);
            }

            var nationalityArr = $.grep(loadResult.Nationalities, function (element, index) {
                return element.DefaultValue == true;

            });
            if (nationalityArr.length > 0) {
                nationalityDefaultValue = nationalityArr[0].LovId;
            }

            setTimeout(multiSelectshow, 10);
            setTimeout(function () {
                $('.multiselect').attr('disabled', true);
            }, 20);

        })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });

    //------------------------Search----------------------------
    var contractorSearchObj = {
        Heading: "Contractor Details",
        SearchColumns: ["ContractorName-Contractor / Vendor Name", "SSMRegistrationCode-Contractor / Vendor Registration Number"],
        ResultColumns: ["ContractorId-Primary Key", "ContractorName-Contractor / Vendor Name", "SSMRegistrationCode-Contractor / Vendor Registration Number"],
        FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtContractor-ContractorName"]
    };

    //------------------------Fetch----------------------------
    var contractorFetchObj = {
        SearchColumn: "txtContractor-ContractorName",//Id of Fetch field
        ResultColumns: ["ContractorId-Primary Key", "ContractorName-ContractorName", "SSMRegistrationCode-SSMRegistrationCode"],
        FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtContractor-ContractorName"]
    };

    $('#txtContractor').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divContractorFetch', contractorFetchObj, "/api/Fetch/ContractorNameFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });


    $("#btnSave, #btnEdit, #btnSaveandAddNew").click(function () {
        $('#btnSave').attr('disabled', true);
        $('#btnEdit').attr('disabled', true);
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var existingStaff = $('#chkExistingStaff').is(":checked");
        var staffName = $('#txtStaffName').val();
        var staffMasterId = $('#hdnStaffMasterId').val();
        var userName = $('#txtUserName').val();
        var gender = $('#selGender').val();
        var phoneNumber = $('#txtPhoneNumber').val();
        var email = $('#txtEmail').val();
        var mobileNumber = $('#txtMobileNumber').val();
        var dateOfJoining = $("#txtDateOfJoining").val();
        //var userType = $('#selUserType').val();
        var status = $('#selStatus').val();
        var staffId = $('#txtStaffId').val();
        var customerId = $('#selCustomer').val();
        var timeStamp = $("#Timestamp").val();
        var services = $('#selServices').val();
        var isDisabled = false;
        if($("#selUserType option:selected").prop('disabled')) {
            $("#selUserType option:selected").attr('disabled', false);
            isDisabled = true;
        }
        var userType = $('#selUserType').val();
        var isFormValid = formInputValidation("frmUserRegistration", 'save');
        if (isDisabled) {
            $("#selUserType option:selected").attr('disabled', true);
        }

        var staffMasterIdInvalid = false;
        if (existingStaff && (staffMasterId == null || staffMasterId == "null" || staffMasterId == "")) {
            staffMasterIdInvalid = true;
            $('#hdnStaffMasterId').parent().addClass('has-error');
        }
        if (!isFormValid || staffMasterIdInvalid) {
            DisplayErrorMessage(Messages.INVALID_INPUT_MESSAGE);
            return false;
        }

        $("#selUserType option:selected").attr('disabled', true);
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
            if (!roleSelected) {
                DisplayErrorMessage("Please select User Role");
                return false;
            }
        }
        $('#myPleaseWait').modal('show');

        var UMUserRegistration = {};
        var LocationDetails = [];

        var UMUserRegistration = {
            ExistingStaff: existingStaff,
            StaffMasterId: staffMasterId,
            StaffName: staffName,
            UserName: userName,
            Gender: gender,
            PhoneNumber: phoneNumber,
            Email: email,
            MobileNumber: mobileNumber,
            DateJoined: dateOfJoining,
            UserTypeId: userType,
            Status: status,
            Employee_ID : staffId,
            CustomerId: customerId,
            UserDesignationId: $('#selDesignation').val(),
            Nationality: $('#selNationality').val(),
            UserGradeId: $('#selGrade').val(),
            UserCompetencyId: $('#selCompetency').val().join(),
            UserDepartmentId: $('#selDepartment').val(),
            UserSpecialityId: $('#selSpeciality').val().join(),
            ContractorId: $('#hdnContractorId').val(),
            IsCenterPool: $('#chkCentralPool').prop('checked'),
            LabourCostPerHour: $('#txtLabourCostPerHour').val(),
            ServicesID: services
           
        };
        var locationDetails = [];
        $.each(LocationRole, function (index, value) {
            var UMUserLocationMstDet = {
                FacilityId: value.LovId,
                UserRoleId: value.UserRoleId,
                CustomerId: customerId
            };
            locationDetails.push(UMUserLocationMstDet);
        });

        UMUserRegistration.LocationDetails = locationDetails;

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            UMUserRegistration.UserRegistrationId = primaryId;
            UMUserRegistration.Timestamp = timeStamp;
            $.each(UMUserRegistration.LocationDetails, function (index, value) {
                value.UserRegistrationId = primaryId;
            });
        }
        else {
            UMUserRegistration.UserRegistrationId = 0;
            UMUserRegistration.Timestamp = "";
        }

        var jqxhr = $.post("/api/userRegistration/Save", UMUserRegistration, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.UserRegistrationId);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            $('#chkExistingStaff').attr('disabled', true);
            $('#txtDateOfJoining').prop("disabled", true);
            $('#txtStaffName').attr('disabled', true);
            $('#txtUserName').attr('disabled', true);
            if (result.UserRegistrationId != 0) {
                $('#LevelCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
            }
            $('#btnDelete').show();
            $(".content").scrollTop(0);
            showMessage('User Role', CURD_MESSAGE_STATUS.SS);

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFileds();
            } else {
                $('#selDesignation').attr('disabled', true);
                $('#selUserType').attr('disabled', true);
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

        LeftLocations = [];
        LocationRole = [];
        $('#tblLocations > tbody').empty();
        $('#tblSelectedLocations > tbody').empty();

        var userTypeId = $('#selUserType').val();
        if (userTypeId == 5) {//userTypeId == 3
            $('#selCustomer').attr('disabled', true);
            $('#selCustomer').removeAttr('required');
            $('#spnCustomer').hide();
        } else {
            $('#selCustomer').attr('disabled', false);
            $('#selCustomer').attr('required', true);
            $('#spnCustomer').show();
        }
        if ($('#selUserType').val() == "null") {
            $('#selUserRole').children('option:not(:first)').remove();
            $('#selCustomer').attr('disabled', true);
            $('#selUserRole').attr('disabled', true);
            $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);

            $('#selNationality').val('null').attr('disabled', true);
            $('#selDesignation').val('null').attr('disabled', true);
            UserTypeChanged(userTypeId);

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
            UserTypeChanged(userTypeId);
            //$('#selCustomer').attr('disabled', false);
            $('#selUserRole').attr('disabled', false);
        }

        $.get("/api/userRegistration/GetUserRoles/" + userTypeId)
        .done(function (result) {
            var getRolesResult = JSON.parse(result);
            userRoles = getRolesResult.UserRoles;
            $('#selUserRole').children('option:not(:first)').remove();
            $.each(userRoles, function (index, value) {
                $('#selUserRole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            if (userTypeId == 5) {//userTypeId == 3
                CompanyAdminSelected();
            }
            $('#myPleaseWait').modal('hide');
        })
      .fail(function (response) {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
          $('#errorMsg').css('visibility', 'visible');
      });
        
    });

    $("#selCustomer").change(function () {

        LeftLocations = [];
        LocationRole = [];
        $('#tblLocations > tbody').empty();
        $('#tblSelectedLocations > tbody').empty();

        var customerId = $('#selCustomer').val();
        if (customerId == "null") {
            return false;
        }
        else {
            $.get("/api/userRegistration/GetLocations/" + customerId)
           .done(function (result) {
               var getLocationsResult = JSON.parse(result);
               BindLocations(getLocationsResult);
               $('#myPleaseWait').modal('hide');
           })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });
        }
    });

    function CompanyAdminSelected() {
        LeftLocations = [];
        LocationRole = [];
        $('#tblLocations > tbody').empty();
        $('#tblSelectedLocations > tbody').empty();

        //var customerId = $('#selCustomer').val();
        //if (customerId == "null") {
        //    return false;
        //}
        //else {
        $('#myPleaseWait').modal('show');
            $.get("/api/userRegistration/GetAllLocations")
           .done(function (result) {
               var getLocationsResult = JSON.parse(result);
               BindLocations(getLocationsResult);
               $('#myPleaseWait').modal('hide');
           })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });

        //}
    }

    function BindLocations(getLocationsResult)
    {
        AllLocations = getLocationsResult.Locations;
        LeftLocations = AllLocations;

        $.each(LeftLocations, function (index, value) {
            value.IsVisible = true;
            value.IsSelected = false;
        });

        var markup = "";
        $.each(LeftLocations, function (index, value) {
            if ($('#ActionType').val() == 'View') {
                markup += "<tr><td style='width:100%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td></tr>";
            }
            else {
                markup += "<tr style='cursor:pointer;'><td style='width:100%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td></tr>";
            }
        });

        $('#tblLocations > tbody').append(markup);
        BindClickForLocations();
        if ($("#selUserType").val() == 5) {//$("#selUserType").val() == 3 
            $('#btnAddEditMoveAllRight').click()
        }
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
        LocationRole = [];
        ReloadTables();
        $('#btnAddEditMoveAllLeft').attr("disabled", false);
    });



    $('#selUserRole').change(function () {
        var selectedValue = $('#selUserRole').val();
        var id = "";
        $.each(LocationRole, function (index, value) {
            id = "sels" + value.LovId;
            $('#' + id).val(selectedValue);
            value.UserRoleId = selectedValue;
        });
    });

    //--------------- Search -----------------
    
    function UserTypeChanged(userType) {
        
        if (userType == "null") {
            $("#edit-rec option:selected").removeAttr("selected");

            $('#selGrade').val("null").attr('disabled', true);
            $("#selCompetency option:selected").prop("selected", false);
            $('#selDepartment').val("null").attr('disabled', true);
            $("#selSpeciality option:selected").prop("selected", false);
            $('#txtLabourCostPerHour').val('').attr('disabled', true);

            setTimeout(multiSelectshow, 10);
            setTimeout(function () {
                $('.multiselect').attr('disabled', true);
            }, 20);

            $('#selCompetency').attr("required", true);
            $('#selDepartment').attr("required", true)
            $('#selSpeciality').attr("required", true);
            $('#txtLabourCostPerHour').attr("required", true);

            $('#spnCompetency').show();
            $('#spnDepartment').show();
            $('#spnSpeciality').show();
            $('#spnLabourCostPerHour').show();

            $('#chkCentralPool').prop('checked', false);
            $('#chkCentralPool').attr('disabled', true);

            DisableContractorFetchSearch();

        } else if (userType == 2 || userType == 3 || userType == 5) {//userType == 9
            $('#selGrade').val("null").attr('disabled', false);
            $("#selCompetency option:selected").prop("selected", false);
            $('#selDepartment').val("null").attr('disabled', true);
            $("#selSpeciality option:selected").prop("selected", false);

            setTimeout(multiSelectshow, 10);
            setTimeout(function () {
                $('.multiselect').attr('disabled', false);
            }, 20);

            $('#selNationality').val(nationalityDefaultValue).attr('disabled', false);
            $('#selNationality').parent().removeClass('has-error');
            $('#selDesignation').val("null").attr('disabled', false);
            $('#txtLabourCostPerHour').val('').attr("disabled", false);

            $('#selCompetency').attr("required", true);
            $('#selDepartment').removeAttr("required")
            $('#selSpeciality').attr("required", true);

            $('#selNationality').attr("required", true);
            $('#selDesignation').attr("required", true);
            $('#txtLabourCostPerHour').attr("required", true);

            $('#selDepartment').parent().removeClass('has-error');

            $('#txtContractor').removeAttr("required");
            $('#spnContractor').hide();
            $('#txtContractor').parent().removeClass('has-error');

            $('#spnCompetency').show();
            $('#spnDepartment').hide();
            $('#spnSpeciality').show();
            $('#spnDesignation').show();
            $('#spnNationality').show();
            $('#spnLabourCostPerHour').show();

            $('#chkCentralPool').prop('checked', false);
            $('#chkCentralPool').attr('disabled', false);

            DisableContractorFetchSearch();

        } else if (userType == 1) {
            $('#selGrade').val("null").attr('disabled', true);
            $('#txtLabourCostPerHour').attr('disabled', true);
            $("#selCompetency option:selected").prop("selected", false);
            $('#selDepartment').val("null").attr('disabled', false);

            $('#selNationality').val(nationalityDefaultValue).attr('disabled', false);
            $('#selDesignation').val("null").attr('disabled', false);

            $("#selSpeciality option:selected").prop("selected", false);
            
            setTimeout(multiSelectshow, 10);
            setTimeout(function () {
                $('.multiselect').attr('disabled', true);
            }, 20);

            $('#selCompetency').removeAttr("required");
            $('#selDepartment').attr("required", true);

            $('#selNationality').attr("required", true);
            $('#selDesignation').attr("required", true);

            $('#selSpeciality').removeAttr("required");
            $('#txtLabourCostPerHour').removeAttr("required");

            $('#selCompetency').parent().removeClass('has-error');
            $('#selSpeciality').parent().removeClass('has-error');
            $('#txtLabourCostPerHour').parent().removeClass('has-error');

            $('#txtContractor').removeAttr("required");
            $('#spnContractor').hide();
            $('#txtContractor').parent().removeClass('has-error');

            $('#spnCompetency').hide();
            $('#spnDepartment').show();
            $('#spnDesignation').show();
            $('#spnNationality').show();

            $('#spnSpeciality').hide();
            $('#spnLabourCostPerHour').hide();

            $('#chkCentralPool').prop('checked', false);
            $('#chkCentralPool').attr('disabled', true);

            DisableContractorFetchSearch();
        }
        else if (userType == 4) {//(userType == 308)
            $('#selGrade').val("null").attr('disabled', true);
            $('#txtLabourCostPerHour').attr('disabled', true);
            $("#selCompetency option:selected").prop("selected", false);
            $('#selDepartment').val("null").attr('disabled', true);

            $('#selDesignation').val("null").attr('disabled', true);
            $('#selNationality').val("null").attr('disabled', true);

            $("#selSpeciality option:selected").prop("selected", false);
            //$('#selSpeciality').attr('disabled', true);
            setTimeout(multiSelectshow, 10);
            setTimeout(function () {
                $('.multiselect').attr('disabled', true);
            }, 20);

            $('#selCompetency').removeAttr("required");
            $('#selSpeciality').removeAttr("required");
            $('#txtLabourCostPerHour').removeAttr("required");

            $('#selDesignation').removeAttr("required");
            $('#selNationality').removeAttr("required");
            $('#selDepartment').removeAttr("required");

            $('#selCompetency').parent().removeClass('has-error');
            $('#selSpeciality').parent().removeClass('has-error');
            $('#txtLabourCostPerHour').parent().removeClass('has-error');

            $('#selDesignation').parent().removeClass('has-error');
            $('#selNationality').parent().removeClass('has-error');
            $('#selDepartment').parent().removeClass('has-error');

            $('#txtContractor').attr("required", true);
            $('#spnContractor').show();
            
            $('#spnCompetency').hide();
            $('#spnSpeciality').hide();
            $('#spnLabourCostPerHour').hide();

            $('#spnDesignation').hide();
            $('#spnNationality').hide();
            $('#spnDepartment').hide();

            $('#chkCentralPool').prop('checked', false);
            $('#chkCentralPool').attr('disabled', true);

            EnableContractorFetchSearch();
        }
    }

    //});

    function DisableContractorFetchSearch() {
        $('#txtContractor').val(null);
        $('#hdnContractorId').val(null);
        $('#txtContractor').removeAttr('required');
        $('#hdnContractorId').removeAttr('required');
        $('#spnContractor').hide();
        $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
        $('#txtContractor').attr('disabled', true);
    }

    function EnableContractorFetchSearch() {
        $('#txtContractor').attr('disabled', false);
        $('#txtContractor').attr('required', true);
        $('#hdnContractorId').attr('required', true);
        $('#spnContractor').show();
        
        $('#spnPopup-contractor').unbind("click");
        $('#spnPopup-contractor').bind("click", function () {
            DisplaySeachPopup('divSearchPopup', contractorSearchObj, "/api/Search/ContractorNameSearch");
        }).attr('disabled', false).css('cursor', 'pointer');
    }

    $('#aCollapse1').on('click', function () {
        var plus = $('#iIndicator1').hasClass('glyphicon-plus');
        var minus = $('#iIndicator1').hasClass('glyphicon-minus');
        if (plus) {
            $('#iIndicator1').addClass('glyphicon-minus').removeClass('glyphicon-plus');
        }
        if (minus) {
            $('#iIndicator1').addClass('glyphicon-plus').removeClass('glyphicon-minus');
        }
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFileds();
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
    $(".content").scrollTop(1);
    $("#frmUserRegistration :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtDateOfJoining').prop("disabled", true);
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#frmUserRegistration :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {

        $('#chkExistingStaff').attr('disabled', true);
        $('#txtStaffName').attr('disabled', true);
        $('#txtUserName').attr('disabled', true);
        $('#selServices').attr('disabled', true);

        $.get("/api/userRegistration/Get/" + primaryId)
            .done(function (result) {
              var getResult = JSON.parse(result);
              if (getResult.ExistingStaff) {
                  $('#chkExistingStaff').prop('checked', true);
              }
              else {
                  $('#chkExistingStaff').prop('checked', false);
                }
              $('#selUserRole').attr('disabled', true);
             $('#selCustomer').attr('disabled', true);
              $('#txtStaffName').val(getResult.StaffName);
              $('#txtUserName').val(getResult.UserName);
              $('#selGender').val(getResult.Gender);
              $('#txtPhoneNumber').val(getResult.PhoneNumber);
              $('#txtEmail').val(getResult.Email);
              $('#txtMobileNumber').val(getResult.MobileNumber);
              $('#txtDateOfJoining').val(moment(getResult.DateJoined).format("DD-MMM-YYYY"));
              $('#selUserType').val(getResult.UserTypeId);
              $('#selStatus').val(getResult.Status);
              $('#selCustomer').val(getResult.CustomerId == null ? 'null' : getResult.CustomerId);
              $('#selServices').val(getResult.ServicesID);
              $('#selDesignation').val(getResult.UserDesignationId == 0 ? "null" : getResult.UserDesignationId);
              $('#selNationality').val(getResult.Nationality == 0 ? "null" : getResult.Nationality);
              $('#selGrade').val(getResult.UserGradeId == 0 ? "null" : getResult.UserGradeId);
              $('#selCompetency').val(getResult.UserCompetencyId == null ? [] : getResult.UserCompetencyId.split(','));
              $('#selDepartment').val(getResult.UserDepartmentId == 0 ? "null" : getResult.UserDepartmentId),
              $('#selSpeciality').val(getResult.UserSpecialityId == null ? [] : getResult.UserSpecialityId.split(','));
                $('#txtLabourCostPerHour').val(getResult.LabourCostPerHour);
                $('#txtStaffId').val(getResult.Employee_ID);
                $('#txtStaffId').attr('disabled', true);
              setTimeout(multiSelectshow, 10);

              var userType = getResult.UserTypeId; //$('#selUserType').val();

              if (userType == 5) {//userType == 3 
                $('#selCustomer').removeAttr('required');
                $('#spnCustomer').hide();
              } else {
                $('#selCustomer').attr('required', true);
                $('#spnCustomer').show();
              }

              if (userType == 2 || userType == 3 || userType == 5) {
                  $('#chkCentralPool').prop('checked', getResult.IsCenterPool);
                  $('#selGrade').attr('disabled', false);
                  $('#txtLabourCostPerHour').attr('disabled', false);
                  $('#selDepartment').attr('disabled', true);
                  
                  setTimeout(function () {
                      $('.multiselect').attr('disabled', false);
                  }, 20);

                  $('#selCompetency').attr("required", true);
                  $('#selDepartment').removeAttr("required")
                  $('#selSpeciality').attr("required", true);
                  $('#txtLabourCostPerHour').attr("required", true);
                  $('#txtContractor').removeAttr("required");
                  $('#hdnContractorId').removeAttr("required");
                  $('#spnContractor').hide();
                  
                  $('#hdnContractorId').val('');
                  $('#txtContractor').val('').attr('disabled', true);
                  $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');

                  $('#spnCompetency').show();
                  $('#spnDepartment').hide();
                  $('#spnSpeciality').show();
                  $('#spnLabourCostPerHour').show();

                  $('#chkCentralPool').attr('disabled', false);
              } else if (userType == 1) { 
                  $('#selGrade').attr('disabled', true);
                  $('#txtLabourCostPerHour').attr('disabled', true);
                  $('#selDepartment').attr('disabled', false);
                  
                  setTimeout(function () {
                      $('.multiselect').attr('disabled', true);
                  }, 20);

                  $('#selCompetency').removeAttr("required");
                  $('#selDepartment').attr("required", true)
                  $('#selSpeciality').removeAttr("required");
                  $('#txtLabourCostPerHour').removeAttr("required");
                  $('#txtContractor').removeAttr("required");
                  $('#hdnContractorId').removeAttr("required");
                  $('#spnContractor').hide();
                  
                  $('#spnCompetency').hide();
                  $('#spnDepartment').show();
                  $('#spnSpeciality').hide();
                  $('#spnLabourCostPerHour').hide();

                  $('#hdnContractorId').val('');
                  $('#txtContractor').val('').attr('disabled', true);
                  $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');

                  $('#chkCentralPool').prop('checked', false);
                  $('#chkCentralPool').attr('disabled', true);
              } else if (userType == 4) {
                  $('#hdnContractorId').val(getResult.ContractorId == 0 ? "null" : getResult.ContractorId);
                  $('#txtContractor').val(getResult.ContractorName);

                  $('#selGrade').attr('disabled', true);
                  $('#txtLabourCostPerHour').attr('disabled', true);
                  $('#selDepartment').attr('disabled', true);
                  
                  setTimeout(function () {
                      $('.multiselect').attr('disabled', true);
                  }, 20);

                  $('#selDesignation').attr('disabled', true);
                  $('#selNationality').attr('disabled', true);

                  $('#selCompetency').removeAttr("required");
                  $('#selSpeciality').removeAttr("required");
                  $('#txtLabourCostPerHour').removeAttr("required");

                  $('#selDesignation').removeAttr("required");
                  $('#selNationality').removeAttr("required");
                  $('#selDepartment').removeAttr("required");

                  $('#spnCompetency').hide();
                  $('#spnSpeciality').hide();
                  $('#spnLabourCostPerHour').hide();

                  $('#spnDesignation').hide();
                  $('#spnNationality').hide();
                  $('#spnDepartment').hide();

                  $('#txtContractor').attr('disabled', false);
                  $('#txtContractor').attr('required', true);
                  $('#hdnContractorId').attr('required', true);
                  $('#spnContractor').show();
                  $('#chkCentralPool').prop('checked', false);
                  $('#chkCentralPool').attr('disabled', true);

                  var contractorSearchObj = {
                      Heading: "Contractor Details",
                      SearchColumns: ["ContractorName-Contractor / Vendor Name", "SSMRegistrationCode-Contractor / Vendor Registration Number"],
                      ResultColumns: ["ContractorId-Primary Key", "ContractorName-Contractor / Vendor Name", "SSMRegistrationCode-Contractor / Vendor Registration Number"],
                      FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtContractor-ContractorName"]
                  };

                  $('#spnPopup-contractor').unbind("click");
                  $('#spnPopup-contractor').bind("click", function () {
                      DisplaySeachPopup('divSearchPopup', contractorSearchObj, "/api/Search/ContractorNameSearch");
                  }).attr('disabled', false).css('cursor', 'pointer');

              }

              $('#Timestamp').val(getResult.Timestamp);

              if (getResult.UserTypeId == 1) {
                  $('#btnAddEditMoveAllRight').attr('disabled', true);
                  $('#btnAddEditMoveOneRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', false);
              }
              else {
                  $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', false);
              }

              userRoles = getResult.UserRoles;
              $.each(userRoles, function (index, value) {
                  $('#selUserRole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
              });
              $('#selUserRole').val(getResult.SelectedUserRole);

              if ($('#ActionType').val() == 'Edit') {
                  $('#selCustomer').attr('disabled', false);
                  $('#selUserRole').attr('disabled', false);
              }

              AllLocations = getResult.AllLocations;
              LeftLocations = getResult.LeftLocations;
              LocationRole = getResult.LocationRole;
              ReloadTables();

              if ($('#ActionType').val() == 'View') {
                  $('#btnAddEditMoveOneRight').attr("disabled", true);
                  $('#btnAddEditMoveAllRight').attr("disabled", true);
                  $('#btnAddEditMoveAllLeft').attr("disabled", true);
                  $('#btnAddEditMoveOneLeft').attr("disabled", true);
                  $("#tblSelectedLocations").find("select").attr("disabled", true);
              }

              $('#selDesignation').attr('disabled', true);
              $('#selUserType').attr('disabled', true);

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
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/userRegistration/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFileds();
             })
             .fail(function () {
                 showMessage('User Registration', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFileds() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#chkExistingStaff').prop("disabled", false);
    $('#txtStaffName').prop("disabled", false);
    $('#txtStaffId').prop("disabled", false);
    $('#txtUserName').prop("disabled", false);
    $('#btnNextScreenSave').show();
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#selGender").val('null');
    $("#selStatus").val(1);
    $("#selDesignation").val('null');
    $("#selNationality").val('null');
    $("#selGrade").val('null');
    $("#selDepartment").val('null');
    $("#selServices").val('null');
    $("#selCustomer").val('null');
    $("#selUserRole").val('null');
    $('#tblLocations > tbody').empty();
    $('#tblSelectedLocations > tbody').empty();
    $('#selCompetency').val('null');
    setTimeout(multiSelectshow, 10);
    setTimeout(function () {
        $('.multiselect').attr('disabled', true);
    }, 20);
    $('#selSpeciality').val('null');
    $('#txtLabourCostPerHour').val('');
    $('#selStatus').val(1);
    
    SetUserTypeDropdown();

    $("#selUserType").val('null');
    $('#selUserType').attr('disabled', false);
    $('#txtDateOfJoining').prop("disabled", false);
    $('#selGrade').attr('disabled', true);
    $('#txtLabourCostPerHour').attr('disabled', true);
    $('#selDepartment').attr('disabled', true);
    $('.multiselect').attr('disabled', true);

    $('#hdnContractorId').val('');
    $('#txtContractor').attr('disabled', true);
    $('#spnPopup-contractor').unbind("click").attr('disabled', true).css('cursor', 'default');
    $('#chkCentralPool').attr('disabled', true);
    $('#chkCentralPool').prop('checked', false);
    $('#selServices').attr('disabled', false);
    $('#selCustomer').attr('disabled', false);
    $('#selCustomer').attr('required', true);
    $('#spnCustomer').show();
    $('#selUserRole').attr('disabled', false);
    $('#btnAddEditMoveOneRight, #btnAddEditMoveAllRight, #btnAddEditMoveAllLeft, #btnAddEditMoveOneLeft').attr('disabled', true);
    AllLocations = [];
    LeftLocations = [];
    LocationRole = [];
    userRoles = [];
    $("#grid").trigger('reloadGrid');
    $("#frmUserRegistration :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

}

function SetUserTypeDropdown()
{
    $('#selUserType').children('option:not(:first)').remove();
    $.each(UserTypesGlobal, function (index, value) {
        var disabled = '';
        if (UserTypeIdGlobal == 1 || UserTypeIdGlobal == 2 || UserTypeIdGlobal == 4) {
            disabled = 'disabled';
        }
        if (UserTypeIdGlobal == 3) {
            if (value.LovId == 3 || value.LovId == 5) {
                disabled = 'disabled';
            }
        }
        if (UserTypeIdGlobal == 5) {
            if (value.LovId == 5) {
                disabled = 'disabled';
            }
        }
        $('#selUserType').append('<option value="' + value.LovId + '" ' + disabled + '>' + value.FieldValue + '</option>');
    });
}

function ReloadTables() {
    $('#tblLocations > tbody').empty();
    $('#tblSelectedLocations > tbody').empty();
    var markup = "";
    $.each(LeftLocations, function (index, value) {
        if (value.IsVisible)
            if ($('#ActionType').val() == 'View') {
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
        if ($('#ActionType').val() == 'View') {
            markup += "<tr><td style='width:50%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td><td style='width:50%'>" + selString + "</td></tr>";
        }
        else {
            markup += "<tr style='cursor:pointer;'><td style='width:50%'><span style='display:none'>" + value.LovId + "</span>" + value.FieldValue + "</td><td style='width:50%'>" + selString + "</td></tr>";
        }
    });
    if (markup != "") {
        $('#tblSelectedLocations > tbody').append(markup);
        tableInputValidation('tblSelectedLocations');
        BindClickForSelectedLocations();
    }
}
function BindClickForLocations() {
    if ($('#ActionType').val() == 'View') {
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
    if ($('#ActionType').val() == 'View') {
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
function createSelect(lovId, UserRoleId) {
    var selectedValue = UserRoleId;
    var selected = "";
    var selString = "<select id='sels" + lovId + "' class='form-control' required><option value='null'>Select</option>";
    $.each(userRoles, function (index, value) {
        selected = ""
        if (value.LovId == selectedValue) selected = "selected"
        selString += "<option value='" + value.LovId + "' " + selected + ">" + value.FieldValue + "</option>";
    });
    selString += "</select>";

    return selString;
}

window.multiSelectshow = function () {
    $('select[name=Flag]').multiselect('destroy');
    $('select[name=Flag]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: true });

    $('select[name=Flag1]').multiselect('destroy');
    $('select[name=Flag1]').multiselect({ maxHeight: 200, maxWidth: 500, buttonWidth: '100%', includeSelectAllOption: false });
}

$('.decimalCheck').each(function (index) {
    var vrate = document.getElementById(this.id);
    vrate.addEventListener('input', function (prev) {
        return function (evt) {
            if ((!/^\d{0,6}(?:\.\d{0,2})?$/.test(this.value))) {
                this.value = prev;
            }
            else {
                prev = this.value;
            }
        };
    }(vrate.value), false);
});

$("#btnPrint").live("click", function () {
    var divContents = $("#dvContainer").html();
    var printWindow = window.open('', '', 'height=400,width=800');
    printWindow.document.write('<html><head><title>DIV Contents</title>');
    printWindow.document.write('</head><body >');
    printWindow.document.write(divContents);
    printWindow.document.write('</body></html>');
    printWindow.document.close();
    printWindow.print();
});