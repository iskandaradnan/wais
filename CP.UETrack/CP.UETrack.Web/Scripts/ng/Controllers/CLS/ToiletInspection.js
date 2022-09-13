var StatusVal = "";
var FileTypeValues = "";
var filePrefix = "TI_";
var ScreenName = "ToiletInspection";
var rowNum2 = 1;

$(document).ready(function () {
    var fetchResult = [];
    $('#txtTotalDone').val('0');
    $('#txtTotalNotDone').val('0');

    $.get("/api/ToiletInspection/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            
            for (var i = 0; i < loadResult.StatusLov.length; i++) {
               
                    StatusVal += "<option value=" + loadResult.StatusLov[i].LovId + " >" + loadResult.StatusLov[i].FieldValue + "</option>"               
            }

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "TI form" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });


    //clicking on 2nd tab restrict
    $(".nav-tabs").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
    });

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
            

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        } 
        var isFormValid = formInputValidation("formToiletInspection", 'save');

        if (!isFormValid) {

            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            return false;
        }

        var obj = {
            ToiletInspectionId: primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,
            DocumentNo: $('#txtDocumentNo').val(),
            Date: $('#txtDate').val(),
            TotalDone: $('#txtTotalDone').val(),
            TotalNotDone: $('#txtTotalNotDone').val(),     
            locationCodeDetailsList: []
        }
        var i = 0;

        $('#myPleaseWait').modal('show');

        $("#myDIV tr").each(function () {

            var row = $(this);
            var tbl = {};
            tbl.LocationCode = row.find("td").eq(0).html();
            tbl.Status = row.children("td").find("select").children("option:selected").val();  
            
            //tbl.Mirror = checkboxValue($('input:checkbox[id=chkMirror' + i + ']').attr("Id"));
            //tbl.Floor = checkboxValue($('input:checkbox[id=chkFloor' + i + ']').attr("Id"));
            //tbl.Wall = checkboxValue($('input:checkbox[id=chkWall' + i + ']').attr("Id"));
            //tbl.Urinal = checkboxValue($('input:checkbox[id=chkUrinal' + i + ']').attr("Id"));
            //tbl.Bowl = checkboxValue($('input:checkbox[id=chkBowl' + i + ']').attr("Id"));
            //tbl.Basin = checkboxValue($('input:checkbox[id=chkBasin' + i + ']').attr("Id"));
            //tbl.ToiletRoll = checkboxValue($('input:checkbox[id=chkToiletRoll' + i + ']').attr("Id"));
            //tbl.SoapDispenser = checkboxValue($('input:checkbox[id=chkSoapDispenser' + i + ']').attr("Id"));
            //tbl.AutoAirFreshner = checkboxValue($('input:checkbox[id=chkAutoAirFreshner' + i + ']').attr("Id"));
            //tbl.Waste = checkboxValue($('input:checkbox[id=chkWaste' + i + ']').attr("Id"));

            tbl.Mirror = checkboxValue('chkMirror' + i);
            tbl.Floor = checkboxValue('chkFloor' + i);
            tbl.Wall = checkboxValue('chkWall' + i);
            tbl.Urinal = checkboxValue('chkUrinal' + i);
            tbl.Bowl = checkboxValue('chkBowl' + i);
            tbl.Basin = checkboxValue('chkBasin' + i);
            tbl.ToiletRoll = checkboxValue('chkToiletRoll' + i);
            tbl.SoapDispenser = checkboxValue('chkSoapDispenser' + i);
            tbl.AutoAirFreshner = checkboxValue('chkAutoAirFreshner' + i);
            tbl.Waste = checkboxValue('chkWaste' + i);
            obj.locationCodeDetailsList.push(tbl);
            i++;

        });

       

        $.post("/api/ToiletInspection/Save", obj, function (response) {

            $('#myPleaseWait').modal('hide');

            var result = JSON.parse(response);
            //var result = JSON.parse(response);
            $("#primaryID").val(result.ToiletInspectionId); 

            showMessage('Toilet Inspection', CURD_MESSAGE_STATUS.SS);
            $("#grid").trigger('reloadGrid');

            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                ToiletAutoGenerate(objToilet);
                showMessage('Toilet Inspection', CURD_MESSAGE_STATUS.SS);
            }
            
        },
            "json")
            .fail(function (response) {

                $('#myPleaseWait').modal('hide');
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

    $("#btnSave1").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg1').css('visibility', 'hidden');

        var FileType = $('#ddlFileType').val();
        var FileName = $('#txtFileName').val();
        var Attachment = $('#txtAttachment').val();
        var primaryId = $("#primaryID").val();

        var isFormValid = formInputValidation("formJi", 'save');

        if (!isFormValid) {

            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            return false;
        }

        var obj = {

            FileType: FileType,
            FileName: FileName,
            Attachment: Attachment,
            DetailsId: primaryId,
            JIAttachmentSaveList: []

        }
        $('#table2 tbody tr').each(function () {
            var tbl = {};
            tbl.DetailsId = "1";
            tbl.FileType = $(this).find("[id^=ddlFileType]")[0].value;
            tbl.FileName = $(this).find("[id^=txtFileName]")[0].value;
            tbl.Attachment = $(this).find("[id^=txtAttachment]")[0].value;
            obj.JIAttachmentSaveList.push(tbl);
        });

        $.post("/api/ToiletInspection/AttachmentSave", obj, function (response) {
            showMessage('JiDetails', CURD_MESSAGE_STATUS.SS);
            var result = JSON.parse(response);
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
                $('#errorMsg1').css('visibility', 'visible');

                $('#btnSave1').attr('disabled', false);

            });

    });


    $("#btnFetch").click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var DocumentNo = $('#txtDocumentNo').val();
        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var objToilet = {
            ToiletInspectionId: primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,
            DocumentNo: DocumentNo
        }

        if (DocumentNo == "null") { return false; }
        $('#table1 > tbody').empty();
        fetchResult = [];
        $("input[id$='All']").prop("checked", false);

         

        $.post("/api/ToiletInspection/ToiletFetch", objToilet, function (response) {

            fetchResult = JSON.parse(response);

            if (fetchResult.locationCodeDetailsList != null) {
                DisplayRows(fetchResult.locationCodeDetailsList, primaryId);             
            }

            $('#myPleaseWait').modal('hide');

        }, "json")
            .fail(function (response) {

                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
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
                    $('#table_data').show();
                    ToiletAutoGenerate(objToilet);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }

            }

        });
    });

    function EmptyFields() {

        $('#formToiletInspection')[0].reset();
        $("#primaryID").val(0);
        $('#myDIV').html(''); 
        $('#errorMsg').css('visibility', 'hidden');
        $('#daily').html('');
        $('#date').removeClass('has-error');
        $('#txtDate').val('');
        $('#txtTotalDone').val('0');
        $('#txtTotalNotDone').val('0');
        $('#jobLocationCode').val('');
        $('#jobItemStatus').val('');
        $("#CheckboxALL").val('');
        $("#CheckboxM").val('');
        $("#CheckboxF").val('');
        $("#CheckboxW").val('');
        $("#CheckboxU").val('');
        $("#CheckboxBW").val('');
        $("#CheckboxBS").val('');
        $("#CheckboxTR").val('');
        $("#CheckboxSP").val('');
        $("#CheckboxAA").val('');
        $("#CheckboxW2").val('');
    }

    //validation red  color border
    $('#txtDate').on('change', function () {

        $('#date').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
    //Date Picker
    $('#txtDate').datetimepicker({
        timepicker: false,
        format: 'm/d/Y'
    });

    // auto generated
    var DocumentNo = $('#txtDocumentNo').val();

    var objToilet = {
        DocumentNo: DocumentNo
    }
    ToiletAutoGenerate(objToilet);

    //*****check all functionaity*****//
    $("#chkCheckAll").click(function () {
        $("input[type='checkbox']:not([disabled]").prop('checked', this.checked);
    });

    //*****rows check functionaity*****//
    $('#chkMirrorAll').click(function () {
        $(".chkM:not([disabled]").prop('checked', this.checked);
    });

    $('#chkFloorAll').click(function () {
        $('.chkF:not([disabled]').prop('checked', this.checked);
    });

    $('#chkWallAll').click(function () {
        $('.chkW:not([disabled]').prop('checked', this.checked);
    });

    $('#chkUrinal').click(function () {
        $('.chkU:not([disabled]').prop('checked', this.checked);
    });
    
    $('#chkBowl').click(function () {
        $('.chkB:not([disabled]').prop('checked', this.checked);
    });

    $('#chkBasin').click(function () {
        $('.chkBA:not([disabled]').prop('checked', this.checked);
    });

    $('#chkToiletRoll').click(function () {
        $('.chkTR:not([disabled]').prop('checked', this.checked);
    });

    $('#chkSoapDispenser').click(function () {
        $('.chkSD:not([disabled]').prop('checked', this.checked);
    });

    $('#chkAutoAirFreshner').click(function () {
        $('.chkAA:not([disabled]').prop('checked', this.checked);
    });

    $('#chkWaste').click(function () {
        $('.chkW2:not([disabled]').prop('checked', this.checked);
    });


});

