var FirstRecord, LastRecord = 0;
var TotalPages = 1;
var GridtotalRecords;
var LOVlist = [];
$("#divEngAssetList").hide();
$("#divEngHistoryList").hide();
$("#divPersonal").hide();
//$("#divEmpList").hide();
var pagesize = 5;
var pageindex = 1;
var id;
var ExpiryDatefromdb;

var BindFetchEventsForPerson = null;
var BindEvensForCheckBoxPerson = null;
var BindFetchEventsForAsset = null;
var BindEvensForCheckBox = null;
$(document).ready(function () {

    //BindFetchEventsForPerson();
    //BindEvensForCheckBoxPerson();

    //BindFetchEventsForAsset();
    //BindEvensForCheckBox();

    formInputValidation("frmLicenseAndCertificate");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    var ActionType = $('#ActionType').val();
    id = $('#primaryID').val();
  
    var jqxhr = $.get("/api/LicenseAndCertificateApi/Load", function (response) {
        var result = response;
        //$("#jQGridCollapse1").click();
        LOVlist = result;
        bindLOVvalues(LOVlist);
        var htmlval = ""; $('#tablebody').empty();
        $('#hdnAssetId_0').removeAttr('required');
        
        var licenseId = $('#hdnLicenseId').val();
        if (licenseId != null && licenseId != "" && licenseId != "0") {
            var rowData1 = {};
            LinkClicked(licenseId, rowData1)
        } else {
            $("#jQGridCollapse1").click();
        }
    })
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


    $("#Category").on("change ", function (event, data) {
        var Lovselected = $("#Category").val();
        $("#frmLicenseAndCertificate :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var item = Enumerable.From(LOVlist.LCCategoryValueList).Where(x=>x.LovId == parseInt(Lovselected)).Select(x=>x.FieldValue).FirstOrDefault();
        
        if (item == "Asset") {
            $("#Type").prop("disabled", false);
            $("#divEngAssetList").show();
            BindFetchEventsForAsset();
            $("#divPersonal").hide();
            $('#divPersonAddNew').hide();
            $('#divAssetAddNew').show();
           // $("#Type").empty();

            LoadLoV(LOVlist.LCAssetTypeValueList, 'Type', true);
            $("#Type").prop("required", true);
            $("#typereq").show();

            $('#tableAssetNos > tbody').children('tr:not(:first)').remove();
            $('#txtAssetNo_0').parent().removeClass('has-error');
            $('#txtAssetNo_0').val(null);
            $('#txtAssetDescription_0').val(null);
            $('#txtRemarks_0').val(null);

            $('#tablePersons > tbody').children('tr:not(:first)').remove();
            $('#txtStaffName_0').removeAttr('required');
            $('#selDesignation_0').removeAttr('required');

            $('#txtAssetNo_0').attr('required', true);
           // $('#hdnAssetId_0').attr('required', true);

            $('#chkAssetDeleteAll').prop('checked', false);
            $('#chkAssetDelete_0').prop('checked', false);
            $('#chkAssetDelete_0').parent().removeClass('bgDelete');
        }
        else if (item == "Personnel") {
            BindFetchEventsForPerson();
            $("#divPersonal").show();
            $("#Type").prop("disabled", true);
            $("#typereq").hide();
            $("#Type").prop("required", false);
            $("#divEngAssetList").hide();
            $('#divAssetAddNew').hide();
            $('#divPersonAddNew').show();

            $('#tablePersons > tbody').children('tr:not(:first)').remove();
            $('#txtStaffName_0').parent().removeClass('has-error');
            $('#selDesignation_0').parent().removeClass('has-error');
            $('#txtStaffName_0').val(null);
            $('#selDesignation_0').val(null);
            $('#txtPersonRemarks_0').val(null);

            $('#tableAssetNos > tbody').children('tr:not(:first)').remove();
            $('#txtAssetNo_0').removeAttr('required');
            $('#hdnAssetId_0').removeAttr('required');

            $('#txtStaffName_0').attr('required', true);
            $('#selDesignation_0').attr('required', true);

            $('#chkAssetDeleteAll').prop('checked', false);
            $('#chkAssetDelete_0').prop('checked', false);
            $('#chkAssetDelete_0').parent().removeClass('bgDelete');
        }
        else {
            $("#Type").prop("disabled", true);
            $("#typereq").hide();
            $("#Type").prop("required", false);
            $("#divEngAssetList").hide();
            $("#divPersonal").hide();
            $('#divPersonAddNew').hide();
            $('#divAssetAddNew').hide();

            $('#tablePersons > tbody').children('tr:not(:first)').remove();
            $('#txtStaffName_0').removeAttr('required');
            $('#selDesignation_0').removeAttr('required');
    
            $('#tableAssetNos > tbody').children('tr:not(:first)').remove();
            $('#txtAssetNo_0').removeAttr('required');
            $('#hdnAssetId_0').removeAttr('required');

            $('#chkAssetDeleteAll').prop('checked', false);
            $('#chkAssetDelete_0').prop('checked', false);
            $('#chkAssetDelete_0').parent().removeClass('bgDelete');
        }
    })



    var AssigneeFetchObj = {
        SearchColumn: 'txtContactPerson-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-StaffName'],
        FieldsToBeFilled: ["txtStaffMasterId-StaffMasterId", "txtContactPerson-StaffName"]
    };

    $('#txtContactPerson').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetchContactPerson', AssigneeFetchObj, "/api/Fetch/CompanyStaffFetch", "UltxtContactPersonFetch", event, 1);//1 -- pageIndex
    });
    var companyRepresentativeSearchObj = {
        Heading: "Person Incharges",//Heading of the popup
        SearchColumns: ['StaffName-Contact Person'],//ModelProperty - Space seperated label value
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Company Representative'],//Columns to be returned for display
        FieldsToBeFilled: ["txtStaffMasterId-StaffMasterId", "txtContactPerson-StaffName"]//id of element - the model property--, , 
    };

    $('#spnPopup-ContactPerson').click(function () {
        DisplaySeachPopup('divContactPersonSearchPopup', companyRepresentativeSearchObj, "/api/Search/CompanyStaffSearch");
    }); 
    var typeCodeFetchObj = {
        SearchColumn: 'txtTypeCode-AssetTypeCode',
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],
        AdditionalConditions: ["CheckEquipmentFunctionDescription-hdnCheckEquipmentFunctionDescription"],
        FieldsToBeFilled: ["hdnTypeCodeId-AssetTypeCodeId", "txtTypeCode-AssetTypeCode", "txtTypeDescription-AssetTypeDescription", "hdnAssetClassificationId-AssetClassificationId"]
    };

    $('#txtTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divTypeCodeFetch', typeCodeFetchObj, "/api/Fetch/TypeCodeFetch", "UlFetch", event, 1);
    });

    typeCodeSearchObj = {
        Heading: "Asset Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationDescription-Asset Classification Description'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationDescription-Asset Classification Description'],//Columns to be returned for display
        AdditionalConditions: ["CheckEquipmentFunctionDescription-hdnCheckEquipmentFunctionDescription"],
        FieldsToBeFilled: ["hdnTypeCodeId-AssetTypeCodeId", "txtTypeCode-AssetTypeCode", "txtTypeDescription-AssetTypeDescription", "hdnAssetClassificationId-AssetClassificationId"]//id of element - the model property--, , 
    };

    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });

    //$('#spnPopup-typeCode').attr('disabled', false).css('cursor', 'pointer');
    //$('#spnPopup-typeCode').click(function () {
    //    DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    //});
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

    //-------------------------------------------Asset No Grid ---------------------------------
    $('#anchorAssetAddNew').unbind('click');
    var linkCliked1 = false;
    $('#anchorAssetAddNew').click(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');
        $("#chkAssetDeleteAll").prop("checked", false)
        var errorMessage = '';

        $('#tableAssetNos tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;            

             if (!tableInputValidation('tableAssetNos', 'save', 'chkAssetDelete')) {            
                 errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
                 $('#txtAssetNo_' + index1).parent().removeClass("has-error");
            }
        });
        if (errorMessage != '') {           
            bootbox.alert(errorMessage);
            return false;
        }
        else {
            var totalRecords = 0;
            $.each($("input[id^='chkAssetDelete_']"), function (index, value) {
                if (!$('#' + value.id).prop('checked')) {
                    totalRecords++;
                }
            });
            if (totalRecords >= 15) {            
                bootbox.alert('Cannot add more than 15 rows');
                return false;
            }

            var index1 = $('#tableAssetNos tr').length - 1;
            var tableRow = '<tr ><td width="3%" style="text-align:center"><input type="checkbox" id="chkAssetDelete_' + index1 + '" /></td>' +
                           '<td width="33%"><input type="text" id="txtAssetNo_' + index1 + '" name="AssetNo_0" class="form-control" placeholder="Please Select" ' +
                           ' maxlength="25" autocomplete="off" pattern="^[a-zA-Z0-9\-\/]+$" required/>' +
                           '<input type="hidden" id="hdnAssetId_' + index1 + '"/><div class="col-sm-12" id="divFetch_' + index1 + '"></div></td>' +
                           '<td width="32%">' +
                           '<input type="text"  class="form-control" id="txtAssetDescription_' + index1 + '" name="AssetDescription" disabled /></td>' +
                           '<td width="32%"><input id="txtRemarks_' + index1 + '"  name="Remarks" class="form-control" type="text" maxlength="500" /></td>' +
                           '</tr>';
            $('#tableAssetNos > tbody').append(tableRow);
            $("#txtRemarks_" + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
            if (!linkCliked1) {
                $('#tableAssetNos tr:last td:first input').focus();
            }
            else {
                linkCliked1 = false;
            }
            //$.each(LOVlist.Designations, function (index, value) {
            //    $('#selAddFieldPattern_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});

            BindFetchEventsForAsset();
            BindEvensForCheckBox();
            tableInputValidation('tableAssetNos');
        }
    });
    BindFetchEventsForAsset = function () {
        $("input[id^='txtAssetNo_']").unbind('input propertychange paste keyup');
        $("input[id^='txtAssetNo_']").on('input propertychange paste keyup', function (event) {
            var index = event.target.id.split('_')[1];

            if (index > 0) {
                if ($('#divFetch_' + index + ' .not-found').length && index == 0) {
                    $('#divFetch_' + index).css({
                        'top': 0,
                        'width': $('#txtAssetNo_' + index).outerWidth()
                    });
                } else {
                    $('#divFetch_' + index).css({
                        'top': $('#txtAssetNo_' + index).offset().top - $('#tableAssetNos').offset().top + $('#txtAssetNo_' + index).innerHeight(),
                        'width': $('#txtAssetNo_' + index).outerWidth()
                    });
                }
            }
            else {
                $('#divFetch_' + index).css({
                    'width': $('#txtAssetNo_' + index).outerWidth()
                });
            }

            var assetFetchObj = {
                SearchColumn: 'txtAssetNo_' + index + '-AssetNo'+ index ,
                ResultColumns: ['AssetId-Primary Key', 'AssetNo-Asset No', 'AssetDescription-Asset Description'],
                FieldsToBeFilled: ['hdnAssetId_' + index + '-AssetId', 'txtAssetNo_' + index + '-AssetNo', 'txtAssetDescription_' + index + '-AssetDescription']
            };
            DisplayFetchResult('divFetch_' + index, assetFetchObj, "/api/Fetch/ParentAssetNoFetch", "UlAssetfetch_" + index + "", event, 1);
        });
    }
    $('#chkAssetDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        //var count = 0;
        $('#tableAssetNos tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                //if (!$('#chkAssetDelete_' + index1).prop('disabled')) {
                $('#chkAssetDelete_' + index1).prop('checked', true);
                $('#chkAssetDelete_' + index1).parent().addClass('bgDelete');
                $('#txtAssetNo_' +index1).removeAttr('required');
                $('#hdnAssetId_' + index1).removeAttr('required');
                $('#txtAssetNo_' +index1).parent().removeClass('has-error');
                //count++;
                //}
            }
            else {
                //if (!$('#chkAssetDelete_' + index1).prop('disabled')) {
                $('#chkAssetDelete_' + index1).prop('checked', false);
                $('#chkAssetDelete_' + index1).parent().removeClass('bgDelete');
                $('#txtAssetNo_' +index1).attr('required', true);
              //  $('#hdnAssetId_' +index1).attr('required', true);
                //}
            }
        });
        //if (count == 0) {
        //    $(this).prop("checked", false);
        //}
    });
    BindEvensForCheckBox = function () {
        $("input[id^='chkAssetDelete_']").unbind('click');
        $("input[id^='chkAssetDelete_']").on('click', function (event) {
            var index2 = event.target.id.split('_')[1];
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $(this).parent().addClass('bgDelete');
                $('#txtAssetNo_' + index2).removeAttr('required');
                $('#hdnAssetId_' + index2).removeAttr('required');
                $('#txtAssetNo_' + index2).parent().removeClass('has-error');
                $('#hdnAssetId_' + index2).parent().removeClass('has-error');
            }
            else {
                $(this).parent().removeClass('bgDelete');
                $('#txtAssetNo_' + index2).attr('required', true);
            //    $('#hdnAssetId_' + index2).attr('required', true);
            }
            var id = $(this).attr('id');
            var index1;
            $('#tableAssetNos tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkAssetDelete_' + index1).prop('checked')) {
                    allChecked = false;
                }
            });
            if (allChecked) {
                $('#chkAssetDeleteAll').prop('checked', true);
            }
            else {
                $('#chkAssetDeleteAll').prop('checked', false);
            }
        });
    }
        BindEvensForCheckBox();
    //-------------------------------------------Asset No Grid ---------------------------------

    //-------------------------------------------Staff Name Grid ---------------------------------
        $('#anchorPersonAddNew').unbind('click');
        var linkCliked2 = false;
    $('#anchorPersonAddNew').click(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');
        $("#chkPersonDeleteAll").prop("checked", false)
        var errorMessage = '';

        $('#tablePersons tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            if (!tableInputValidation('tablePersons', 'save', 'chkPersonDelete')) {
                errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
                $('#txtStaffName_' + index1).parent().removeClass("has-error");
                $('#selDesignation_' + index1).parent().removeClass("has-error");
            }
        });
        if (errorMessage != '') {           
            bootbox.alert(errorMessage);
            return false;
        }
        else {
            var totalRecords = 0;
            $.each($("input[id^='chkPersonDelete_']"), function (index, value) {
                if (!$('#' + value.id).prop('checked')) {
                    totalRecords++;
                }
            });
            if (totalRecords >= 15) {            
                bootbox.alert('Cannot add more than 15 rows');
                return false;
            }

            var index1 = $('#tablePersons tr').length - 1;
            var tableRow = '<tr ><td width="3%" style="text-align:center"><input type="checkbox" id="chkPersonDelete_' + index1 + '" /></td>' +
                           '<td width="33%"><input type="text" id="txtStaffName_' + index1 + '" class="form-control" placeholder="Please Select" ' +
                           ' maxlength="75" autocomplete="off" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" required/>' +
                           '<input type="hidden" id="hdnStaffId_' + index1 + '"/><div class="col-sm-12" id="divPersonalFetch_' + index1 + '"></div></td>' +
                           '<td width="32%">' +
                           '<input type="text" id="selDesignation_' + index1 + '" class="form-control" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" maxlength="75" required/></td>' +
                           '<td width="32%"><input id="txtPersonRemarks_' + index1 + '"  class="form-control" type="text" maxlength="500" /></td>' +
                           '</tr>';
            $('#tablePersons > tbody').append(tableRow);
            $("#txtPersonRemarks_" + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
            if (!linkCliked2) {
                $('#tablePersons tr:last td:first input').focus();
            }
            else {
                linkCliked2 = false;
            }
            //$.each(LOVlist.Designations, function (index, value) {
            //    $('#selDesignation_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});

            BindFetchEventsForPerson();
            BindEvensForCheckBoxPerson();
            tableInputValidation('tablePersons');
        }
    });

    BindFetchEventsForPerson = function () {
        $("input[id^='txtStaffName_']").unbind('input propertychange paste keyup');
        $("input[id^='txtStaffName_']").on('input propertychange paste keyup', function (event) {
            var index = event.target.id.split('_')[1];

            if (index > 0) {
                if ($('#divPersonalFetch_' + index + ' .not-found').length && index == 0) {
                    $('#divPersonalFetch_' + index).css({
                        'top': 0,
                        'width': $('#txtStaffName_' + index).outerWidth()
                    });
                } else {
                    $('#divPersonalFetch_' + index).css({
                        'top': $('#txtStaffName_' + index).offset().top - $('#tablePersons').offset().top + $('#txtStaffName_' + index).innerHeight(),
                        'width': $('#txtStaffName_' + index).outerWidth()
                    });
                }
            }
            else {
                $('#divPersonalFetch_' + index).css({
                    'width': $('#txtStaffName_' + index).outerWidth()
                });
            }

            var personFetchObj = {
                SearchColumn: 'txtStaffName_' + index + '-StaffName',
                ResultColumns: ['StaffMasterId-Primary Key', 'StaffName-Staff Name'],
                FieldsToBeFilled: ['hdnStaffId_' + index + '-StaffMasterId', 'txtStaffName_' + index + '-StaffName']
            };
            DisplayFetchResult('divPersonalFetch_' + index, personFetchObj, "/api/Fetch/FetchRecords", "UlPersonFetch_" + index + "", event, 1);
        });
    }
    

    //$('#spnPopup-typeCode').click(function () {
    //    DisplaySeachPopup('divTypeCodeSearchPopup', TypeCodeSearchSearchObj, "/api/Search/TypeCodeSearch");
    //});
    
    $('#chkPersonDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        //var count = 0;
        $('#tablePersons tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                //if (!$('#chkAssetDelete_' + index1).prop('disabled')) {
                $('#chkPersonDelete_' + index1).prop('checked', true);
                $('#chkPersonDelete_' + index1).parent().addClass('bgDelete');
                $('#txtStaffName_' +index1).removeAttr('required');
                $('#hdnStaffId_' +index1).removeAttr('required');
                $('#selDesignation_' + index1).removeAttr('required');
                $('#txtStaffName_' +index1).parent().removeClass('has-error');
                $('#selDesignation_' +index1).parent().removeClass('has-error');
                //count++;
                //}
            }
            else {
                //if (!$('#chkAssetDelete_' + index1).prop('disabled')) {
                $('#chkPersonDelete_' + index1).prop('checked', false);
                $('#chkPersonDelete_' + index1).parent().removeClass('bgDelete');
                $('#txtStaffName_' +index1).attr('required', true);
                $('#hdnStaffId_' + index1).attr('required', true);
                $('#selDesignation_' + index1).attr('required', true);
                //}
            }
        });
        //if (count == 0) {
        //    $(this).prop("checked", false);
        //}
    });

    BindEvensForCheckBoxPerson = function () {
        $("input[id^='chkPersonDelete_']").unbind('click');
        $("input[id^='chkPersonDelete_']").on('click', function (event) {
            var index2 = event.target.id.split('_')[1];
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $(this).parent().addClass('bgDelete');
                $('#txtStaffName_' + index2).removeAttr('required');
                $('#hdnStaffId_' + index2).removeAttr('required');
                $('#selDesignation_' + index2).removeAttr('required');

                $('#txtStaffName_' + index2).parent().removeClass('has-error');
                $('#selDesignation_' + index2).parent().removeClass('has-error');
            }
            else {
                $(this).parent().removeClass('bgDelete');
                $('#txtStaffName_' + index2).attr('required', true);
                $('#hdnStaffId_' + index2).attr('required', true);
                $('#selDesignation_' +index2).attr('required', true);
            }
            var id = $(this).attr('id');
            var index1;
            $('#tablePersons tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkPersonDelete_' + index1).prop('checked')) {
                    allChecked = false;
                }
            });
            if (allChecked) {
                $('#chkPersonDeleteAll').prop('checked', true);
            }
            else {
                $('#chkPersonDeleteAll').prop('checked', false);
            }
        });
    }
    BindEvensForCheckBoxPerson();
    //-------------------------------------------Staff Name Grid ---------------------------------
    function bindLOVvalues(lovval) {
        $(LOVlist.LCCategoryValueList).each(function (_index, _data) {
            $('#Category').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        });
        $("#Category").change();
        //$(LOVlist.ServiceList).each(function (_index, _data) {
        //    $('#ServiceId').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        //});
        $(LOVlist.IssuingBodyList).each(function (_index, _data) {
            $('#IssuingBody').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        });
        $(LOVlist.StatusValueList).each(function (_index, _data) {
            $('#Status').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        });
        //$(LOVlist.Designations).each(function (_index, _data) {
        //    $('#selDesignation_0').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        //});
    }
});






