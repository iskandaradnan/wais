var Dropdownvalue = "";
var FileTypeValues = "";
var rowNum = 1; 
var rowNum2 = 1;

var FileTypeValues = "";
var filePrefix = "OSWCN_";
var ScreenName = "ConsignmentNoteCWCN";
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/ConsignmentNoteCWCN/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
           // FileTypeValues = "<option value=''>" + "Select" + "</option>";
            for (var i = 0; i < loadResult.QcLovs.length; i++) {
                $("#ddlQC").append(
                    "<option value=" + loadResult.QcLovs[i].LovId + ">" + loadResult.QcLovs[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.OnScheduleLovs.length; i++) {
                $("#ddlOnSchedule").append(
                    "<option value=" + loadResult.OnScheduleLovs[i].LovId + ">" + loadResult.OnScheduleLovs[i].FieldValue + "</option>"
                );
            }
            //for (var i = 0; i < loadResult.FileTypeLovs.length; i++) {
            //    FileTypeValues += "<option value=" + loadResult.FileTypeLovs[i].LovId + ">" + loadResult.FileTypeLovs[i].FieldValue + "</option>"
            //}
           // $("#tblAttachment tbody #ddlFileType1").append(FileTypeValues);
            //$("#hdnAttachmentId1").val(getUID(6));

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "Consignment Note (CWCN)" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);


            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
    //AutoDisplay for Vehicle no
    $(body).on('input propertychange paste keyup', '.clsVehicleNo', function (event) {
        var controlId = event.target.id;
        var id = controlId.slice(12, 14);

        var VehicleNoFetchObj = {
            SearchColumn: 'txtVehicleNo' + id + '-VehicleNo',//Id of Fetch field
            ResultColumns: ['VehicleId-Primary Key', 'VehicleNo-VehicleNo'],
            FieldsToBeFilled: ['hdnVehicleNoId' + id + '-VehicleId', 'txtVehicleNo' + id + '-VehicleNo']
        };
        DisplayFetchResult('divVehicleNoFetch' + id, VehicleNoFetchObj, "/Api/ConsignmentNoteCWCN/VehicleNoFetch", 'UlFetch1' + id, event, 1); //1 -- pageIndex
    });
    //AutoDisplay for Driver Code
    $(body).on('input propertychange paste keyup', '.clsDriverCode', function (event) {
       var controlId = event.target.id;
        var id = controlId.slice(13, 15);

        var DriverCodeFetchObj = {
            SearchColumn: 'txtDriverCode' + id + '-DriverCode',//Id of Fetch field
            ResultColumns: ['DriverId-Primary Key', 'DriverCode-DriverCode'],
            FieldsToBeFilled: ['hdnDriverCodeId' + id + '-DriverId', 'txtDriverCode' + id + '-DriverCode', 'txtDriverName' + id + '-DriverName']
        };
        DisplayFetchResult('divDriverCodeFetch' + id, DriverCodeFetchObj, "/Api/ConsignmentNoteCWCN/DriverCodeFetch", 'UlFetch2' + id, event, 1);
    });   
      //AutoDisplay for Hospital Representative
    var HospitalStaffFetchObj = {
        SearchColumn: 'txtHospitalRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHospitalRepresentative-StaffName", "txtHospitalRepresentativeDesignation-Designation"]
    };
    $('#txtHospitalRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', HospitalStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);
    });
    //AutoDisplay for CW Representative
    var CompanyStaffFetchObj = {
        SearchColumn: 'txtCWRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],
        FieldsToBeFilled: ["hdnCompanyStaffId-StaffMasterId", "txtCWRepresentative-StaffName", "txtCWRepresentativeDesignation-Designation"]
    };
    $('#txtCWRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch5', CompanyStaffFetchObj, "/api/Fetch/CompanyStaffFetch", "UlFetch5", event, 1);
    });

    //***************************** Getting TreatmentPlant DropDown from HWMS_TreatmentPlant ***********************
    $.get("/api/ConsignmentNoteCWCN/AutoDisplaying", function (response) {
        var result = JSON.parse(response);
        Dropdownvalues = "<option value=''>" + "Select" + "</option>";
        if (result.length > 0) {
            for (var i = 0; i < result.length; i++) {
                Dropdownvalues += "<option value=" + result[i].TreatmentPlantId + ">" + result[i].TreatmentPlantName + "</option>"
            }
        }
        $("#ddlTreatmentPlant").html(Dropdownvalues);

    })
    $.get("/api/ConsignmentNoteCWCN/AutoDisplayDWRSNO", function (response) {
        var result = JSON.parse(response);
        Dropdownvalue = "<option value=''>" + "Select" + "</option>";
        if (result.length > 0) {
            for (var i = 0; i < result.length; i++) {
                Dropdownvalue += "<option value=" + result[i].DWRId + ">" + result[i].DWRNo + "</option>"
            }
        }
        $("#txtDWRSNo1").html(Dropdownvalue);

    })

    $('#ddlOnSchedule').change(function () {

        if ($("#ddlOnSchedule option:selected").text() == 'Yes') {
            $('#ddlQC').val('');
            $('#ddlQC').prop('disabled', true);
            $('#ddlQC').prop('required', false);
        }
        else {
            $('#ddlQC').prop('disabled', false);
            $('#ddlQC').prop('required', true);
        }

    });
    
    $('body').on('change', '.DWRSNo', function () {

        var controlId = event.target.id;
        var DWRId = $('#' + controlId).val();

        $.get("/api/ConsignmentNoteCWCN/DWRSNOData?DWRId=" + DWRId, function (response) {
            var result = JSON.parse(response);
            var binNo = result.BinNo;
            var binWeight = result.Weight;
                        
            var id1 = controlId.slice(9, 11);
            $('#txtBinNo' + id1).val(binNo);
            $('#txtBinWeight' + id1).val(binWeight); 


            var TotalBinWeight = 0;
            $('[id^=txtBinWeight]').each(function () {
                TotalBinWeight += Number($(this).val());
            })
            $("#txtTotalEst").val(TotalBinWeight);
            
        })

        

    });

    $('body').on('change', '.TreatmentplantName', function (e) {
        var controlId = event.target.id;

        var TreatmentPlantName = $('#' + controlId + '').val();

        var jqxhr = $.get("/api/ConsignmentNoteCWCN/TreatmentPlantData/" + TreatmentPlantName, function (response) {
            var result = JSON.parse(response);

            var Ownership = result.Ownership;                     

            $('#txtOwnership').val(Ownership);          

        })
    });
     // ---Data Save Code ---------
    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();
        
        var isFormValid = formInputValidation("formConsignmentNoteCWCN", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicate = 0;
        $("[id^=txtDWRSNo]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicate += 1;
            }
        });

        if (isDuplicate > 0) {
            $("div.errormsgcenter").text('Duplicate DWR No.');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }


        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var obj = {
            ConsignmentId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            ConsignmentNoteNo: $('#txtConsignmentNoteNo').val(),
            DateTime: $('#txtDateTime').val(),
            OnSchedule: $('#ddlOnSchedule').val(),
            Qc: $('#ddlQC').val(),
            CwRepresentative: $('#txtCWRepresentative').val(),
            CwRepresentativeDesignation: $('#txtCWRepresentativeDesignation').val(),
            HospitalRepresentative: $('#txtHospitalRepresentative').val(),
            HospitalRepresentativeDesignation: $('#txtHospitalRepresentativeDesignation').val(),
            TreatmentPlantName: $('#ddlTreatmentPlant').val(),
            Ownership: $('#txtOwnership').val(),
            VehicleNo: $('#txtVehicleNo').val(),
            DriverCode: $('#txtDriverCode').val(),
            DriverName: $('#txtDriverName').val(),
            TotalNoOfBins: $('#txtTotalNoofBins').val(),
            TotalEst: $('#txtTotalEst').val(),
            Remarks: $('#txtRemarks').val(),
            ConsignmentNoteList: []
        }

        $('#ConsignmentNotetable tbody tr').each(function () {
            var tbl = {};
            tbl.DWRNoId = $(this).find("[id^=hdnDWRSNoId]")[0].value; 
            tbl.DWRDocId = $(this).find("[id^=txtDWRSNo]")[0].value;
            tbl.BinNo = $(this).find("[id^=txtBinNo]")[0].value;
            tbl.Weight = $(this).find("[id^=txtBinWeight]")[0].value;
            tbl.Remarks_Bin = $(this).find("[id^=txtRemarksBin]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.ConsignmentNoteList.push(tbl);
        });       
       
        $.post("/api/ConsignmentNoteCWCN/Save", obj, function (response) {
            showMessage('ConsignmentNoteCWCN', CURD_MESSAGE_STATUS.SS);
            var result = JSON.parse(response);   
            
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
     //Cancel Button.....
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
      
    //Mutliple rows delete button code....
    var n2 = "";
    $("#deleteDWRSNo").click(function () {
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
                        $("#tbodyDWRSNo tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnDWRSNoId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                    getTotalBags();
                                    n2 = $("#tbodyDWRSNo").find("tr").length;

                                    $('#txtTotalNoofBins').val(n2);
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
    

     //********************* Validation red border removal while giving value ******************
    $('#txtConsignmentNoteNo').change(function () {
        $('#formConsignmentNoteCWCN #CosignmentNoteNo').removeClass('has-error');
    });
    $('#ddlQC').change(function () {
        $('#formConsignmentNoteCWCN #QC').removeClass('has-error');
    });
    $('#ddlTreatmentPlant').change(function () {
        $('#formConsignmentNoteCWCN #TreatmentPlant').removeClass('has-error');
    });
    $('#txtVehicleNo').change(function () {
        $('#formConsignmentNoteCWCN #VehicleNo').removeClass('has-error');
    });
    $('#txtDriverCode').change(function () {
        $('#formConsignmentNoteCWCN #DriverCode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    $('#ddlFileType').on('change', function () {
        $('#formCWCN #filetype').removeClass('has-error');
    });
    $('#txtFileName').keypress(function () {
        $('#formCWCN #fname').removeClass('has-error');
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


    //********************************************* adding Bin Numbers While Adding Rows **********************************************************
    var n = $("#tbodyDWRSNo tr").length;
    $('#txtTotalNoofBins').val(n);

    //********************************************* Add Multiple Values **********************************************************

    $("#addRowDWRSNo").click(function () {
        rowNum = rowNum + 1;
        addRowDWRSNo(rowNum);

        var n1 = $("#ConsignmentNotetable").find("tbody tr").length;
        $('#txtTotalNoofBins').val(n1);        
   
        //********************************************* Functionlaties in table while adding Rows ****************************
        $("#ConsignmentNotetable tbody tr").click(function () {

            var id = this.rowIndex - 1;
            //validation red border removal while giving value
            $('#txtDWRSNo' + id + '').on('change', function () {
                $('#formConsignmentNoteCWCN #DWRSNo').removeClass('has-error');
                $('#errorMsg').css('visibility', 'hidden');
            });
            $('#txtBinNo' + id + '').on('change', function () {

                $('#formConsignmentNoteCWCN #BinNo').removeClass('has-error');
                $('#errorMsg').css('visibility', 'hidden');
            });
            $('#txtBinWeight' + id + '').on('change', function () {

                $('#formConsignmentNoteCWCN #Weight').removeClass('has-error');
                $('#errorMsg').css('visibility', 'hidden');
            });
            $('#txtRemarksBin' + id + '').on('change', function () {

                $('#formConsignmentNoteCWCN #Remark').removeClass('has-error');
                $('#errorMsg').css('visibility', 'hidden');
            });
        });
    });
    //  ****************************** It is calculated from the sum of all the weight entered in the gridview.*****************************     
    $(".Weight").change(function () {
        sumOfColumns('.Weight');
    });
    function sumOfColumns() {
        $('.Weight').keyup(function () {
            var sum = 0;
            $('.Weight').each(function () {
                sum += Number($(this).val());
            });
            $('#txtTotalEst').val(sum);
        });
    }
 
});

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

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formConsignmentNoteCWCN :input:not(:button)").parent().removeClass('has-error');
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
        $.get("/api/ConsignmentNoteCWCN/Get/" + primaryId)
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

function EmptyFields() {
    $("#primaryID").val(0);
    $('[id^=hdnDWRSNoId]').val(0);

    $('#formConsignmentNoteCWCN #txtConsignmentNoteNo').val('');
    $('#formConsignmentNoteCWCN #txtDateTime').val('');
    $('#formConsignmentNoteCWCN #ddlOnSchedule').val('');
    $('#formConsignmentNoteCWCN #ddlQC').val('');
    $('#formConsignmentNoteCWCN #txtCWRepresentative').val('');
    $('#formConsignmentNoteCWCN #txtCWRepresentativeDesignation').val('');
    $('#formConsignmentNoteCWCN #txtHospitalRepresentative').val('');
    $('#formConsignmentNoteCWCN #txtHospitalRepresentativeDesignation').val('');
    $('#formConsignmentNoteCWCN #ddlTreatmentPlant').val('');
    $('#formConsignmentNoteCWCN #txtOwnership').val('');
    $('#formConsignmentNoteCWCN #txtVehicleNo').val('');
    $('#formConsignmentNoteCWCN #txtDriverCode').val('');
    $('#formConsignmentNoteCWCN #txtDriverName').val('');
    $('#formConsignmentNoteCWCN #txtTotalNoofBins').val(1);
    $('#formConsignmentNoteCWCN #txtTotalEst').val('');
    $('#formConsignmentNoteCWCN #txtRemarks').val('');
    $('#formConsignmentNoteCWCN #txtDWRSNo1').val('');
    $('#formConsignmentNoteCWCN #txtBinNo1').val('');
    $('#formConsignmentNoteCWCN #txtBinWeight1').val('');
    $('#formConsignmentNoteCWCN #txtRemarksBin1').val('');
  
    $('#CosignmentNoteNo').removeClass('has-error');
    $('#DateTime').removeClass('has-error');
    $('#QC').removeClass('has-error');
    $('#CWRepresentative').removeClass('has-error');
    $('#HospitalRepresentative').removeClass('has-error');
    $('#TreatmentPlant').removeClass('has-error');
    $('#VehicleNo').removeClass('has-error');
    $('#DriverCode').removeClass('has-error'); 
    $('#errorMsg').css('visibility', 'hidden');

    $('#ddlQC').val('');
    $('#ddlQC').prop('disabled', true);
    $('#ddlQC').prop('required', false);

    var i = 1;
    $("#tbodyDWRSNo").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
}

function fillDetails(result) {

    if (result != undefined) {

        $('#primaryID').val(result.ConsignmentId);
        $('#txtConsignmentNoteNo').val(result.ConsignmentNoteNo);
        $('#txtDateTime').val(result.DateTime);
        $('#ddlOnSchedule').val(result.OnSchedule);
        $('#ddlQC').val(result.Qc);
        $('#txtCWRepresentative').val(result.CwRepresentative);
        $('#txtCWRepresentativeDesignation').val(result.CwRepresentativeDesignation);
        $('#txtHospitalRepresentative').val(result.HospitalRepresentative);
        $('#txtHospitalRepresentativeDesignation').val(result.HospitalRepresentativeDesignation);
        $('#ddlTreatmentPlant').val(result.TreatmentPlantName);
        $('#txtOwnership').val(result.Ownership);
        $('#txtVehicleNo').val(result.VehicleNo);
        $('#txtDriverCode').val(result.DriverCode);
        $('#txtDriverName').val(result.DriverName);
        $('#txtTotalNoofBins').val(result.TotalNoOfBins);
        $('#txtTotalEst').val(result.TotalEst);
        $('#txtRemarks').val(result.Remarks);

      
        if ($("#ddlOnSchedule option:selected").text() == 'Yes') {
            $('#ddlQC').val('');
            $('#ddlQC').prop('disabled', true);
            $('#ddlQC').prop('required', false);
        }
        else {
            $('#ddlQC').prop('disabled', false);
            $('#ddlQC').prop('required', true);
        }

        rowNum = 1;        
        $("#tbodyDWRSNo").html('');
        $("#txtTotalNoofBins").val(0);
        if (result.ConsignmentNoteList != null) {
           
            $("#txtTotalNoofBins").val(result.ConsignmentNoteList.length);
            for (var i = 0; i < result.ConsignmentNoteList.length; i++) {
                addRowDWRSNo(rowNum); 

                $('#hdnDWRSNoId' + rowNum).val(result.ConsignmentNoteList[i].DWRNoId);
                $('#txtDWRSNo' + rowNum).val(result.ConsignmentNoteList[i].DWRDocId);
                $('#txtBinNo' + rowNum).val(result.ConsignmentNoteList[i].BinNo);
                $('#txtBinWeight' + rowNum).val(result.ConsignmentNoteList[i].Weight);
                $('#txtRemarksBin' + rowNum).val(result.ConsignmentNoteList[i].Remarks_Bin);
                         
                rowNum += 1;
            }
        }
        else
        {
            addRowDWRSNo(rowNum); 
        }

        //if (result.AttachmentList != null) {
            fillAttachment(result.AttachmentList);
       //}
      
    }

}

function addRowDWRSNo(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" name="isDelete"  id="isDelete' + num + '" /> <input type="hidden" value="0" id="hdnDWRSNoId' + num + '"  /></td>';
    var DwrsNo = '<td id="DWRNo"> <select type="text" class="form-control DWRSNo" id="txtDWRSNo' + num + '"  name="DWRSNo" maxlength="25" >' + Dropdownvalue + '</select> </td>';
    var BinNo = '<td id="BinNo">  <input type="text" class="form-control" id="txtBinNo' + num + '" disabled="disabled" autocomplete="off" name="BinNo" maxlength="25"  />';
    var BinWeight = '<td id="Weight"> <input type="text" class="form-control Weight" id="txtBinWeight' + num + '" disabled="disabled" autocomplete="off" name="BinWeight(Kg)" maxlength="25"  />';
    var Remarks_Bin = '<td> <input type="text" class="form-control" id="txtRemarksBin' + num + '" autocomplete="off" name="Remarks" maxlength="25"  />';

    $("#tbodyDWRSNo").append('<tr>' + CheckBox + DwrsNo + BinNo + BinWeight + Remarks_Bin + '</tr>');  
   
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
        var monthindex = date.slice(5, 7);
        if (monthindex >= 10) {
            var month = monthNames[date.slice(5, 7)];
        }
        else {
            var month = monthNames[date.slice(6, 7)];
        }
        var year = date.slice(0, 4);

        return day + "-" + month + "-" + year;
    }
}

function getTotalBags() {

    var calculated_total_sum = 0;

    $("#tbodyDWRSNo .Weight").each(function () {
        var get_textbox_value = $(this).val();
        if ($.isNumeric(get_textbox_value)) {
            calculated_total_sum += parseFloat(get_textbox_value);
        }
    });
    $("#txtTotalEst").val(calculated_total_sum);
}

$(".nav-tabs > li:not(:first-child)").click(function () {
    var primaryId = $('#primaryID').val();
    if (primaryId == 0) {
        bootbox.alert("Save the details before moving on to Other!");
        return false;
    }
});