//*****Fetch functionaity*****//
function DisplayRows(result, primaryId) {    

    if (result.length > 0) {

        $('#table_data').hide();
        $('#myDIV').html('');           

        for (var i = 0; i < result.length; i++) {

            var trStru = "";

            var CheckboxALL = "<td><input type='checkbox' class='cssChkAllColums'  name='chkRowCheckAll" + i + "' id='chkRowCheckAll" + i + "'></input></td>";

            var CheckboxM = "<td><input type='checkbox' class='chkM' " + checkboxStatus(result[i].Mirror) + "  id='chkMirror" + i + "'>" + "</input></td>";
                        
            var CheckboxF = "<td><input type='checkbox' class='chkF' " + checkboxStatus(result[i].Floor) + "  id='chkFloor" + i + "'></input></td>";
                       
            var CheckboxW = "<td><input type='checkbox' class='chkW' " + checkboxStatus(result[i].Wall) + " id='chkWall" + i + "'></input></td>"

            var CheckboxU = "<td><input type='checkbox' class='chkU' " + checkboxStatus(result[i].Urinal) + " id='chkUrinal" + i + "'>" + "</input></td>";

            var CheckboxBW = "<td><input type='checkbox' class='chkB' " + checkboxStatus(result[i].Bowl) + "  id='chkBowl" + i + "'>" + "</input></td>";          
            
            var CheckboxBS = "<td><input type='checkbox' class='chkBA' " + checkboxStatus(result[i].Basin) + "  id='chkBasin" + i + "'>" + "</input></td>";
           
            var CheckboxTR = "<td><input type='checkbox' class='chkTR' " + checkboxStatus(result[i].ToiletRoll) + "  id='chkToiletRoll" + i + "'></input></td>";           

            var CheckboxSP = "<td><input type='checkbox' class='chkSD' " + checkboxStatus(result[i].SoapDispenser) + " id='chkSoapDispenser" + i + "'></input></td>";
          
            var CheckboxAA = "<td><input type='checkbox' class='chkAA' " + checkboxStatus(result[i].AutoAirFreshner) + "  id='chkAutoAirFreshner" + i + "'></input></td>";
            
            var CheckboxW2 = "<td><input type='checkbox'  class='chkW2' " + checkboxStatus(result[i].Waste) + " id='chkWaste" + i + "'></input></td>";
                     

            trStru = "<tr class='chkRow" + i + "'><td>" + result[i].LocationCode + "</td><td><select class='countableValue' id='ddlStatus" + i + "'>" + StatusVal + "</select ></td>" + CheckboxALL + CheckboxM + CheckboxF + CheckboxW + CheckboxU + CheckboxBW + CheckboxBS + CheckboxTR + CheckboxSP + CheckboxAA + CheckboxW2 + "</tr>"

            $('#myDIV').append(trStru);
            if (primaryId != 0) {
                var statusvalues1 = result[i].Status;
                $('#ddlStatus' + i).val(statusvalues1);
            }


            $('#chkRowCheckAll' + i).click(function () {
                $(this).closest('tr').find("input[type='checkbox']:not([disabled])").prop('checked', this.checked);
            });
        }
        
        $('#myDIV').find("select").addClass("form-control");
        $('#myDIV').find("input[type='checkbox']:not([disabled])").closest('td').css('background-color','#dbfccf');

        if (primaryId == 0) {
            $('#txtTotalDone').val(result.length);
            $('#txtTotalNotDone').val(0);
        }

        $('body').on('change', '.countableValue', function () {
            var Totaldone = 0;
            var TotalNotdone = 0;
            $('.countableValue').each(function () {
                var AttachIdId = $(this)[0].id;
                var toilet = $("#" + AttachIdId)[0];
                if (toilet.options[toilet.options.selectedIndex].text == "Done") {
                    Totaldone = Totaldone + 1;
                }
                else {
                    TotalNotdone = TotalNotdone + 1;
                }
            })
            $('#txtTotalDone').val(Totaldone);
            $('#txtTotalNotDone').val(TotalNotdone);
        });

       
    }

}