//function FetchEmployeegriddata(event, index) {



//    var AssigneeFetchObj = {
//        SearchColumn: 'txtEmployeeId_' + index + '-StaffMasterId',//Id of Fetch field
//        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-txtEmployeeName_' + index, "StaffEmployeeId-txtEmployeeId_" + index],
//        FieldsToBeFilled: ["txtStaffMasterId_" + index + "-StaffMasterId", 'txtEmployeeName_' + index + "-StaffName", "txtEmployeeId_" + index + "-StaffEmployeeId"]
//    };
//    DisplayFetchResult('divEmpgridFetch_' + index, AssigneeFetchObj, "/api/Fetch/CompanyStaffFetch", "UltxtContactPersonFetch_" + index, event, 1);//1 -- pageIndex
//}

//function AddNewRow() {

//    var inputpar = {
//        inlineHTML: ' <tr > <td id="del_maxindexval" width="4%"> <div class="checkbox text-center"> <label> <input type="checkbox" name="checkboxes" id="IsDeleted_maxindexval"> </label> </div></td><td width="30%"> <input type="text" id="txtEmployeeId_maxindexval" name="EmployeeId" class="form-control " onkeyup="FetchEmployeegriddata(event, maxindexval)" onpaste=" FetchEmployeegriddata(event, maxindexval)" change="FetchEmployeegriddata(event,maxindexval)" oninput=" FetchEmployeegriddata(event, maxindexval)" placeholder="Please Select" autocomplete="off" only-Name maxlength="25" required/> <input type="hidden" id="txtStaffMasterId_maxindexval"/> <input type="hidden" id="LicenseDetId_maxindexval" /><div class="col-sm-12" id="divEmpgridFetch_maxindexval"></div></td><td width="30%"> <input type="text" maxlength="100" id="txtEmployeeName_maxindexval" class="form-control" name="EmployeeName" disabled/> </td><td width="30%"> <input id="txtRemarks_maxindexval" name="Remarks" class="form-control" type="text" maxlength="500" pattern="(^[_A-z0-9]*((-|\s)*[_A-z0-9])*$)$"> </td></tr>',

