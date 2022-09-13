//*Golbal variables decration section starts*//
var pageindex = 1; var pagesize = 5;
var LOVlist = {};
var GridtotalRecords;
var TotalPages, FirstRecord, LastRecord = 0;
var WorkOrderStatusStringLoad = "";
//*Golbal variables decration section ends*//


$(document).ready(function () {

    formInputValidation("crmworkorderPage");
    $('#btnDelete').hide();
    $('#btnSaveandAddNewEdit').hide();
    $('#btnEdit').hide();
    $('#btnCancel').hide();
    var action= $('#ActionType').val();
    if (action == 'ADD') {
        $('#crmWorkAssetNo').prop("disabled", true);
        $('#crmWorkStfAss').prop("disabled", true);
        $('#crmWorkManu').prop("disabled", true);
        $('#crmWorkModel').prop("disabled", true);
        $('#crmWorkWrkOrdDet').prop("disabled", true);
        $('#crmWorkReqTyp').prop("disabled", true);
        $('#crmWorkReqTypService').prop("disabled", true);
    }
    $.get("/api/CRMWorkorderTab/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            //$("#jQGridCollapse1").click();
            //$('#ManufactModel').hide();
            //$('#ManufactModel').hide();

            $.each(loadResult.TypeofRequestLov, function (index, value) {
                $('#crmWorkReqTyp').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.WorkOrderStatusLov, function (index, value) {
                $('#crmWorkWrkOrdSts').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#crmWorkWrkOrdSts option[value="' + 139 + '"]').prop('selected', true);
            $("#crmWorkWrkOrdSts").prop("disabled", "disabled");

            ///*Creating workorder from CRM Request Screen passes Reqno param in query string form*/

            //var vars = [], hash;
            //var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            //var Passcrmreqid;
            //var Passcrmreqno;
            //var Passcrmreqtyp;

            //for (var i = 0; i < hashes.length; i++) {
            //    hash = hashes[i].split('=');
            //    vars.push(hash[0]);
            //    vars[hash[0]] = hash[1];
            //}

            //Passcrmreqid = vars.reqid;
            //Passcrmreqno = vars.reqno;
            //Passcrmreqtyp = vars.reqtyp;

            //$("#hdncrmWorkReqId").val(Passcrmreqid);
            //$("#crmWorkReqNo").val(Passcrmreqno);
            //$('#crmWorkReqTyp option[value="' + Passcrmreqtyp + '"]').prop('selected', true);


            ///***************************************************End**********************************************/

            //$("#crmWorkReqTyp").change(function () {

            //    if (this.value == 136 || this.value == 137 || this.value == 138) {
            //        $('#ManufactModel').css('visibility', 'visible');
            //        $('#ManufactModel').show();

            //        $('#crmWorkManu').prop('required', true);
            //        $('#crmWorkModel').prop('required', true);
            //        //$('#crmWorkModel').show();                    
            //    }
            //    else {
            //        $('#ManufactModel').css('visibility', 'hidden');
            //        $('#ManufactModel').hide();
            //        $('#crmWorkManu').prop('required', false);
            //        $('#crmWorkModel').prop('required', false);
            //        // $('#crmWorkModel').hide();
            //    }
            //});


            /******************************************** Getby ID ****************************************************/
            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    $.get("/api/CRMWorkorderTab/Get/" + primaryId)
            //      .done(function (result) {

            //          var getResult = JSON.parse(result);

            //          GetCRMWorkorderTabData(getResult)

            //          $('#myPleaseWait').modal('hide');
            //      })
            //     .fail(function () {
            //         $('#myPleaseWait').modal('hide');
            //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //         $('#errorMsg').css('visibility', 'visible');
            //     });
            //}
            //else {
            //    $('#myPleaseWait').modal('hide');
            //}
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });


    //****************************************** Save *********************************************

    $('#btnEdit,#btnSave,#btnSaveandAddNewEdit').click(function () {
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var WorkOrdNo = $('#crmWorkWorkOrdNo').val();
        var crmReqNo = $('#crmWorkReqNo').val();
        var crmReqId = $('#hdncrmWorkReqId').val();
        var workorderdate = $('#crmWorkWorkDat').val();
        var reqtyp = $('#crmWorkReqTyp').val();
        var Assetid = $('#hdncrmWorkAssetId').val();
        var AssetNo = $('#crmWorkAssetNo').val();
        var stfname = $('#crmWorkStfAss').val();
        var stfId = $('#hdncrmWorkStfAssId').val();
        var stfemail = $('#hdncrmWorkStfEmail').val();
        var stfMailSts = $('#hdncrmWorkMailSts').val();
        var workordSts = $('#crmWorkWrkOrdSts').val();
        var workorderdet = $('#crmWorkWrkOrdDet').val();
        //if (reqtyp == 136 || reqtyp == 137 || reqtyp == 138) {
        //    var Manuid = $('#hdncrmWorkManuId').val();
        //    var Modid = $('#hdncrmWorkModId').val();
        //}
        //else {
        //    var Manuid = null;
        //    var Modid = null;
        //}
        var Manuid = $('#hdncrmWorkManuId').val();
        var Modid = $('#hdncrmWorkModId').val();
        var timeStamp = $("#Timestamp").val();

        //var workorderdate = new Date($('#crmWorkWorkDat').val());

        var isFormValid = formInputValidation("crmworkorderPage", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //$('#btnEdit').attr('disabled', false);
            return false;
        }

        if (crmReqId == '') {
            $("div.errormsgcenter").text("Valid CRM Request No. is required.");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (stfId == '') {
            $("div.errormsgcenter").text("Valid Staff is required.");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            CRMWOId = primaryId;
            timeStamp = timeStamp;
        }
        else {
            CRMWOId = 0;
            timeStamp = "";
        }

        var WorkOrderData = {
            CRMRequestWOId: CRMWOId,
            CRMRequestWONo: WorkOrdNo,
            CRMRequestId: crmReqId,
            CRMWorkOrderDateTime: workorderdate,
            TypeOfRequestId: reqtyp,
            AssetId: Assetid,
            UserId: stfId,
            StaffEmail: stfemail,
            MailSts: stfMailSts,
            WorkOrderStatusId: workordSts,
            WorkorderDetails: workorderdet,
            ManufacturerId: Manuid,
            ModelId: Modid,
            Timestamp: timeStamp
        }

        var jqxhr = $.post("/api/CRMWorkorderTab/Save", WorkOrderData, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.CRMRequestWOId);
            GetCRMWorkorderTabData(result);
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.CRMRequestWOId != 0) {                
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
         
            }

            $(".content").scrollTop(0);
            showMessage('CRM Workorder', CURD_MESSAGE_STATUS.US);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
           // $("#grid").trigger('reloadGrid');
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNewEdit") {
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
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);

            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

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

    $(".nav-tabs > li:eq(1)").click(function () {
       // var primaryId = $('#primaryID').val();
        var stfAssid = $('#hdncrmWorkStfAssId').val();
        if (stfAssid == 0 || stfAssid == "" || stfAssid == null) {
            bootbox.alert("Work Order details must be saved before entering additional information");
            return false;
        }
    });


    $('.nospchar').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:(){}\[\];?<>\^\"\']/g, ''));
        }, 5);
    });
    $('.nospchar').on('keypress', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:(){}\[\];?<>\^\"\']/g, ''));
        }, 5);
    });


    // **** Query String to get ID Begin****\\\

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
        if (ID != null && ID != "0") {
            $.get("/api/CRMWorkorderTab/Get/" + ID)
              .done(function (result) {
                  var getResult = JSON.parse(result);                
                  WorkOrderStatusStringLoad = getResult.WorkOrderStatus;                  
                  LinkClicked(ID, WorkOrderStatusStringLoad);
              })
             .fail(function (response) {
                 $('#myPleaseWait').modal('hide');
                 $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                 $('#errorMsg').css('visibility', 'visible');
             });
        }
    }
    // **** Query String to get ID  End****\\\
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
function GetCRMWorkorderTabData(getResult) {
    if (getResult.WorkOrderStatusId == 139 || getResult.WorkOrderStatusId == 140 || getResult.WorkOrderStatusId == 251) {
        $('#crmWorkStfAss').prop("disabled", false);
        $('#crmWorkWrkOrdDet').prop("disabled", false);
    }
    if (getResult.WorkOrderStatusId != 142) {
        $('#AttachRowPlus').show();
        $('#btnEditAttachment').show();
    }
    var primaryId = $('#primaryID').val();
    $("#hdnAttachId").val(getResult.HiddenId);

    $('#hdncrmAssTabAssId').val(getResult.IsAssessFinished);

    $('#primaryID').val(getResult.CRMRequestWOId);
    $("#crmWorkWorkOrdNo").val(getResult.CRMRequestWONo);
    $("#crmWorkReqTypService").val(getResult.Service);
    $("#hdncrmWorkWorkOrdId").val(getResult.CRMRequestWOId);
    $("#crmWorkReqNo").val(getResult.RequestNo);
    $("#hdncrmWorkReqId").val(getResult.CRMRequestId);
    //$("#crmWorkWorkDat").val(DateFormatter(getResult.CRMWorkOrderDateTime));
    var a = moment.utc(getResult.CRMWorkOrderDateTime).toDate();
    $("#crmWorkWorkDat").val(moment(getResult.CRMWorkOrderDateTime).format("DD-MMM-YYYY HH:mm"));
    //if (getResult.IsReqTypeReferenced == 1) {
    //    $('#crmWorkReqTyp option[value="' + getResult.TypeOfRequestId + '"]').prop('selected', true);
    //    $("#crmWorkReqTyp").prop("disabled", true);
    //}
    //else if (getResult.IsReqTypeReferenced == 0) {
    //    $('#crmWorkReqTyp option[value="' + getResult.TypeOfRequestId + '"]').prop('selected', true);
    //    $("#crmWorkReqTyp").prop("disabled", false);
    //}
    $('#crmWorkReqTyp option[value="' + getResult.TypeOfRequestId + '"]').prop('selected', true);
        $("#crmWorkReqTyp").prop("disabled", true);
    $("#crmWorkAssetNo").val(getResult.AssetNo).prop("disabled", true);
    $("#hdncrmWorkAssetId").val(getResult.AssetId);
    $('#crmWorkStfAss').val(getResult.StaffName);
    $('#hdncrmWorkStfEmail').val(getResult.StaffEmail);
    $("#hdncrmWorkStfAssId").val(getResult.UserId);
    $("#hdncrmWorkMailSts").val(getResult.MailSts);   
    $('#crmWorkWrkOrdSts option[value="' + getResult.WorkOrderStatusId + '"]').prop('selected', true);
    $("#crmWorkWrkOrdDet").val(getResult.WorkorderDetails);
    $("#divWOStatus").text(getResult.WorkOrderStatus);


    //if (getResult.TypeOfRequestId == 136 || getResult.TypeOfRequestId == 137 || getResult.TypeOfRequestId == 138) {
    //    $('#ManufactModel').css('visibility', 'visible');
    //    $('#ManufactModel').show();
    //    $("#crmWorkManu").val(getResult.Manufacturer);
    //    $("#hdncrmWorkManuId").val(getResult.ManufacturerId);
    //    $("#crmWorkModel").val(getResult.Model);
    //    $("#hdncrmWorkModId").val(getResult.ModelId);
    //} else {
    //    $('#ManufactModel').css('visibility', 'hidden');
    //    $('#ManufactModel').hide();
    //}

    $("#crmWorkManu").val(getResult.Manufacturer).prop("disabled", true);
    $("#hdncrmWorkManuId").val(getResult.ManufacturerId);
    $("#crmWorkModel").val(getResult.Model).prop("disabled", true);
    $("#hdncrmWorkModId").val(getResult.ModelId);

    $("#hdncrmRequesterId").val(getResult.RequesterId);
    $("#hdncrmRequesterEmail").val(getResult.RequesterEmail);


    if (getResult.TypeOfRequestId == 134 || getResult.TypeOfRequestId == 138) {
        $('#CrmWrkAreaLocDiv').css('visibility', 'visible');
        $('#CrmWrkAreaLocDiv').show();
        $("#CrmWrkUsrAreaCd").val(getResult.UserAreaCode).prop("disabled", true);
        $("#hdnCrmWrkUsrAreaCdId").val(getResult.UserAreaId);
        $("#CrmWrkUsrAreaNam").val(getResult.UserAreaName).prop("disabled", true);
        $("#CrmWrkUsrLocCde").val(getResult.UserLocationCode).prop("disabled", true);
        $("#hdnCrmWrkUsrLocCdeId").val(getResult.UserLocationId);
        $("#CrmReqUsrLocNam").val(getResult.UserLocationName).prop("disabled", true);
    } else {
        $('#CrmWrkAreaLocDiv').css('visibility', 'hidden');
        $('#CrmWrkAreaLocDiv').hide();
    }

    $('#Timestamp').val(getResult.Timestamp);

    //if (getResult.WorkOrderStatusId == 141) {

    //}

    //if (getResult.WorkOrderStatusId == 143) {
    //    $("#AttachmentTab").click(function () {
    //        $(this).removeAttr("href");
    //        bootbox.alert("Cancelled Work Order cannot move into Attachment Tab");
    //        return false;
    //    });
    //}

    if (getResult.WorkOrderStatusId == 141) {
        $('#crmWorkStfAss').prop("disabled", true);
    }
    if (getResult.WorkOrderStatusId == 142 || getResult.WorkOrderStatusId == 143) {
        DisableFields();
        $('#btnSaveandAddNewEdit').hide();
        $('#btnDelete').hide();
    }

    if (getResult.WorkOrderStatusId == 142) {
        $('#AttachRowPlus').hide();
        $('#btnEditAttachment').hide();
        //var rowCount = $('#FileUploadTable tr:last').index();
        //for (i = 0; i <= rowCount; i++) {
        //    $('#FileTypeId_' + rowCount).prop("disabled", true);
        //}
    }
}


