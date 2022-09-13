//var ARPID = 0;
var ListModel = [];


$(document).ready(function () {
    $('#Draft').hide();
    $('#Submitted').hide();
    formInputValidation("frmPROPOSAL");
    $("#1stProposal").val();
    $("#primaryID").val();
    $(".Submit").hide();
    $('#btnClarify').hide();
    $('#btnVerify').hide();
    $('#btnApprove').hide();
    $('#btnApproveMoreinfo').hide();
    $('#btApproveForward').hide();
    $('#btnReject').hide();
    $('#btnRecommend').hide();
    $('#btnRecommendMoreInfo').hide();
    $('#btnDelete').hide();
    $('#RejectedBER').attr('disabled', true);
    //$('#txtSelectProposal').attr('disabled', true);
    //$('#txtJustification').attr('disabled', true);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
    var hasVerifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasRejectPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Reject'");
    var hasRecommendPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Recommend'");
    var hasClarifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Clarify'");

    var primaryID = $('#primaryID').val();

    $('#rejectedBERDiv,#ApprovedBERDiv').show();
    var actionType = $('#ActionType').val();
    if (hasApprovePermission || hasRejectPermission || hasVerifyPermission || hasRecommendPermission) {
        DisableFormFields();
        $('#btnSaveandAddNew,#spnPopup-compStaff').hide();
        $('#AssetNoDiv,#companypopup').hide();
        $('#Remarks').attr('disabled', true);
    }
    else {
        $('#btnCancel').show();
        $('#btnCancelBER2').show();
        $('#btnAdditionalInfoCancel1').show();
        $('#btnSaveandAddNew').show();
    }
    $('#myPleaseWait').modal('show');
    //formInputValidation("beroneformid");


    $.get("/api/Arp/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            //$("#1stProposal").val(loadResult.ArpId);
            $('#myPleaseWait').modal('hide');

            $('#Draft').hide();
            $('#Submitted').hide();

            $.each(loadResult.BER1StatusLovs, function (index, value) {
                $('#BER1status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $.each(loadResult.SelectProposal, function (index, value) {
                $('#BER1status').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            if (primaryID == "0" || primaryID == 0) {
                $('#BERActionStatus').val(202);
                $('#BER1status').val(202); // New


            }
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    $("#btnCancel").click(function () {
        //debugger;
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                clearInputFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
    $("#btnProposalCancel").click(function () {
        //debugger;
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                clearInputFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {

        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $('#errorMsgPurchase').css('visibility', 'hidden');
        //$("#top-notificationspopup").modal('show');
        //$('#msg5').removeClass("fa fa-times"); //SUCCESS
        //$('#msg5').addClass("fa fa-check");
        //$('#hdr5').html("Data saved successfully");
        //setTimeout(function () {
        //    $("#top-notificationspopup").modal('hide');
        //}, 4000);


        var isFormValid = formInputValidation("frmArp", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var timeStamp = $("#Timestamp").val();
        var arpid = $("#1stProposal").val();
        var primaryID = $("#primaryID").val();
        //if (primaryID != null) {
        //    MstArp.ARPID;
        //    MstArp.Timestamp = timeStamp;
        //}
        //else {

        //}


        var BERApplicationDate = $('#txtApplicationDate').val();
        var MstArp = {
            ARPID: primaryID,
            AssetId: $('#hdnAssetId').val(),
            UserAreaId: $('#hdnAreaId').val(),
            UserLocationId: $('#hdnLocationId').val(),
            BERno: $('#txtARPBerNo').val(),
            BERApplicationDate: $('#txtApplicationDate').val(),
            ConditionAppraisalRefNo: $('#txtARPConditionAppraisalReferenceNo').val(),
            AssetNo: $('#txtAssetNo').val(),
            AssetName: $('#ARPAssetName').val(),
            AssetTypeCode: $('#AssetTypecode').val(),
            AssetTypeDescription: $('#assetTypeDescription').val(),
            AssetTypeCodeId: $('#hdnAssetTypecodeId').val(),
            AreaName: $('#ARPAreaName').val(),
            LocationName: $('#UserLocationName').val(),
            ItemNo: $('#txtARPItemNo').val(),
            Quantity: $('#ARPQuantity').val(),
            PurchaseCostRM: $('#PurchaseCost').val(),
            PurchaseDate: $('#PurchaseDate').val(),
            BatchNo: $('#txtARPBatchNo').val(),
            PackageCode: $('#txtARPPackageCode').val(),
            BERRemarks: $('#txARPBerRemarks').val(),

            PROP_ID1: 1,
            PROP_ID2: 2,
            PROP_ID3: 3,
            Model1: $('#txtmodel1').val(),
            Model2: $('#txtmodel2').val(),
            Model3: $('#txtmodel3').val(),
            Brand1: $('#txtBrand1').val(),
            Brand2: $('#txtBrand2').val(),
            Brand3: $('#txtBrand3').val(),
            Manufacture1: $('#txtManufacture1').val(),
            Manufacture2: $('#txtManufacture2').val(),
            Manufacture3: $('#txtManufacture3').val(),
            EstimationPrice1: $('#txtEstimationPrice1').val(),
            EstimationPrice2: $('#txtEstimationPrice2').val(),
            EstimationPrice3: $('#txtEstimationPrice3').val(),
            SupplierName1: $('#txtSupplierName1').val(),
            SupplierName2: $('#txtSupplierName2').val(),
            SupplierName3: $('#txtSupplierName3').val(),
            ContactNo1: $('#txtContactNo1').val(),
            ContactNo2: $('#txtContactNo2').val(),
            ContactNo3: $('#txtContactNo3').val()
        };


        var jqxhr = $.post("/api/Arp/Save", MstArp, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.ARPID);
            $("#Timestamp").val(result.Timestamp);

            $('#hdnStatus').val(result.Active);
            BindEquipmentData(result);
            $('#Draft').show();
            $('#Draft').prop('visible', true);
            $("#grid").trigger('reloadGrid');
            $('#btnEdit').show();
            $('#btnSubmit').show();
            $('#txtSelectProposal').attr('disabled', false);
            $('#txtJustification').attr('disabled', false);
            if (result.ARPID != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#blockCode').prop('disabled', true);
                $('#btnNextScreenSave').show();

                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $('#errorMsgPurchase').css('visibility', 'hidden');
            $("#top-notificationspopup").modal('show');
            $('#msg5').removeClass("fa fa-times"); //SUCCESS
            $('#msg5').addClass("fa fa-check");
            $('#hdr5').html("Data saved successfully");
            setTimeout(function () {
                $("#top-notificationspopup").modal('hide');
            }, 1000);
            //showMessage('Purchase Request', CURD_MESSAGE_STATUS.SS);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            //$("#grid").trigger('reloadGrid');
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
                $('#myPleaseWait').modal('hide');
            });
        // }
    });

    $(".Submit").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var timeStamp = $("#Timestamp").val();
        var MstSubmit = {
            ARPID: $("#1stProposal").val(),
            BERno: $('#txtARPBerNo').val(),
            BERApplicationDate: $('#ApplicationDate').val(),
            SelectedProposal: $('#txtSelectProposal').val(),
            Justification: $('#txtJustification').val()
        };

        var primaryID = $("#primaryID").val();
        if (primaryID != null) {
            MstSubmit.ARPID;
            MstSubmit.Timestamp = timeStamp;
        }
        else {
            MstSubmit.ARPID = 0;
            MstSubmit.Timestamp = "";
        }


        var jqxhr = $.post("/api/Arp/Submit", MstSubmit, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.ARPID);
            $("#Timestamp").val(result.Timestamp);
            $('#hdnStatus').val(result.Active);

            $("#grid").trigger('reloadGrid');
            if (result.ArpId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#blockCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                //$('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Arp', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            $('#msg5').removeClass("fa fa-times"); //SUCCESS
            $('#msg5').addClass("fa fa-check");
            $('#hdr5').html("Data saved successfully");
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            //$("#grid").trigger('reloadGrid');
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
                $('#myPleaseWait').modal('hide');
            });
        // }
    });

    var typeCodeFetchObj = {
        SearchColumn: 'txtARPBerNo-BERno',
        ResultColumns: ["BERno-Primary Key", 'BERno', 'AssetNo-AssetNo', 'AssetName-AssetName', 'BatchNo-BatchNo',
            'ApplicationDate-ApplicationDate', 'AssetTypeCode-AssetTypeCode', 'AssetId-AssetId',
            'AssetDescription-AssetDescription', 'UserAreaName-UserAreaName',
            'UserLocationName-UserLocationName', 'ItemCode-ItemCode', 'BER1Remarks-BER1Remarks',
            'PurchaseCostRM-PurchaseCostRM', 'PurchaseDate-PurchaseDate', 'UserAreaId-UserAreaId',
            'UserLocationId-UserLocationId', 'AssetTypeCodeId-AssetTypeCodeId', 'Package_Code-Package_Code'],
        AdditionalConditions: ["CheckEquipmentFunctionDescription-hdnCheckEquipmentFunctionDescription"],
        FieldsToBeFilled: ["hdnRejectedBERReferenceId-ApplicationId", "txtARPBerNo-BERno",
            "txtApplicationDate-ApplicationDate", "txtAssetNo-AssetNo", "hdnAssetId-AssetId",
            "ARPAssetName-AssetName", "AssetTypecode-AssetTypeCode",
            "assetTypeDescription-AssetDescription", "ARPAreaName-UserAreaName",
            "txtARPBatchNo-BatchNo", "UserLocationName-UserLocationName", "txtARPItemNo-ItemCode",
            "txARPBerRemarks-BER1Remarks", "PurchaseCost-PurchaseCostRM", "hdnAreaId-UserAreaId",
            "hdnLocationId-UserLocationId", "PurchaseDate-PurchaseDate", "hdnAssetTypecodeId-AssetTypeCodeId", "ARPPackageCode-Package_Code"]
    };

    $('#txtARPBerNo').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch1', typeCodeFetchObj, "/api/Fetch/ArpBerNo", "UlFetch2", event, 1);
    });




    $("#btnProposalSave, #btnProposalSaveandAddNew").click(function () {
        debugger;
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $('#errorMsgPurchase').css('visibility', 'hidden');
        var currentbutton = (this.id);
       
        // $("#txtmodel1").prop('required', true);
        $('#txtmodel1').attr('required', true);
        $('#txtBrand1').attr('required', true);
        $('#txtManufacture1').attr('required', true);
        $('#txtEstimationPrice1').attr('required', true);
        $('#txtSupplierName1').attr('required', true);
        $('#txtContactNo1').attr('required', true);

        $('#txtmodel2').attr('required', true);
        $('#txtBrand2').attr('required', true);
        $('#txtManufacture2').attr('required', true);
        $('#txtEstimationPrice2').attr('required', true);
        $('#txtSupplierName2').attr('required', true);
        $('#txtContactNo2').attr('required', true);

        $('#txtmodel3').attr('required', true);
        $('#txtBrand3').attr('required', true);
        $('#txtManufacture3').attr('required', true);
        $('#txtEstimationPrice3').attr('required', true);
        $('#txtSupplierName3').attr('required', true);
        $('#txtContactNo3').attr('required', true);
        debugger;

        //formInputValidation("frmPROPOSAL");
        var isFormValid = formInputValidation("frmPROPOSAL", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg2').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        //$("div.errormsgcenter").text("");
        //$('#btnlogin').attr('disabled', true);
        //$('#myPleaseWait').modal('show');
        //$("div.errormsgcenter").text("");
        //$('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("ARPID");
        var timeStamp = $("#Timestamp").val();

        var primaryID = $("#primaryID").val();
        var MstProposal = {
            ARPID: primaryID,
            BERno: $('#txtARPBerNo').val(),
            BERApplicationDate: $('#ApplicationDate').val(),
            ConditionAppraisalRefNo: $('#txtARPConditionAppraisalReferenceNo').val(),
            AssetNo: $('#txtAssetNo').val(),
            AssetTypeCode: $('#assetDescription').val(),
            BERRemarks: $('#txARPBerRemarks').val(),
            PROP_ID1: 1,
            PROP_ID2: 2,
            PROP_ID3: 3,
            Model1: $('#txtmodel1').val(),
            Model2: $('#txtmodel2').val(),
            Model3: $('#txtmodel3').val(),
            Brand1: $('#txtBrand1').val(),
            Brand2: $('#txtBrand2').val(),
            Brand3: $('#txtBrand3').val(),
            Manufacture1: $('#txtManufacture1').val(),
            Manufacture2: $('#txtManufacture2').val(),
            Manufacture3: $('#txtManufacture3').val(),
            EstimationPrice1: $('#txtEstimationPrice1').val(),
            EstimationPrice2: $('#txtEstimationPrice2').val(),
            EstimationPrice3: $('#txtEstimationPrice3').val(),
            SupplierName1: $('#txtSupplierName1').val(),
            SupplierName2: $('#txtSupplierName2').val(),
            SupplierName3: $('#txtSupplierName3').val(),
            ContactNo1: $('#txtContactNo1').val(),
            ContactNo2: $('#txtContactNo2').val(),
            ContactNo3: $('#txtContactNo3').val(),

            SelectedProposal: $('#txtSelectProposal').val(),
            Justification: $('#txtJustification').val()

        };
        var jqxhr = $.post("/api/Arp/ProposalSave", MstProposal, function (response) {
            var result = JSON.parse(response);
            // var htmlval = ""; $('#tablebody').empty();
            
            if (currentbutton = "btnProposalSaveandAddNew") {

              
            }
            $("#primaryID").val(result.ARPID);
            $("#Timestamp").val(result.Timestamp);

            $('#hdnStatus').val(result.Active);

            $("#grid").trigger('reloadGrid');
            debugger;
            var Submissionresult = result.Status;
            if (Submissionresult = "Submitted") {
                $("#Submitted").show();
                $('#Draft').hide();
            }
            else if (Submissionresult = "Draft") {
                $("#Submitted").hide();
                $('#Draft').show();
            }
            if (result.ArpId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#btnProposalNextScreenSave').show();
                //$('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Arp', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            $('#msg5').removeClass("fa fa-times"); //SUCCESS
            $('#msg5').addClass("fa fa-check");
            $('#hdr5').html("Data saved successfully");
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnProposalSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            //$("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnProposalSaveandAddNew") {
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

                $('#btnProposalSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        // }
    });



    $("#hdnRejectedBERReferenceId").change(function () {
        clearInputFields();
        $('#StillwithInLifeSpan').val("");
        $('#CurrentValue').val("");
        var ApplicationId = $('#hdnRejectedBERReferenceId').val();
        if (ApplicationId != null && ApplicationId != "0" && ApplicationId != "") {
            $.get("/api/BerOne/ArpGet/" + ApplicationId)

                .done(function (result) {
                    var getResult = JSON.parse(result);

                    BindEquipmentData(getResult);
                    //BindBER1HeaderDate(getResult, 2);
                    // $('#divArpCStatus').hide();
                    $('#myPleaseWait').modal('hide');
                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
    });

    function clearInputFields() {
        $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
        $('#txtAssetNo').val("");
        $('#assetDescription').val("");
        $('#ARPAssetName').val("");
        $('#hdnAssetId').val('null');
        $('#UserLocationCode').val("");
        $('#UserLocationName').val("");
        $('#Manufacturer').val("");
        $('#Model').val("");
        $('#SupplierName').val("");
        $('#PurchaseCost').val("");
        $('#PurchaseDate').val("");
        $('#txtApplicationDate').val("");
        $('#AssetTypecode').val("");
        $('#txtARPItemNo').val("");
        $('#txtARPBatchNo').val("");
        $('#txARPBerRemarks').val("");
        $('#txtmodel1').val("");



        // $('#txtApplicationDate').prop("disabled", false);

        $('#txtARPBerNo').val("");
        $('#ApplicationDate').val("");



        $('#hdnCompanyStaffId').val("");
        $('#txtARPConditionAppraisalReferenceNo').val("");
        $('#assetTypeDescription').val("");
        $('#ARPAreaName').val("");
        $('#ARPItemNo').val("");
        $('#ARPQuantity').val("");
        $('#ARPBatchNo').val("");
        $('#ARPPackageCode').val("");

        $('#txtmodel1').val("");
        $('#txtmodel2').val("");
        $('#txtmodel3').val("");
        $('#txtBrand1').val("");
        $('#txtBrand2').val("");
        $('#txtBrand3').val("");
        $('#txtManufacture1').val("");
        $('#txtManufacture2').val("");
        $('#txtManufacture3').val("");
        $('#txtEstimationPrice1').val("");
        $('#txtEstimationPrice2').val("");
        $('#txtEstimationPrice3').val("");
        $('#txtSupplierName1').val("");
        $('#txtSupplierName2').val("");
        $('#txtSupplierName3').val("");
        $('#txtContactNo1').val("");
        $('#txtContactNo2').val("");
        $('#txtContactNo3').val("");

        $('#txtSelectProposal').val("Select");
        $('#txtJustification').val("");
        $("#Draft").hide();
        $('#Submitted').hide();

    }

    function DisplayError() {
        $('#errorMsg').css('visibility', 'visible');
        $('#myPleaseWait').modal('hide');
        //$('#btnSave').attr('disabled', false);
    }

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


// first header data 
function BindEquipmentData(getResult) {
    $('#txtARPBerNo').val(getResult.BERno);
    $('#ARPAssetName').val(getResult.AssetName);
    $('#hdnAssetId').val(getResult.AssetId);
    $('#AssetTypecode').val(getResult.AssetTypeCode);
    $('#ARPAssetName').val(getResult.AssetName);
    $('#txtAssetNo').val(getResult.AssetNo);
    $('#UserLocationCode').val(getResult.UserLocationCode);
    $('#UserLocationName').val(getResult.UserLocationName);
    $('#1stProposal').val(getResult.ARPID);
    $('#txtmodel1').val(getResult.Model1);
    $('#txtBrand1').val(getResult.Brand1);
    $('#txtManufacture1').val(getResult.Manufacture1);
    $('#txtEstimationPrice1').val(getResult.EstimationPrice1);
    $('#txtSupplierName1').val(getResult.SupplierName1);
    $('#txtContactNo1').val(getResult.ContactNo1);
    $('#ApplicationDate').val(getResult.ApplicationDate);

    $('#txtmodel2').val(getResult.Model2);
    $('#txtBrand2').val(getResult.Brand2);
    $('#txtManufacture2').val(getResult.Manufacture2);
    $('#txtEstimationPrice2').val(getResult.EstimationPrice2);
    $('#txtSupplierName2').val(getResult.SupplierName2);
    $('#txtContactNo2').val(getResult.ContactNo2);
    $('#txtmodel3').val(getResult.Model3);
    $('#txtBrand3').val(getResult.Brand3);
    $('#txtManufacture3').val(getResult.Manufacture3);
    $('#txtEstimationPrice3').val(getResult.EstimationPrice3);
    $('#txtSupplierName3').val(getResult.SupplierName3);
    $('#txtContactNo3').val(getResult.ContactNo3);
    $('#BIL').val(getResult.BIL);
    $('#txtARPConditionAppraisalReferenceNo').val(getResult.ConditionAppraisalRefNo);
    $('#assetTypeDescription').val(getResult.AssetTypeDescription);
    $('#ARPAreaName').val(getResult.UserAreaName);
    $('#txtARPItemNo').val(getResult.ItemNo);
    $('#ARPQuantity').val(getResult.Quantity);
    $('#txtARPBatchNo').val(getResult.BatchNo);
    $('#ARPPackageCode').val(getResult.PackageCode);
    $('#txARPBerRemarks').val(getResult.BERRemarks);
    $('#txtApplicationDate').val(moment(getResult.ApplicationDate).format("DD-MMM-YYYY")).prop("disabled", true);
    $("#primaryID").val(getResult.ARPID);
    
    //$.each(getResult.Status, function (index, value) {
    //    $('#BIL').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    //});
    
    //else if (result = "Subimitted") {
    //    $("#Draft").hide();
    //    $('#Submitted').show();
    //}


    // $("#divArpCStatus").show();



    if (getResult.PurchaseCost != null) {
        $('#PurchaseCost').val(addCommas(getResult.PurchaseCost));
    }
    else {
        $('#PurchaseCost').val(getResult.PurchaseCost);
    }
    $('#PurchaseDate').val(DateFormatter(getResult.PurchaseDate));
    $('#hdnAttachId').val(getResult.HiddenId);
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
            $.get("/api/BerOne/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('BER2', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFieldsBER2();
                })
                .fail(function () {
                    showMessage('BER2', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

//newly added code 

window.DisableFormFields = function () {
    $("#beroneformid :input:not(:button)").prop("disabled", false);
    $("#bertwoformid :input:not(:button)").prop("disabled", true);

}


window.DisableButtons = function () {
    var berstatus = $('#BERActionStatus').val();
    var primaryID = $('#primaryID').val();
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");

}

window.BindValuesOnClickingTab = function () {
    $('#berNord').val($('#berNo').val());
    $('#ApplicationDaterd').val($('#ApplicationDate').val());
    $('#txtAssetNord').val($('#txtAssetNo').val());
    $('#assetDescriptionrd').val($('#assetDescription').val());
    $('#ARPAssetNamerd').val($('#ARPAssetName').val());
    $('#UserLocationCoderd').val($('#UserLocationCode').val());
    $('#UserLocationNamerd').val($('#UserLocationName').val());
    $('#Modelrd').val($('#Model').val());
    $('#Manufacturerrd').val($('#Manufacturer').val());
    $('#ApplicantNameBER').val($('#ApplicantName').val());
    $('#ApplicantNamerd').val($('#ApplicantName').val());
    $('#ApplicantDesignationrd').val($('#ApplicantDesignation').val());
    $('#AssetAgerd').val($('#AssetAge').val());
    $('#BER2status').val($('#BER1status').val());

    $('#ARPAreaName').val($('#ARPAreaName').val());
    $('#ARPItemNo').val($('#ARPItemNo').val());
    $('#ARPQuantity').val($('#ARPQuantity').val());
    $('#ARPBatchNo').val($('#ARPBatchNo').val());
    $('#ARPPackageCode').val($('#ARPPackageCode').val());

}
function LinkClicked(ARPID) {
    debugger
    $('.nav-tabs a:first').tab('show');
    $(".content").scrollTop(1);
    $("#beroneformid :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $("div.errormsgcenter1").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#errorMsg1').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(ARPID);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");
    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    var hasverifyPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
    if (hasEditPermission) {
        action = "Edit";
    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#beroneformid :input:not(:button)").prop("disabled", true);
    } else {

        //$('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }

    var primaryID = $('#primaryID').val();

    if (primaryID != null && primaryID != "0") {
        //debugger
        $.get("/api/Arp/Get/" + primaryID)
            .done(function (result) {
                debugger;
                var getResult = JSON.parse(result);

                BindEquipmentData(getResult);
                var result = getResult.Status;
                var ProposalStatus = getResult.ProposalStatus;
                if (ProposalStatus == 203) {
                    $("#Draft").hide();
                    $('#Submitted').show();
                }
                else if (result = "Draft") {
                    $("#Draft").show();
                    $('#Submitted').hide();
                }

                //BindBER1HeaderDate(getResult, 1);
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

///////////***********print tab *****/

function printDiv(divName) {
    generatePDF();
}


$('#cmd2').click(function () {
    var options = {

    };
    var pdf = new jspdf('p', 'pt', 'a4');
    pdf.addhtml($("#content2"), -1, 220, options, function () {
        pdf.save('admit_card.pdf');
    });
});
$('#downloadPDF').click(function () {
    generatePDF();
});

function generatePDF() {
    // Choose the element that our invoice is rendered in.
    const element = document.getElementById("divCommonHistory11");
    // Choose the element and save the PDF for our user.
    html2pdf().from(element).save();
}
///////////*********** end print tab ********////