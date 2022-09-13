var JIDropdownLovVal = "<option value='' selected >" + "Select" + "</option>";
var LocationCode = 0;
var FileTypeValue = "";
var rowNum1 = 1;

$(document).ready(function () {

    $('#JiRating').on('shown.bs.collapse', function () {
        $(".JiIcon").removeClass('glyphicon-chevron-down');
        $(".JiIcon").addClass('glyphicon-chevron-up');
    });
    $('#JiRating').on('hidden.bs.collapse', function () {
        $(".JiIcon").removeClass('glyphicon-chevron-up');
        $(".JiIcon").addClass('glyphicon-chevron-down')
    });

    $.get("/api/JIDetails/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
          FileTypeValue = "<option value=''>" + "Select" + "</option>";
          for (var i = 0; i < loadResult.DropDownLovs.length; i++) {
              JIDropdownLovVal +="<option value=" + loadResult.DropDownLovs[i].LovId + ">" + loadResult.DropDownLovs[i].FieldValue + "</option>"
            }

            for (var i = 0; i < loadResult.FileTypeValues.length; i++) {
                FileTypeValue += "<option value=" + loadResult.FileTypeValues[i].LovId + ">" + loadResult.FileTypeValues[i].FieldValue + "</option>"
            }
           
            $("#table2 tbody #ddlFileType1").append(FileTypeValue);
            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    var DocumentNoFetchObj = {
        SearchColumn: 'txtJIDocumentNo-DocumentNo',//Id of Fetch field
        ResultColumns: ["ScheduleId-Primary Key", 'DocumentNo-DocumentNo'],//Columns to be displayed
        FieldsToBeFilled: ["hdnDocumentId-ScheduleId", "txtJIDocumentNo-DocumentNo", "txtUserAreaCode-UserAreaCode", "txtUserAreaName-UserAreaName"]//id of element - the model property
    };

    $('#txtJIDocumentNo').on('input propertychange paste keyup', function (event) {
        $('#tbodyLocations').html("");
        LocationCode = 0;
        $('#txtUserLocation').val(LocationCode);
        var Satisfactory = 0;
        var UnSatisfactory = 0;
        var TotalElementsInspected = 0;
        var Notapplicable = 0;
        $("#txtSatisfactory").val(Satisfactory);
        $("#txtUnSatisfactory").val(UnSatisfactory);
        $("#txtNotApplicable").val(Notapplicable);
        $("#txtInspected").val(TotalElementsInspected);
        $('#lblReference').html("Reference No.(*If Rating is 'YS')");
        $('#txtReferenceNo').prop('required', false);
        $('#txtReferenceNo').prop("disabled", true);
        DisplayFetchResult('divFetchId', DocumentNoFetchObj, "/api/JIDetails/DocumentNoFetch", "UlFetch1", event, 1);//1 -- pageIndex
    });
        
    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCompanyRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCompanyRepresentative-StaffName","txtCompanyRepresentativeDesignation-Designation"]//id of element - the model property
    };

    $('#txtCompanyRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch5', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });
    
    var HospitalStaffFetchObj = {
        SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-Designation"]//id of element - the model property
    };

    $('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', HospitalStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    //clicking on 2nd tab restrict
    $(".nav-tabs").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
    });

    $("#btnSubmit").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
            bootbox.alert("Save All The Fields First before submit");
            return false;
        }
        else {  
            bootbox.confirm({
                message: "Details once submitted cannot be edited",
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
                        $('#myPleaseWait').modal('show');
                        var obj = {
                            Status: 'Closed',
                            DetailsId: primaryId
                        }

                        $.post("/api/JIDetails/Submit", obj, function (response) {
                            var result = JSON.parse(response);
                            showMessage('JiDetails', CURD_MESSAGE_STATUS.SS);
                            $('#btnSave').hide();
                            $('#btnSubmit').hide();
                            //$("#primaryID").val(result.DetailsId);
                            $('#myPleaseWait').modal('hide');
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
                                $('#myPleaseWait').modal('hide');

                            });
                    }
                }
            });

           
        }
    });

    $("#btnSave").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
       
        var isFormValid = formInputValidation("formJIDetail", 'save');
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
            DetailsId: primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,           
            DocumentNo: $('#txtJIDocumentNo').val(),
            DateandTime: $('#txtJIDateTime').val(),
            UserAreaCode: $('#txtUserAreaCode').val(),
            UserAreaName: $('#txtUserAreaName').val(),
            HospitalRepresentative: $('#txtHospitalRepresentative').val(),
            HospitalRepresentativeDesignation: $('#txtHospitalRepresentativeDesignation').val(),
            CompanyRepresentative: $('#txtCompanyRepresentative').val(),
            CompanyRepresentativeDesignation: $('#txtCompanyRepresentativeDesignation').val(),
            Remarks: $('#txtRemarks').val(),
            ReferenceNo: $('#txtReferenceNo').val(),
            Satisfactory: $('#txtSatisfactory').val(),
            NoofUserLocation: $('#txtUserLocation').val(),
            UnSatisfactory: $('#txtUnSatisfactory').val(),
            GrandTotalElementsInspected: $('#txtInspected').val(),
            NotApplicable: $('#txtNotApplicable').val(),
            LocationCode: $('#txtLocationCode').val(),
            LocationName: $('#txtLocationName').val(),
            Floor: $('#ddlFloor').val(),
            Walls: $('#ddlWalls').val(),
            Ceiling: $('#ddlCeiling').val(),
            WindowsandDoors: $('#ddlWindowsandDoors').val(),
            ReceptaclesandContainers: $('#ddlReceptaclesandContainers').val(),
            FurnitureFixtureandEquipment: $('#ddlFurnitureandFixture').val(),
            Remark: $('#txtRemark').val(),
            LocationDetailsList: []
        }

        //var i = 0;
        $("#tbodyLocations tr").each(function () {
           
            var tbl = {};           
            tbl.LocationCode = $(this).children("td").find("text").eq(0).html();
            tbl.LocationName = $(this).children("td").find("text").eq(1).html();           
            tbl.Floor = $(this).find("[id^=ddlFloor]")[0].value;
            tbl.Walls = $(this).find("[id^=ddlWalls]")[0].value;            
            tbl.Ceiling = $(this).find("[id^=ddlCeling]")[0].value;           
            tbl.WindowsandDoors = $(this).find("[id^=ddlWD]")[0].value;           
            tbl.ReceptaclesandContainers = $(this).find("[id^=ddlRC]")[0].value;           
            tbl.FurnitureFixtureandEquipment = $(this).find("[id^=ddlFFE]")[0].value;           
            tbl.Remark = $(this).children("td").children("textarea").val();
            obj.LocationDetailsList.push(tbl);

        });

       
        $.post("/api/JIDetails/Save", obj, function (response) {
            var result = JSON.parse(response);

            showMessage('JiDetails', CURD_MESSAGE_STATUS.SS);            
            $("#grid").trigger('reloadGrid');

            fillDetails(result);
           
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

    $("#btnFetch").click(function () {
       
        var obj = {
            DocumentNo: $('#txtJIDocumentNo').val()
        }
        if ($('#txtJIDocumentNo').val() !== "") {
            FetchJIDetails(obj);
        }
        else {
            bootbox.alert("Please select the JI Document No.");
        }
    });

    $('body').on('change', '.JiDetail', function (event) {

        setJIQualityRating();
        
    });

    
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

    $("#btnSaveAttachment").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg1').css('visibility', 'hidden');

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var isFormValid = formInputValidation("formJi", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');
            return false;
        }

        var obj = {
            DetailsId: primaryId,
            lstJIDetailsAttachments: []
        }

        var isValidAttachments = true;
        $('#tbodyAttachments tr').each(function () {
            if ($(this).find("[id^=icon]")[0] == undefined) {
                isValidAttachments = false;
                return;
            }
        });

        if (isValidAttachments == false) {
            $("div.errormsgcenter").text(' Please select the file to proceed. ');
            $('#errorMsg1').css('visibility', 'visible');
            return false;
        }

        $('#tbodyAttachments tr').each(function () {

            var tbl = {};
            tbl.JIAttachmentId = $(this).find("[id^=hdnAttachmentId]")[0].value;
            tbl.FileType = $(this).find("[id^=ddlFileType]")[0].value;
            tbl.FileName = $(this).find("[id^=txtFileName]")[0].value;
            if ($(this).find("[id^=txtAttachment]")[0].files.length != 0) {
                tbl.AttachmentName = $(this).find("[id^=txtAttachment]")[0].files[0].name;
            }
            tbl.FilePath = $(this).find("[id^=icon]")[0].pathname;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");

            obj.lstJIDetailsAttachments.push(tbl);
        });



        $.post("/api/JIDetails/AttachmentSave", obj, function (response) {
            var result = JSON.parse(response);
            fillAttachments(result);
            showMessage('JIDetails Attachment', CURD_MESSAGE_STATUS.SS);
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
                $('#errorMsg1').css('visibility', 'hidden');

                $('#btnSaveAttachment').attr('disabled', false);

            });


    });   

    $("#addAttachment").click(function () {
        rowNum1 = rowNum1 + 1;
        addAttachment(rowNum1);
    });

    $("#deleteAttachments").click(function () {

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
                        $("#tbodyAttachments tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnAttachmentId]").val() == 0) {
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

    $('body').on('change', '.fileAttachment', function (e) {
        var AttachIdId1 = event.target.id;
        
        var id = AttachIdId1.slice(13, 15);
        var fileUpload = $(this).get(0);
        var files = fileUpload.files;

        var fileData = new FormData();

        var d = new Date();
        var day = d.getDate();
        var month = d.getMonth() + 1;
        var year = d.getFullYear();
        if (day < 10) {
            day = "0" + day;
        }
        if (month < 10) {
            month = "0" + month;
        }
        var fileName = "JI_" + year + month + day + "_" + Math.floor(Math.random() * 100000);

        fileData.append(fileName, files[0]);

        $.ajax({
            url: '/api/Common/FileUpload',
            type: "POST",
            contentType: false, // Not to set any content header  
            processData: false, // Not to process data  
            data: fileData,
            success: function (result) {

                if (result == "File Uploaded Successfully!") {


                    $('#icon' + id).remove();
                    if (id >= 1) {
                        $('#cell' + id).append(
                            '<a href="" style="color:cornflowerblue" download="" id="icon' + id + '"><span style="text-align:center"><i class="fa fa-download" style="font-size:15px;"></i></span> </a>'
                        );
                    }
                    else {
                        $('#cell').append(
                            '<a href="" style="color:cornflowerblue" download="" id="icon"><span style="text-align:center"><i class="fa fa-download" style="font-size:15px;"></i></span> </a>'
                        );
                    }

                    var testFileName = $('#txtAttachment' + id).val();                   
                    var extn = testFileName.split('.').pop();

                    $("#icon" + id).attr("href", "../uploads/attachments/" + fileName + "." + extn);
                }
            },
            error: function (err) {

                var errorMessage = "";
                if (err.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(err);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
            }
        });

    });

    $('#txtHospitalRepresentative').change('change', function () {
        $('#formJIDetail #hospital').removeClass('has-error');
    });

    $('#txtReferenceNo').on('change', function () {
        $('#formJIDetail #referenceno').removeClass('has-error');
    });

    $('#txtCompanyRepresentative').change('change', function () {

        $('#formJIDetail  #company').removeClass('has-error');
    });

    $('#ddlFileType').change(function () {

        $('#formJi #filetypee').removeClass('has-error');

    });

    $('#txtFileName').keypress(function () {

        $('#formJi #fname').removeClass('has-error');
        $('#errorMsg1').css('visibility', 'hidden');
    });

    $('.fileAttachment').change(function () {

        $('#formJIDetail #icon').remove();

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

function FetchJIDetails(obj) {

    var jqxhr = $.post("/api/JIDetails/LocationCodeFetch", obj, function (response) {

        var result = JSON.parse(response);

        if (result.LocationDetailsList.length > 0) {

            $('#table_data').hide();
            $('#tbodyLocations').html('');
            var fetch = "";

            for (var i = 0; i < result.LocationDetailsList.length; i++) {

                fetch = "<tr><td id='txtLocationCode" + i + "'><text>" + result.LocationDetailsList[i].LocationCode + "</text></td>"
                    + "<td><text id='txtLocationName" + i + "'>" + result.LocationDetailsList[i].LocationName + "</text></td>"
                    + "<td><select class='JiDetail' required id='ddlFloor" + i + "'>" + JIDropdownLovVal + "</select></td>"
                    + "<td><select class='JiDetail' required id='ddlWalls" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlCeling" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlWD" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlRC" + i + "'>" + JIDropdownLovVal  + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlFFE" + i + "'>" + JIDropdownLovVal  + "</select ></td>"
                    + "<td id='txtRemark" + i + "'><textarea type='text'/>" + "</td></tr>";

                $('#tbodyLocations').append(fetch);

                $('#ddlFloor' + i).val(result.LocationDetailsList[i].Floor);
                $('#ddlWalls' + i).val(result.LocationDetailsList[i].Walls);
                $('#ddlCeling' + i).val(result.LocationDetailsList[i].Ceiling);
                $('#ddlWD' + i).val(result.LocationDetailsList[i].WindowsandDoors);
                $('#ddlRC' + i).val(result.LocationDetailsList[i].ReceptaclesandContainers);
                $('#ddlFFE' + i).val(result.LocationDetailsList[i].FurnitureFixtureandEquipment);
            }
            
            $('#tbodyLocations').find("select").addClass("form-control");
            LocationCode = result.LocationDetailsList.length;
            $('#txtUserLocation').val(LocationCode);

            setJIQualityRating();
        }
        
    },
        "json")
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
           

        });
    
}

function setJIQualityRating() {

    var Satisfactory = 0;
    var UnSatisfactory = 0;
    var TotalElementsInspected = 0;
    var Notapplicable = 0;
    var isYSRequired = 0;

    $('.JiDetail').each(function () {

        var AttachIdId = $(this)[0].id;
        var JI = $("#" + AttachIdId)[0];

        if (JI.options[JI.options.selectedIndex].text == "NA") {
            Notapplicable = Notapplicable + 1;
        }
        if (JI.options[JI.options.selectedIndex].text == "Y") {
            Satisfactory = Satisfactory + 1;
        }
        if (JI.options[JI.options.selectedIndex].text != "NA" && JI.options[JI.options.selectedIndex].text != "Y" && JI.options[JI.options.selectedIndex].text != "Select") {
            UnSatisfactory = UnSatisfactory + 1;
        }
        if (JI.options[JI.options.selectedIndex].text != "NA" && JI.options[JI.options.selectedIndex].text != "Select") {
            TotalElementsInspected = TotalElementsInspected + 1;
        }
        if (JI.options[JI.options.selectedIndex].text == "YS") {

            isYSRequired += 1;

        }
    });

    $("#txtSatisfactory").val(Satisfactory);
    $("#txtUnSatisfactory").val(UnSatisfactory);
    $("#txtNotApplicable").val(Notapplicable);
    $("#txtInspected").val(TotalElementsInspected);

    if (isYSRequired > 0) {
        $('#lblReference').html("Reference No.(*If Rating is 'YS') <span class='red'>*</span>");
        $('#txtReferenceNo').prop('required', true);
        $('#txtReferenceNo').prop("disabled", false);
    }
    else {
        $('#lblReference').html("Reference No.(*If Rating is 'YS')");
        $('#txtReferenceNo').prop('required', false);
        $('#txtReferenceNo').prop("disabled", true);
        $('#txtReferenceNo').val('');
    }
}

function EmptyFields() {

    $('#formJIDetail')[0].reset();
    $('#primaryID').val(0);
    $('[id^=hdnAttachmentId]').val(0);

    $('#btnSave').show();
    $('#btnSubmit').show();  

    $('#formJIDetail #txtHospitalRepresentative').val('');
    $('#formJIDetail #txtCompanyRepresentative').val('');
    $('#table_data').show();
    $('#datetable').removeClass('has-error');
    $('#hospital').removeClass('has-error');
    $('#company').removeClass('has-error');
    $('#table_data').show();
    $('#txtSatisfactory').val('');
    $('#txtUserLocation').val('');
    $('#txtUnSatisfactory').val('');
    $('#txtInspected').val('');
    $('#txtNotApplicable').val('');
    rowNum1 = 1;
   
    $("#tbodyLocations").find('tr').each(function () {        
            $(this).remove();       
    });
    var i = 1;
    $("#tbodyAttachments").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
    $('#errorMsg').css('visibility', 'hidden');
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formDeptAreaDetail :input:not(:button)").parent().removeClass('has-error');
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
        $("#formDeptAreaDetail :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/JIDetails/Get/" + primaryId)
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
}

function fillDetails(result) {

    if (result != undefined) {

        $('#primaryID').val(result.DetailsId);
        $('#txtJIDocumentNo').val(result.DocumentNo);
        $('#txtJIDateTime').val(result.DateandTime);
        $('#txtUserAreaCode').val(result.UserAreaCode);
        $('#txtUserAreaName').val(result.UserAreaName);
        $('#txtHospitalRepresentative').val(result.HospitalRepresentative);
        $('#txtHospitalRepresentativeDesignation').val(result.HospitalRepresentativeDesignation);
        $('#txtCompanyRepresentative').val(result.CompanyRepresentative);
        $('#txtCompanyRepresentativeDesignation').val(result.CompanyRepresentativeDesignation);
        $('#txtRemarks').val(result.Remarks);
        $('#txtReferenceNo').val(result.ReferenceNo);
        $('#txtSatisfactory').val(result.Satisfactory);
        $('#txtUserLocation').val(result.NoofUserLocation);
        $('#txtUnSatisfactory').val(result.UnSatisfactory);
        $('#txtInspected').val(result.GrandTotalElementsInspected);
        $('#txtNotApplicable').val(result.NotApplicable);

        if (result.IsSubmitted == 1) {
            $('#btnSave').hide();
            $('#btnSubmit').hide();
        }
        else {
            $('#btnSave').show();
            $('#btnSubmit').show();
        }

        var fetch = "";
        $('#tbodyLocations').html('');

        if (result.LocationDetailsList != null) {

            for (i = 0; i < result.LocationDetailsList.length; i++) {

                fetch = "<tr><td id='txtLocationCode" + i + "'><text>" + result.LocationDetailsList[i].LocationCode + "</text></td>"
                    + "<td><text id='txtLocationName" + i + "'>" + result.LocationDetailsList[i].LocationName + "</text></td>"
                    + "<td><select class='JiDetail' required id='ddlFloor" + i + "'>" + JIDropdownLovVal + "</select></td>"
                    + "<td><select class='JiDetail' required id='ddlWalls" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlCeling" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlWD" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlRC" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td><select class='JiDetail' required id='ddlFFE" + i + "'>" + JIDropdownLovVal + "</select ></td>"
                    + "<td id='txtRemark" + i + "'><textarea type='text'>" + result.LocationDetailsList[i].Remark + "</textarea></td>";

                $('#tbodyLocations').append(fetch);

                $('#ddlFloor' + i).val(result.LocationDetailsList[i].Floor);
                $('#ddlWalls' + i).val(result.LocationDetailsList[i].Walls);
                $('#ddlCeling' + i).val(result.LocationDetailsList[i].Ceiling);
                $('#ddlWD' + i).val(result.LocationDetailsList[i].WindowsandDoors);
                $('#ddlRC' + i).val(result.LocationDetailsList[i].ReceptaclesandContainers);
                $('#ddlFFE' + i).val(result.LocationDetailsList[i].FurnitureFixtureandEquipment);

            }

           
            $('#table_data').hide();
        }        

        $('#tbodyLocations').find("select").addClass("form-control");

        fillAttachments(result.lstJIDetailsAttachments);
       
        
    }
}

function fillAttachments(result) {


    $('#tbodyAttachments').html('');
    rowNum1 = 1;
    if (result != null) {
        $('#table_data').hide();

        for (var k = 0; k < result.length; k++) {

            addAttachment(rowNum1);

            $('#hdnAttachmentId' + rowNum1).val(result[k].JIAttachmentId);
            $('#ddlFileType' + rowNum1).val(result[k].FileType);
            $('#txtFileName' + rowNum1).val(result[k].FileName);
            $('#fileAttachment' + rowNum1).val(result[k].AttachmentName1);

            var FilePath = result[k].FilePath
            $('#cell' + rowNum1).append(
                '<a href="' + FilePath + '" style="color:cornflowerblue" download="" id="icon' + rowNum1 + '"><span style="text-align:center"><i class="fa fa-download" style="font-size:15px;"></i></span> </a>'
            );

            rowNum1 += 1;
        }

        $('#tbodyAttachments').find("select").addClass("form-control");
    }
    else {
        addAttachment(1);
    }
    
}

function addAttachment(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /><input type="hidden" id="hdnAttachmentId' + num + '"  value="0" /></td>';
    var FileType = '<td id="filetypee"> <select type="text" required class="form-control" id="ddlFileType' + num + '" autocomplete="off" name="FileType" maxlength="25" >' + FileTypeValue + ' </select> </td>';
    var FileName = '<td id="fname"><input type="text" required class="form-control" id="txtFileName' + num + '" autocomplete="off" name="FileName" maxlength="25"  /></td>';
    var Attachment = '<td id="attachment"> <input type="file" id="txtAttachment' + num + '" name="fileAttachment" required class="form-control fileAttachment" /></td>';
    var Download = '<td style="text-align:center" id="cell' + num + '"></td>';

    $("#tbodyAttachments").append('<tr>' + CheckBox + FileType + FileName + Attachment + Download + '</tr>');
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

    
   
   