//        TargetId: "#myEmployeeTable",
//        TargetElement: ["tr"]

//    }
//    AddNewRowToDataGrid(inputpar);
//}

function Datevalidation() {
    $("#IssuingDate").removeClass("has-error");
    $("#InspectionConductedOn").removeClass("has-error");
    $("#NextInspectionDate").removeClass("has-error");
    $("#ExpireDate").removeClass("has-error"); 

    var IssuingDate = Date.parse($("#IssuingDate").val());
    var NotificationForInspectionDate =  Date.parse($("#NotificationForInspection").val());
    var InspectionConductedOnDate =  Date.parse($("#InspectionConductedOn").val());
    var NextInspectionDate =  Date.parse($("#NextInspectionDate").val());
    var ExpireDate = Date.parse($("#ExpireDate").val());
    var PreviousExpiryDate = Date.parse($("#PreviousExpiryDate").val());
    if (IssuingDate && IssuingDate > (new Date())) {    
        bootbox.alert("Issuing Date can't be greater that the current date ");
        $("#IssuingDate").addClass('has-error');
        $("#IssuingDate").val("");
        return false;
    }
    //if (NotificationForInspectionDate && (NotificationForInspectionDate > IssuingDate)) {

    //    bootbox.alert("\"Notification For Inspection\" Date  should be lesser than \"Issuing Date\"");
    //    $("#NotificationForInspection").val("");
    //    return false;

    //}
    if (InspectionConductedOnDate && InspectionConductedOnDate > IssuingDate) {    
        bootbox.alert("\"Inspection Conducted On\" Date  should be lesser than \"Issuing Date\"");
        $("#InspectionConductedOn").addClass('has-error');
        $("#InspectionConductedOn").val("");
        return false;

    }
    if (NextInspectionDate && (NextInspectionDate < InspectionConductedOnDate || NextInspectionDate < IssuingDate)) {  
        bootbox.alert("\" Next Inspection Date \" should be greater  than \"Issuing Date\" && \"Inspection Conducted On\" Date ");
        $("#NextInspectionDate").addClass('has-error');
        $("#NextInspectionDate").val("");
        return false;
    }

    //if (InspectionConductedOnDate < NotificationForInspectionDate) {

    //    bootbox.alert("\" Inspection Conducted On \" Date  should be greater  than \"Notification for Inspection\"");
    //    $("#InspectionConductedOn").val("");
    //    return false;
    //}

    if (ExpireDate && ExpireDate <= NextInspectionDate) {       
        bootbox.alert("\"Expire Date\"   should be greater than \"Next Inspection Conducted\" Date");
        $("#ExpireDate").addClass('has-error');
        $("#ExpireDate").val("");
        return false;
    }
    if (PreviousExpiryDate && PreviousExpiryDate >= ExpireDate) {     
        bootbox.alert("\"Expiry Date\" should be greater than \" Previous Expiry Date\" Date");
        $("#ExpireDate").addClass('has-error');
        //$("#PreviousExpiryDate").val("");
        return false;
    }
    if (ExpireDate < IssuingDate) {    
        bootbox.alert("\" Expiry Date\" should be greater than \"Issuing\" Date");
        $("#ExpireDate").addClass('has-error');
        $("#ExpireDate").val("");
        return false;
    }
    

}


