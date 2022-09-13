var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
var LOVData = {};
var ckNewRowPaginationValidation = false;

var ActionType = $('#ActionType').val();

$(document).ready(function () {
    $('#myPleaseWait').modal('show');

    formInputValidation("EODParamMappingScreen");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/EODParameterMapping/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            LOVData = loadResult;

            window.UOM = loadResult.UOM
            window.DataType = loadResult.DataType
            window.Frequency = loadResult.Frequency
            window.Status = loadResult.Status

            AddNewRowEODParamMap();

            $.each(loadResult.ServiceLovs, function (index, value) {
                if (value.LovId == 2)
                    $('#EODParamMapService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            //$("#EODParamMapClss").val('').empty().append('<option value="">Select</option>')
            $.each(loadResult.CategorySystem, function (index, value) {
                $('#EODParamMapClss').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $.each(loadResult.Frequency, function (index, value) {
                $('#EODParamMapFrequency').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#EODParamMapClss').on('change',function () {
                $('#EODParamMapTypeCode').val('');
                $('#EODParamMapModel').val('').attr("disabled", true);
                $('#EODParamMapManu').val('').attr("disabled", true);
                $('#EODParamMapTypCdeDesc').val('').attr("disabled", true);
                $("#EODParamMappingBody").empty();
                if (this.value > 0) {
                    $("#EODParamMapTypeCode").prop('disabled', false);
                }
                else {
                    $("#EODParamMapTypeCode").prop('disabled', true);
                }
                 AddNewRowEODParamMap();
            });

            $('#hdnParamMapTypCdeId').on('change', function () {
                var manufacturerId = $('#hdnParamMapTypCdeId').val();
                if (manufacturerId != '') {
                    $('#EODParamMapModel').attr('disabled', false);
                    
                }
                else {
                    $('#EODParamMapModel').attr('disabled', true);
                    $('#EODParamMapModel').val('');
                    $('#EODParamMapManu').val('');
                }
            });

            $('#hdnParamMapModId').on('change', function () {
                var manufacturerId = $('#hdnParamMapModId').val();
                //var manufacturerId = $('#EODParamMapManu').val();
                  if (manufacturerId !='') {
                      $('#EODParamMapManu').attr('disabled', true);
                }
                else {
                      $('#EODParamMapManu').attr('disabled', true);
                      $('#EODParamMapManu').val('');
                }
            });

            $('#EODParamMapTypeCode').on('change', function () {
                var typcde = $('#hdnParamMapTypCdeId').val();
                //var manufacturerId = $('#EODParamMapManu').val();
                if (typcde == '') {
                    $('#EODParamMapManu').attr('disabled', true);
                    $('#EODParamMapModel').attr('disabled', true);
                    $("#EODParamMappingBody").empty();
                    AddNewRowEODParamMap();
                }
                else {
                    //$('#EODParamMapManu').attr('disabled', true);
                    //$('#EODParamMapManu').val('');
                }
            });


            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    $.get("/api/EODParameterMapping/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
            //      .done(function (result) {
            //          var getResult = JSON.parse(result);
            //          if (ActionType == "VIEW") {
            //              $("#EODParamMappingScreen :input:not(:button)").prop("disabled", true);
            //              //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
            //          }
            //          GetParamMappingBind(getResult)

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

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var _index;
        $('#EODParamMappingBody tr').each(function () {
            _index = $(this).index();
        });

        var ParameterMappingId = $('#primaryID').val();
        var ServiceId = $('#EODParamMapService').val();
        var ClassificationId = $('#EODParamMapClss').val();
        var manufactId = $('#hdnParamMapManuId').val();
        var ModId = $('#hdnParamMapModId').val();
        var Typecodeid = $('#hdnParamMapTypCdeId').val();        
        var timeStamp = $("#Timestamp").val();
        var freqency = $('#EODParamMapFrequency').val();

        var result = [];


        //var isFormValid = formInputValidation("EODParamMappingScreen", 'save');
        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}


        for (var i = 0; i <= _index; i++) {
            var _EODParamMappGrid = {
                ParameterMappingId: $('#primaryID').val(),
                ParameterMappingDetId: $('#hdnEodParMapGrid_' + i).val(),
                parameter: $.trim($('#ParamMapParam_' + i).val()),
                //Standard: $.trim($('#ParamMapStand_' + i).val()),
                UomId: $('#ParamMapUom_' + i).val(),
                UOM: $('#ParamMapUom_' + i + 'option:selected').text(),
                DatatypeId: $('#ParamMapDataType_' + i).val(),
                DataType: $('#ParamMapDataType_' + i + 'option:selected').text(),
                AlphanumDropdown: $('#ParamMapAlphaNum_' + i).val(),
                Min: $('#ParamMapMin_' + i).val(),
                Max: $('#ParamMapMax_' + i).val(),
                //FrequencyId: $('#ParamMapFreq_' + i).val(),
                //Frequency: $('#ParamMapFreq_' + i + 'option:selected').text(),
                EffectiveFrom: $('#ParamMapEffFrom_' + i).val(),
                StatusId: $('#ParamMapEffTo_' + i).val(),
                //EffectiveTo: $('#ParamMapEffTo_' + i).val(),
                IsEffectiveDateFilled:$('#hdnIsEffToDateFilled_' + i).val(),
                Remarks: $.trim($('#ParamMapRem_' + i).val()),
                //IsDeleted: $('#Isdeleted_' + i).is(":checked"),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }

            
            if ((_EODParamMappGrid.IsDeleted == false) && (parseFloat(_EODParamMappGrid.Max) <= parseFloat(_EODParamMappGrid.Min))) {
                $("div.errormsgcenter").text("Max should be greater than Min");
                $('#errorMsg').css('visibility', 'visible');

                $('#btnlogin').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }


            if (_EODParamMappGrid.DatatypeId == 176) {
                if (_EODParamMappGrid.Min == '' && _EODParamMappGrid.Max == '') {
                    $("div.errormsgcenter").text("Either Min or Max must be given");
                    $('#errorMsg').css('visibility', 'visible');

                    $('#btnlogin').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                    return false;
                }

                //if ((_EODParamMappGrid.IsDeleted == false) && (_EODParamMappGrid.Max == 0)) {
                //    $("div.errormsgcenter").text("Maximum Field should be greater than Zero.");
                //    $('#errorMsg').css('visibility', 'visible');

                //    $('#btnlogin').attr('disabled', false);
                //    $('#myPleaseWait').modal('hide');
                //    return false;
                //}

                //if (_EODParamMappGrid.Min == '' && _EODParamMappGrid.Max == '') {
                //    $("div.errormsgcenter").text("Either Min or Max must be given");
                //    $('#errorMsg').css('visibility', 'visible');

                //    $('#btnlogin').attr('disabled', false);
                //    $('#myPleaseWait').modal('hide');
                //    return false;
                //}
            }

            if (_EODParamMappGrid.IsEffectiveDateFilled == "") {
                _EODParamMappGrid.IsEffectiveDateFilled = "0";
            }

            result.push(_EODParamMappGrid);
        }

        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                $('#ParamMapParam_' + i).prop("required", false);
               // $('#ParamMapStand_' + i).prop("required", false);
                $('#ParamMapUom_' + i).prop("required", false);
                $('#ParamMapDataType_' + i).prop("required", false);
                $('#ParamMapAlphaNum_' + i).prop("required", false);
                $('#ParamMapMin_' + i).prop("required", false);
                $('#ParamMapMax_' + i).prop("required", false);
                //$('#ParamMapFreq_' + i).prop("required", false);
                $('#ParamMapEffFrom_' + i).prop("required", false);
                $('#ParamMapEffTo_' + i).prop("required", false);
                $('#ParamMapRem_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }

        var _index;
        $('#EODParamMappingBody tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            var CompareFrmDat = new Date($('#ParamMapEffFrom_' + i).val());
            var CompareToDat = new Date($('#ParamMapEffTo_' +i).val());
            var CurrDate = new Date();
            var CurrDate = new Date(CurrDate.dateFormat("M-d-Y"));

            //if (CompareFrmDat > CurrDate) {
            //    $("div.errormsgcenter").text("Effective From Date should be lesser than or equal to Current Date");
            //    $('#errorMsg').css('visibility', 'visible');
            //    $('#myPleaseWait').modal('hide');
            //    return false;
            //}

            if (result[i].IsEffectiveDateFilled == 1) {
                if (CompareToDat < CurrDate) {
                    $("div.errormsgcenter").text("Effective To should be greater than or equal to current date");
                    $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
            }
        }

        if (ParameterMappingId > 0) {
             TotalPages = $("#Id_TotPag").val();
        }
        else {
             TotalPages = 0;
        }

        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length && (TotalPages == 1 || TotalPages == 0)) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            ParameterMappingId = primaryId;
            Timestamp = timeStamp;
        }
        else {
            ParameterMappingId = 0;
            Timestamp = "";
        }

        var obj = {
            ParameterMappingId: ParameterMappingId,
            ServiceId: ServiceId,
            AssetClassificationId: ClassificationId,
            ManufacturerId: manufactId,
            ModelId: ModId,
            AssetTypeCodeId: Typecodeid,
            Frequency:freqency,
            EODParameterMappingGridData: result,
            Timestamp: timeStamp
        }

        var isFormValid = formInputValidation("EODParamMappingScreen", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        //if (manufactId == '') {
        //    DisplayErrorMessage("Valid Manufacturer is required.");
        //    return false;
        //}
        if (ModId == '') {
            DisplayErrorMessage("Valid Model is required.");
            return false;
        }
        if (obj.EODParameterMappingGridData.length == 1)
        {
            statusval = (obj.EODParameterMappingGridData[0].StatusId)
            if (statusval==2)  {
                $("div.errormsgcenter").text("All Parameters cannot be Inactive");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (Isdeleteavailable == true) {
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveParameterMapping(obj);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });
        }
        else {
            SaveParameterMapping(obj);
        }

        function SaveParameterMapping(obj) {

            var jqxhr = $.post("/api/EODParameterMapping/Save", obj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.ParameterMappingId);
                $("#Timestamp").val(result.Timestamp);
                $('#btnDelete').show();
                GetParamMappingBind(result);

               
                $("#grid").trigger('reloadGrid');
                if (result.ParameterMappingId != 0) {
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                }
                $(".content").scrollTop(0);
                showMessage('Parameter Mapping BEMS', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnSave').attr('disabled', false);
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
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        }

    });

    $("#chk_ParamMap").change(function () {
        var Isdeletebool = this.checked;
        //$('#EODParamMappingBody tr').map(function (i) {
        //    if ($("#Isdeleted_" + i).prop("disabled"))
        //    {
        //        $("#Isdeleted_" + i).prop("checked", false);
        //    }
        //    else {
        //        $("#Isdeleted_" + i).prop("checked", true);
        //    }            

            if (this.checked) {
                $('#EODParamMappingBody tr').map(function (i) {
                    if ($("#Isdeleted_" + i).prop("disabled")) {
                        $("#Isdeleted_" + i).prop("checked", false);
                    }
                    else {
                        $("#Isdeleted_" + i).prop("checked", true);
                    }
                });
            } else {
                $('#EODParamMappingBody tr').map(function (i) {
                    $("#Isdeleted_" + i).prop("checked", false);
                });
            }
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

function GetParamMappingBind(getResult) {
    var datatypePagination = [];

     var primaryId = $('#primaryID').val();
    //var primaryId = $('#primaryID').val(getResult.ParameterMappingId);

    $("#chk_ParamMap").prop('checked',false);
    $('#EODParamMapService option[value="' + getResult.ServiceId + '"]').prop('selected', true);
    $("#EODParamMapClss").prop("disabled", "disabled");
    $('#EODParamMapClss option[value="' + getResult.AssetClassificationId + '"]').prop('selected', true);

    $("#EODParamMapTypeCode").val(getResult.AssetTypeCode);
    $("#hdnParamMapTypCdeId").val(getResult.AssetTypeCodeId);
    $("#EODParamMapTypCdeDesc").val(getResult.AssetTypeCodeDesc);

    $("#hdnParamMapManuId").val(getResult.ManufacturerId);
    $("#EODParamMapManu").val(getResult.Manufacturer);
    $("#EODParamMapManu").prop("disabled", true);
    $("#hdnParamMapModId").val(getResult.ModelId);
    $("#EODParamMapModel").val(getResult.Model);
    $("#EODParamMapModel").prop("disabled", false);
    $("#EODParamMapFrequency").val(getResult.Frequency);
    $('#Timestamp').val(getResult.Timestamp);
    $("#EODParamMappingBody").empty();

    if (getResult.EODParameterMappingGridData.length > 0)
    {
        $('#hdnParamMapTotPag').val(getResult.EODParameterMappingGridData[0].TotalPages);
   
    $.each(getResult.EODParameterMappingGridData, function (index, value) {
        AddNewRowEODParamMap();
        if (getResult.EODParameterMappingGridData[index].DatatypeId == 176 ||getResult.EODParameterMappingGridData[index].DatatypeId == 177 ) {
            DatatypeNumber(index, value)
        }
        else if ( getResult.EODParameterMappingGridData[index].DatatypeId == 178) {
            DatatypeDropdownAlpha(index, value)
        }
        else {
            datatypeDefault(index, value);
        }

        $('#EODParamMappingBody tr').each(function (index, value) {
            $('#ParamMapDataType_' + index).change(function () {
                if ( $('#ParamMapDataType_' + index).val() == 178) {
                    DatatypeDropdownAlpha(index, value);
                }
                else if ($('#ParamMapDataType_' + index).val() == 176 || $('#ParamMapDataType_' + index).val() == 177 ) {
                    DatatypeNumber(index, value)
                }
                else {
                    datatypeDefault(index, value)
                }
            });
        });

        if (getResult.EODParameterMappingGridData[index].Isreferenced == true) {

            if (getResult.EODParameterMappingGridData[index].DatatypeId == 176 ||getResult.EODParameterMappingGridData[index].DatatypeId == 177 ) {
                IsChkReferencedNum(index, value);
            }
            else if ( getResult.EODParameterMappingGridData[index].DatatypeId == 178) {
                IsChkReferencedAlpDrp(index, value);
            }          
        }
        else {
            $("#Isdeleted_" + index).prop("disabled", false)
        }
       

        $("#hdnEodParMapGrid_" + index).val(getResult.EODParameterMappingGridData[index].ParameterMappingDetId);
        $("#ParamMapParam_" + index).val(getResult.EODParameterMappingGridData[index].parameter);
       // $("#ParamMapStand_" + index).val(getResult.EODParameterMappingGridData[index].Standard);
        $('#ParamMapUom_' + index + ' option[value="' + getResult.EODParameterMappingGridData[index].UomId + '"]').prop('selected', true);
        $('#ParamMapDataType_' + index + ' option[value="' + getResult.EODParameterMappingGridData[index].DatatypeId + '"]').prop('selected', true);
        $('#ParamMapDataType_' + index).prop('disabled', true);
        $("#ParamMapAlphaNum_" + index).val(getResult.EODParameterMappingGridData[index].AlphanumDropdown);
        //$("#ParamMapMin_" + index).val(getResult.EODParameterMappingGridData[index].Min == 0 ? null : getResult.EODParameterMappingGridData[index].Min);
        //$("#ParamMapMax_" + index).val(getResult.EODParameterMappingGridData[index].max == 0 ? null : getResult.EODParameterMappingGridData[index].max);
        $("#ParamMapMin_" + index).val(getResult.EODParameterMappingGridData[index].Min);
        $("#ParamMapMax_" + index).val(getResult.EODParameterMappingGridData[index].max);
        //$('#ParamMapFreq_' + index + ' option[value="' + getResult.EODParameterMappingGridData[index].FrequencyId + '"]').prop('selected', true);
        $('#ParamMapEffFrom_' + index).val(DateFormatter(getResult.EODParameterMappingGridData[index].EffectiveFrom));
        //var EffDate = getResult.EODParameterMappingGridData[index].IsEffectiveDateNull ? "" : DateFormatter(getResult.EODParameterMappingGridData[index].EffectiveTo);
        //$('#ParamMapEffTo_' + index).val(EffDate);
        $('#ParamMapEffTo_' + index).val(getResult.EODParameterMappingGridData[index].StatusId);

        //if (getResult.EODParameterMappingGridData[index].IsEffectiveDateFilled == false) {
        //    $('#hdnIsEffToDateFilled_' + index).val('0');
        //    $('#ParamMapEffTo_' + index).prop('disabled', true);
        //}
        //else {
        //    $('#hdnIsEffToDateFilled_' + index).val('1');
        //}

        $("#ParamMapRem_" + index).val(getResult.EODParameterMappingGridData[index].Remarks);
       datatypePagination = getResult.EODParameterMappingGridData[index].DatatypeId

    });

    if (ActionType == "VIEW") {
        $("#EODParamMappingScreen :input:not(:button)").prop("disabled", true);
        //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
    }

        //var ParameterMappingId = 0;
    ckNewRowPaginationValidation = false;
    if ((getResult.EODParameterMappingGridData && getResult.EODParameterMappingGridData.length) > 0) {
        ParameterMappingId = getResult.ParameterMappingId;
        GridtotalRecords = getResult.EODParameterMappingGridData[0].TotalRecords;
        TotalPages = getResult.EODParameterMappingGridData[0].TotalPages;
        LastRecord = getResult.EODParameterMappingGridData[0].LastRecord;
        FirstRecord = getResult.EODParameterMappingGridData[0].FirstRecord;
        pageindex = getResult.EODParameterMappingGridData[0].PageIndex;
    }

    var mapIdproperty = ["IsDeleted-Isdeleted_", "ParameterMappingDetId-hdnEodParMapGrid_", "parameter-ParamMapParam_", "Standard-ParamMapStand_", "UomId-ParamMapUom_", "DatatypeId-ParamMapDataType_", "AlphanumDropdown-ParamMapAlphaNum_", "Min-ParamMapMin_", "max-ParamMapMax_", "FrequencyId-ParamMapFreq_", "EffectiveFrom-ParamMapEffFrom_-date", "EffectiveTo-ParamMapEffTo_-date", "Remarks-ParamMapRem_"];
    var htmltext = EODParamMpaHtml();//Inline Html
    var obj = { formId: "#EODParamMappingScreen", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "ParMapBEMS", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "EODParameterMappingGridData", tableid: '#EODParamMappingBody', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/EODParameterMapping/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

    CreateFooterPagination(obj)
    $('#paginationfooter').show();
    }
    else {
        $("#EODParamMappingBody").empty();
        var emptyrow = '<tr id="NoActRec" class="norecord"><td width="100%"><h5 class="text-center">No  Active records to display</h5></td></tr>'
        $("#EODParamMappingBody ").append(emptyrow);
         
    }
}

function AddNewRow() {
  
    $("div.errormsgcenter1").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var rowCount = $('#EODParamMappingBody tr:last').index();
    var parRowFill = $('#ParamMapParam_' + rowCount).val();
    var DatTypFill = $('#ParamMapDataType_' + rowCount).val();
    var EffFrmRowFill = $('#ParamMapEffFrom_' + rowCount).val();
    var UomFill = $('#ParamMapUom_' + rowCount).val();
    $("#NoActRec").remove();
    if (rowCount >= 0 && parRowFill != "" && DatTypFill != "" && EffFrmRowFill != "" && UomFill !=="") {
         AddNewRowEODParamMap();
    }
    else {
         bootbox.alert("Please enter values in existing row");
    }
}

function AddNewRowEODParamMap() {
    var inputpar = {
        inlineHTML: EODParamMpaHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#EODParamMappingBody",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    ckNewRowPaginationValidation = true;
    $("#chk_ParamMap").prop("checked",false)
    var rowCount = $('#EODParamMappingBody tr:last').index();
    if (rowCount > 1) {
        $('#ParamMapParam_' + rowCount).focus();
    }
   
    

    $('#EODParamMappingBody tr').each(function (index, value) {
        $('#ParamMapDataType_' + index).change(function () {
            var DataTyp = $('#ParamMapDataType_' + rowCount).val();
            if (DataTyp == 176 ) {
                DatatypeNumber(rowCount, null);
            }
            else if ( DataTyp == 178) {
                DatatypeDropdownAlpha(rowCount, null);
            }
            else if (DataTyp == 177) {
                DatatypeAlphanum(rowCount, null);
            }
            else {
                datatypeDefault(rowCount, null);
            }
        });
    });

    $('#ParamMapUom_').empty().append('<option value="">Select</option>');
    $.each(window.UOM, function (index, value) {
        $('#ParamMapUom_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $('#ParamMapDataType_').empty().append('<option value="">Select</option>');
    $.each(window.DataType, function (index, value) {
        $('#ParamMapDataType_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    //$('#ParamMapFreq_').empty().append('<option value="">Select</option>');
    //$.each(window.Frequency, function (index, value) {
    //    $('#ParamMapFreq_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    //});
    $.each(window.Status, function (index, value) {
        $('#ParamMapEffTo_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });


    //$('.decimalPointonly').keypress(function (e) {
    //    var regex = new RegExp("^[0-9.]*$");
    //    //var regex = new RegExp("/^\d{0,3}(?:\.\d{0,2})?$/");
    //    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);level
    //    if (regex.test(str)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});

    $('.decimalPointonly').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(vrate.value), false);
    });

    //    $('.decimalPointonly').each(function (index) {
    //    //$(this).attr('id', 'ParamMapMin_' + index);
    //    var vrate = document.getElementById(this.id);
    //    vrate.addEventListener('input', function (prev) {
    //        return function (evt) {
    //            if ((!/^\D{0,2}(?:\d{0,4})?$/.test(this.value))) {
    //                this.value = prev;
    //            }
    //            else {
    //                prev = this.value;
    //            }
    //        };
    //    }(vrate.value), false);
    //});


    //$('.decimalPointonly').on('paste', function (e) {
    //    var $this = $(this);
    //    setTimeout(function () {
    //        $this.val($this.val().replace(/[a-zA-Z0-9~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
    //    }, 5);
    //});

    $('.Rem').on('paste input', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+=|\\{}\[\]?<>/\^]/g, ''));
        }, 5);
    });

    formInputValidation("EODParamMappingScreen");
}

function EODParamMpaHtml() {

    return ' <tr class="ng-scope" style=""><td width="5%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(EODParamMappingBody,chk_ParamMap)" value="false" autocomplete="off" class="ng-pristine ng-untouched ng-valid"> </label></div></td> \
                <td width="15%" data-original-title="" title=""> <div> <input type="text" id="ParamMapParam_maxindexval"  maxlength="150" required class="form-control" autocomplete="off"></div> \
                    <input type="hidden" id="hdnEodParMapGrid_maxindexval" /> </td> \
                <td width="10%" data-original-title="" title=""><div> <select id="ParamMapUom_maxindexval" class="form-control" required autocomplete="off"><option value="">Select</option> </select></div> \
                    <input type="hidden" id="hdnParamMapUom_maxindexval" /></td> \
                <td width="11%" style="text-align: center;" data-original-title="" title=""><div> <select id="ParamMapDataType_maxindexval" required class="form-control" autocomplete="off"><option value="">Select</option> </select></div> \
                    <input type="hidden" id="hdnParamMapDataType_maxindexval" /></td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="ParamMapAlphaNum_maxindexval" maxlength="100" class="form-control" disabled autocomplete="off"/></div></td> \
                <td width="7%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control decimalPointonly" id="ParamMapMin_maxindexval" style="text-align:right" maxlength="11" pattern="^[0-9]+(\.[0-9]{1,2})?$" autocomplete="off" disabled/></div></td> \
                <td width="7%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control decimalPointonly" autocomplete="off"  id="ParamMapMax_maxindexval" style="text-align:right" maxlength="11" pattern="^[0-9]+(\.[0-9]{1,2})?$" disabled/></div></td> \
                <td width="9%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control datetime" id="ParamMapEffFrom_maxindexval" onchange="effectiveFromValidation(event,maxindexval)" autocomplete="off" required/></div></td> \
                <td width="9%" style="text-align: center;" data-original-title="" title=""><div> <select id="ParamMapEffTo_maxindexval" required class="form-control" autocomplete="off"> </select></div> </td> \
                <td width="12%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" class="form-control Rem" id="ParamMapRem_maxindexval" maxlength="255" autocomplete="off"/></div> <input type="hidden" id="hdnParamMapTotPag_maxindexval" /></td></tr>'
}

//function FetchManufacturer(event) {
//    var ItemMst = {
//        SearchColumn: 'EODParamMapManu' + '-Manufacturer',//Id of Fetch field
//        ResultColumns: ["ManufacturerId" + "-Primary Key", 'Manufacturer' + '-EODParamMapManu'],//Columns to be displayed
//        FieldsToBeFilled: ["hdnParamMapManuId" + "-ManufacturerId", 'EODParamMapManu' + '-Manufacturer']//id of element - the model property
//    };
//    //DisplayFetchResult('ManufactFetch', ItemMst, "/api/Fetch/ManufacturerFetch", "Ulfetch", event, 1);
//}

//function FetchModel(event) {
//    var ItemMst = {
//        SearchColumn: 'EODParamMapModel' + '-Model',//Id of Fetch field
//        ResultColumns: ["ModelId" + "-Primary Key", 'Model' + '-EODParamMapModel'],//Columns to be displayed
//        FieldsToBeFilled: ["hdnParamMapModId" + "-ModelId", 'EODParamMapModel' + '-Model']//id of element - the model property
//    };
//    DisplayFetchResult('ModelFetch', ItemMst, "/api/Fetch/ModelFetch", "Ulfetch1", event, 1);
//}

function FetchTypeCode(event) {
    $('#TypecodeFetch').css({
        'width': $('#EODParamMapTypeCode').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'EODParamMapTypeCode' + '-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-EODParamMapTypeCode', 'AssetTypeDescription-AssetTypeCodeDesc'],//Columns to be displayed
        AdditionalConditions: ["AssetClassificationId-EODParamMapClss", "AssetTypeCode-EODParamMapTypeCode"], //Filter conditions
        FieldsToBeFilled: ["hdnParamMapTypCdeId" + "-AssetTypeCodeId", 'EODParamMapTypeCode' + '-AssetTypeCode', 'EODParamMapTypCdeDesc' + '-AssetTypeDescription']//id of element - the model property
    };
    DisplayFetchResult('TypecodeFetch', ItemMst, "/api/Fetch/TypeCodeFetch", "Ulfetch", event, 1);
}

function FetchModel(event) {

    var ItemMst = {
        SearchColumn: 'EODParamMapModel' + '-Model',//Id of Fetch field
        ResultColumns: ["ModelId" + "-Primary Key", 'Model' + '-EODParamMapModel'],//Columns to be displayed
        AdditionalConditions: ["AssetClassificationId-EODParamMapClss", "TypeCodeId-hdnParamMapTypCdeId", "Model-EODParamMapModel", "ScreenName-hdnScreenName"],
        FieldsToBeFilled: ["hdnParamMapModId" + "-ModelId", 'EODParamMapModel' + '-Model', "hdnParamMapManuId" + "-ManufacturerId", 'EODParamMapManu' + '-Manufacturer']//id of element - the model property
    };
    DisplayFetchResult('ModelFetch', ItemMst, "/api/Fetch/ModelFetch", "Ulfetch1", event, 1);
}

function FetchManufacturer(event) {
    var ItemMst = {
        SearchColumn: 'EODParamMapManu' + '-Manufacturer',//Id of Fetch field
        ResultColumns: ["ManufacturerId" + "-Primary Key", 'Manufacturer' + '-EODParamMapManu'],//Columns to be displayed
        AdditionalConditions: ["AssetClassificationId-EODParamMapClss", "Manufacturer-EODParamMapManu", "ModelId-hdnParamMapModId", "TypeCodeId-hdnParamMapTypCdeId"],
        FieldsToBeFilled: ["hdnParamMapManuId" + "-ManufacturerId", 'EODParamMapManu' + '-Manufacturer']//id of element - the model property
    };
    DisplayFetchResult('ManufactFetch', ItemMst, "/api/Fetch/ManufacturerFetch", "Ulfetch2", event, 1);
}



function DatatypeDropdownAlpha(index, value) {
    $('#ParamMapAlphaNum_' + index).prop("disabled", false);
    $('#ParamMapAlphaNum_' + index).prop('required', true);
    $("#lblParamMapAlphaDrop").html("Dropdown Data Values<span class='red'>*</span>");
    $('#ParamMapMin_' + index).prop("disabled", true);
    $('#ParamMapMax_' + index).prop("disabled", true);
    $('#ParamMapMin_' + index).val('');
    $('#ParamMapMax_' + index).val('');
}

function DatatypeNumber(index, value) {
    $('#ParamMapMin_' + index).prop("disabled", false);
    $('#ParamMapMax_' + index).prop("disabled", false);
    $('#ParamMapAlphaNum_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop('required', false);
    $("#lblParamMapAlphaDrop").html("Dropdown Data Values");
    $('#ParamMapAlphaNum_' + index).val('');
}

function datatypeDefault(index, value) {
    $('#ParamMapMin_' + index).prop("disabled", true);
    $('#ParamMapMax_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop('required', false);
    $("#lblParamMapAlphaDrop").html("Dropdown Data Values");
    $('#ParamMapMin_' + index).val('');
    $('#ParamMapMax_' + index).val('');
    $('#ParamMapAlphaNum_' + index).val('');
}

function DatatypeAlphanum(index, value) {
    $('#ParamMapMin_' + index).prop("disabled", true);
    $('#ParamMapMax_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop('required', false);
    $("#lblParamMapAlphaDrop").html("Dropdown Data Values");
    $('#ParamMapAlphaNum_' + index).val('');
}

function IsChkReferencedNum(index, value) {
    $("#Isdeleted_" + index).prop("disabled", "disabled")
    $('#ParamMapParam_' + index).prop("disabled", true);
   // $('#ParamMapStand_' + index).prop("disabled", true);
    $('#ParamMapUom_' + index).prop("disabled", true);
    $('#ParamMapDataType_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop("disabled", true);
  //  $('#ParamMapFreq_' + index).prop("disabled", true);
    
}

function IsChkReferencedAlpDrp(index, value) {
    $("#Isdeleted_" + index).prop("disabled", "disabled")
    $('#ParamMapParam_' + index).prop("disabled", true);
  //  $('#ParamMapStand_' + index).prop("disabled", true);
    $('#ParamMapUom_' + index).prop("disabled", true);
    $('#ParamMapDataType_' + index).prop("disabled", true);
    $('#ParamMapAlphaNum_' + index).prop("disabled", true);
    $('#ParamMapMin_' + index).prop("disabled", true);
    $('#ParamMapMax_' + index).prop("disabled", true);
  //  $('#ParamMapFreq_' + index).prop("disabled", true);
}

//***********Grid merging************//

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#EODParamMappingScreen :input:not(:button)").parent().removeClass('has-error');
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
        $("#EODParamMappingScreen :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/EODParameterMapping/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
          .done(function (result) {
              var getResult = JSON.parse(result);
              if (ActionType == "VIEW") {
                  $("#EODParamMappingScreen :input:not(:button)").prop("disabled", true);
                  //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
              }
              GetParamMappingBind(getResult)

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
            $.get("/api/EODParameterMapping/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Parameter Mapping BEMS', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Parameter Mapping BEMS', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}
function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#EODParamMapClss').val("null");
    $('#EODParamMapFrequency').val("null");
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');    
    $('#EODParamMapClss').attr('disabled', false);
    $('#EODParamMapModel').attr('disabled', true);
    $('#EODParamMapManu').attr('disabled', true);
    $("#grid").trigger('reloadGrid');
    $("#EODParamMappingScreen :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#EODParamMappingBody').empty();
    $(".content").scrollTop(1);
    AddNewRowEODParamMap();

    $('#paginationfooter').hide();
}

function effectiveFromValidation(event, index) {
    if (index > 0) {
        var a = $("#ParamMapEffFrom_" + index).val();
    }
}