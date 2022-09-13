var classGradedropdown = "";
var statusvalues = "";
var issuingBody = "";
var rowNum = 1; 

var FileTypeValues = "";
var filePrefix = "DD_";
var ScreenName = "DriverDetails";
var rowNum2 = 1;

$(document).ready(function () {

    //****************************************** Load dropdown values *********************************************

    $.get("/api/HWMSDriverDetails/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#ddlClassGrade1").append("<option value='' >" + "Select" + "</option>");
            issuingBody = "<option value=''>Select</option>";
            var TreatmentPlant = "<option value=''>Select</option>";
            var Route = "<option value=''>Select</option>";
            for (var i = 0; i < loadResult.IssuingBodyLovs.length; i++) {
                issuingBody += "<option value=" + loadResult.IssuingBodyLovs[i].LovId + ">" + loadResult.IssuingBodyLovs[i].FieldValue + "</option>"
            }
           
            for (var i = 0; i < loadResult.DriverStatusLovs.length; i++) {
                statusvalues += "<option value=" + loadResult.DriverStatusLovs[i].LovId + ">" + loadResult.DriverStatusLovs[i].FieldValue + "</option>";
            }
            for (var i = 0; i < loadResult.ClassGradeLovs.length; i++) {
                classGradedropdown += "<option value=" + loadResult.ClassGradeLovs[i].LovId + ">" + loadResult.ClassGradeLovs[i].FieldValue + "</option>";
            }
            for (var i = 0; i < loadResult.TreatmentPlantLovs.length; i++) {
                TreatmentPlant += "<option value=" + loadResult.TreatmentPlantLovs[i].LovId + ">" + loadResult.TreatmentPlantLovs[i].FieldValue + "</option>"
            }
            for (var i = 0; i < loadResult.RouteLovs.length; i++) {
                Route += "<option value=" + loadResult.RouteLovs[i].LovId + ">" + loadResult.RouteLovs[i].FieldValue + "</option>"
            }

            $("#ddlIssuedBy1").append(issuingBody);
            $("#ddlStatus").append(statusvalues);
            $("#ddlClassGrade1").append(classGradedropdown);
            $("#ddlTreatmentPlant").append(TreatmentPlant);
            $("#ddlRoute").append(Route);

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "Driver Details" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);


            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });


    //****************************************** AutoPopulate LicenseCode ******************************************
        
    $(body).on('input propertychange paste keyup', '.clsLicenseCode', function (event) {
        var controlld = event.target.id;
        var id = controlld.slice(14, 16);

        var LicenseCodeFetchObj = {
            SearchColumn: 'txtLicenseCode' + id + '-LicenseCode',//Id of Fetch field
            ResultColumns: ['LicenseId-Primary Key', 'LicenseCode-LicenseCode'],
            FieldsToBeFilled: ['hdnLicenseId' + id + '-LicenseId', 'txtLicenseCode' + id + '-LicenseCode', 'txtLicenseDescription' + id + '-LicenseDescription', 'ddlIssuedBy' + id + '-IssuingBody' ]
        };

        DisplayFetchResult('divLicenseCode' + id , LicenseCodeFetchObj, "/api/HWMSDriverDetails/LicenseCodeFetch", 'UlFetch' + id, event, 1);//1 -- pageIndex
    });

    
  

    //********************************************* Changing Effectiveto date based on status 

    $("#ddlStatus").change(function () {

        var StateValue = $('#ddlStatus option:selected').text();
        if (StateValue == 'Active') {
            $('#txtEffectiveTo').val("");
            $("#txtEffectiveTo").prop('disabled', true);
        }
        else {
            var val = "";
            var date = new Date();
            var months = ["Jan", "Feb", "Mar", "Apr",
                "May", "Jun", "Jul", "Aug",
                "Sep", "Oct", "Nov", "Dec"];
            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $("#txtEffectiveTo").val(val);
            $("#txtEffectiveTo").prop('disabled', false);
        }

    });
      
   
   //**************************** Save,Save and Add New **********************//

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();       

        var isFormValid = formInputValidation("formDriverDetails", 'save');
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
            DriverId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            DriverCode: $('#txtDriverCode').val(),
            DriverName: $('#txtDriverName').val(),
            TreatmentPlant: $('#ddlTreatmentPlant').val(),
            Status: $('#ddlStatus').val(),
            EffectiveFrom: $('#txtEffectiveFrom').val(),
            EffectiveTo: $('#txtEffectiveTo').val(),
            ContactNo: $('#txtContactNo').val(),
            Route: $('#ddlRoute option:selected').text(),
            DriverDetailsList: []
        }

        $("#tbodyLicenseCode tr").each(function () {

            var tbl = {};            
            tbl.LicenseCodeId = $(this).find("[id^=hdnLicenseCodeId]")[0].value;
            tbl.LicenseCode = $(this).find("[id^=txtLicenseCode]")[0].value;
            tbl.Description = $(this).find("[id^=txtLicenseDescription]")[0].value;
            tbl.LicenseNo = $(this).find("[id^=txtLicenseNo]")[0].value;
            tbl.ClassGrade = $(this).find("[id^=ddlClassGrade]")[0].value;
            tbl.IssuedBy = $(this).find("[id^=ddlIssuedBy]")[0].value;
            tbl.IssuedDate = $(this).find("[id^=txtIssuedDate]")[0].value;
            tbl.ExpiryDate = $(this).find("[id^=txtExpiryDate]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.DriverDetailsList.push(tbl);
        });
               
         
        var jqxhr = $.post("/api/HWMSDriverDetails/Save", obj, function (response) {

            showMessage('DriverDetails', CURD_MESSAGE_STATUS.SS);                
            var result = JSON.parse(response);            
            $("#grid").trigger('reloadGrid');
            
            $("div.errormsgcenter").text('');
            $('#errorMsg').css('visibility', 'hidden');

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

    //Cancel Button
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


    //******************************************************* Add multiple rows ******************************************************** 
    

    $("#addRowLicenseCode").click(function () {       
        rowNum = rowNum + 1;
        addRowLicenseCode(rowNum);        
    });

    //Mutliple rows delete button code....   
    $("#deleteLicenseCode").click(function () {
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

     
    //************************************************ Validation red border removal while giving value *********************************************

    $('#txtDriverCode').on('change', function () {

        $('#DriverCode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtDriverName').on('change', function () {

        $('#DriverName').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlTreatmentPlant').on('change', function () {

        $('#ddlTreatmentPlant1').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlStatus').on('change', function () {

        $('#Status').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtEffectiveFrom').on('change', function () {

        $('#effect').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });


    $('#txtLicenceCode').on('change', function () {

        $('#formDriverDetails #LicenseCode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtLicenceNo1').on('change', function () {

        $('#formDriverDetails #LicenseNo').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlClassGrade1').on('change', function () {

        $('#formDriverDetails #ClassGrade').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtIssuedDate1').on('change', function () {

        $('#formDriverDetails #IssuedDate').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#txtExpiryDate1').on('change', function () {

        $('#formDriverDetails #ExpiryDate').removeClass('has-error');
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


//********************************* Function Empty Fields(Reset) ************************************

function EmptyFields() {

    $("#primaryID").val('0');
    $('[id^=hdnLicenseCodeId]').val(0);

    $('#formDriverDetails')[0].reset(); 
    $('#formDriverDetails #txtDriverCode').val('');
    $('#formDriverDetails #txtDriverName').val('');
    $('#formDriverDetails #ddlTreatmentPlant').val('');
    $("#ddlStatus").val($("#ddlStatus option:contains('Active')").val());
    $('#formDriverDetails #txtEffectiveFrom').val('');
    $('#formDriverDetails #txtEffectiveTo').val('');
    $('#formDriverDetails #txtContactNo').val('');
    $('#formDriverDetails #ddlRoute').val('');
    $('#formDriverDetails #txtLicenseCode1').val('');
    $('#formDriverDetails #txtLicenseDescription1').val('');
    $('#formDriverDetails #txtLicenseNo1').val('');
    $('#formDriverDetails #ddlClassGrade1').val('');
    $('#formDriverDetails #ddlIssuedBy1').val('');
    $('#formDriverDetails #txtIssuedDate1').val('');
    $('#formDriverDetails #txtExpiryDate1').val('');
    $("#txtEffectiveTo").prop('disabled', true);
    
    $('#DriverCode').removeClass('has-error');
    $('#DriverName').removeClass('has-error');
    $('#TreatmentPlant1').removeClass('has-error');
    $('#Status').removeClass('has-error');
    $('#effect').removeClass('has-error');
    $('#formDriverDetails #LicenseCode').removeClass('has-error');
    $('#formDriverDetails #LicenseNo').removeClass('has-error');
    $('#formDriverDetails #ClassGrade').removeClass('has-error');
    $('#formDriverDetails #IssuedDate').removeClass('has-error');
    $('#formDriverDetails #ExpiryDate').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');

    var i = 1;
    $("#tbodyLicenseCode").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
}


//************************************************ Function LinkClicked(Get) *************************************************
function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formDriverDetails :input:not(:button)").parent().removeClass('has-error');
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
        //$('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/HWMSDriverDetails/Get/" + primaryId)
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

        $("#primaryID").val(result.DriverId);
        $('#txtDriverCode').val(result.DriverCode);
        $('#txtDriverName').val(result.DriverName);
        $('#ddlTreatmentPlant').val(result.TreatmentPlant);
        $('#ddlStatus').val(result.Status);

        var fromDate = getCustomDate(result.EffectiveFrom);
        $('#txtEffectiveFrom').val(fromDate);

        var toDate = getCustomDate(result.EffectiveTo);
        $('#txtEffectiveTo').val(toDate);

        if (toDate == '') {   
            $("#txtEffectiveTo").prop('disabled', true);
        }

        $('#txtContactNo').val(result.ContactNo);
        //$('#ddlRoute').val(result.Route);        
        $('#ddlRoute option').map(function () {
            if ($(this).text() == result.Route) return this;
        }).attr('selected', 'selected');

       

        rowNum = 1;
        $("#tbodyLicenseCode").html('');
        if (result.DriverDetailsList != null) {
            for (var i = 0; i < result.DriverDetailsList.length; i++) {

                addRowLicenseCode(rowNum);

                $('#hdnLicenseCodeId' + rowNum).val(result.DriverDetailsList[i].LicenseCodeId);
                $('#txtLicenseCode' + rowNum).val(result.DriverDetailsList[i].LicenseCode);
                $('#txtLicenseDescription' + rowNum).val(result.DriverDetailsList[i].Description);
                $('#txtLicenseNo' + rowNum).val(result.DriverDetailsList[i].LicenseNo);
                $('#ddlClassGrade' + rowNum).val(result.DriverDetailsList[i].ClassGrade);
                $('#ddlIssuedBy' + rowNum).val(result.DriverDetailsList[i].IssuedBy);

                var IssuDate = getCustomDate(result.DriverDetailsList[i].IssuedDate);
                $('#txtIssuedDate' + rowNum).val(IssuDate);
                var ExpairyDate = getCustomDate(result.DriverDetailsList[i].ExpiryDate);
                $('#txtExpiryDate' + rowNum).val(ExpairyDate);

                rowNum = rowNum + 1;
            }
        }
        else {
            addRowLicenseCode(rowNum);
        }

        fillAttachment(result.AttachmentList);
        
    }   
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
});

function addRowLicenseCode(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" name="isDelete"  id="isDelete' + num + '" /> <input type="hidden" value="0" id="hdnLicenseCodeId' + num + '"  /></td>';
    var LicenseCode = '<td id="LicCodeError"><input type="text" required class="form-control clsLicenseCode" placeholder="Please Select" id="txtLicenseCode' + num + '" autocomplete="off" name="LicenseCode" maxlength="25" >   <input type = "hidden" id="hdnLicenseId' + num + '" />   <div class="col-sm-12" id="divLicenseCode' + num + '">   </div>   </td >';
    var LicenseDescription = '<td id="LicenseDescription"><input type="text"  class="form-control" disabled id="txtLicenseDescription' + num + '" autocomplete="off" name="Description" maxlength="25"  /></td>';
    var IssuedBy = '<td id="IssuedBy"><select type="text" disabled class="form-control" id="ddlIssuedBy' + num + '" autocomplete="off" name="ddlIssuedBy" maxlength="25"  >  ' + issuingBody + ' </select> </td>';
    var LicenseNo = '<td id="LicNoError"><input type="text" required class="form-control" id="txtLicenseNo' + num + '" autocomplete="off" name="LicenseNo" maxlength="25"  /></td>';
    var ClassGrade = '<td id="ClassGrade"> <select required class="form-control" id="ddlClassGrade' + num + '" autocomplete="off" name="ClassGrade" maxlength="25"  ><option value="">Select </option>' + classGradedropdown + '</td>';
    var IssuedDate = '<td id="IssuedDate"><input type="text" required class="form-control datetime" id="txtIssuedDate' + num + '" autocomplete="off" name="IssuedDate" maxlength="25"  /></td>';
    var ExpiryDate = '<td id="ExpiryDate"><input type="text" required class="form-control datetime" id="txtExpiryDate' + num + '" autocomplete="off" name="ExpiryDate" maxlength="25"  /></td>';

    $("#tbodyLicenseCode").append('<tr>' + CheckBox + LicenseCode + LicenseDescription + IssuedBy + LicenseNo + ClassGrade + IssuedDate + ExpiryDate + '</tr>');

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