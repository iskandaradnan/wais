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


    $.get("/api/Dashboard/LoadBERAssetChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId + "/" + UserId)
              .done(function (result) {
                  var getResult = JSON.parse(result);

                  BERAssetChart(getResult);

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

function BERAssetChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'column',
            RenderTo: 'BerAssetChart',
            Legend: { enabled: false },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.point.sts + ' : ' + addCommas(this.y) +
                    '<br>' + '<span style="color:' + this.color + '">\u25CF</span> ' + this.point.sts + ' Perc' + ' : ' + addCommas(this.point.per) + ' %';
                }
            },
            Series: [{
                name: "BER Asset",
                color: "#90ED7D",
                data: BERAssetChartdataOptions(getResult)
                //data: SeriesDataFormationNew(getResult)

            },
            {
                name: "BER Asset2",
                color: "#F7A35B",
                data: BERAssetChartdataOptions1(getResult)
            }
            ]
        }
        CommonChart(ChartOptions);
    })();
}
function BERAssetChartdataOptions(getResult) {

    var BerName = []; var year = []; var BerCount = []; var Col = []; var arr = []; var perc = []; var name = [];

    // var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
    //     '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
    //'#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    for (ind = 0; ind < getResult.BERAssetChartData.length; ind++) {
        BerName =  getResult.BERAssetChartData[ind].Name;
        BerCount = getResult.BERAssetChartData[ind].Count;
        perc = getResult.BERAssetChartData[ind].Percentage;
        //Col = ChartColor(ind);
        name = 'BER1 ' + getResult.BERAssetChartData[ind].Name;
        arr.push({ name: BerName, y: BerCount, per: perc, sts: name });
    }
    return arr;
}

function BERAssetChartdataOptions1(getResult) {

    var BerName2 = []; var year = []; var BerCount2 = []; var Col = []; var arr2 = []; var percn = []; var name2 = [];

    // var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
    //     '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
    //'#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    for (ind = 0; ind < getResult.BERAssetChartData.length; ind++) {
        BerName2 = getResult.BERAssetChartData[ind].Name;
        BerCount2 = getResult.BERAssetChartData[ind].BER2Count;
        percn = getResult.BERAssetChartData[ind].BER2Percentage;
        //Col = ChartColor(ind);
        name2 = 'BER2 ' + getResult.BERAssetChartData[ind].Name;
        arr2.push({ name: BerName2, y: BerCount2, per: percn, sts: name2 });
    }
    return arr2;
}

function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}