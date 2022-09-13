//To Be Done 
//   On selecting status is inactive disable effective from date 
var glaobaldata = [];

$(document).ready(function () {
    $('#dataTable1212').hide();
    $('#myPleaseWait').modal('show');
    formInputValidation("StandardTaskform");
    $('#txtAssetTypeCode').prop('disabled', false);
    $("#popupsearch").show();


    //Save 
    $("#btnSave,#btnEdit").click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var ServiceId = $('#ServiceId').val();
        var WorkGroupId = $('#WorkGroupId').val();
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        var AssetTypeCode = $('#txtAssetTypeCode').val();
        var AssetTypeDescription = $('#txtAssetTypeDesc').val();
        var timeStamp = $("#Timestamp").val();



        //Standardtask details grid 
        var _index;        // var _indexThird;
        var result = [];
        var finalResult = [];
        $('#detgrid tr').each(function () {
            _index = $(this).index();
        });
        for (var i = 0; i <= _index; i++) {
            var active = true;
            if ($('#Active_' + i).is(":checked")) {
                active = false;
                // it is checked
            }
            var _tempObj = {
                StandardTaskDetId: $('#StandardTaskDetId_' + i).val(),
                StandardTaskId: $("#primaryID").val(),
                TaskCode: $('#TaskCode_' + i).val(),
                TaskDescription: $('#TaskDescription_' + i).val(),
                ModelId: $('#ModelId_' + i).val(),
                PPMId: $('#PPMId_' + i).val(),
                OGWI: $('#hdnOGWIDesc' + i).val(),
                EffectiveFrom: $('#EffectiveFrom_' + i).val(),
                Status: $('#Status_' + i).val(),
                Active: active,
            }
            result.push(_tempObj);
        }

        $.each(result, function (index, data) {
            if (data.StandardTaskDetId == 0 && !data.Active) {
            }
            else {
                finalResult.push(data);
            }
        });
        var isFormValid = formInputValidation("StandardTaskform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }
        else if (result == null || result == "") {
            $("div.errormsgcenter").text(Messages.StandardTaskLGrid_OneRow_MIn);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        else if (!validateGridRows(finalResult)) {
            $("div.errormsgcenter").text(Messages.StandardTaskLGrid_OneRow_MIn);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        else if (!validateGridRequredFields(result)) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        else if (!validateEffectiveFromDate(finalResult)) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var Standardtast = {};
        Standardtast.ServiceId = ServiceId;
        Standardtast.WorkGroupId = WorkGroupId;
        Standardtast.AssetTypeCodeId = AssetTypeCodeId;
        Standardtast.AssetTypeCode = AssetTypeCode;
        Standardtast.AssetTypeCodeStandardTasksDets = finalResult;

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            Standardtast.StandardTaskId = primaryId;
            Standardtast.Timestamp = timeStamp;
        }
        else {
            Standardtast.StandardTaskId = 0;
            Standardtast.Timestamp = "";
        }

        var jqxhr = $.post("/api/StandardTask/Add", Standardtast, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.StandardTaskId);
            $("#Timestamp").val(result.Timestamp);
            $('#txtAssetTypeCode').prop('disabled', true);
            $("#popupsearch").hide();
            FillHeaderData(result);
            if (result.AssetTypeCodeStandardTasksDets != null && result.AssetTypeCodeStandardTasksDets.length > 0) {
                $('#dataTable1212').show();
                BindDetailGrid(result.AssetTypeCodeStandardTasksDets);
            }
            $('#myPleaseWait').modal('hide');
            $(".content").scrollTop(0);
            showMessage('Standard Tast', CURD_MESSAGE_STATUS.DS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            
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
    });


    function validateEffectiveFromDate(finalResult) {
        var isDateMandatory = true;
        for (var i = 0; i < finalResult.length ; i++) {
            if (/*finalResult[i].Status == 1 &&*/ (finalResult[i].EffectiveFrom == null || finalResult[i].EffectiveFrom == undefined || finalResult[i].EffectiveFrom == '')) {
                isDateMandatory = false;
                break;
            }
        }
        return isDateMandatory;
    }
    function validateGridRequredFields(result) {
        var count = 0;
        if (result != null) {
            $.each(result, function (index, data) {
                if (data.TaskDescription == "" && data.Active) {
                    $('#TaskDescription_' + index).parent().addClass('has-error');
                    count++;
                }
                else {
                    $('#TaskDescription_' + index).parent().removeClass('has-error');
                }

                if (data.EffectiveFrom == "" && data.Active) {
                    $('#EffectiveFrom_' + index).parent().addClass('has-error');
                } else {
                    $('#EffectiveFrom_' + index).parent().removeClass('has-error');
                }
            });

            if (count > 0) {
                return false;
            }
            else return true;
        }

    }

    function validateGridRows(list) {
        var count = 0;
        if (list != null) {
            $.each(list, function (index, data) {
                if (data.Active == true) {
                    count++;
                }
            });
            if (count > 0) {
                return true;
            }
            else return false;
        }
    }

    $.get("/api/StandardTask/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $('#Service').val(loadResult.ServiceName);
            $.each(loadResult.StatusList, function (index, value) {
                $('.StatusDet').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $.each(loadResult.EngAssetWorkGroupList, function (index, value) {
                $('#WorkGroupId').append('<option value="' + value.WorkGroupId + '">' + value.WorkGroupCode + '</option>');
            });
            $('#WorkGroupId').val(1);
            $('#WorkGroupName').val(loadResult.WorkGroupName);


            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0") {
                $.get("/api/StandardTask/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $('#txtAssetTypeCode').prop('disabled', true);
                      $("#popupsearch").hide();
                      FillHeaderData(getResult);
                      if (getResult.AssetTypeCodeStandardTasksDets != null && getResult.AssetTypeCodeStandardTasksDets.length > 0) {
                          $('#dataTable1212').show();
                          BindDetailGrid(getResult.AssetTypeCodeStandardTasksDets);
                      }

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
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });



    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/BEMS/AssetTypeCodeStandardTasks";
    });


    function FillHeaderData(getResult) {
        $('#ServiceId').val(getResult.ServiceId);
        $('#WorkGroupId').val(getResult.WorkGroupId);
        $('#WorkGroupName').val(getResult.WorkGroupName);
        $('#hdnAssetTypeCodeId').val(getResult.AssetTypeCodeId);
        $('#txtAssetTypeCode').val(getResult.AssetTypeCode);
        $('#txtAssetTypeDesc').val(getResult.AssetTypeDescription);
        //var gridList = res
        $('#Timestamp').val(getResult.Timestamp);
        $('#primaryID').val(getResult.StandardTaskId);

    }

    var typeCodeSearchObj = {
        Heading: "Type Code Details",//Heading of the popup
        SearchColumns: ['AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//ModelProperty - Space seperated label value
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description', 'AssetClassificationCode-Asset Classification Code'],//Columns to be returned for display
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDesc-AssetTypeDescription"], //id of element - the model property
        ScreenName: 'StandardTaskDetails'
    };

    var apiUrlForTypeCodeSearch = "/api/Search/TypeCodeSearch";

    $('#spnPopup-staff').click(function () {
        DisplaySeachPopup('divSearchPopup', typeCodeSearchObj, apiUrlForTypeCodeSearch);
    });
    //----------------------------------------------------------

    //------------------------Fetch-----------------------------
    var typeCodeFetchObj = {
        SearchColumn: 'txtAssetTypeCode-AssetTypeCode',//Id of Fetch field
        ResultColumns: ["AssetTypeCodeId-Primary Key", 'AssetTypeCode-Asset Type Code', 'AssetTypeDescription-Asset Type Description'],//Columns to be displayed
        FieldsToBeFilled: ["hdnAssetTypeCodeId-AssetTypeCodeId", "txtAssetTypeCode-AssetTypeCode", "txtAssetTypeDesc-AssetTypeDescription"],//id of element - the model property
        ScreenName: 'StandardTaskDetails'

    };

    var apiUrlForTypeCodeFetch = "/api/Fetch/TypeCodeFetch";

    $('#txtAssetTypeCode').on('input propertychange paste keyup', function (event) {
        DisplayFetchResult('divFetch', typeCodeFetchObj, apiUrlForTypeCodeFetch, "UlFetch", event, 1);//1 -- pageIndex
    });


    //$("select[id^='sels']"
    $("#hdnAssetTypeCodeId").change(function () {
        $("#detgrid").empty();
        $('#dataTable1212').hide();
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var AssetTypeCodeId = $('#hdnAssetTypeCodeId').val();
        if (AssetTypeCodeId != null && AssetTypeCodeId != "0" && AssetTypeCodeId != "") {
            $.get("/api/StandardTask/GetTaskCodeList/" + AssetTypeCodeId)
              .done(function (result) {
                  var getResult = JSON.parse(result);
                  if (getResult.AssetTypeCodeStandardTasksDets != null && getResult.AssetTypeCodeStandardTasksDets.length > 0) {
                      $('#dataTable1212').show();
                      BindDetailGrid(getResult.AssetTypeCodeStandardTasksDets);
                      glaobaldata = getResult.AssetTypeCodeStandardTasksDets;
                  }
                  $('#myPleaseWait').modal('hide');
              })
             .fail(function () {
                 $('#myPleaseWait').modal('hide');
                 $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                 $('#errorMsg').css('visibility', 'visible');
             });
        }
    });

    $(".nav-tabs > li:not(:first-child)").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            $("div.errormsgcenter1").text("");
            $('#errorMsg1').css('visibility', 'hidden');
            var StandardTaskId = $('#primaryID').val();
            $('#histAssetTypeCode').val($('#txtAssetTypeCode').val());
            $('#histAssetTypeCodeDesc').val($('#txtAssetTypeDesc').val());
            $.get("/api/StandardTask/GetTaskCodeHistory/" + StandardTaskId)
           .done(function (result) {
               var getHistory = JSON.parse(result);
               $("#historygridId").empty();
               if (getHistory != null && getHistory.EngAssetTypeCodeStandardTasksHistoryDets != null && getHistory.EngAssetTypeCodeStandardTasksHistoryDets.length > 0) {
                   var html = '';
                   $(getHistory.EngAssetTypeCodeStandardTasksHistoryDets).each(function (index, data) {
                       data.EffectiveFrom = (data.EffectiveFrom != null) ? DateFormatter(data.EffectiveFrom) : "";
                       html += '<tr class="ng-scope" style=""><td width="20%" style="text-align:left;"><div> ' +
                               ' <input type="text" id="TaskCode_' + index + '" value="' + data.TaskCode + '"  class="form-control " readonly></div></td>' +
                                '<td width="40%" style="text-align:left;"><div> ' +
                                '<input type="text" id="TaskDescription_' + index + '" value="' + data.TaskDescription + '" style="max-width:100%" class="form-control " readonly></div></td><td width="20%" style="text-align:left;" ><div> ' +
                                '<input type="text" id="StatusName_' + index + '" value="' + data.StatusName + '" class="form-control" readonly></div></td><td width="20%" style="text-align:left;"><div> ' +
                                '<input type="text" id="EffectiveFrom_' + index + '" value="' + data.EffectiveFrom + '" class="form-control" readonly></div></td></tr>';

                   });
                   $("#historygridId").append(html);
                   $('#myPleaseWait').modal('hide');
               }
               else {
                   $('#myPleaseWait').modal('hide');
                   $("div.errormsgcenter1").text(Messages.NO_RECORD_FOUND);
                   $('#errorMsg1').css('visibility', 'visible');
               }

           })
       .fail(function () {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter1").text(Messages.COMMON_FAILURE_MESSAGE);
           $('#errorMsg1').css('visibility', 'visible');
       });
        }
    });

});
function BindDetailGrid(list) {

    var ActionType = $('#ActionType').val();

    $("#detgrid").empty();

    if (list.length > 0) {
        var html = '';
        $(list).each(function (index, data) {

            data.TaskDescription = (data.TaskDescription == null) ? "" : data.TaskDescription;
            // data.EffectiveFrom = (data.EffectiveFrom == null) ? "" : data.EffectiveFrom;
            data.EffectiveFrom = (data.EffectiveFrom != null) ? DateFormatter(data.EffectiveFrom) : "";
            html += '<tr>';
            html += '<td width="5%" id="standardTaskDetailsDel"> <div class="checkbox text-center"> <label for="checkboxes-0"> ';
            html += '<input type="checkbox"  id="Active_' + index + '" name="standardTaskDetailsCheckboxes" class= "clearErrorLine" tabindex="0"> </label> </div>';
            html += '</td>';
            html += '<td width="15%" style="text-align: center;"> <div>';
            html += '<input type="hidden" id="PPMId_' + index + '" value="' + data.PPMId + '" name="PPMId"/>';
            html += '<input type="hidden" id="StandardTaskDetId_' + index + '" value="' + data.StandardTaskDetId + '" name="StandardTaskDetId"/>';
            html += '<input type="text" id="TaskCode_' + index + '"  value="' + data.TaskCode + '" name="TaskCode" class="form-control" readonly="readonly"> </div>';
            html += '</td>';
            html += '<td width="20%" style="text-align: center;"> <div> ';
            html += '<input  id="TaskDescription_' + index + '" value="' + data.TaskDescription + '" type="text" class="form-control validate" name="TaskDescription" maxlength="500"> </div>';
            html += '</td>';
            html += '<td width="12%" style="text-align: center;"> <div> ';
            html += '<input type="hidden" id="ModelId_' + index + '" value="' + data.ModelId + '" name="ModelId"/> ';
            html += '<input id="Model_' + index + '" value="' + data.Model + '" type="text" class="form-control" name="Model" readonly="readonly" maxlength="25"> </div>';
            html += '</td>';

            html += '<td width="15%" style="text-align: center;"> <div> ';
            html += ' <a class="glyphicon glyphicon-download-alt" id="PPMChecklistNo_' + index + '"   onclick="downloadfiles(' + data.DocumentId + ')"    value="' + data.PPMChecklistNo + '"></a> &nbsp;';
            html += '<a href="#" tabindex="0"  id="PPMChecklistNo_' + index + '" value="' + data.PPMChecklistNo + '"style="">' + data.PPMChecklistNo + '</a>';
            html += '</div></td>';
            html += '<td width="9%" style="text-align: center;"> <input type="hidden" id="hdnOGWIDesc' + index + '"/> <div> ';
            html += '<a data-toggle="modal"  onclick="UpdateOCW(' + index + ')"  class="btn btn-sm btn-primary btn-info btn-lg" data-target="#myModal">';
            html += ' <span class="glyphicon glyphicon-modal-window btn-info"     role="button" tabindex="0"></span> </a> </div>';
            html += '</td>';
            html += '<td width="12%" style="text-align: center;"> <div> ';
            html += '<select  required id="Status_' + index + '"  value="' + data.Status + '" class="form-control" name="Status"> <option selected value="1">Active</option> <option value="2">Inactive</option> </select> </div></td>';
            html += '<td width="12%" style="text-align: center;"> <div>';
            html += ' <input type="text" id="EffectiveFrom_' + index + '" value="' + data.EffectiveFrom + '"  class="form-control datetimeNoFuture validateDate" name="EffectiveFrom"/> </div>';
            html += '</td>';
            html += '</tr>';
        });

        $('#detgrid').append(html);
        $('.datetimeNoFuture').datetimepicker({
            format: 'd-M-Y',
            timepicker: false,
            step: 15,
            scrollInput: false,
            onChangeDateTime: function (dp, $input) {
                if ($input.val() !== "")
                    $($input).parent().removeClass('has-error');
            },
        });

        $(list).each(function (index, data) {
            if (data.Active)
                $("#Active_" + index).prop('checked', false);
            else $("#Active_" + index).prop('checked', true);
            $("#Status_" + index).val(data.Status);
            $("#hdnOGWIDesc" + index).val(data.OGWI);
        });

        var ActionType = $('#ActionType').val();
        if (ActionType == "VIEW") {
            $(list).each(function (index, data) {
                $("#TaskDescription_" + index).prop('disabled', true);
                $("#Status_" + index).prop('disabled', true);
                $("#EffectiveFrom_" + index).prop('disabled', true);
            });
        }

        $(".validate").keyup(function (e) {
            var ind = $(this).closest('tr').index();
            if ($("#TaskDescription_" + ind).val() != "" && $("#TaskDescription_" + ind).val() != null) {
                $('#TaskDescription_' + ind).parent().removeClass('has-error');
            }
            else {
                $('#TaskDescription_' + ind).parent().addClass('has-error');
            }
        });

        if (ActionType == "View") {
            if (list != null && list.length > 0) {

                $(list).each(function (index, data) {
                    $('#Active_' + index).prop('disabled', true);
                    $('#TaskDescription_' + index).prop('disabled', true);
                    $('#OGWI').prop('disabled', true);
                    $('#Status_' + index).prop('disabled', true);
                    $('#EffectiveFrom_' + index).prop('disabled', true);
                });
            }

        }
    }

    function UpdateOCW(index) {
        $('#indexvalue').val(index);
        $('#OGWI').val($("#hdnOGWIDesc" + index).val());
    }

    function updateOG() {
        var index = $('#indexvalue').val();
        glaobaldata[index].OGWI = $('#OGWI').val();
        $("#hdnOGWIDesc" + index).val($('#OGWI').val());
    }

    $("#btnCancelHist").click(function () {
        window.location.href = "/BEMS/AssetTypeCodeStandardTasks";
    });


}
function downloadfiles(DocumentId) {

    //console.log(event);
    //return;

    if (DocumentId != 0 && DocumentId != undefined && DocumentId != "0") {
        $.get("/api/PPMRegister/Download/" + DocumentId)
                  .done(function (result) {
                      var data = JSON.parse(result);
                      var FileName = data.FileName;
                      var ContentType = "item.st"
                      var Gid = "";
                      // /bems/general/Print?Gid=BA9899AC-E7C6-4322-971A-0F30F64FCFCD&FileName=ba9899ac-e7c6-4322-971a-0f30f64fcfcd_fff.jpeg&ContentType={{item.st}}
                      window.location.href = "/BEMS/General/Print?Gid=" + Gid + "&FileName=" + FileName + "&ContentType=" + ContentType;
                      //  window.location.href = '@Url.Action("Add", "General", new { Gid = "", FileName =filename, ContentType= ctype })';
                      $('#myPleaseWait').modal('hide');

                  })
                 .fail(function () {
                     $('#myPleaseWait').modal('hide');
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                     $('#errorMsg').css('visibility', 'visible');
                 });
    }




}
