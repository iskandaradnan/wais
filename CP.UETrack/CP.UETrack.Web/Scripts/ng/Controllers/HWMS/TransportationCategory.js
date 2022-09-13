var rowNum = 1; 

$(document).ready(function () {

    $.get("/api/TransportationCategory/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                $("#ddlStatus").append(
                    "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>"
                );
            }
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    $(body).on('input propertychange paste keyup', '.clsHospitalCode', function (event) {
       
        var id = event.target.id.slice(15, 17);
        var HospitalCodeFetchObj = {
            SearchColumn: 'txtHospitalCode' + id + '-HospitalCode',//Id of Fetch field
            ResultColumns: ['RouteHospitalId-Primary Key', 'HospitalCode-HospitalCode'],
            FieldsToBeFilled: ['txtHospitalCode' + id + '-HospitalCode', 'txtHospitalName' + id + '-HospitalName']
        };

        DisplayFetchResult('divHospitalCodeFetch' + id, HospitalCodeFetchObj, "/Api/TransportationCategory/HospitalCodeFetch", 'UlFetch' + id, event, 1);
        
    });

    $("#btnSave,#btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();       
     
        var isFormValid = formInputValidation("formTransportCategory", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }       

        var arr = [];
        var isDuplicatHospitalCode = 0;
        $("[id^=txtHospitalCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicatHospitalCode += 1;
            }
        });

        if (isDuplicatHospitalCode > 0) {
            $("div.errormsgcenter").text('Duplicate Hospital Codes');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }
        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();
        }

        var obj = {
            RouteTransportationId: primaryId,
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            RouteCode: $('#txtRouteCode').val(),
            RouteDescription: $('#txtRouteDescription').val(),
            RouteCategory: $('#ddlRouteCategory').val(),
            Status: $('#ddlStatus').val(),           
            TransportationCategoryList: []
        }
        $('#tbodyHospital tr').each(function () {
            var tbl = {};            
            tbl.RouteHospitalId = $(this).find("[id^=hdnTransportationHospitalId]")[0].value;
            tbl.HospitalCode = $(this).find("[id^=txtHospitalCode]")[0].value;
            tbl.HospitalName = $(this).find("[id^=txtHospitalName]")[0].value;
            tbl.Remarks = $(this).find("[id^=txtRemarks]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.TransportationCategoryList.push(tbl);
        });
       
        
        var jqxhr = $.post("/api/TransportationCategory/Save", obj, function (response) {            
            showMessage('TransportationCategory', CURD_MESSAGE_STATUS.SS); 

            var result = JSON.parse(response);
            $("#primaryID").val(result.TransportationId);            
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

    //Reset Functionality....
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

    $('#txtRouteCode').change(function () {
        $('#formTransportCategory #RouteCode').removeClass('has-error');
    });
    $('#txtRouteDescription').change(function () {
        $('#formTransportCategory #RouteDescription').removeClass('has-error');
    });
    $('#txtHospitalCode1').change(function () {
        $('#formTransportCategory #HospitalCode').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });
     
    $("#addHospitalRows").click(function () {    
        rowNum = rowNum + 1; 
        addHospitalRows(rowNum);
    });

    //Mutliple rows delete button code....
    $("#deleteHospital").click(function () {
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
                        $("#tbodyHospital tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnTransportationHospitalId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }                    
                            }
                        });
                    }
                    else
                        alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

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

function EmptyFields() {

    $("#primaryID").val('0');
    $('[id^=hdnTransportationHospitalId]').val(0);

    $('#formTransportCategory')[0].reset();
    
    $('#formTransportCategory #txtRouteCode').val('');
    $('#formTransportCategory #txtRouteDescription').val('');  
    $('#formTransportCategory #ddlStatus').val('10573');
    $('#formTransportCategory #txtHospitalCode1').val('');
    $('#formTransportCategory #txtHospitalName1').val(''); 
    $('#formTransportCategory #txtRemarks1').val('');
    $('#RouteCode').removeClass('has-error');
    $('#RouteDescription').removeClass('has-error');
    $('#RouteCategory').removeClass('has-error');
    $('#Status').removeClass('has-error');
    $('#HospitalCode').removeClass('has-error');
    $('#formTransportCategory #HospitalCode').removeClass('has-error');
    $('#errorMsg').css('visibility', 'hidden');

    var i = 1;
    $("#tbodyHospital").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

}

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formTransportCategory :input:not(:button)").parent().removeClass('has-error');
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
        $.get("/api/TransportationCategory/Get/" + primaryId)
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

function fillDetails(result) {

    if (result != undefined) {

        $("#primaryID").val(result.RouteTransportationId);
        $('#txtRouteCode').val(result.RouteCode);
        $('#txtRouteDescription').val(result.RouteDescription);
        $('#ddlRouteCategory').val(result.RouteCategory);
        $('#ddlStatus').val(result.Status);

        rowNum = 1;
        $("#tbodyHospital").html('');
        if (result.TransportationCategoryList != null) {
            for (var i = 0; i < result.TransportationCategoryList.length; i++) {

                addHospitalRows(rowNum);

                $('#hdnTransportationHospitalId' + rowNum).val(result.TransportationCategoryList[i].RouteHospitalId);
                $('#txtHospitalCode' + rowNum).val(result.TransportationCategoryList[i].HospitalCode);
                $('#txtHospitalName' + rowNum).val(result.TransportationCategoryList[i].HospitalName);
                $('#txtRemarks' + rowNum).val(result.TransportationCategoryList[i].Remarks);

                rowNum += 1;
            }
        }
        else {
            addHospitalRows(rowNum);
        }
    }
}

function addHospitalRows(num)
{
    var Checkbox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /><input type="hidden" value="0" id="hdnTransportationHospitalId' + num + '"  /></td>';
    var HospitalCode = '<td id="HospitalCode"> <input type="text" required class="form-control clsHospitalCode" placeholder="Please Select" id="txtHospitalCode' + num + '" autocomplete="off" name="HospitalCode" maxlength="25"  /> <input type = "hidden" id="hdnHospitalId' + num + '" />' + '<div class="col-sm-12" id="divHospitalCodeFetch' + num + '">   </div> </td>';
    var HospitalName = '<td> <input type="text" requireddisabled class="form-control" id="txtHospitalName' + num + '" autocomplete="off" name="HospitalName" maxlength="25"  /></td>';
    var Remarks = '<td> <input type="text"  class="form-control" id="txtRemarks' + num + '" autocomplete="off" name="Remarks" maxlength="25"  /></td>';

    $("#tbodyHospital").append('<tr class="tablerow">' + Checkbox + HospitalCode + HospitalName + Remarks + '</tr>');
}