var list = {};
var YesNoList;
var action = "";
function loadSNFdetails(assetNo, typecode, typedesc, service) {
    if ($('#hdnARPrimaryID').val() == 0) {
        return false;
    }
    $('#txtARvariationAssetDescription').val($('#txtARTypeDescription').val());
    $("div.errormsgcenter").text("");
    $('#errorMsgVariationTab').css('visibility', 'hidden');

    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    // if (event.keyCode == 40) {

    if (action == "View") {
        $("#btnVariationDetailsEdit").hide();
        $('#addNewRowVariationDetail').attr('disabled', true).css('cursor', 'default');
        $('#addNewRowVariationDetail').removeAttr('onclick');
    }

    var _AssetId = $('#hdnARPrimaryID').val();//asset Id

    $("div.errormsgcenter").text('');
    $('#errorMsgVariationTab').css('visibility', 'hidden');

    var jqxhr = $.post("/api/AssertregisterVariationDetailsTab/FetchSNFRef1", { AssetId: _AssetId }, function (response) {
        var result = JSON.parse(response);
        var htmlval = "";
        $('#tablebody').empty();    
        YesNoList = result.YesNoList;

        if (result.detailsList != null) {
            $.each(result.detailsList, function (i, data) {
            //if (i == 0)
            //{
            //        YesNoList = data.YesNoList;
                //}
                //if (data.WarrantyEndDate == "0001-01-01T00:00:00" || data.WarrantyEndDate == "" || data.WarrantyEndDate == "")
                //{
                //    data.WarrantyEndDate = "";
                //}
                htmlval = '<tr class="" style=""><td width="11%" style="text-align: center;" data-original-title="" title=""><div><input type="hidden" id="ContractLpoNo_' + i + '" value="' + data.ContractLpoNo + '"><input type="hidden" id="PurchaseDate_' + i + '" value="' + data.PurchaseDate + '"><input type="hidden" id="MainSupplierCode_' + i + '" value="' + data.MainSupplierCode + '"><input type="hidden" id="MainSupplierName_' + i + '" value="' + data.MainSupplierName + '"><input type="hidden" id="WarrantyStartDate_' + i + '" value="' + data.WarrantyStartDate + '"><input type="hidden" id="VariationStatusLovId_' + i + '" value="' + data.VariationStatusLovId + '"><input type="hidden" id="VariationId_' + i + '" value="' + data.VariationId + '"><input type="hidden" id="WarrantyDuration_' + i + '" value="' + data.WarrantyDuration + '"><input type="hidden" id="AssetClassification_' + i + '" value="' + data.AssetClassification + '"><input type="hidden" id="SnfDate_' + i + '" value="' + data.SnfDate + '"><input type="text" placeholder="Please Select ..."  id="id_SNFReferenceNo_' + i + '" readonly value=' + data.SNFDocumentNo + ' name="SNFReferenceNo" class="form-control" autocomplete="off"> <input type="hidden" id="TestingandCommissioningId_' + i + '" value="' + data.TestingandCommissioningId + '"></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationStatus_' + i + '" readonly value="' + data.VariationStatusName + '"  type="text" class="form-control  " name="VariationStatus" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="ProjectCost_' + i + '"  readonly value=' + addCommas(data.PurchaseProjectCost)+ ' type="text" class="form-control text-right" name="ProjectCost" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationDate_' + i + '"  readonly value=' + DateFormatter(data.VariationDate) + ' type="text" class="form-control  " name="VariationDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="ServiceStartDate_' + i + '"   readonly value=' + DateFormatter(data.StartServiceDate) + ' type="text" class="form-control  " name="ServiceStartDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="ServiceStopDate_' + i + '"  readonly value="' + DateFormatter(data.StopServiceDate) + ' " type="text" class="form-control   " name="ServiceStopDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="CommissioningDate_' + i + '"   readonly value=' + DateFormatter(data.CommissioningDate) + '  type="text" class="form-control  " name="CommissioningDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="WarrantyEndDate_' + i + '"  readonly value=' + DateFormatter(data.WarrantyEndDate) + ' type="text"  class="form-control  " name="WarrantyEndDate" autocomplete="off"           ></div></td><td width="5%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationMonth_' + i + '"  readonly value=' + data.VariationMonthName + ' type="text" class="form-control  " name="VariationMonth" autocomplete="off"           ></div></td><td width="5%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationYear_' + i + '"   readonly value=' + data.VariationYear + ' type="text" class="form-control  " name="VariationYear" autocomplete="off"           ></div></td><td width="9%" style="text-align: center;" data-original-title="" title=""><div><select id="VariationStatusApproved_' + i + '" value=' + data.AuthorizedStatusForVariation + ' class="form-control " name="VariationStatusApproved"></select></div></td></tr>';
                $('#tablebody').append(htmlval);
                $("#tablebody tr").each(function (i, data) {
                   var value= $("#WarrantyEndDate_" + i).val();
                   if (value == '01-Jan-1' || value == "" || value==null)
                    {
                       $("#WarrantyEndDate_" + i).val('');
                    }

                });
            $(YesNoList).each(function (index, _data) {
                $('#VariationStatusApproved_' + i).append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

            });
            $('#VariationStatusApproved_' + i).val(data.AuthorizedStatusForVariation);
            });
        }
           
            if (action == "View") {
                $("#frmVariationDetails :input:not(:button)").prop("disabled", true);
    }

        list = result;
           
            setTimeout(function () {
                $("#top-notifications").hide();
    }, 5000);
    $('#btnVariationDetailsEdit').attr('disabled', false);
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
         $('#errorMsgVariationTab').css('visibility', 'visible');
         $('#btnVariationDetailsEdit').attr('disabled', false);

         $('#myPleaseWait').modal('hide');
     });

    //}
}

