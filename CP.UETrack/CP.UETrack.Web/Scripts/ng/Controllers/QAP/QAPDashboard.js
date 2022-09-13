$(document).ready(function () {
   // InitChartCall();


    //******************************** Load DropDown ***************************************

    $.get("/api/QAPDashboard/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);       

       $.each(loadResult.QAPDashboardServiceTypeData, function (index, value) {
           $('#QAPDashService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });  

       var primaryId = $('#primaryID').val();
       if (primaryId != null && primaryId != "0") {
           getByYear(Year);
           getByMonth(month);
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

//*************************************** Chart Start ***********************************



function InitChartCall(getresult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'column',
            RenderTo: 'QAP_Dashboard_Performance_Chart',
            Legend: { enabled: true },
            Series: [{
                name: "Equipment Uptime",
                data: [{
                    name: 'Genereal', y: 107, color: "#90ED7D"
                }, {
                    name: 'Radialogy', y: 122, color: "#F7A35B"
                }, {
                    name: 'Dialysis', y: 157, color: "#7CB5EC"
                }, {
                    name: 'Life Support', y: 101, color: "#434348"
                }, {
                    name: 'Therapeutic', y: 95, color: "#F45A5A"
                }]
            }]
        }
        CommonChart(ChartOptions);
    })();
    

    (function () {
        ChartOptions = {
            ChartType: 'line',
            RenderTo: 'QAP_Dashboard_Month_Chart',
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


//****************************************** GetById BarChart *******************************************


var Year = (new Date()).getFullYear();
function getByYear(Year) {
    $.get("/api/QAPDashboard/Get/" + Year)
            .done(function (result) {
                var getresult = JSON.parse(result);
                var ChartOptions;


                InitChartCall(getresult)
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

//****************************************** GetById LineChart *******************************************


var month = 6;
function getByMonth(month) {
    $.get("/api/QAPDashboard/GetLineChart/" + month)
            .done(function (result) {
                var loadresult = JSON.parse(result);
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