var rowNum = 1;
$(document).ready(function () {
    var MethodofDisposalValues = "";
    var RecyclableWasteTypeValues = "";
    var TransportationCategoryValues = "";
    var WasteCodeValues = "";
   
    $.get("/api/RecordsofRecyclableWaste/Load")
   
        .done(function (result) {
            var loadResult = JSON.parse(result);

            MethodofDisposalValues= "<option value='' Selected>" + "Select" + "</option>";
            RecyclableWasteTypeValues="<option value='' Selected>" + "Select" + "</option>";
            TransportationCategoryValues="<option value='0' Selected>" + "Select" + "</option>";

            for (var i = 0; i < loadResult.MethodofDisposalValue.length; i++) {            
                    MethodofDisposalValues+= "<option value=" + loadResult.MethodofDisposalValue[i].LovId + ">" + loadResult.MethodofDisposalValue[i].FieldValue + "</option>"            
            }
            $("#ddlMethodOfDisposal").append(MethodofDisposalValues)

            for (var i = 5; i < loadResult.RecyclableWasteTypeValue.length; i++) {             
                    RecyclableWasteTypeValues+= "<option value=" + loadResult.RecyclableWasteTypeValue[i].LovId + ">" + loadResult.RecyclableWasteTypeValue[i].FieldValue + "</option>"            
            }
            $("#ddlWasteType").append(RecyclableWasteTypeValues);
            
            for (var i = 0; i < loadResult.TransportationCategoryValue.length; i++) {               
                    TransportationCategoryValues+= "<option value=" + loadResult.TransportationCategoryValue[i].LovId + ">" + loadResult.TransportationCategoryValue[i].FieldValue + "</option>"               
            }
            $("#ddlTransportationCategory").append(TransportationCategoryValues);

            $('#myPleaseWait').modal('hide');
        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    //***************************Hospital Representative Auto Populate*****************************//

    var HospitalStaffFetchObj = {
        SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-Designation"]
        //id of element - the model property
    };

    $('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', HospitalStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    //**********************************CSW Representative Auto Populate Code******************************//

    
    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCSWRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCSWRepresentative-StaffName", "txtCSWRepresentativeDesignation-Designation"]//id of element - the model property
    };
    $('#txtCSWRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch5', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch5", event, 1);//1 -- pageIndex
    });

    var ContractorFetchObj = {
        SearchColumn: 'txtVendorCode-ContractorName',//Id of Fetch field
        ResultColumns: ["ContractorId-Primary Key", 'SSMRegistrationCode-SSMRegistration Code'],//Columns to be displayed
        FieldsToBeFilled: ["hdnContractorId-ContractorId", "txtVendorCode-SSMRegistrationCode", "txtVendorName-ContractorName"]//id of element - the model property
    };
    $('#txtVendorCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch6', ContractorFetchObj, "/api/Fetch/ContractorNameFetch", "UlFetch6", event, 1);//1 -- pageIndex
    });

    $("#btnSave, #btnSaveAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
      
        var isFormValid = formInputValidation("formRecyclableWasteRecords", 'save');
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
            RecyclableId: primaryId,
            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            RRWNo: $('#txtRRWNo').val(),
            TotalWeight: $('#txtTotalWeight').val(),
            CSWRepresentative: $('#txtCSWRepresentative').val(),
            HospitalRepresentative: $('#txtHospitalRepresentative').val(),
            VendorCode: $('#txtVendorCode').val(),
            UnitRate: $('#txtUnitRate').val(),
            TotalAmount: $('#txtTotalAmount').val(),
            WasteType: $('#ddlWasteType').val(),
            TransportationCategory: $('#ddlTransportationCategory').val(),
            Remarks: $('#txtRemarks').val(),
            DateTime: $('#txtDateTime').val(),
            MethodofDisposal: $('#ddlMethodOfDisposal').val(),
            CSWRepresentativeDesignation: $('#txtCSWRepresentativeDesignation').val(),
            HospitalRepresentativeDesignation: $('#txtHospitalRepresentativeDesignation').val(),
            VendorName: $('#txtVendorName').val(),
            ReturnValue: $('#txtReturnValue').val(),
            InvoiceNoReceiptNo: $('#txtInvoiceNoReceiptNo').val(),
            WasteCode: $('#txtWasteCode').val(),
            StartDate: $('#txtStartDate').val(),
            EndDate: $('#txtEndDate').val(),
                                
            RecordsofRecyclableWasteList: []
        }
        $("#tbodyCSWRS  tr").each(function () {
           
            var RecyclableWasteRecordsObj = {}; 
            RecyclableWasteRecordsObj.CSWRSId = $(this).find("[id^=hdnCSWRSId]")[0].value;
            RecyclableWasteRecordsObj.UserAreaCode = $(this).find("[id^=txtUserAreaCode]")[0].value;
            RecyclableWasteRecordsObj.UserAreaName = $(this).find("[id^=txtUserAreaName]")[0].value;
            RecyclableWasteRecordsObj.CSWRSNo = $(this).find("[id^=txtCSWRSNo]")[0].value;  
            RecyclableWasteRecordsObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.RecordsofRecyclableWasteList.push(RecyclableWasteRecordsObj);
        });
    
        $.post("/api/RecordsofRecyclableWaste/Save", obj, function (response) {              
            var result = JSON.parse(response);
            showMessage('Records of Recyclable Waste', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.RecyclableId);

                $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveAddNew") {
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
   
    $("#AddCSWRS").click(function () {     
        rowNum += 1;
        addAddCSWRSRecords(rowNum);   
    })

    $("#deleteCSWRS").click(function () {
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

                        $("#tbodyCSWRS ").find('input[name="isDelete"]').each(function () {

                            if ($(this).is(":checked")) {

                                if ($(this).closest("tr").find("[id^=hdnCSWRSId]").val() == 0) {
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

    $("#btnCSWRSDetailsFetch").click(function () {        var StartDate = $('#txtStartDate').val();        var EndDate = $('#txtEndDate').val();        if (StartDate != 0 & EndDate != 0) {            var obj = {                RecyclableId: $("#primaryID").val(),                StartDate: StartDate,                EndDate: EndDate            }
            $.post("/api/RecordsofRecyclableWaste/CSWRSFetch", obj, function (response) {                    var result = JSON.parse(response);                    var rowNum2 = 1
                    $('#tbodyCSWRS').html('');
                    if (result.CSWRSDetailsFetchList != null) {
                                         
                            for (var i = 0; i < result.CSWRSDetailsFetchList.length; i++) {
                              
                                var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + rowNum2 + '" name="isDelete" /><input type="hidden" id="hdnCSWRSId' + rowNum2 + '" value="0" /></td>';
                                var UserAreaCode = '<td> <input type="text" class="form-control" id="txtUserAreaCode' + rowNum2 + '" autocomplete="off" name="UserAreaCode" maxlength="25" tabindex="2" /></td>';
                                var UserAreaName = '<td> <input type="text" class="form-control" id="txtUserAreaName' + rowNum2 + '" autocomplete="off" name="UserAreaName" maxlength="25" tabindex="2" /></td>';
                                var CSWRSNo = '<td> <input type="text" class="form-control" id="txtCSWRSNo' + rowNum2 + '" autocomplete="off" name="CSWRSNo" maxlength="25" tabindex="2" /></td>';

                                $("#tbodyCSWRS").append('<tr>' + CheckBox + UserAreaCode + UserAreaName + CSWRSNo + '</tr>');

                                $('#hdnCSWRSId' + rowNum2).val(result.CSWRSDetailsFetchList[i].CSWRSId);
                                $('#txtUserAreaCode' + rowNum2).val(result.CSWRSDetailsFetchList[i].UserAreaCode);
                                $('#txtUserAreaName' + rowNum2).val(result.CSWRSDetailsFetchList[i].UserAreaName);
                                $('#txtCSWRSNo' + rowNum2).val(result.CSWRSDetailsFetchList[i].CSWRSNo);
                                $('#table_data').hide();
                                
                                rowNum2 += 1;
                            }
                                               
                    }                },                    "json")                    .fail(function (response) {                        var errorMessage = "";                        if (response.status == 400) {                            errorMessage = response.responseJSON;                        }                        else {                            errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);                        }                    });                      
        }        else {            var message = "Please Select Start Date & End Date";
            bootbox.confirm(message, function (result) {
                if (result) {
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });
        }                   });

    //************************Total Amount Calculation**********************************//

    $('#txtTotalWeight, #txtUnitRate, #txtReturnValue').keyup(function () {

        var sum = 0;
        var TW = $("#txtTotalWeight").val();
        var UR = $("#txtUnitRate").val();
        var RV = $("#txtReturnValue").val();
        $('#txtTotalWeight,#txtUnitRate,#txtReturnValue').each(function () {
            sum = (TW * UR - RV);
        });
        $('#txtTotalAmount').val(sum);
    });

    //******************Enable WasteCode********************************//
  
   
    $('#txtWasteCode').append("<option value='' Selected>" + "Select" + "</option>");
   
    $('body').on('change', '.WasteType', function () {

        var WasteType = $("#ddlWasteType").val();
        $("#txtWasteCode option").remove();
       
        $.get("/api/RecordsofRecyclableWaste/WasteCodeGet/" + WasteType, function (response) {
            var result = JSON.parse(response);
           
            if (result.RecyclableWaste.length != 0) {

                $('#txtWasteCode').prop("disabled", false);
                WasteCodeValues = "<option value='' Selected>" + "Select" + "</option>"
               
                for (var i = 0; i < result.RecyclableWaste.length; i++) {
                    WasteCodeValues += "<option value=" + result.RecyclableWaste[i].WasteCode + ">" + result.RecyclableWaste[i].WasteCode + "</option>"
                }
                $('#txtWasteCode').append(WasteCodeValues);

            }
            else {
                $('#txtWasteCode').append("<option value='0' Selected>" + "Select" + "</option>");
                $('#txtWasteCode').prop("disabled", true);
            }
        })      

        
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
        $.get("/api/RecordsofRecyclableWaste/Get/" + primaryId)
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

        var WasteCode = result.WasteCode;
        //var Date = getCustomDate(result.DateTime);
        var StartDate = getCustomDate(result.StartDate);
        var EndDate = getCustomDate(result.EndDate);

        $("#primaryID").val(result.RecyclableId)
        $('#txtRRWNo').val(result.RRWNo);
        $('#txtDateTime').val(result.DateTime);
        $('#txtTotalWeight').val(result.TotalWeight);
        $('#ddlMethodOfDisposal').val(result.MethodofDisposal);
        $('#txtCSWRepresentative').val(result.CSWRepresentative);
        $('#txtCSWRepresentativeDesignation').val(result.CSWRepresentativeDesignation);
        $('#txtHospitalRepresentative').val(result.HospitalRepresentative);
        $('#txtHospitalRepresentativeDesignation').val(result.HospitalRepresentativeDesignation);
        $('#txtVendorCode').val(result.VendorCode);
        $('#txtVendorName').val(result.VendorName);
        $('#txtUnitRate').val(result.UnitRate);
        $('#txtReturnValue').val(result.ReturnValue);
        $('#txtTotalAmount').val(result.TotalAmount);
        $('#txtInvoiceNoReceiptNo').val(result.InvoiceNoReceiptNo);
        $('#ddlWasteType').val(result.WasteType);
        if (WasteCode != 0) {
            $("#txtWasteCode option").remove();
            $('#txtWasteCode').prop("disabled", false);

            $('#txtWasteCode').append("<option value=" + WasteCode + ">" + WasteCode + "</option>");

        }
        else {
            $('#txtWasteCode').prop("disabled", true);
        }

        $('#ddlTransportationCategory').val(result.TransportationCategory);
        $('#txtRemarks').val(result.Remarks);
        $('#txtStartDate').val(StartDate);
        $('#txtEndDate').val(EndDate);

        var rowNum1 = 1;
        $('#tbodyCSWRS').html('');
        if (result.CSWRSDetailsFetchList != null) {

            for (i = 0; i < result.CSWRSDetailsFetchList.length; i++) {

                addAddCSWRSRecords(rowNum1);

                $('#hdnCSWRSId' + rowNum1).val(result.CSWRSDetailsFetchList[i].CSWRSId);
                $('#txtUserAreaCode' + rowNum1).val(result.CSWRSDetailsFetchList[i].UserAreaCode);
                $('#txtUserAreaName' + rowNum1).val(result.CSWRSDetailsFetchList[i].UserAreaName);
                $('#txtCSWRSNo' + rowNum1).val(result.CSWRSDetailsFetchList[i].CSWRSNo);
                $('#table_data').hide();

                rowNum1 += 1;

            }
        }        

    }

}

function EmptyFields() {

    $('#formRecyclableWasteRecords')[0].reset();
    var i = 1;
    $("#tbodyCSWRS").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
    $('#RRWNo').removeClass('has-error');
    $('#Date').removeClass('has-error');
    $('#TotalWeight').removeClass('has-error');
    $('#MethodOfDisposal').removeClass('has-error');
    $('#CSWRepresentative').removeClass('has-error');  
    $('#HospitalRepresentative').removeClass('has-error');   
    $('#VendorCode').removeClass('has-error');
    $('#UnitRate').removeClass('has-error');  
    $('#WasteType').removeClass('has-error');
    $('#WasteCode').removeClass('has-error');  
    $('#StartDate').removeClass('has-error');
    $('#EndDate').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtWasteCode option').remove();
    $('#txtWasteCode').prop("disabled", true);
    $('#txtWasteCode').append("<option value='' Selected>" + "Select" + "</option>");
}

function addAddCSWRSRecords(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /><input type="hidden" id="hdnCSWRSId' + num + '" value="0" /> </td>';

    var UserAreaCode = '<td> <input type="text" class="form-control" id="txtUserAreaCode' + num + '" autocomplete="off" name="UserAreaCode" maxlength="25" tabindex="2" /></td>';
    var UserAreaName = '<td> <input type="text" class="form-control" id="txtUserAreaName' + num + '" autocomplete="off" name="UserAreaName" maxlength="25" tabindex="2" /></td>';
    var CSWRSNo = '<td> <input type="text" class="form-control" id="txtCSWRSNo' + num + '" autocomplete="off" name="CSWRSNo" maxlength="25" tabindex="2" /></td>';

    $("#tbodyCSWRS ").append('<tr>' + CheckBox + UserAreaCode + UserAreaName + CSWRSNo + '</tr>');
    $('#table_data').hide();
    
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