$("#btnSave, #btnEdit, #btnSaveandAddNew").click(function () {

   // $('#btnSave').attr('disabled', true);
   // $('#btnEdit').attr('disabled', true);
   // $('#btnSaveandAddNew').attr('disabled', true);

    $('#errorMsg').hide();
    $(".errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var isFormValid = formInputValidation("frmLicenseAndCertificate", 'save');
    if (!isFormValid) {
        $(".errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#errorMsg').show();

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnSaveandAddNew').attr('disabled', false);
        return false;
    }
    var CurrentbtnID = $(this).attr("Id");
    if (Datevalidation() == false) {
        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnSaveandAddNew').attr('disabled', false);
        return;
    }
    var Lovselected = $("#Category").val();
    var item = Enumerable.From(LOVlist.LCCategoryValueList).Where(x=>x.LovId == parseInt(Lovselected)).Select(x=>x.FieldValue).FirstOrDefault();
    var EngLicenseandCertificateTxnDetList = [];

    var txtTypeCode = $("#txtTypeCode").val();
    var hdnTypeCodeId = $("#hdnTypeCodeId").val();

    if (txtTypeCode && !hdnTypeCodeId) {
        $("div.errormsgcenter").text("Please enter valid Asset Type Code");
        $('#errorMsg').css('visibility', 'visible');
        $('#errorMsg').show();

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnSaveandAddNew').attr('disabled', false);

        return false;
    }

    var txtContactPerson = $('#txtContactPerson').val();
    var txtStaffMasterId = $('#txtStaffMasterId').val();
    if (txtContactPerson && !txtStaffMasterId) {
        $("div.errormsgcenter").text("Please enter valid Person Incharge");
        $('#errorMsg').css('visibility', 'visible');
        $('#errorMsg').show();

        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnSaveandAddNew').attr('disabled', false);

        return false;
    }
  
    if (item == "Asset") {

        //var allChecked = $('#chkAssetDeleteAll').prop('checked');
        //if (allChecked) {           
        //            bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
        //            $('#btnSave').attr('disabled', false);
        //            $('#btnEdit').attr('disabled', false);
        //            $('#btnSaveandAddNew').attr('disabled', false);
        //            return false;
        //}
        
        var chkreturnTruFal = true;
        var totalRecords = 0;
        $("#tableAssetNos tr").each(function(index, value) {
            if (index == 0) return;
            var index1 = index -1;
          
            var isDeleted = $('#chkAssetDelete_' + index1).prop('checked')
           
                    //if (!isDeleted) {
                    var assetObj = {
                        LicenseId: $('#primaryID').val(),
                        AssetId: $('#hdnAssetId_' + index1).val(),
                        Remarks: $('#txtRemarks_' + index1).val(),                       
                        IsDeleted: chkIsDeletedRow(index1, $('#chkAssetDelete_' + index1).is(":checked")),
                     }
                    totalRecords++;

                    if (assetObj.AssetId == "" && assetObj.IsDeleted == false) {
                        $(".errormsgcenter").text("Valid Asset No. Required");
                        $('#errorMsg').css('visibility', 'visible');
                        $('#errorMsg').show();
                        chkreturnTruFal = false;
                        return false;
                    }
                    
                        EngLicenseandCertificateTxnDetList.push(assetObj);                    
                //    }
                 
                        function chkIsDeletedRow(i, delrec) {
                            if (delrec == true) {
                                $('#txtAssetNo_' + i).prop("required", false);
                                return true;
                            }
                            else {
                                return false;
                            }
                        }
             //EngLicenseandCertificateTxnDetList.additionalFields = additionalFieldsList;
        });
     
       
        if (totalRecords >= 15) {           
                bootbox.alert('Cannot add more than 15 rows');
                $('#btnSave').attr('disabled', false);
                $('#btnEdit').attr('disabled', false);
                $('#btnSaveandAddNew').attr('disabled', false);
                return false;
                }

                var duplicates = false;
                for (i = 0; i < EngLicenseandCertificateTxnDetList.length; i++) {
                    var assetId = EngLicenseandCertificateTxnDetList[i].AssetId;
                    for (j = i+1; j < EngLicenseandCertificateTxnDetList.length; j++) {
                        if ((assetId == EngLicenseandCertificateTxnDetList[j].AssetId) && (EngLicenseandCertificateTxnDetList[j].IsDeleted == false)) {
                            duplicates = true;
                        }
                    }
                }
                if (duplicates) {
                    $("div.errormsgcenter").text('Asset No. should be unique');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#errorMsg').show();
                    
                    $('#btnSave').attr('disabled', false);
                    $('#btnEdit').attr('disabled', false);
                    $('#btnSaveandAddNew').attr('disabled', false);
                    return false;
                }

                if (chkreturnTruFal == false) {
                    return false;
                }
    }
    else if (item == "Personnel") {
        //var allChecked = $('#chkPersonDeleteAll').prop('checked');
        //if (allChecked) {          
        //    bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
        //    $('#btnSave').attr('disabled', false);
        //    $('#btnEdit').attr('disabled', false);
        //    $('#btnSaveandAddNew').attr('disabled', false);
        //    return false;
        //}
        var chkreturnTruFalPersonal = true;
        $("#tablePersons tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            var totalRecords = 0;
            var isDeleted = $('#chkPersonDelete_' + index1).prop('checked')
            //if (!isDeleted) {
                var assetObj = {
                    LicenseId: $('#primaryID').val(),
                    StaffName: $('#txtStaffName_' + index1).val(),
                    StaffId:   $('#hdnStaffId_' + index1).val(),                   
                    Designation: $('#selDesignation_' + index1).val(),
                    Remarks: $('#txtPersonRemarks_' + index1).val(),
                    IsDeleted: chkIsDeletedRow(index1, $('#chkPersonDelete_' + index1).is(":checked")),
                }
                totalRecords++;

                if (assetObj.StaffId == "" && assetObj.IsDeleted == false) {
                    $(".errormsgcenter").text("Valid Person Name Required");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#errorMsg').show();
                    chkreturnTruFalPersonal = false;
                    return false;
                }

                EngLicenseandCertificateTxnDetList.push(assetObj);
            //}
            //EngLicenseandCertificateTxnDetList.additionalFields = additionalFieldsList;
            function chkIsDeletedRow(i, delrec) {
                if (delrec == true) {
                    $('#txtStaffName_' + i).prop("required", false);
                    return true;
                }
                else {
                    return false;
                }
            }
        });

        if (totalRecords >= 15) {           
            bootbox.alert('Cannot add more than 15 rows');
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#btnSaveandAddNew').attr('disabled', false);
            return false;
        }
        var duplicates = false;
                for (i = 0; i < EngLicenseandCertificateTxnDetList.length; i++) {
                    var staffName = EngLicenseandCertificateTxnDetList[i].StaffName;
                    for (j = i+1; j < EngLicenseandCertificateTxnDetList.length; j++) {
                        if ((staffName.toLowerCase() == EngLicenseandCertificateTxnDetList[j].StaffName.toLowerCase()) && ((EngLicenseandCertificateTxnDetList[j].IsDeleted == false))) {
                            duplicates = true;
                        }
                    }
                }
                if (duplicates) {
                    $("div.errormsgcenter").text('Person Name should be unique');
                    $('#errorMsg').css('visibility', 'visible');
                    $('#errorMsg').show();

                    $('#btnSave').attr('disabled', false);
                    $('#btnEdit').attr('disabled', false);
                    $('#btnSaveandAddNew').attr('disabled', false);
                    return false;
                }
                if (chkreturnTruFalPersonal == false) {
                    return false;
                }
    }
    else {
        EngLicenseandCertificateTxnDetList = null
    }

    //var deletedCount = Enumerable.From(EngLicenseandCertificateTxnDetList).Where(x=>x.IsDeleted).Count();
    //var Isdeleteavailable = deletedCount > 0;

    var deletedCount = Enumerable.From(EngLicenseandCertificateTxnDetList).Where(x=>x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (Isdeleteavailable == true) {
        if (deletedCount == EngLicenseandCertificateTxnDetList.length && (TotalPages == 1 || TotalPages == 0)) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#myPleaseWait').modal('hide');
            return false;
        }
    }


    var PostData = {
        LicenseId: $("#primaryID").val(),
        LicenseNo: $("#LicenseNo").val(),
        LicenseDescription: $('#txtLicenseDescription').val(),
        Status: $("#Status").val(),
        Category: $("#Category").val(),
        ServiceId: 2,
        AssetTypeCode: $("#txtTypeCode").val(),
        AssetTypeCodeId: $("#hdnTypeCodeId").val(),
        ClassGrade: $("#ClassGrade").val(),
        ContactPersonStaffId: $("#txtStaffMasterId").val(),
        ContactPerson: $("#txtContactPerson").val(),
        IssuingBody: $("#IssuingBody").val(),
        IssuingDate: $("#IssuingDate").val(),
        IssuingDateUTC: $("#IssuingDate").val(),
        NotificationForInspection: $("#NotificationForInspection").val(),
        NotificationForInspectionUTC: $("#NotificationForInspection").val(),
        InspectionConductedOn: $("#InspectionConductedOn").val(),
        InspectionConductedOnUTC: $("#InspectionConductedOn").val(),
        NextInspectionDate: $("#NextInspectionDate").val(),
        NextInspectionDateUTC: $("#NextInspectionDate").val(),
        ExpireDate: $("#ExpireDate").val(),
        ExpireDateUTC: $("#ExpireDate").val(),
        PreviousExpiryDate: $("#PreviousExpiryDate").val(),
        PreviousExpiryDateUTC: $("#PreviousExpiryDate").val(),
        RegistrationNo: $("#RegistrationNo").val(),
        Timestamp: $("#Timestamp").val(),
        EngLicenseandCertificateTxnDetList: EngLicenseandCertificateTxnDetList

    }

    //var _index;
    //$('#myTable tr').each(function () {
    //    _index = $(this).index();
    //});
    if (Isdeleteavailable == true) {
        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (EngLicenseandCertificateTxnDetList) {
            if (EngLicenseandCertificateTxnDetList) {
                save(PostData);
            }
            else {
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                $('#btnEdit').attr('disabled', false);
                $('#btnSaveandAddNew').attr('disabled', false);
                
            }
        });
    }
    else {
        save(PostData);
    }


    

    function save(PostData) {

        var ActionType = $('#ActionType').val();
        id = $('#primaryID').val();

        if ((id == 0 || id==null) && (CurrentbtnID == "btnSave" || CurrentbtnID == "btnSaveandAddNew")) {
            var jqxhr = $.post("/api/LicenseAndCertificateApi/save", PostData, function (response) {
                var result = JSON.parse(response);

                if (result.ErrorMsg) {
                    $("div.errormsgcenter").text(result.ErrorMsg);
                    $('#errorMsg').css('visibility', 'visible');
                    $('#errorMsg').show();

                    $('#btnSave').attr('disabled', false);
                    $('#btnEdit').attr('disabled', false);
                    $('#btnSaveandAddNew').attr('disabled', false);

                    $('#myPleaseWait').modal('hide');
                    return;
                }
                var htmlval = ""; $('#tablebody').empty();
                $('#myTable').empty();
                $('#ActionType').val("EDIT");
                $("#LicenseNo").prop("disabled", true);
                $("#txtLicenseDescription").prop("disabled", true);
                $("#Category").prop("disabled", true);
                $("#grid").trigger('reloadGrid');
                $('#hdnAttachId').val(result.HiddenId);
                $('#btnDelete').show();
                if (result.LicenseId != 0) {
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                }
                BindDatatoHeader(result);
                $(".content").scrollTop(0);
                showMessage('License and Certificate Details', CURD_MESSAGE_STATUS.SS);
                //$("#top-notifications").modal('show');
                //setTimeout(function () {
                //    $("#top-notifications").modal('hide');
                //}, 5000);
                //setTimeout(function () {
                //    $("#top-notifications").modal('hide');
                //}, 5000);
            
                $('#btnSave').attr('disabled', false);
                $('#btnEdit').attr('disabled', false);
                $('#btnSaveandAddNew').attr('disabled', false);

                $('#myPleaseWait').modal('hide');
                if (CurrentbtnID == "btnSaveandAddNew") {
                    EmptyFields();
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
                  $("div.errormsgcenter").text(errorMessage);
                  $('#errorMsg').css('visibility', 'visible');
                  $('#errorMsg').show();
             
                  $('#btnSave').attr('disabled', false);
                  $('#btnEdit').attr('disabled', false);
                  $('#btnSaveandAddNew').attr('disabled', false);

                  $('#myPleaseWait').modal('hide');
              });



        }

        else if ((id != 0) && (CurrentbtnID == "btnEdit" || CurrentbtnID == "btnSaveandAddNew")) {
            $('#myPleaseWait').modal('show');

            var jqxhr = $.post("/api/LicenseAndCertificateApi/update", PostData, function (response) {
                var result = JSON.parse(response);
                var htmlval = ""; $('#tablebody').empty();
                //$('#myTable').empty();
                $('#ActionType').val("EDIT");
                if (result.ErrorMsg) {
                    $("div.errormsgcenter").text(result.ErrorMsg);
                    $('#errorMsg').css('visibility', 'visible');
                    $('#errorMsg').show();

                    $('#btnSave').attr('disabled', false);
                    $('#btnEdit').attr('disabled', false);
                    $('#btnSaveandAddNew').attr('disabled', false);
                    $('#hdnAttachId').val(result.HiddenId);
                    $('#myPleaseWait').modal('hide');
                    return;
                }
                $('#btnDelete').show();
                $("#grid").trigger('reloadGrid');
                if (result.LicenseId != 0) {
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                }
                BindDatatoHeader(result);
                $(".content").scrollTop(0);
                showMessage('License and Certificate Details', CURD_MESSAGE_STATUS.SS);

                $('#btnSave').attr('disabled', false);
                $('#btnEdit').attr('disabled', false);
                $('#btnSaveandAddNew').attr('disabled', false);

                $('#myPleaseWait').modal('hide');
                if (CurrentbtnID == "btnSaveandAddNew") {
                    EmptyFields();
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
                 $("div.errormsgcenter").text(errorMessage);
                 $('#errorMsg').css('visibility', 'visible');

                 $('#btnSave').attr('disabled', false);
                 $('#btnEdit').attr('disabled', false);
                 $('#btnSaveandAddNew').attr('disabled', false);

                 $('#myPleaseWait').modal('hide');
             });
        }
    }
    //if ((id == 0 || id==null) && (CurrentbtnID == "btnSave" || CurrentbtnID == "btnSaveandAddNew")) {
    //    var jqxhr = $.post("/api/LicenseAndCertificateApi/save", PostData, function (response) {
    //        var result = JSON.parse(response);

    //        if (result.ErrorMsg) {
    //            $("div.errormsgcenter").text(result.ErrorMsg);
    //            $('#errorMsg').css('visibility', 'visible');
    //            $('#errorMsg').show();

    //            $('#btnSave').attr('disabled', false);
    //            $('#btnEdit').attr('disabled', false);
    //            $('#btnSaveandAddNew').attr('disabled', false);

    //            $('#myPleaseWait').modal('hide');
    //            return;
    //        }
    //        var htmlval = ""; $('#tablebody').empty();
    //        $('#myTable').empty();
    //        $('#ActionType').val("EDIT");
    //        $("#LicenseNo").prop("disabled", true);
    //        $("#txtLicenseDescription").prop("disabled", true);
    //        $("#Category").prop("disabled", true);
    //        $("#grid").trigger('reloadGrid');
    //        $('#hdnAttachId').val(result.HiddenId);
    //        if (result.LicenseId != 0) {
    //            $('#btnNextScreenSave').show();
    //            $('#btnEdit').show();
    //            $('#btnSave').hide();
    //        }
    //        BindDatatoHeader(result);

    //        showMessage('License and Certificate Details', CURD_MESSAGE_STATUS.SS);
    //        //$("#top-notifications").modal('show');
    //        //setTimeout(function () {
    //        //    $("#top-notifications").modal('hide');
    //        //}, 5000);
    //        //setTimeout(function () {
    //        //    $("#top-notifications").modal('hide');
    //        //}, 5000);
            
    //        $('#btnSave').attr('disabled', false);
    //        $('#btnEdit').attr('disabled', false);
    //        $('#btnSaveandAddNew').attr('disabled', false);

    //        $('#myPleaseWait').modal('hide');
    //        if (CurrentbtnID == "btnSaveandAddNew") {
    //            EmptyFields();
    //        }
    //    },
    //     "json")
    //      .fail(function (response) {
    //          var errorMessage = "";
    //          if (response.status == 400) {
    //              errorMessage = response.responseJSON;
    //          }
    //          else {
    //              errorMessage = Messages.COMMON_FAILURE_MESSAGE;
    //          }
    //          $("div.errormsgcenter").text(errorMessage);
    //          $('#errorMsg').css('visibility', 'visible');
    //          $('#errorMsg').show();
             
    //          $('#btnSave').attr('disabled', false);
    //          $('#btnEdit').attr('disabled', false);
    //          $('#btnSaveandAddNew').attr('disabled', false);

    //          $('#myPleaseWait').modal('hide');
    //      });



    //}

    //else if ((id != 0) && (CurrentbtnID == "btnEdit" || CurrentbtnID == "btnSaveandAddNew")) {
    //    $('#myPleaseWait').modal('show');

    //    var jqxhr = $.post("/api/LicenseAndCertificateApi/update", PostData, function (response) {
    //        var result = JSON.parse(response);
    //        var htmlval = ""; $('#tablebody').empty();
    //        //$('#myTable').empty();
    //        $('#ActionType').val("EDIT");
    //        if (result.ErrorMsg) {
    //            $("div.errormsgcenter").text(result.ErrorMsg);
    //            $('#errorMsg').css('visibility', 'visible');
    //            $('#errorMsg').show();

    //            $('#btnSave').attr('disabled', false);
    //            $('#btnEdit').attr('disabled', false);
    //            $('#btnSaveandAddNew').attr('disabled', false);
    //            $('#hdnAttachId').val(result.HiddenId);
    //            $('#myPleaseWait').modal('hide');
    //            return;
    //        }
    //        $("#grid").trigger('reloadGrid');
    //        if (result.LicenseId != 0) {
    //            $('#btnNextScreenSave').show();
    //            $('#btnEdit').show();
    //            $('#btnSave').hide();
    //        }
    //        BindDatatoHeader(result);

    //        showMessage('License and Certificate Details', CURD_MESSAGE_STATUS.SS);
            
    //         $('#btnSave').attr('disabled', false);
    //         $('#btnEdit').attr('disabled', false);
    //         $('#btnSaveandAddNew').attr('disabled', false);

    //        $('#myPleaseWait').modal('hide');
    //        if (CurrentbtnID == "btnSaveandAddNew") {
    //            EmptyFields();
    //        }
    //    },
    //    "json")
    //     .fail(function (response) {
    //         var errorMessage = "";
    //         if (response.status == 400) {
    //             errorMessage = response.responseJSON;
    //         }
    //         else {
    //             errorMessage = Messages.COMMON_FAILURE_MESSAGE;
    //         }
    //         $("div.errormsgcenter").text(errorMessage);
    //         $('#errorMsg').css('visibility', 'visible');

    //         $('#btnSave').attr('disabled', false);
    //         $('#btnEdit').attr('disabled', false);
    //         $('#btnSaveandAddNew').attr('disabled', false);

    //         $('#myPleaseWait').modal('hide');
    //     });
    //}
});

function BindDatatoHeader(result)
{    
    //$("#txtAssetNo").prop('disabled', true);

    $("#Timestamp").val(result.Timestamp);
    $("#primaryID").val(result.LicenseId);
    $("#LicenseNo").val(result.LicenseNo);
    $("#txtLicenseDescription").val(result.LicenseDescription);
    $("#Status").val(result.Status);
    $("#Category").val(result.Category);
    $("#Category").change();
    
  
    $("#hdnTypeCodeId").val(result.AssetTypeCodeId); 
    $("#txtTypeCode").val(result.AssetTypeCode);
    $("#txtTypeDescription").val(result.AssetTypeDescription);
     $("#ClassGrade").val(result.ClassGrade);
     $("#txtStaffMasterId").val(result.ContactPersonStaffId);
     $("#txtContactPerson").val(result.ContactPerson);
     $("#IssuingBody").val(result.IssuingBody);
     $("#IssuingDate").val(checkForNullDate(result.IssuingDate));
     $("#NotificationForInspection").val(checkForNullDate(result.NotificationForInspection));
     
     $("#InspectionConductedOn").val(checkForNullDate(result.InspectionConductedOn));
     $("#NextInspectionDate").val(checkForNullDate(result.NextInspectionDate));
     ExpiryDatefromdb = checkForNullDate(result.ExpireDate);
     $("#ExpireDate").val(checkForNullDate(result.ExpireDate));
     $("#PreviousExpiryDate").val(checkForNullDate(result.PreviousExpiryDate));
     $("#RegistrationNo").val(result.RegistrationNo);
  //   $("#LicenseNoHistory").val(result.LicenseNohistory);
     bindDatatoDatagrid(result);

}

function bindDatatoDatagrid(result)
{
    var category = result.Category;
   
    var item = Enumerable.From(LOVlist.LCCategoryValueList).Where(x=>x.LovId == parseInt(category)).Select(x=>x.FieldValue).FirstOrDefault();
    if (item == "Asset")
    {
        $("#divEngAssetList").show();
        $("#divPersonal").hide();
        $('#txtStaffName_0').removeAttr('required');
        $('#selDesignation_0').removeAttr('required');

        if (result != null && result.EngLicenseandCertificateTxnDetList != null && result.EngLicenseandCertificateTxnDetList.length > 0) {
            $('#tableAssetNos > tbody').children('tr').remove();
            $.each(result.EngLicenseandCertificateTxnDetList, function (index1, value1) {
                        var tableRow = '<tr ><td width="3%" style="text-align:center"><input type="checkbox" id="chkAssetDelete_' + index1 + '" /></td>' +
                            '<td width="33%"><input type="text" id="txtAssetNo_' + index1 + '" name="AssetNo_0" class="form-control" placeholder="Please Select" ' +
                            ' maxlength="25" autocomplete="off" pattern="^[a-zA-Z0-9\-\/]+$" required/>' +
                            '<input type="hidden" id="hdnAssetId_' + index1 + '"/><div class="col-sm-12" id="divFetch_' + index1 + '"></div></td>' +
                            '<td width="32%">' +
                            '<input type="text"  class="form-control" id="txtAssetDescription_' + index1 + '" name="AssetDescription" disabled /></td>' +
                            '<td width="32%"><input id="txtRemarks_' + index1 + '"  name="Remarks" class="form-control" type="text" maxlength="500" /></td>' +
                            '</tr>';
                        $('#tableAssetNos > tbody').append(tableRow);

                        $('#hdnAssetId_' + index1).val(value1.AssetId);
                        $('#txtAssetNo_' + index1).val(value1.AssetNo);
                        $('#txtAssetDescription_' + index1).attr('disabled', true).val(value1.AssetDescription);
                        $('#txtRemarks_' + index1).val(value1.Remarks);
                        linkCliked1 = true;
                });
                        BindFetchEventsForAsset();
                        BindEvensForCheckBox();
                        tableInputValidation('tableAssetNos');
        }

        //************************************************ Grid Pagination *******************************************

        //if ((result.EngLicenseandCertificateTxnDetList && result.EngLicenseandCertificateTxnDetList.length) > 0) {
        //    AssetId = result.EngLicenseandCertificateTxnDetList[0].AssetId;
        //    GridtotalRecords = result.EngLicenseandCertificateTxnDetList[0].TotalRecords;
        //    TotalPages = result.EngLicenseandCertificateTxnDetList[0].TotalPages;
        //    LastRecord = result.EngLicenseandCertificateTxnDetList[0].LastRecord;
        //    FirstRecord = result.EngLicenseandCertificateTxnDetList[0].FirstRecord;
        //    pageindex = result.EngLicenseandCertificateTxnDetList[0].PageIndex;
        //}
        ////$('#paginationfooter').show();
        //var mapIdproperty = ["IsDeleted-chkAssetDelete_", "AssetId-hdnAssetId_", "AssetNo-txtAssetNo_", "AssetDescription-txtAssetDescription_", "Remarks-txtRemarks_"];
        //var index1 = $('#tableAssetNos tr').length - 1;
        //var htmltext = '<tr ><td width="5%" style="text-align:center"><input type="checkbox" id="chkAssetDelete_' + index1 + '" /></td>' +
        //                       '<td width="33%"><input type="text" id="txtAssetNo_' + index1 + '" name="AssetNo_0" class="form-control" placeholder="Please Select" ' +
        //                       ' maxlength="25" autocomplete="off" pattern="^[a-zA-Z0-9\-\/]+$" required/>' +
        //                       '<input type="hidden" id="hdnAssetId_' + index1 + '" required/><div class="col-sm-12" id="divFetch_' + index1 + '"></div></td>' +
        //                       '<td width="31%">' +
        //                       '<input type="text"  class="form-control" id="txtAssetDescription_' + index1 + '" name="AssetDescription" disabled /></td>' +
        //                       '<td width="31%"><input id="txtRemarks_' + index1 + '"  name="Remarks" class="form-control" type="text" maxlength="500" /></td>' +
        //                       '</tr>';//Inline Html
        //var primaryId = $('#primaryID').val();
        //var obj = {
        //    formId: "#frmLicenseAndCertificate", IsView: ($('#ActionType').val() == ""), PageNumber: pageindex, flag: "LicenseAndCertificateflag", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "EngLicenseandCertificateTxnDetList", tableid: '#tableAssetNos', destionId: "#paginationfooterAsset", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/LicenseAndCertificateApi/get/" + primaryId, pageindex: pageindex, pagesize: pagesize
        //};

        //CreateFooterPagination(obj);

        //************************************************ End *******************************************************

    }
    else if (item == "Personnel") {

        $("#divEngAssetList").hide();
        $("#divPersonal").show();
        $('#txtAssetNo_0').removeAttr('required');
        $('#hdnAssetId_0').removeAttr('required');

        if (result != null && result.EngLicenseandCertificateTxnDetList != null && result.EngLicenseandCertificateTxnDetList.length > 0) {
            $('#tablePersons > tbody').children('tr').remove();
            $.each(result.EngLicenseandCertificateTxnDetList, function (index1, value1) {
                var tableRow = '<tr ><td width="3%" style="text-align:center"><input type="checkbox" id="chkPersonDelete_' + index1 + '" /></td>' +
                               '<td width="33%"><input type="text" id="txtStaffName_' + index1 + '" class="form-control" placeholder="Please Select" ' +
                               ' maxlength="75" autocomplete="off" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" required/>' +
                               '<input type="hidden" id="hdnStaffId_' +index1 + '"/><div class="col-sm-12" id="divPersonalFetch_' +index1 + '"></div></td>' +
                               '<td width="32%">' +
                               '<input type="text" id="selDesignation_' + index1 + '" class="form-control" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" maxlength="75" required/></td>' +
                               '<td width="32%"><input id="txtPersonRemarks_' +index1 + '"  class="form-control" type="text" maxlength="500" /></td>' +
                               '</tr>';
                    $('#tablePersons > tbody').append(tableRow);
                    $("#txtPersonRemarks_" + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\-\\s!@#$%*"&]+$');
                    //$.each(LOVlist.Designations, function (index, value) {
                    //    $('#selDesignation_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                    //});

                    $('#txtStaffName_' + index1).val(value1.StaffName);
                    $('#selDesignation_' + index1).val(value1.Designation);
                    $('#txtPersonRemarks_' + index1).val(value1.Remarks);
                    $('#hdnStaffId_' + index1).val(value1.StaffId);
                    linkCliked2 = true;
                });
                    BindFetchEventsForPerson();
                    BindEvensForCheckBoxPerson();
                    tableInputValidation('tablePersons');
          }
    }
    else {
        $("#divEngAssetList").hide();
        $("#divPersonal").hide();
        $('#txtStaffName_0').removeAttr('required');
        $('#selDesignation_0').removeAttr('required');
        $('#txtAssetNo_0').removeAttr('required');
        $('#hdnAssetId_0').removeAttr('required');
    }

    if (result != null && result.EngLicenseandCertificateTxnHistoryList != null && result.EngLicenseandCertificateTxnHistoryList.length > 0) {
        $("#divEngHistoryList").show();
        $('#tableHistoryList > tbody').children('tr').remove();
        $.each(result.EngLicenseandCertificateTxnHistoryList, function (index1, value1) {
            var tableRow = '<tr ><td width="24%"><input type="text" id="txtLicenseNo_' + index1 + '" name="LicenseNo" class="form-control" disabled /></td> ' +
                '<td width="24%">' +
                '<input type="text"  class="form-control" id="txtIssuingDate_' + index1 + '" name="IssuingDate" disabled /></td>' +
                '<td width="24%"><input id="txtExpireDate_' + index1 + '"  name="ExpireDate" class="form-control" type="text" disabled /></td>' +
                '<td width="24%"><input id="txtStatus_' + index1 + '"  name="Status" class="form-control" type="text" disabled /></td>' +
                '</tr>';
            $('#tableHistoryList > tbody').append(tableRow);

            const date = new Date(value1.IssuingDate);
            const formattedIssueDate = date.toLocaleDateString('en-GB', {
                day: 'numeric', month: 'short', year: 'numeric'
            }).replace(/ /g, '-');

            const dateexp = new Date(value1.ExpireDate);
            const formattedExpireDate = dateexp.toLocaleDateString('en-GB', {
                day: 'numeric', month: 'short', year: 'numeric'
            }).replace(/ /g, '-');

            $('#txtLicenseNo_' + index1).attr('disabled', true).val(value1.LicenseNo);
            $('#txtIssuingDate_' + index1).attr('disabled', true).val(formattedIssueDate);
            $('#txtExpireDate_' + index1).attr('disabled', true).val(formattedExpireDate);
            $('#txtStatus_' + index1).attr('disabled', true).val("Inactive");
        });
    }
    else 
    {
        $("#divEngHistoryList").hide();
    }
}

function checkForNullDate(date)
{
    if (date == "0001-01-01T00:00:00")
        return " ";
    else
        return DateFormatter(date);
}

function ChangePreviousExpiryDate()
{
    if (new Date($("#ExpireDate").val()) < new Date(ExpiryDatefromdb))
    {
        return;
    }
    if (ExpiryDatefromdb && new Date(ExpiryDatefromdb) !=  new Date($("#ExpireDate").val()))
    {
        $("#PreviousExpiryDate").val(ExpiryDatefromdb);
    }
}

$("#btnLicenseCancel").click(function () {
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

function LinkClicked(id) {
    linkCliked1 = true;
    linkCliked2 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#frmLicenseAndCertificate :input:not(:button)").parent().removeClass('has-error');
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
        $("#frmLicenseAndCertificate :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    if (ActionType !== "ADD") {
        $("#Category").prop("disabled", true);
      //  $("#LicenseNo").prop("disabled", true);
        $("#txtLicenseDescription").prop("disabled", true);
        //$("#txtAssetNo").prop("disabled", true);
        var jqxhr = $.get("/api/LicenseAndCertificateApi/get/" + id + "/" + pagesize + "/" + pageindex, function (response) {
            var result = JSON.parse(response);
            var htmlval = "";
            $('#tablebody').empty();
            $('#myTable').empty();
            BindDatatoHeader(result);
            $('#hdnAttachId').val(result.HiddenId);
            if (ActionType == "VIEW") {
                $("#frmLicenseAndCertificate :input:not(:button)").prop("disabled", true);
                $("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
            }

            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        })
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

    }
    setTimeout(function () {
        $("#top-notifications").modal('hide');
    }, 5000);
    $('#btnSave').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
   
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();    
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/LicenseAndCertificateApi/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('License and Certificate Details', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('License and Certificate Details', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $("#divEngHistoryList").hide();
    $('input[type="text"], textarea').val('');
    $(".content").scrollTop(0);
    $('#tableAssetNos > tbody').children('tr:not(:first)').remove();
    $('#tablePersons > tbody').children('tr:not(:first)').remove();
    $('#tableHistoryList > tbody').children('tr:not(:first)').remove();
    $('#primaryID').val(null);
    //$("#LicenseDetId").val(null)
    $('#Category').val(144);
    //$('#ServiceId').val(2);
    $('#txtTypeCode').val(" ");
    $("#hdnTypeCodeId").val(" ");
    $('#Status').val(1);
    $('#IssuingBody').val("null");
    $('#LicenseNo').prop('disabled', false);
    $('#txtLicenseDescription').prop('disabled', false);
    $('#Category').prop('disabled', false);
    $('#hdnTypeCodeId').prop('disabled', false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    //$("#txtAssetNo").prop('disabled', false);
    $("#frmLicenseAndCertificate :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    $('#spnPopup-typeCode').attr('disabled', false).css('cursor', 'pointer');
    $('#spnPopup-typeCode').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, "/api/Search/TypeCodeSearch");
    });
}