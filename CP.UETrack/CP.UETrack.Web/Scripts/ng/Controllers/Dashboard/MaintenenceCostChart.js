var aaa = [];
var currency;
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


    $.get("/api/Dashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId)
                .done(function (result) {
                    var getResult = JSON.parse(result);

                    currency = getResult.CurrencyFormat;
                    MainCostChart(getResult);

                    // $.get("/api/HomeDashboard/LoadMaintCostChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth)


                    $('#myPleaseWait').modal('hide');
                })
               .fail(function () {
                   $('#myPleaseWait').modal('hide');
                   $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                   $('#errorMsg').css('visibility', 'visible');
               });


});

/********************************** Asset Maintenance Cost Chart ***********************************/

//(<span class="spnCurrencyName"></span>)

function MainCostChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'pie',
            RenderTo: 'MaintenanceCostChart',
            customDataLabels: "RM",
            Legend: { enabled: true },
            tooltip: {
                formatter: function () {
                   // return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + "RM " + addCommas(this.y.toFixed(2));
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + '<span class="spnCurrencyName"></span>' + addCommas(this.y.toFixed(2));
                }
            },
            Series: [{
                name: "Active",
                //color: "#8A8FEB",
                data: MainCostChartdataOptions(getResult)
            }]
        }
        CommonChart(ChartOptions);
    })();
}
function MainCostChartdataOptions(getResult) {

    var MainCostCat = []; var MaintenCost = []; var arr = [];
    for (ind = 0; ind < getResult.MaintenanceCostChartData.length; ind++) {
        MainCostCat = getResult.MaintenanceCostChartData[ind].MaintenCat;
        MaintenCost = getResult.MaintenanceCostChartData[ind].Cost;
        Col = ChartColor(ind);
        arr.push({ name: MainCostCat, y: MaintenCost, color: Col });
    }
    return arr;
}

function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}