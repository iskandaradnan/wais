var aaa = [];

$(document).ready(function () {

    $('#myPleaseWait').modal('show');

    var StartYear;
    var StartMonth;
    var EndYear;
    var EndMonth;

    StartMonth = $("#StartMonth").val();
    StartYear = $("#StartYear").val();
    EndMonth = $("#EndMonth").val();
    EndYear = $("#EndYear").val();

    //StartYear = (new Date).getFullYear();
    //StartMonth = (new Date).getMonth() + 1;
    //EndYear = (new Date).getFullYear();
    //EndMonth = (new Date).getMonth() + 1;
    var FacilityId = 0;
    var UserId = 0;


    $.get("/api/Dashboard/LoadExpiryAlertChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId + "/" + UserId)
              .done(function (result) {
                  var getResult = JSON.parse(result);

                  ExpiryAlertChart(getResult);

                  //$.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
                  //      .done(function (result) {
                  //          var getResult = JSON.parse(result);

                  //          MainCostChart(getResult);

                  //     // $.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth)


                  //          $('#myPleaseWait').modal('hide');
                  //      })
                  //     .fail(function () {
                  //         $('#myPleaseWait').modal('hide');
                  //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                  //         $('#errorMsg').css('visibility', 'visible');
                  //     });
              })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            var errorMessage = '';
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

/********************************** Work order Chart ***********************************/

function ExpiryAlertChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'pie',
            RenderTo: 'ExpiryAlertChart',
            Legend: { enabled: true },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y) +
                      '<br>' + '<span style="color:' + this.color + '">\u25CF</span> ' + 'Perc' + ' : ' + addCommas(this.point.per) + ' %';
                }
            },
            Series: [{
                name: "Expiry Alert",
                //color: "#8A8FEB",
                data: ExpiryAlertChartdataOptions(getResult)
                //data: SeriesDataFormationNew(getResult)

            }]
        }
        CommonChart(ChartOptions);
    })();
}
function ExpiryAlertChartdataOptions(getResult) {

    var workOrdStstus = []; var year = []; var WorkorderCount = []; var Col = []; var arr = []; var perc = [];

    // var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
    //     '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
    //'#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    for (ind = 0; ind < getResult.ExpiryAlertChartData.length; ind++) {
        workOrdStstus = getResult.ExpiryAlertChartData[ind].Name;
        WorkorderCount = getResult.ExpiryAlertChartData[ind].Count;
        perc = getResult.ExpiryAlertChartData[ind].Percentage;
        Col = ChartColor(ind);
        arr.push({ name: workOrdStstus, y: WorkorderCount, per:perc, color: Col });
    }
    return arr;
}

function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}