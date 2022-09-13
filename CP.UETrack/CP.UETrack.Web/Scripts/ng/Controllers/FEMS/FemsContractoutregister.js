
var LOVlist = {};
var pagesize = 5;
var pageindex = 1;
var GridtotalRecords;
var TotalPages = 1, FirstRecord, LastRecord = 0;
var AllowRenew = false;
var id;
var btntype;
var IsRenewed = false;
var ActionType = $('#ActionType').val();
$(document).ready(function () {
    $('input[type="text"], textarea').val('');
    $('#myPleaseWait').modal('show');
    formInputValidation("CORForm");
    $('#btnDelete').hide();
    $('#btnEdit').hide();   
    $('#btnNextScreenSave').hide();
    //disableStartdate();
  
    id = $('#primaryID').val();


    var jqxhr = $.get("/api/FemsContractOutRegisterApi/Load", function (response) {
        var result = response;
        LOVlist = result;
        $(LOVlist.StatusValueList).each(function (_index, _data) {
            $('#status').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        });
        AddNewRow();
        //$("#jQGridCollapse1").click();
        $('#Renewbtn').hide();

        var contractorId = $('#hdnContractId').val();
        if (contractorId != null && contractorId != "" && contractorId != "0") {
            $("#jQGridCollapse1").click();
            var rowData1 = {};
            LinkClicked(contractorId, rowData1)
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
    //--------------- Search -----------------
    var staffSearchObj = {
        Heading: "Contractor Details ",//Heading of the popup
        SearchColumns: ['SSMNo-Contractor  Code', 'ContractorName-Contractor Name'],//ModelProperty - Space seperated label value
        ResultColumns: ["ContractorId-Primary Key", "SSMNo-Contractor  Code", "ContactNo-Contact No", "Email-Email", 'ContractorName-Contractor Name', "ContactPerson-Contact Person", "Designation-Designation"],//Columns to be returned for display
        FieldsToBeFilled: ["ContractorId-ContractorId", "contractCode-SSMNo", "ContactNo-ContactNo", "Email-Email", 'ContractorName-ContractorName', "FaxNo-FaxNo", "ContactPerson-ContactPerson", "Designation-Designation"]//id of element - the model property
    };

    var apiUrlForSearch = "/api/Search/SearchforContractorcode";

    $('#spnPopup-contractCode').click(function () {

        DisplaySeachPopup('divSearchPopup', staffSearchObj, apiUrlForSearch);
    });
    //----------------------------------------

    //--------------- Fetch -----------------
    var staffFetchObj = {
        SearchColumn: 'contractCode-SSMNo',//Id of Fetch field
        ResultColumns: ["ContractorId-Primary Key", 'SSMNo-contractCode', 'ContractorName-ContractorName'],//Columns to be displayed
        FieldsToBeFilled: ["ContractorId-ContractorId", "contractCode-SSMNo", "ContactNo-ContactNo", "Email-Email", 'ContractorName-ContractorName', "FaxNo-FaxNo", "ContactPerson-ContactPerson", "Designation-Designation"]//id of element - the model property
    };

    var apiUrlForFetch = "/api/Fetch/FetchWarrantyProvider";

    $('#contractCode').on('input propertychange paste keyup', function (event) {

        DisplayFetchResult('divFetch', staffFetchObj, apiUrlForFetch, "UlFetch", event, 1);//1 -- pageIndex
    });

    //----------------------------------------


    $("#startDate,#endDate").on('input propertychange change paste', function () {
        RenewAction(true, true);
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

    $("#chk_ContractoutRegDet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#myTable tr').map(function (i) {
                if ($("#IsDeleted_" + i).prop("disabled")) {
                    $("#IsDeleted_" + i).prop("checked", false);
                }
                else {
                    $("#IsDeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#myTable tr').map(function (i) {
                $("#IsDeleted_" + i).prop("checked", false);
            });
        }
    });

});

$('#scopeOfWork').on('input propertychange paste keyup', function (event) {
    //  $('#Ber2Remarks').change(function ()

    var remarks = $('#scopeOfWork').val();
    if (remarks != '' && remarks != null && remarks != undefined) {
        $('#scopeOfWork').parent().removeClass('has-error');

    }

})
$('#BtnAddPlus').click(function () {

    var rowCount = $('#myTable tr:last').index();
    var AssetNo = $('#AssetNo_' + rowCount).val();
    var conntractvalue = $('#ContractValue_' + rowCount).val();
    if (rowCount < 0)
        AddNewRow();
    else if (rowCount >= "0" && (AssetNo == "null" || conntractvalue == "")) {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");       
    }
    else {
        AddNewRow();
    }
});
var linkCliked1 = false;
function AddNewRow() {

    var inputpar = {
        inlineHTML: '<tr ><input type="hidden" id="ContractDetId_maxindexval"/> <td id="del_maxindexval" width="3%"> <div class="checkbox text-center"> <label> <input type="checkbox"id="IsDeleted_maxindexval" onchange="IsDeleteCheckAllContractOut(myTable, chk_ContractoutRegDet)" name="checkboxes" value="" > </label> </div></td><td width="24%"> <ng-form novalidate name="AssetNo"> <input type="text" id="AssetNo_maxindexval" name="AssetNo" class="form-control fetchField" placeholder="Please Select " onkeyup="Fetchdata(event,maxindexval)" onpaste="Fetchdata(event,maxindexval)" change="Fetchdata(event,maxindexval)" oninput="Fetchdata(event,maxindexval)" autocomplete="off" required/> <input type="hidden" id="AssetRegisterId_maxindexval"/> <div class="col-sm-12" id="divFetch_maxindexval"></div></ng-form> </td><td width="25%"> <div> <input type="text" maxlength="100" id="AssetDescription_maxindexval" class="form-control" name="AssetDescription" disabled/> </div></td><td width="24%"> <select class="form-control " name="contractType" id="ContractType_maxindexval" required></select> </td><td width="24%"> ' +
                 '<div><input type="text"  id="ContractValue_maxindexval" name="ContractValue" style="text-align: right;" class="form-control decimalCheck commaSeperatorTable" required ></div> </td></tr>',
        //IdPlaceholderused: "maxindexval",
        TargetId: "#myTable",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_ContractoutRegDet').prop("checked", false);
    if (!linkCliked1) {
        $('#myTable tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var _index;
    $('#myTable tr').each(function () {
        _index = $(this).index();
    });
    $(LOVlist.ContractTypeValueList).each(function (index, _data) {
        $('#ContractType_' + _index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

    })
    $('.decimalCheck').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,16}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

    $('.commaSeperatorTable').focusout(function () {
        var id = $(this).attr('id');
        var x = $('#' + id).val();
        $('#hdn_' + id).val(x);
        if (parseInt(x) > 0) {
            $('#' + id).val(addCommasTable(x));
        }

    });
    $('.commaSeperatorTable').on('click', function (event) {     
        var id = $(this).attr('id');
        var val = $('#' + id).val();
        var result = val.split(',').join('');
        // var result = val.replace(/[_\W]+/g, "");
        $('#' + id).val(result);
    });
    function addCommasTable(x) {
        var parts = x.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return parts.join(".");
    }

    formInputValidation("CORForm");
}

function Fetchdata(event, index) {

    $('#divFetch_' + index).css({
        'top': $('#AssetNo_' + index).offset().top - $('#dataTableCheckList').offset().top + $('#AssetNo_' + index).innerHeight(),
        'width': $('#AssetNo_' + index).outerWidth()
    });

    // var index = arrayforIndex[temp - 1] ? arrayforIndex[temp - 1] : undefined;
    var parentAssetFetchObj = {
        SearchColumn: 'AssetNo_' + index + '-AssetNo',
        ResultColumns: ["AssetId-Primary Key", 'AssetNo' + '-AssetNo_' + index, 'AssetDescription-' + 'AssetDescription_' + index],
        FieldsToBeFilled: ["AssetRegisterId_" + index + "-AssetId", 'AssetNo_' + index + '-AssetNo', 'AssetDescription_' + index + "-AssetDescription"]
    };
    DisplayFetchResult('divFetch_' + index, parentAssetFetchObj, "/api/Fetch/ParentAssetNoFetch", "Ulfetch" + index, event, 1);
    //$('#SaprePartType_0').val(37);
}
function Save(isrenew,btntype) {

    //("#startDate,#endDate").trigger('input');
    var isFormValid = formInputValidation("CORForm", 'save');
    if (!isFormValid) {
        $(".errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnARSave').attr('disabled', false);
        //$('#btnEdit').attr('disabled', false);
        return false;
    }
    if (IsRenewed && isrenew) {
        $("#savebtn").show();
        bootbox.alert("Please Save Before Renewing");
        return;
    }

    $(".errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var startdate =  Date.parse($("#startDate").val());
    var endDate =  Date.parse($("#endDate").val());
    var currentdate = new Date();
    if (endDate != "" && endDate != null) {
    if (startdate > endDate) {
        $(".errormsgcenter").text("Contract End Date should be greater than Start Date");
        $('#errorMsg').css('visibility', 'visible');
        return
    }
    }
    //var id = $('#primaryID').val();
    //if (id == 0 || id == undefined || id == null || id == "") {
    //    if (startdate > currentdate) {
    //        $(".errormsgcenter").text("Contract Start Date should be less than or equal to Current Date");
    //        $('#errorMsg').css('visibility', 'visible');
    //        return
    //    }
    //}
    if ((currentdate > endDate)) {
        $('#status').val(2);
    }
    else {
        $('#status').val(1);
    }
    var isAssetNoInvalid = false;

    var resultList = [];
    $('#myTable tr').each(function () {
        var i = $(this).index();

        var currentVal= 0; 
        if ($('#ContractValue_' + i).val() != null)
        {
             currentVal=$('#ContractValue_' + i).val(); 
             currentVal = currentVal.split(',').join('');
        }
        
        var _tempObj = {
            ContractId: $("#primaryID").val(),
            ContractDetId: $('#ContractDetId_' + i).val(),
            AssetNo: $('#AssetNo_' + i).val(),
            AssetId: $('#AssetRegisterId_' + i).val(),
            AssetDescription: $('#AssetDescription_' + i).val(),
            ContractType: $('#ContractType_' + i).val(),
            ContractValue: ($('#ContractValue_' + i).val() != null ) ? currentVal :  $('#ContractValue_' + i).val(),
            IsDeleted: DeleteRec(i, $('#IsDeleted_' + i).is(":checked")),
            //Quantity: $('#Quantity_' + i).val(),
            //Cost: $('#Cost_' + i).val(),
            //InvoiceNo: $('#InvoiceNo_' + i).val(),
            //Remarks: $('#Remarks_' + i).val(),
            //SparePartsId: $('#SparePartsId_' + i).val(),
            //ItemId: 1,
            

        }
        //alert($('#Isdeleted_' + i).is(":checked"));
        resultList.push(_tempObj);


    });
    $('#myTable tr').each(function (index, value) {
        if (isAssetNoInvalid) {
            return;
        }
        var AssetregisterId = $('#AssetRegisterId_' + index).val();
        var AssetNo= $('#AssetNo_' + index).val();
        var isdeleted = $('#IsDeleted_' + index).is(":checked");
        var id = $('#AssetNo_' + index).val();
       // var AssetDescription = $('#AssetDescription_' + index).val();
        if ((AssetregisterId == '' || AssetregisterId == undefined || AssetregisterId == null || AssetregisterId == 0) && AssetNo!='' && isdeleted==false) {
            isAssetNoInvalid = true;
            //DisplayErrorMessage("Please enter valid Asset No");
            $("div.errormsgcenter").text("Please enter valid Asset No");
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#btnSaveandAddNew').attr('disabled', false);
            $('#' + id).parent().addClass('has-error');
            return false;
        }
    });
    if (isAssetNoInvalid) {
        return false;
    }
    var Contractorcodevalid = $("#ContractorId").val();
    if ((Contractorcodevalid == '' || Contractorcodevalid == undefined || Contractorcodevalid == null || Contractorcodevalid == 0)) { 
        $("div.errormsgcenter").text("Please enter valid Contractor Code");
        $('#errorMsg').css('visibility', 'visible');
        $('#btnSave').attr('disabled', false);
        $('#btnEdit').attr('disabled', false);
        $('#btnSaveandAddNew').attr('disabled', false);
        return false;
    }
   
  

    var deletedCount = Enumerable.From(resultList).Where(x=>x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    
    var allChecked = $('#chk_ContractoutRegDet').prop('checked');
    if (allChecked) {

        // $("div.errormsgcenter").text("All records can't be deleted ");
        bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
        //$('#errorMsg').css('visibility', 'visible');
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    else if (Isdeleteavailable) {
        message = "Are you sure that you want to delete the record(s)?";

        bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
            if (result) {
                Submit(resultList, isrenew, btntype, btntype);
            }
            else {

            }

        });
    }
    else {
        Submit(resultList, isrenew, btntype);
    }
}

function Submit(result, isrenew, btntype) {
    var postdata = {
        AssetList: result,
        ContractId: $("#primaryID").val(),
        ServiceId: 2,

        HospitalCode: $("#HospitalCode").val(),
        ContractNo: $("#ContractNo").val(),
        contractCode: $("#contractCode").val(),
        ContractorId: $("#ContractorId").val(),
        startDate: $("#startDate").val(),//moment(new Date($("#startDate").val())).format("YYYY-MMM-DD"),
        endDate: $("#endDate").val(),//moment(new Date($("#endDate").val())).format("YYYY-MMM-DD"),
        ContractorType: $("#ContractorType").val(),
        ContactPerson: $("#ContactPerson").val(),
        SecResponsiblePerson: $("#SecResponsiblePerson").val(),
        Designation: $("#Designation").val(),
        SecDesignation: $("#SecDesignation").val(),
        ContactNo: $("#ContactNo").val(),
        SecTelephoneNo: $("#SecTelephoneNo").val(),
        FaxNo: $("#FaxNo").val(),
        SecFaxNo: $("#SecFaxNo").val(),
        Email: $("#Email").val(),
        ContractSum: $("#ContractSum").val(),
        remarks: $("#remarks").val(),
        scopeOfWork: $("#scopeOfWork").val(),
        IsRenewed: isrenew,
        Status: $("#status").val(),
        NotificationForInspection: $("#NotificationForInspection").val(),
       

    };

    var ActionType = $('#ActionType').val();
    var Id = $("#primaryID").val();
    if (ActionType == "ADD" && (Id == null || Id == 0 || Id == "" || Id == undefined)) {
       
        var jqxhr = $.post("/api/ContractOutRegisterApi/save", postdata, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();


            BindDatatoHeader(result);
            bindDatatoDatagrid(result.AssetList);
            if (result.HistoryTab)
                bindhistoryvalues(result.HistoryTab);
            $("#grid").trigger('reloadGrid');
            $('#hdnAttachId').val(result.HiddenId);
            if (result.ContractId != 0) {
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
                $("#startDate").prop("disabled", true);
            }
            $(".content").scrollTop(0);
            showMessage('Contract Out Register', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (btntype == "btnSaveandAddNew") {
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
              $('#myPleaseWait').modal('hide');
          });



    }
    else {
        $('#myPleaseWait').modal('show');

        var jqxhr = $.post("/api/ContractOutRegisterApi/update", postdata, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();
            $('#ActionType').val("EDIT");
            BindDatatoHeader(result);
            bindDatatoDatagrid(result.AssetList);
            if (result.HistoryTab)
                bindhistoryvalues(result.HistoryTab);
            $("#grid").trigger('reloadGrid');
            $('#hdnAttachId').val(result.HiddenId);
            $(".content").scrollTop(0);
            showMessage('Contract Out Register', CURD_MESSAGE_STATUS.US);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (btntype == "btnSaveandAddNew") {
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
             $('#myPleaseWait').modal('hide');
         });



    }
}

function BindDatatoHeader(data) {

    $("#primaryID").val(data.ContractId);
    $('#HospitalCode').val(data.HospitalCode);
    $('#ContractNo').val(data.ContractNo);
    $("#ContractNo").prop("disabled", true);
    $("#startDate").prop("disabled", true);
    $('#contractCode').prop("disabled", true).val(data.contractCode); $('#contractCodehst').val(data.contractCode);
    $('#ContractorId').val(data.ContractorId);
    $('#ContractorName').val(data.ContractorName); $('#ContractorNamehst').val(data.ContractorName);
    $('#ContractorType').val(data.ContractorType);
    $('#startDate').val(DateFormatter(data.startDate));
    $('#endDate').val(DateFormatter(data.endDate));
    $('#ContactPerson').val(data.ContactPerson);
    $('#SecResponsiblePerson').prop("disabled", true).val(data.SecResponsiblePerson);
    $('#Designation').val(data.Designation);
    $('#SecDesignation').prop("disabled", true).val(data.SecDesignation);
    $('#ContactNo').val(data.ContactNo);
    $('#SecTelephoneNo').prop("disabled", true).val(data.SecTelephoneNo);
    $('#FaxNo').val(data.FaxNo);
    $('#SecFaxNo').prop("disabled", true).val(data.SecFaxNo);
    $('#Email').val(data.Email);
    if (data.ContractSum) {
        //$('#ContractSum').val(addCommas(data.ContractSum));
        $('#ContractSum').val(addCommas(data.ContractSumString));
    }
    else {
        $('#ContractSum').val(data.ContractSum);
    }
    $('#scopeOfWork').val(data.scopeOfWork);
    $('#remarks').val(data.remarks);
    $('#status').val(data.Status);
    AllowRenew = data.AllowRenew;
    IsRenewed = data.IsRenewed;
    $("#NotificationForInspection").val(DateFormatter(data.NotificationForInspection));
    //if (AllowRenew && ($('#ActionType').val()) != "ADD")
    //{ $("#Renewbtn").show(); $("#savebtn").hide(); }
    //else { $("#Renewbtn").hide(); $("#savebtn").show(); }
    $('#spnPopup').hide();
    if (IsRenewed) {
        $('#endDate').val("");
        // $('#startDate').val(data.endDate);
    }
    //disableStartdate();
    var mode = $('#ActionType').val();
    //if (mode == "ADD") {
    //    $('#ActionType').val("EDIT");
    RenewAction(null, false);
    //}
    //else {
    //     RenewAction();
    //
    //}






}


//function bindhistoryvalues(_data) {

//    if (res != null && res.CategoryHistoryList != null && res.CategoryHistoryList.length > 0) {
//        var html = '';
//        $.each(_data, function (index, data) {

           
//            html += '<tr > <td> <div> <label class="col-sm-6 control-label" id="ContractNoHst_maxindexval"> </label> </div></td><td> <div> <label class="col-sm-6 control-label" id="ContractStartDateHst_maxindexval"> </label> </div></td><td> <div> <label class="col-sm-6 control-label" id="ContractEndDateHst_maxindexval"> </label> </div></td>' +
//                          '<input type="hidden" id ="ContractHistoryId_maxindexval"><input type="hidden" id="ContractIdHst_maxindexval"/><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
//                                  '<a data-toggle="modal" onclick="GetAssetDetailsforPopup(' + index + ')" class="btn btn-sm btn-primary btn-info btn-lg" data-target="#myModal1"> <span class="glyphicon glyphicon-modal-window btn-info" role="button" tabindex="0"></span> </a> </div></td></tr>';


//            //html += ' <tr class="ng-scope" style=""> <td width="25%" style="text-align: center;"> <div>' +
//            //          ' <input type="text" id="Version_' + index + '" value="' + data.Version + '"  class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" > <div> ' +
//            //          ' <input type="text" id="EffectiveFromDate_' + index + '" value="' + DateFormatter(data.EffectiveFromDate) + '"  class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
//            //          '<input type="text" id="ModifiedBy_' + index + '" value="' + data.ModifiedBy + '" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
//            //          '<a data-toggle="modal" class="btn btn-sm btn-primary btn-info btn-lg" onclick="GetCategoryDetails(' + index + ')" data-target="#myModal"> <span class="glyphicon glyphicon-modal-window btn-info" role="button" tabindex="0"></span> </a> </div></td></tr>';


//        });
//        $('#HistCategoryId').append(html);
//    }
//}




function bindhistoryvalues(_data) {
    $("#Hstory").empty();
    $(_data).each(function (index, data1) {
        var inputpar = {
            inlineHTML: '<tr > <td> <div> <label class="col-sm-6 control-label" id="ContractNoHst_maxindexval"> </label> </div></td><td> <div> <label class="col-sm-6 control-label" id="ContractStartDateHst_maxindexval"> </label> </div></td><td> <div> <label class="col-sm-6 control-label" id="ContractEndDateHst_maxindexval"> </label> </div></td>' +
                          '<input type="hidden" id ="ContractHistoryId_maxindexval"><input type="hidden" id="ContractIdHst_maxindexval"/><td width="25%" style="text-align: center;" data-original-title="" title=""> <div> ' +
                                  '<a data-toggle="modal" onclick="GetAssetDetailsforPopup(' + index + ')" class="btn btn-sm btn-primary btn-info btn-lg" data-target="#myModal"> <span class="glyphicon glyphicon-modal-window btn-info" role="button" tabindex="0"></span> </a> </div></td></tr>',
           // IdPlaceholderused: "maxindexval",
            TargetId: "#Hstory",
            TargetElement: ["tr"]

        }
        AddNewRowToDataGrid(inputpar);
       
        $("#ContractStartDateHst_" + index).html(DateFormatter(data1.ContractStartDate));//moment(data1.ContractStartDate).format("YYYY-MMM-DD"));
        $("#ContractEndDateHst_" + index).html(DateFormatter(data1.ContractEndDate));//moment(data1.ContractEndDate).format("YYYY-MMM-DD"));
        $("#ContractHistoryId_" + index).val(data1.ContractHistoryId);
        $("#ContractIdHst_" + index).html(data1.ContractId);
        $("#ContractNoHst_" + index).html(data1.ContractNo);

    });

}
function GetAssetDetailsforPopup(index) {
    var ContractHisId = $('#ContractHistoryId_' + index).val();
    $('#HistPopupCategoryId').empty();
    GetPopUpDetails(ContractHisId)
}
function GetPopUpDetails(ContractHisId) {
    var primaryId = $('#primaryID').val();

    if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {

        $.get("/api/ContractOutRegisterApi/GetPopupDetails/" + primaryId + "/" + ContractHisId)
          .done(function (result) {

              var res = JSON.parse(result);
              if (res != null && res.HistoryTab != null && res.HistoryTab.length > 0) {
                      var html = '';
                      $('#HistPopupCategoryId').empty();
                      $.each(res.HistoryTab, function (index, data) {

                          html += '  <tr class="ng-scope"> <td width="25%" style="text-align: center;"> <div>' +
                            '<input type="text" id="AssetNo_' + index + '" value="' + data.AssetNo + '" name="Version" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;"> <div>' +
                            ' <input type="text" id="AssetDescription_' + index + '" value="' + data.AssetDescription + '" name="Version" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" > <div> ' +
                              '<input type="text" id="ContractType_' + index + '" value="' + data.ContractTypeName + '" name="Version" class="form-control" readonly> </div></td><td width="25%" style="text-align: center;" > <div> ' +
                              '<input type="text" id="ContractValue_' + index + '" value="' + addCommas(data.ContractValueString) + '" name="Version" style="text-align: right;" class="form-control" readonly> </div></td></tr>';
                      });
                      $('#HistPopupCategoryId').append(html);
                  }
              
              $('#myPleaseWait').modal('hide');
          })
         .fail(function () {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
             $('#errorMsg').css('visibility', 'visible');
         });
    }

}
function bindDatatoDatagrid(data) {
    $(data).each(function (i, data) {
        AddNewRow();
        //$("#primaryID").val(data.ContractId);
        $('#ContractDetId_' + i).val(data.ContractDetId);
        $('#AssetNo_' + i).val(data.AssetNo);
        $('#AssetRegisterId_' + i).val(data.AssetId);
        $('#AssetDescription_' + i).val(data.AssetDescription);
        $('#ContractType_' + i).val(data.ContractType);

        if (data.ContractValue != null)
        {
            //$('#ContractValue_' + i).val(addCommas(data.ContractValue));
            $('#ContractValue_' + i).val(addCommas(data.ContractValueString));
        }
        GridtotalRecords = data.TotalRecords;
        TotalPages = data.TotalPages;
        LastRecord = data.LastRecord;
        FirstRecord = data.FirstRecord;
        pageindex = data.PageIndex;
        if (ActionType == "VIEW") {
            $('#IsDeleted_' + i).prop("disabled", true);
            $('#AssetNo_' + i).prop("disabled", true);
            $('#AssetRegisterId_' + i).prop("disabled", true);
            $('#AssetDescription_' + i).prop("disabled", true);
            $('#ContractType_' + i).prop("disabled", true);
            $('#ContractValue_' + i).prop("disabled", true);

        }

    });
    var primaryId = $('#primaryID').val();
    var mapIdproperty = ["Isdeleted-Isdeleted_", "ContractDetId-ContractDetId_", "AssetNo-AssetNo_", "AssetId-AssetRegisterId_", "AssetDescription-AssetDescription_", "ContractType-ContractType_", "ContractValue-ContractValue_"];
    var htmltext = '<tr ><input type="hidden" id="ContractDetId_maxindexval"/> <td id="del_maxindexval" width="3%"> <div class="checkbox text-center"> <label> <input type="checkbox"id="IsDeleted_maxindexval" onchange="IsDeleteCheckAllContractOut(myTable, chk_ContractoutRegDet)" name="checkboxes" value="" > </label> </div></td><td width="24%"> <ng-form novalidate name="AssetNo"> <input type="text" id="AssetNo_maxindexval" name="AssetNo" class="form-control fetchField" placeholder="Please Select " onkeyup="Fetchdata(event,maxindexval)" onpaste="Fetchdata(event,maxindexval)" change="Fetchdata(event,maxindexval)" oninput="Fetchdata(event,maxindexval)" autocomplete="off" required/> <input type="hidden" id="AssetRegisterId_maxindexval"/> <div class="col-sm-12" id="divFetch_maxindexval"></div></ng-form> </td><td width="25%"> <div> <input type="text" maxlength="100" id="AssetDescription_maxindexval" class="form-control" name="AssetDescription" disabled/> </div></td><td width="24%"> <select class="form-control " name="contractType" id="ContractType_maxindexval" required></select> </td><td width="24%"> <input type="text" maxlength="9" id="ContractValue_maxindexval" name="ContractValue" style="text-align: right;" class="form-control decimalValidation" required > </td></tr>';
    var obj = { formId: "#frmUserRegistration", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "CORAssetList", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "AssetList", tableid: '#myTable', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/ContractOutRegisterApi/get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

    CreateFooterPagination(obj);
    if (ActionType == "VIEW") {
        $("#form :input:not(:button)").prop("disabled", true);
        $("#addnewrowbtn,#Renewbtn,#addnewbtn,#spnPopup,#BtnAddPlus").hide();//savebtn
    }


}

//function disableStartdate() {
//    var actiontype = $("#ActionType").val();
//    actiontype == "ADD" ? $("#startDate").prop("disabled", false) : $("#startDate").prop("disabled", true);

//}
function RenewAction(disble, iseditedfromtextField) {
    $(".errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var startdate =  Date.parse($("#startDate").val());
    var endDate =  Date.parse($("#endDate").val());
    var currentdate = new Date();
    if (endDate != "" && endDate != null) {
    if (startdate > endDate) {
        $(".errormsgcenter").text("Contract End date should be greater than Start Date");
        $('#errorMsg').css('visibility', 'visible');
        return
     }
   }
    if ((currentdate > endDate)) {
        $('#status').val(2);
    }
    else {
        $('#status').val(1);
    }


    if (endDate > currentdate) {

    }
    if (iseditedfromtextField) {
        return;
    }

    // var diffdays = ((ContractOutRegisterEntity.endDate.Date) - (DateTime.Now.Date)).TotalDays;

    var diff = new Date(endDate - currentdate);

    // get days
    var days = diff / 1000 / 60 / 60 / 24;  
    days = days < 0 ? (days * (-1)) : days;
    AllowRenew = (days <= 30 && days >= 0);


    if (AllowRenew ) {  //&& ($('#ActionType').val()) != "ADD"
        $("#Renewbtn").show(); $("#savebtn").hide();
        //if (ActionType != "VIEW")
      $("#ContractNo").prop("disabled", false).prop("required", true);
       // $("#startDate").prop("disabled", false).prop("required", true);
        $("#endDate").prop("disabled", false).prop("required", true);
        $("#BtnAddPlus").show();
    }
    else {
        $("#BtnAddPlus").hide();
        $("#Renewbtn").hide(); $("#savebtn").show();
        //if (!disble)
           // $("#endDate").prop("disabled", false).prop("required", true);
    }
}

function DeleteRec(i, delrec) {
    if (delrec == true) {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var ischecked = $("#IsDeleted_" + i).is(":checked");
        if (ischecked) {
            $("#AssetNo_" + i).prop("required", false).parent().removeClass('has-error');;
            $("#ContractValue_" + i).prop("required", false).parent().removeClass('has-error');;
        }
        else {
            $("#AssetNo_" + i).prop("required", true);
            $("#ContractValue_" + i).prop("required", true);
        }
        return true;
    }
    else {
        return false;
    }

}
function LinkClicked(id) {
    linkCliked1 = true;
    $(".content").scrollTop(0);
    $('.nav-tabs a:first').tab('show');
    $("#CORForm :input:not(:button)").parent().removeClass('has-error');
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
    //else if (!hasEditPermission && hasViewPermission) {
    //    action = "View"
    //}
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#CORForm :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var htmlval = ""; $('#tablebody').empty();
    id = $('#primaryID').val();
    if (id != null && id != "0") {
        var jqxhr = $.get("/api/ContractOutRegisterApi/get/" + id + "/" + pagesize + "/" + pageindex, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();

            if (ActionType == "VIEW") {
                $("#form :input:not(:button)").prop("disabled", true);
                $("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
            }
            BindDatatoHeader(result);
            bindDatatoDatagrid(result.AssetList);
            if (result.HistoryTab)
                bindhistoryvalues(result.HistoryTab);
            $('#hdnAttachId').val(result.HiddenId);
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
    else {
        //setTimeout(function () {
        //    $("#top-notifications").modal('hide');
        //}, 5000);
        //$('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    }
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
            $.get("/api/ContractOutRegisterApi/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Contract Out Register', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Contract Out Register', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#myTable').empty();
    $('#paginationfooter').hide()
    AddNewRow();
    $('#LevelFacility').val("null");
    $('#status').val(1);
    $("#ContractNo").prop("disabled", false);
    $("#startDate").prop("disabled", false);
    $("#endDate").prop("disabled", false).prop("required", false);
    $('#contractCode').prop("disabled", false); 
    $('#SecResponsiblePerson').prop("disabled", false);
    $('#SecDesignation').prop("disabled", false);
    $('#SecTelephoneNo').prop("disabled", false);
    $('#SecFaxNo').prop("disabled", false);
    $('#endDate').prop("disabled", false);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#Renewbtn').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#CORForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');   
    $('#spnPopup').show();
    $("#Hstory").empty();

}

$("#btnCancel,#btnHistoryCancel").click(function () {
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

function IsDeleteCheckAllContractOut(tbodyId, IsDeleteHeaderId) {
    var count = 0;
    var Isdeleted_ = [];
    tbodyId = '#' + tbodyId.id + ' tr';
    IsDeleteHeaderId = "#" + IsDeleteHeaderId.id;

    $(tbodyId).map(function (index, value) {
        if ($("#IsDeleted_" + index).prop("disabled")) {
            count++;
        }
        var Isdelete = $("#IsDeleted_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    var rowlen = ($(tbodyId).length) - (count)

    if (rowlen == Isdeleted_.length)
        $(IsDeleteHeaderId).prop("checked", true);
    else
        $(IsDeleteHeaderId).prop("checked", false);
    $('#myTable tr').each(function () {
        _index = $(this).index();
        var ischecked = $("#IsDeleted_" + _index).is(":checked");
            if (ischecked) {
                $("#AssetNo_" + _index).prop("required", false).parent().removeClass('has-error');;
                $("#ContractValue_" + _index).prop("required", false).parent().removeClass('has-error');;
            }
            else {
                $("#AssetNo_" + _index).prop("required", true);
                $("#ContractValue_" + _index).prop("required", true);
            
        }
    });
    
}