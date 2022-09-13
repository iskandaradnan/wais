$(document).ready(function () {
    InitChartCall();


//***************************************** Load DropDown ******************************************

    $.get("/api/KPIDashboard/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       var date = new Date();
       var month = date.getMonth();
       var currentMonth = month + 1;

       $.each(loadResult.Years, function (index, value) {
           $('#KPIDashYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $('#KPIDashYear').val(loadResult.CurrentYear);

       $.each(loadResult.MonthListTypedata, function (index, value) {
           $('#KPIDashMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $('#KPIDashMonth option[value="' + currentMonth + '"]').prop('selected', true);
     
       var kpiyear = $('#KPIDashYear').val();
       var kpimonth = $('#KPIDashMonth').val();
       getByKPIDashboard(kpiyear, kpimonth);

       var primaryId = $('#primaryID').val();
       if (primaryId != null && primaryId != "0") {
           getById(Year);

       }
       else {
           $('#myPleaseWait').modal('hide');

       }
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       var errorMessage = '';
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });

});


//***************************************** Chart Start ********************************************


function InitChartCall(getresult) {
    var ChartOptions;

    //Work Order Chart
    (function () {
        ChartOptions = {
            ChartType: 'line',
            RenderTo: 'KPI_Dashboard_Value_Chart',
            Legend: { enabled: true },
            Series: [{
                name: "Active",
                color: "#90ED7D",
                data: [{
                    name: 'Jan', y: 107
                }, {
                    name: 'Feb', y: 122
                }, {
                    name: 'Mar', y: 157
                }, {
                    name: 'Apr', y: 101
                }]
            },
            {
                name: "Closed",
                color: "#434348",
                data: [{
                    name: 'Jan', y: 155
                }, {
                    name: 'Feb', y: 111
                }, {
                    name: 'Mar', y: 198
                }, {
                    name: 'Apr', y: 155
                }]
            }]
        }
        CommonChart(ChartOptions);

        //ChartOptions.Series = SeriesDataFormation(getResult, "KPI_Dashboard_Value_Chart");
        //    ChartOptions.Err = ChartOptions.Series;
        //    CommonChart(ChartOptions);
    })();

    (function () {
        ChartOptions = {
            ChartType: 'line',
            RenderTo: 'KPI_Dashboard_Year_Chart',
            Legend: { enabled: true },
            Series: [{
                name: "Active",
                color: "#90ED7D",
                data: [{
                    name: 'Jan', y: 107
                }, {
                    name: 'Feb', y: 122
                }, {
                    name: 'Mar', y: 157
                }, {
                    name: 'Apr', y: 101
                }]
            },
            {
                name: "Closed",
                color: "#434348",
                data: [{
                    name: 'Jan', y: 155
                }, {
                    name: 'Feb', y: 111
                }, {
                    name: 'Mar', y: 198
                }, {
                    name: 'Apr', y: 155
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();
}


function SeriesDataFormation(SeriesData, SeriesName) {

    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    var Series = [{
        name: SeriesName,
        data: []
    }];

    if (SeriesData && SeriesData.length) {
        for (var i = 0; i < SeriesData.length; i++) {
            var innerTemp = {
                name: SeriesData[i].ItemName,
                y: SeriesData[i].ItemValues,
                color: colors[i],
            }

            Series.data.push(innerTemp);
        }
        return Series;
    } else {
        return [];
    }

}


//****************************************** AddNewRow **********************************************

function AddNewRowKPIDashboard() {

    var inputpar = {
        inlineHTML: ' <tr> <input type="hidden" id="hdnkpidashDetId_maxindexval"> <td width="20%" style="text-align: center;" title="Service"> <div> <input type="text" class="form-control" id="KPIDashService_maxindexval" readonly="readonly"> </div></td><td width="30%" style="text-align: center;" title="MonthlyServiceFee(RM)"> <div> <input type="text" class="form-control" id="KPIDashRM_maxindexval" readonly="readonly"> </div></td><td width="25%" style="text-align: center;" title="Deduction Value"> <div> <input type="text" class="form-control" id="KPIDashDeduction_maxindexval" readonly="readonly"> </div></td><td width="25%" style="text-align: center;" title="Penalty"> <div> <input type="text" class="form-control" id="KPIDashPenalty_maxindexval" readonly="readonly"> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#KPIDashboardTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
}


//****************************************** GetById Chart *******************************************


var Year = (new Date()).getFullYear();
function getById(Year) {
    $.get("/api/KPIDashboard/get/" + Year)
            .done(function (result) {
                var getresult = JSON.parse(result);
                var ChartOptions;

                //ChartOptions.Series = SeriesDataFormation(getresult.KPIDashboardChartListData[0], "KPI_Dashboard_Value_Chart");
                //ChartOptions.Err = ChartOptions.Series;
                //CommonChart(ChartOptions);
                

                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
}


//************************************** Onchange Year & Month ***************************************


$('#KPIDashYear,#KPIDashMonth').on('change', function () {

    var kpiyear = $('#KPIDashYear').val();
    var kpimonth = $('#KPIDashMonth').val();

    if (kpiyear != '0' && kpiyear != 'null' && kpimonth != '0' && kpimonth != 'null') {
        getByKPIDashboard(kpiyear, kpimonth);
    }
    else {        
        $("#KPIDashboardTbl").empty();
        $('#myPleaseWait').modal('hide');
    }
});

function getByKPIDashboard(kpiyear, kpimonth) {
    $.get("/api/KPIDashboard/GetDate/" + kpiyear + "/" + kpimonth)
            .done(function (result) {
                var loadResult = JSON.parse(result);

                $('#KPIDashYear option[value="' + loadResult.Year + '"]').prop('selected', true);
                $('#KPIDashMonth option[value="' + loadResult.Month + '"]').prop('selected', true);

                $("#KPIDashboardTbl").empty();
                $.each(loadResult.KPIDashboardListData, function (index, value) {
                    AddNewRowKPIDashboard();
                    $("#hdnkpidashDetId_" + index).val(loadResult.KPIDashboardListData[index].KPIDashboardId);
                    $("#KPIDashService_" + index).val(loadResult.KPIDashboardListData[index].ServiceName).prop("disabled", "disabled");
                    $("#KPIDashRM_" + index).val(loadResult.KPIDashboardListData[index].MSF).prop("disabled", "disabled");
                    $("#KPIDashDeduction_" + index).val(loadResult.KPIDashboardListData[index].DeductionValue).prop("disabled", "disabled");
                    $("#KPIDashPenalty_" + index).val(loadResult.KPIDashboardListData[index].PenaltyValue).prop("disabled", "disabled");
                });
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                var errorMessage = '';
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
}