//*****auto generated functionaity*****//
function ToiletAutoGenerate(objToilet) {
    $.get("/api/ToiletInspection/AutoGeneratedCode", objToilet, function (response) {

        var result = JSON.parse(response);       
        $('#txtDocumentNo').val(result.DocumentNo);
    });
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
})

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formToiletInspection :input:not(:button)").parent().removeClass('has-error');
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
        $("#formToiletInspection :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();

        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ToiletInspection/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
                    "May", "Jun", "Jul", "Aug",
                    "Sep", "Oct", "Nov", "Dec"];
               
                if (getResult != undefined) {

                    var Docno = getResult.DocumentNo;
                    var DateTime = getResult.Date;
                    var Date = DateTime.slice(0, 10);
                    var year = Date.slice(0, 4);
                    var monthindex = Date.slice(5, 7)
                    if (monthindex >= 10) {

                        var month = monthNames[Date.slice(5, 7)];
                    }
                    else {
                        var month = monthNames[Date.slice(6, 7)];
                    }

                    var date1 = Date.slice(8, 10);
                    var DateFormat = date1 + "-" + month + "-" + year;                   
                    var TotalDone = getResult.TotalDone;
                    var TotalNotDone = getResult.TotalNotDone;

                    $('#txtDocumentNo').val(Docno);
                    $('#txtDate').val(DateFormat);
                    $('#txtTotalDone').val(TotalDone);
                    $('#txtTotalNotDone').val(TotalNotDone);
                }
                                
                if (getResult.locationCodeDetailsList != null){                      
                    DisplayRows(getResult.locationCodeDetailsList, primaryId);                   
                }

                
                    fillAttachment(getResult.AttachmentList);
                
                            
                $('tbody').on('change', '.countableValue', function () {
                    var Totaldone = 0;
                    var TotalNotdone = 0;
                    $('.countableValue').each(function () {
                        var AttachIdId = $(this)[0].id;
                        var toilet = $("#" + AttachIdId)[0];
                        if (toilet.options[toilet.options.selectedIndex].text == "Done") {
                            Totaldone = Totaldone + 1;
                        }
                        else {
                            TotalNotdone = TotalNotdone + 1;
                        }
                    })
                    $('#txtTotalDone').val(Totaldone);
                    $('#txtTotalNotDone').val(TotalNotdone);
                });

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


function checkboxStatus(status) {
    if (status == 2) {
        return 'disabled';
    }
    else if (status == 1) {
        return 'checked';
    }
    else {
        return '';
    }
}

function checkboxValue(chkId) {

    if ($('#' + chkId).prop('disabled')) {
        return 2;
    }
    else if ($('#' + chkId).prop('checked')) {
        return 1;
    }
    else {
        return 0;
    }
}