function filldata(id) {
   // alert();
    //alert(list[id].SNFDocumentNo);
    $('#id_fetchlist').empty();
    if (list[id] != undefined)
    {
        $('#VariationStatus_0').val(list[id].VariationStatusName);
        $('#ProjectCost_0').val(list[id].PurchaseProjectCost);
        $('#VariationDate_0').val(list[id].VariationDate);
        $('#ServiceStartDate_0').val(list[id].StartServiceDate);
        $('#ServiceStopDate_0').val(list[id].StopServiceDate);
        $('#CommissioningDate_0').val(list[id].CommissioningDate);
        $('#WarrantyEndDate_0').val(list[id].WarrantyEndDate);
        $('#VariationMonth_0').val(list[id].VariationMonth);
        $('#VariationYear_0').val(list[id].ClosingYear);//VariationId , 
        $('#id_SNFReferenceNo_0').val(list[id].SNFDocumentNo);
    }
}
 //function back() {
 //       window.location.href = "/bems/general";
 //};

 function Fetchdata(event, index) {



     // var index = arrayforIndex[temp - 1] ? arrayforIndex[temp - 1] : undefined;
     
     var ItemMst = {
         AdditionalConditions: ["AssetId-primaryid"],
         SearchColumn: 'id_SNFReferenceNo_' + index + '-SNFDocNo',//Id of Fetch field
         AdditionalConditions: ["AssetId-hdnARPrimaryID"],
         ResultColumns: ["TestingandCommissioningId" + "-Primary Key", 'SNFDocNo' + '-id_SNFReferenceNo_' + index],//Columns to be displayed
         FieldsToBeFilled: ["TestingandCommissioningId_" + index + "-TestingandCommissioningId", 'id_SNFReferenceNo_' + index + '-SNFDocNo', 'VariationStatus_' + index + "-VariationStatusLovName", 'ProjectCost_' + index + '-PurchaseProjectCost', 'VariationDate_' + index + '-VariationDate', 'ServiceStartDate_' + index + '-StartServiceDate', 'ServiceStopDate_' + index + '-StopServiceDate', "CommissioningDate_" + index + "-CommissioningDate", "WarrantyEndDate_" + index + "-WarrantyEndDate", "VariationMonth_" + index + "-VariationMonth", "VariationYear_" + index + "-VariationYear", "VariationStatusApproved_" + index + "-VariationApprovedStatusLovId", "VariationStatusLovId_" + index + "-VariationStatusLovId", "VariationId_" + index + "-VariationId"]//id of element - the model property
     };
     DisplayFetchResult('divFetch_' + index, ItemMst, "/api/Fetch/FetchSNFDetails", "Ulfetch" + index, event, 1);
     //$('#SaprePartType_0').val(37);
 }
 $('#addNewRowVariationDetail').click(function () {

     var rowCount = $('#tablebody tr:last').index();
     var SNFRefNo = $('#id_SNFReferenceNo_' + rowCount).val();
     // var conntractvalue = $('#ContractValue_' + rowCount).val();
     if (rowCount < 0)
         AddNewRow();
     else if (rowCount >= "0" && (SNFRefNo == "null" || SNFRefNo == "")) {
         bootbox.alert("All fields are mandatory. Please enter details in existing row");
     }
     else {
         AddNewRow();
     }
 });
 function AddNewRow() {

     var inputpar = {
         inlineHTML: '<tr class="" style=""><td width="11%" style="text-align: center;" data-original-title="" title=""><div><input type="hidden" id="AuthorizedStatus_maxindexval" value=""><input type="hidden" id="ContractLpoNo_maxindexval" value=""><input type="hidden" id="PurchaseDate_maxindexval" value=""><input type="hidden" id="MainSupplierCode_maxindexval" value=""><input type="hidden" id="MainSupplierName_maxindexval" value=""><input type="hidden" id="WarrantyStartDate_maxindexval" value=""><input type="hidden" id="VariationStatusLovId_maxindexval" value=""><input type="hidden" id="VariationId_maxindexval" value=""><input type="hidden" id="WarrantyDuration_maxindexval" value=""><input type="hidden" id="AssetClassification_maxindexval" value=""><input type="hidden" id="SnfDate_maxindexval" value=""><input type="text" placeholder="Please Select ..."  id="id_SNFReferenceNo_maxindexval" value=""  name="SNFReferenceNo" onkeyup="Fetchdata(event,maxindexval)" onpaste="Fetchdata(event,maxindexval)" change="Fetchdata(event,maxindexval)" oninput="Fetchdata(event,maxindexval)" class="form-control"  autocomplete="off" required/> <input type="hidden" id="TestingandCommissioningId_maxindexval"  value=""></div><div class="col-sm-12" id="divFetch_maxindexval"></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationStatus_maxindexval" readonly  type="text" class="form-control  "  ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="ProjectCost_maxindexval"  readonly value=""    type="text" class="form-control text-right" name="ProjectCost" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationDate_maxindexval"  readonly value="" type="text" class="form-control  " name="VariationDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="ServiceStartDate_maxindexval"   readonly value="" type="text" class="form-control  " name="ServiceStartDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="ServiceStopDate_maxindexval"  readonly value="" type="text" class="form-control   " name="ServiceStopDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="CommissioningDate_maxindexval"   readonly value=""  type="text" class="form-control  " name="CommissioningDate" autocomplete="off"           ></div></td><td width="10%" style="text-align: center;" data-original-title="" title=""><div><input id="WarrantyEndDate_maxindexval"  readonly value="" type="text"  class="form-control  " name="WarrantyEndDate" autocomplete="off"           ></div></td><td width="5%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationMonth_maxindexval"  readonly value="" type="text" class="form-control  " name="VariationMonth" autocomplete="off"           ></div></td><td width="5%" style="text-align: center;" data-original-title="" title=""><div><input id="VariationYear_maxindexval"   readonly value="" type="text" class="form-control  " name="VariationYear" autocomplete="off"           ></div></td><td width="9%" style="text-align: center;" data-original-title="" title=""><div><select id="VariationStatusApproved_maxindexval" class="form-control " name="VariationStatusApproved"></select></div></td></tr>',
         //IdPlaceholderused: "maxindexval",
         TargetId: "#tablebody",
         TargetElement: ["tr"]

     }
     AddNewRowToDataGrid(inputpar);
     var _index;
     $('#tablebody tr').each(function () {
         _index = $(this).index();
     });
     $(YesNoList).each(function (index, _data) {
         $('#VariationStatusApproved_' + _index ).append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

     });

     $('#id_SNFReferenceNo_' + _index).prop("required", true);


 }
 function Save() {
     var postList = [];
     $('#tablebody tr').each(function (index) {
         var tem = {
             VariationId: $("#VariationId_" + index).val(),
             //CustomerId:$("#" +index).val(),
             // FacilityId:$("#" +index).val(),
             // ServiceId:$("#" +index).val(),
             SNFDocumentNo: $("#id_SNFReferenceNo_" + index).val(),
             SnfDate: $("#SnfDate_" + index).val(),
             AssetId: $("#hdnARPrimaryID").val(),
             AssetClassification: $("#AssetClassification_" + index).val(),
             VariationStatus: $("#VariationStatusLovId_" + index).val(),
             PurchaseProjectCost: $("#ProjectCost_" + index).val(),
             VariationDate: $("#VariationDate_" + index).val(),
             VariationDateUTC: $("#VariationDate_" + index).val(),
             StartServiceDate: $("#ServiceStartDate_" + index).val(),
             StartServiceDateUTC: $("#ServiceStartDate_" + index).val(),
             StopServiceDate: $("#ServiceStopDate_" + index).val(),
             StopServiceDateUTC: $("#ServiceStopDate_" + index).val(),
             CommissioningDate: $("#CommissioningDate_" + index).val(),
             CommissioningDateUTC: $("#CommissioningDate_" + index).val(),
             WarrantyDurationMonth: $("#WarrantyDuration_" + index).val(),
             WarrantyStartDate: $("#WarrantyStartDate_" + index).val(),
             WarrantyStartDateUTC: $("#WarrantyStartDate_" + index).val(),
             WarrantyEndDate: $("#WarrantyEndDate_" + index).val(),
             WarrantyEndDateUTC: $("#WarrantyEndDate_" + index).val(),
             VariationStatus: $("#VariationStatusLovId_" + index).val(),
             //ClosingMonth:$("#" +index).val(),
             //ClosingYear:$("#" +index).val(),
            /// VariationApprovedStatus: $("#VariationStatusApproved_" + index).val(),
             //Justification:$("#" +index).val(),
             //Remarks:$("#" +index).val(),
             // AuthorizedStatus: $("#AuthorizedStatus_" + index).val(),
             AuthorizedStatus: $("#VariationStatusApproved_" + index).val(),
             VariationRaisedDate: $("#SnfDate_" + index).val(),
             VariationRaisedDateUTC: $("#SnfDate_" + index).val(),
             //AssetOldVariationData:$("#" +index).val(),
             //VariationWFStatus:$("#" +index).val(),
             PurchaseDate: $("#PurchaseDate_" + index).val(),
             PurchaseDateUTC: $("#" + index).val(),
             VariationPurchaseCost: $("#ProjectCost_" + index).val(),
             //ContractCost:$("#" +index).val(),
             ContractLpoNo: $("#ContractLpoNo_" + index).val(),
             MainSupplierCode: $("#MainSupplierCode_" + index).val(),
             MainSupplierName: $("#MainSupplierName_" + index).val(),
             AuthorizedStatusForVariation: $("#VariationStatusApproved_" + index).val(),
         }

         tem.PurchaseProjectCost = tem.PurchaseProjectCost.split(',').join('');
         postList.push(tem);
     });
     console.log(postList); //return;
     var sumblist = {
     SaveList: postList
 }
     var duplicates = false;
     for (i = 0; i < postList.length; i++) {
         var snfDocumentNo = postList[i].SNFDocumentNo;
         for (j = i + 1; j < postList.length; j++) {
             if (snfDocumentNo == postList[j].SNFDocumentNo) {
                duplicates = true;
            }
            }
     }
     var isFormValid = formInputValidation("frmVariationDetails", 'save');
     if (!isFormValid) {
         $(".errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
         $('#errorMsgVariationTab').css('visibility', 'visible');

         $('#btnVariationDetailsEdit').attr('disabled', false);
         //$('#btnEdit').attr('disabled', false);
         return false;
     }
    if (duplicates) { 
        $("div.errormsgcenter").text('SNF Reference No. should be unique');
         $('#errorMsgVariationTab').css('visibility', 'visible');
        
        $('#btnVariationDetailsEdit').attr('disabled', false);
        return false;
    }
    var isSNFNoInvalid = false;
    $('#tablebody tr').each(function (index, value) {
        if (isSNFNoInvalid) {
            return;
        }
        var SNFReferenceNo = $('#id_SNFReferenceNo_' + index).val();
        var TestingandCommissionId = $('#TestingandCommissioningId_' + index).val();
       // var isdeleted = $('#IsDeleted_' + index).is(":checked");
        var id = $('#id_SNFReferenceNo_' + index).val();
        // var AssetDescription = $('#AssetDescription_' + index).val();
        if ((TestingandCommissionId == '' || TestingandCommissionId == undefined || TestingandCommissionId == null || TestingandCommissionId == 0 || TestingandCommissionId == "") && SNFReferenceNo != '') {
            isSNFNoInvalid = true;
            //DisplayErrorMessage("Please enter valid Asset No");
            $("div.errormsgcenter").text("Please enter valid SNF Reference No");
            $('#errorMsgVariationTab').css('visibility', 'visible');
            $('#btnVariationDetailsEdit').attr('disabled', false);
          //  $('#btnEdit').attr('disabled', false);
           // $('#btnSaveandAddNew').attr('disabled', false);
            $('#' + id).parent().addClass('has-error');
            return false;
        }
    });
    if (isSNFNoInvalid) {
        return false;
    }
            $("div.errormsgcenter").text('');
            $('#errorMsgVariationTab').css('visibility', 'hidden');

     var jqxhr = $.post("/api/AssertregisterVariationDetailsTab/save", sumblist, function (response) {
         var result = JSON.parse(response);
         if (result.SaveList != null && result.SaveList.length > 0) {
             $.each(result.SaveList, function (i, data) {
                 $("#VariationId_" + i).val(data.VariationId);
             });
         }
         $(".content").scrollTop(0);
            showMessage('Asset Register', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            //setTimeout(function () {
            //    $("#top-notifications").modal('hide');
            //}, 5000);
            //setTimeout(function () {
            //    $("#top-notifications").modal('hide');
            //}, 5000);
            $('#btnVariationDetailsEdit').attr('disabled', false);
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
              $('#errorMsgVariationTab').css('visibility', 'visible');

              $('#btnVariationDetailsEdit').attr('disabled', false);
              $('#myPleaseWait').modal('hide');
 });

 }
 $("#btntab7Cancel").click(function () {
     //window.location.href = "/bems/general";
     var message = Messages.Reset_TabAlert_CONFIRMATION;
     bootbox.confirm(message, function (result) {
         if (result) {
             EmptyFieldsVariationdetails();
         }
         else {
             $('#myPleaseWait').modal('hide');
         }
     });
    
 });
 function EmptyFieldsVariationdetails() {

     $('input[type="text"], textarea').val('');
     $('#selARAssetClassification').val("null");
     $('#selARServiceId,.selARServiceId').val(2);
     $('#selARAssetStatus').val(1);
     $('#selARRiskRating').val(113);
     $('#selARPurchaseCategory').val("null");
     $('#selARAppliedPartType').val("null");
     $('#selAREquipmentClass').val("null");
     $('#selARPPM').val("null");
     $('#selAROther').val("null");
     $('#selARRI').val("null");
     $('#selARAssetTransferMode').val("null");

     $('#txtARAssetNo').attr('disabled', false);

     $('#txtARTypeCode').attr('disabled', false);
     $('#txtARAssetPreRegistrationNo').attr('disabled', false);
     $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', false).css('cursor', 'default');
     $('#spnPopup-typeCode').unbind("click").attr('disabled', false).css('cursor', 'default');
     $('#btnAREdit').hide();
     $('#btnARSave').show();
     $('#btnDelete').hide();
     $('#btnNextScreenSave').hide();
     $('#spnActionType').text('Add');
     $("#hdnARPrimaryID").val('');
     $("#grid").trigger('reloadGrid');
     $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
     $("div.errormsgcenter").text("");
     $('#errorMsg').css('visibility', 'hidden');
     $('.nav-tabs a:first').tab('show')
 }