$('#AttachmentTab').click(function () {
    var status = $('#divWOStatus').text();    
    if (status.indexOf('Closed') != -1) {
        setTimeout(function () {
            $("#CommonAttachment :input").prop("disabled", true);
        }, 150)
    }
});
function loadWorkOrderTab()
{
    var primaryId = $('#primaryID').val();
    $.get("/api/CRMWorkorderTab/Get/" + primaryId)
                  .done(function (result) {

                      var getResult = JSON.parse(result);

                      GetCRMWorkorderTabData(getResult)

                      $('#myPleaseWait').modal('hide');
                  })
                 .fail(function () {
                     $('#myPleaseWait').modal('hide');
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                     $('#errorMsg').css('visibility', 'visible');
                 });
}
function FetchAsset(event) {
    var ItemMst = {
        SearchColumn: 'crmWorkAssetNo' + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-crmWorkAssetNo'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmWorkAssetId" + "-AssetId", 'crmWorkAssetNo' + '-AssetNo', 'crmWorkManu' + '-Manufacturer', 'hdncrmWorkManuId' + '-ManufacturerId', 'crmWorkModel' + '-Model', 'hdncrmWorkModId' + '-ModelId', ]//id of element - the model property
    };
    DisplayFetchResult('AssetFetch', ItemMst, "/api/Fetch/ParentAssetNoFetch", "Ulfetch", event, 1);
}

