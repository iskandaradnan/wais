var statusdrodown = "";
var rowNum = 1;

var FileTypeValues = "";
var filePrefix = "DWR_";
var ScreenName = "DailyWeighingRecord";


$(document).ready(function () {
    //****************************************** Changing dropdown values *********************************************//
    $.get("/api/DailyWeighingRecord/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);

            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                statusdrodown += "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>";
            }
            $("#ddlStatus").append(statusdrodown);


            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "DWR" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    //****************************************** AutoPopulate BinNo ****************************************** // 


    $(body).on('input propertychange paste keyup', '.clsBinNo', function (event) {

        var controlld = event.target.id;
        var id = controlld.slice(8, 10);

        var BinNoCodeFetchObj = {
            SearchColumn: 'txtBinNo' + id + '-BinNo',//Id of Fetch field
            ResultColumns: ['BinNoId-Primary Key', 'BinNo-BinNo'],
            FieldsToBeFilled: ['hdnBinNoId' + id + '-BinNoId', 'txtBinNo' + id + '-BinNo']
        };

        DisplayFetchResult('divBinNo' + id, BinNoCodeFetchObj, "/api/DailyWeighingRecord/BinNoCodeFetch", 'UlFetch' + id, event, 1);//1 -- pageIndex
    });

    // Enter keyword and search function populates the names of the hospital staff matching the keyword//

    var CompanyStaffFetchObj = {
        SearchColumn: 'txtHRepresentative-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name'],//Columns to be displayed
        FieldsToBeFilled: ["hdnHospitalStaffId-StaffMasterId", "txtHRepresentative-StaffName"]//id of element - the model property
    };
    $('#txtHRepresentative').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch4', CompanyStaffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch4", event, 1);//1 -- pageIndex
    });

    /***************** Auto Generated Code******************************************************/
    AutoGen();

    /******************************************* Save *****************************************/
    $("#btnSave, #btnSaveandAddNew").click(function () {

        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formDailyWeighingRecord", 'save');

        if (!isFormValid) {

            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
        var arr = [];
        var isDuplicate = 0;
        $("[id^=txtBinNo]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicate += 1;
            }
        });

        if (isDuplicate > 0) {
            $("div.errormsgcenter").text('Duplicate bin numbers');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val()
        }

        var obj = {
            DWRID : primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,
            DWRNo: $('#txtDwrNo').val(),
            TotalWeight: $('#txtTWeight').val(),
            Date: $('#txtDate').val(),
            TotalBags: $('#txtTotalBags').val(),
            TotalNoofBins: $('#txtNoofBins').val(),
            HospitalRepresentative: $('#txtHRepresentative').val(),
            ConsignmentNo: $('#txtConsignmentNo').val(),
            Status: $('#ddlStatus').val(),
            dailyWeighingRecordsList: []

        }

        $("#tbodyDWR  tr").each(function () {
            var DWRObj = {};
            DWRObj.BinDetailsId = $(this).find("[id^=hdnBinNumId]")[0].value;
            DWRObj.BinNo = $(this).find("[id^=txtBinNo]")[0].value;
            DWRObj.Weight = $(this).find("[id^=txtWeight]")[0].value;
            DWRObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");

            obj.dailyWeighingRecordsList.push(DWRObj);

        });


        $.post("/Api/DailyWeighingRecord/Save", obj, function (response) {

            var result = JSON.parse(response);
            showMessage('DailyWeighingRecord', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.DWRID);
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                $('#DWRLabel').hide();                
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

    //****************************************** Cancel *********************************************
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
                    AutoGen();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });
    //  ********** It is calculated from the sum of all the weight entered in the gridview.***************

    $(".clsWeight").click(function () {

        sumOfColumns('.clsWeight');
    });

    function sumOfColumns() {
        $('.clsWeight').keyup(function () {
            var sum = 0;
            $('.clsWeight').each(function () {
                sum += Number($(this).val());
            });
            $('#txtTWeight').val(sum);
        });
    }
    //********************************************* adding Bin Numbers While Adding Rows //
        var n = $("#tbodyDWR tr").length;
        $('#txtNoofBins').val(n);
   
    //******************* Add Multiple Values*************//

        $("#addDWR").click(function () {

            rowNum += 1;
            addDWR(rowNum);

            var n1 = $("#tableDwrdetails").find("tbody tr").length;
            $('#txtNoofBins').val(n1);

            //Weight('txtWeight' + rowNum);            

        //********************* Functionlaties in table while adding Rows **************//

            $("#tableDwrdetails tbody tr").click(function () {

                 var id = this.rowIndex - 1;
                 $('#txtBinNo' + id).on('change', function () {
                     $('#formDailyWeighingRecord #BinError').removeClass('has-error');
                     $('#errorMsg').css('visibility', 'hidden');
                 });
                 $('#txtWeight' + id).on('change', function () {
                     $('#formDailyWeighingRecord #WeightError').removeClass('has-error');
                     $('#errorMsg').css('visibility', 'hidden');
                });
            });
    });

    $("body").on('input', '.clsWeight', function () {
        getTotalWeight();
    });
    
    
    /********************************************* Rows delete functionalities**********/

   $("#deleteDWRNo").click(function () {
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
                            $("#tbodyDWR tr").find('input[name="isDelete"]').each(function () {
                                if ($(this).is(":checked")) {
                                    if ($(this).closest("tr").find("[id^=hdnBinNumId]").val() == 0) {
                                        $(this).closest("tr").remove();
                                        getTotalWeight();
                                    }
                                }
                            });
                            $('#txtNoofBins').val($("#tableDwrdetails").find("tbody tr").length);
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
        var n2 = $("#tableDwrdetails").find("tbody tr").length;
        $('#txtNoofBins').val(n2);

        $('#txtDate').on('change', function () {

            $('#date').removeClass('has-error');
            $('#errorMsg').css('visibility', 'hidden');
        });
        $('#txtTotalBags').on('change', function () {

            $('#tbags').removeClass('has-error');
            $('#errorMsg').css('visibility', 'hidden');
        });
        $('#txtHRepresentative').on('change', function () {

            $('#hospital').removeClass('has-error');
            $('#errorMsg').css('visibility', 'hidden');
        });
        $('#txtBinNo1').on('change', function () {

            $('#formDailyWeighingRecord #bin').removeClass('has-error');
            $('#errorMsg').css('visibility', 'hidden');
        });
        $('#txtWeight1').on('change', function () {

            $('#formDailyWeighingRecord #weight').removeClass('has-error');
            $('#errorMsg').css('visibility', 'hidden');
        });

         //********************************* Get By ID ************************************//

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

    function EmptyFields() {

        $("#primaryID").val('0');
        $('[id^=hdnBinNumId]').val(0);

        $('#formDailyWeighingRecord #txtDate').val('');
        $('#formDailyWeighingRecord #txtTotalBags').val('');
        $('#formDailyWeighingRecord #txtHRepresentative').val('');
        $('#formDailyWeighingRecord #txtTWeight').val('');
        $('#formDailyWeighingRecord #txtNoofBins').val(1);
        $('#formDailyWeighingRecord #txtBinNo1').val('');
        $('#formDailyWeighingRecord #txtWeight1').val('');

        $('#date').removeClass('has-error');
        $('#tbags').removeClass('has-error');
        $('#hospital').removeClass('has-error');
        $('#formDailyWeighingRecord #BinError').removeClass('has-error');
        $('#formDailyWeighingRecord #WeightError').removeClass('has-error');
        $('#bin').removeClass('has-error');
        $('#weight').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');

        var i = 1;
        rowNum = 1;
        $("#tbodyDWR").find('tr').each(function () {
            if (i > 1) {
                $(this).remove();
            }
            i += 1;
        });
    }
    function LinkClicked(id) {
        $(".content").scrollTop(1);
        $('.nav-tabs a:first').tab('show');
        $("#formDailyWeighingRecord :input:not(:button)").parent().removeClass('has-error');
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
            $("#formDailyWeighingRecord :input:not(:button)").prop("disabled", true);
        } else {
            $('#btnEdit').show();
            //$('#btnSave').hide();
            //$('#btnSaveandAddNew').hide();
            $('#btnNextScreenSave').show();
        }
        $('#spnActionType').text(action);

        var primaryId = $('#primaryID').val();

        if (primaryId != null && primaryId != "0") {
            $.get("/api/DailyWeighingRecord/Get/" + primaryId)
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

    function addDWR(num) {
        var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete">  <input type="hidden" id="hdnBinNumId' + num + '" value="0" /></td>';
        var BinNo = '<td id="BinError"><input type="text" required class="form-control clsBinNo" placeholder="Please Select" id="txtBinNo' + num + '" placeholder="Please  autocomplete="off" name="BinNo" maxlength="25"  >   <input type = "hidden" id="hdnBinNoId' + num + '" /> ' + ' <div class="col-sm-12" style="position:relative;" id="divBinNo' + num + '"></div></td>';
        var Weight = '<td><input type="text" required class="form-control clsWeight" id="txtWeight' + num + '" autocomplete="off" name="Weight" maxlength="25"  /></td>';
        $("#tbodyDWR").append('<tr class="table_row">' + CheckBox + BinNo + Weight + '</tr>');
    }

    function fillDetails(result) {

        if (result != undefined) {

            $("#primaryID").val(result.DWRId)
            $('#txtDwrNo').val(result.DWRNo);
            $('#txtTWeight').val(result.TotalWeight);

            var Date = getCustomDate(result.Date);
            $('#txtDate').val(Date);

            $('#txtTotalBags').val(result.TotalBags);
            $('#txtNoofBins').val(result.TotalNoofBins);
            $('#txtHRepresentative').val(result.HospitalRepresentative);
            $('#txtConsignmentNo').val(result.ConsignmentNo);
            $('#ddlStatus').val(result.Status);

            $('#DWRLabel').html(" ");


            rowNum = 1;
            $("#tbodyDWR").html('');

            $("#txtNoofBins").val(0);
            if (result.dailyWeighingRecordsList != null) {

                $("#txtNoofBins").val(result.dailyWeighingRecordsList.length);
                for (var i = 0; i < result.dailyWeighingRecordsList.length; i++) {

                    addDWR(rowNum);

                    $('#hdnBinNumId' + rowNum).val(result.dailyWeighingRecordsList[i].BinDetailsId);
                    $('#txtBinNo' + + rowNum).val(result.dailyWeighingRecordsList[i].BinNo);
                    $('#txtWeight' + rowNum).val(result.dailyWeighingRecordsList[i].Weight);

                    rowNum += 1;
                }
            }
            else {
                addDWR(rowNum);
            }

            fillAttachment(result.AttachmentList);

            getTotalWeight();
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

    function getCustomDate(date) {

        if (date == '' || date == null) {
            return '';
        }
        else {
            let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
                "May", "Jun", "Jul", "Aug",
                "Sep", "Oct", "Nov", "Dec"];

            var day = date.slice(8, 10);
            var monthindex = date.slice(5, 7);            if (monthindex >= 10) {                var month = monthNames[date.slice(5, 7)];            }            else {                var month = monthNames[date.slice(6, 7)];            }
            var year = date.slice(0, 4);
            return day + "-" + month + "-" + year;
        }
    }

function getTotalWeight() {
    var calculated_total_sum = 0;

    $("#tbodyDWR .clsWeight").each(function () {
        var get_textbox_value = $(this).val();
        if ($.isNumeric(get_textbox_value)) {
            calculated_total_sum += parseFloat(get_textbox_value);
        }
    });
    $("#txtTWeight").val(calculated_total_sum);
}

function AutoGen() {
    $.get("/api/DailyWeighingRecord/AutoGeneratedCode", function (response) {
        var result = JSON.parse(response);
        $('#txtDwrNo').val(result.DWRNo);
    });
}
//function Weight(Weight) {

//    var CCode = $("#CCode")[0];

//    if (CCode.options[CCode.options.selectedIndex].text == 'Wheel bin 660L') {
//        $('.clsWeight').prop('', true);
//    }
//    else {
//        $('.clsWeight').prop("", false);
//    }
//}