function FetchManufacturer(event) {
    var ItemMst = {
        SearchColumn: 'crmWorkManu' + '-Manufacturer',//Id of Fetch field
        ResultColumns: ["ManufacturerId" + "-Primary Key", 'Manufacturer' + '-crmWorkManu'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmWorkManuId" + "-ManufacturerId", 'crmWorkManu' + '-Manufacturer']//id of element - the model property
    };
    DisplayFetchResult('ManuFetch', ItemMst, "/api/Fetch/ManufacturerFetch", "Ulfetch1", event, 1);
}

function FetchModel(event) {
    var ItemMst = {
        SearchColumn: 'crmWorkModel' + '-Model',//Id of Fetch field
        ResultColumns: ["ModelId" + "-Primary Key", 'Model' + '-crmWorkModel'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmWorkModId" + "-ModelId", 'crmWorkModel' + '-Model']//id of element - the model property
    };
    DisplayFetchResult('ModelFetch', ItemMst, "/api/Fetch/ModelFetch", "Ulfetch2", event, 1);
}

function FetchStaff(event) {
    var ItemMst = {
        SearchColumn: 'crmWorkStfAss' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffId" + "-Primary Key", 'StaffName' + '-crmWorkStfAss'],//Columns to be displayed
        AdditionalConditions: ["TypeOfRequest-crmWorkReqTyp"],
        FieldsToBeFilled: ["hdncrmWorkStfAssId" + "-StaffId", 'crmWorkStfAss' + '-StaffName', 'hdncrmWorkStfEmail' + '-StaffEmail']//id of element - the model property
    };
   // DisplayFetchResult('StaffFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch3", event, 1);
    DisplayFetchResult('StaffFetch', ItemMst, "/api/Fetch/CRMWorkorderStaffFetch", "Ulfetch3", event, 1);
    
}

function FetchRequest(event) {
    var ItemMst = {
        SearchColumn: 'crmWorkReqNo' + '-RequestNo',//Id of Fetch field
        ResultColumns: ["CRMRequestId" + "-Primary Key", 'RequestNo' + '-crmWorkReqNo' ,'TypeOfRequest' + '-crmWorkReqTyp'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmWorkReqId" + "-CRMRequestId", 'crmWorkReqNo' + '-RequestNo' , 'crmWorkReqTyp' + '-TypeOfRequest']//id of element - the model property
    };
    DisplayFetchResult('RequestNoFetch', ItemMst, "/api/Fetch/CRMWorkorderRequestFetch", "Ulfetch4", event, 1);
}

function LinkClicked(id, rowData) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#crmworkorderPage :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#crmWorkAssetNo').prop("disabled", false);
    $('#crmWorkStfAss').prop("disabled", false);
    $('#crmWorkManu').prop("disabled", false);
    $('#crmWorkModel').prop("disabled", false);
    $('#crmWorkWrkOrdDet').prop("disabled", false);
    $('#crmWorkReqTyp').prop("disabled", false);
    var action = "";
    EmptyFields(true);
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission ) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
        $('#btnSaveandAddNewEdit').show();
        $('#btnEdit').show();
        $('#btnCancel').show();
    }

    if (action == 'View') {
        $("#formBemsLevel :input:not(:button)").prop("disabled", true);
    }
    else if (action != 'View' && (rowData.WorkOrderStatus == "Cancelled" || rowData.WorkOrderStatus == "Closed") || (rowData == "Cancelled" || rowData == "Closed"))
    {
        $('#btnEdit').hide();
        $('#btnSave').hide();
        $('#btnDelete').hide();
        //$('#btnSaveandAddNewEdit').hide();
        $('#btnSaveandAddNewEdit').hide();
        $('#btnCancel').show();
        $('#crmWorkStfAss').prop("disabled", true);
        $('#crmWorkStfAss').prop("disabled", true);

        
    }
    else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNewEdit').hide();
        $('#btnNextScreenSave').show();

        $('#btnDelete').show();
        $('#btnSaveandAddNewEdit').show();
        $('#btnCancel').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CRMWorkorderTab/Get/" + primaryId)
          .done(function (result) {

              var getResult = JSON.parse(result);

              GetCRMWorkorderTabData(getResult)

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
            $.get("/api/CRMWorkorderTab/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('CRM Work Order', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('CRM Work Order', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields(fromLink) {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
     $('.ui-tabs-hide').empty();  
    $('#crmWorkReqTyp').val("null");
    $('#hdncrmWorkStfAssId').val(""); 
    $('#CRMAssessmentPage').val("")
    $('#crmWorkAssetNo').prop('disabled', false);
    $('#crmWorkManu').prop('disabled', false);
    $('#crmWorkModel').prop('disabled', false);
    $("#crmWorkReqTyp").prop("disabled", false);
    $("#crmWorkAssetNo").prop("disabled", false);  
    $('#CrmWrkAreaLocDiv').css('visibility', 'hidden');
    $('#CrmWrkAreaLocDiv').hide();
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#btnCancel').hide();
    $('#btnSaveandAddNewEdit').hide();
    $('#crmWorkAssetNo').prop("disabled", true);
    $('#crmWorkStfAss').prop("disabled", true);
    $('#crmWorkManu').prop("disabled", true);
    $('#crmWorkModel').prop("disabled", true);
    $('#crmWorkWrkOrdDet').prop("disabled", true);
    $('#crmWorkReqTyp').prop("disabled", true);
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#crmWorkWrkOrdSts").val('');
    $("#divWOStatus").text('');
    if (fromLink == undefined) {
        $("#grid").trigger('reloadGrid');
    }
    $("#crmworkorderPage :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#CRMWorkAssFeedback').prop("disabled", false);
    $('#CRMWorkAssStartdatTime').prop("disabled", false);
    $('#CRMWorkAssEnddatTime').prop("disabled", false);
    $('#btnEditAssm').show();

    $('#CRMWorkCompInfoSrtDat').prop("disabled", false);
    $('#CRMWorkCompInfoEndDat').prop("disabled", false);
    $('#CRMWorkCompInfoCompBy').prop("disabled", false);
    $('#CRMWorkCompInfoCompRem').prop("disabled", false);
    $('#CRMWorkCompInfoHanOvrDat').prop("disabled", false);
    $('#btnEditComp').show();
    $('#CRMWorkCompInfoAccBy').prop('required', false);
    $('#CRMWorkCompInfoRem').prop('required', false);
    $("#AcceptedBy").html("Accepted By");
    $("#lblCRMWorkCompInfoClorem").html("Closing Remarks");
    $('#hdncrmCompTabCompInfoId').val('');
    
}


