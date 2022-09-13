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


    $.get("/api/Dashboard/LoadDeductionChart/" + StartYear + "/" + StartMonth + "/" + EndYear + "/" + EndMonth + "/" + FacilityId +"/"+ UserId)
   .done(function (result) { 
       var getResult = JSON.parse(result);

       DeductionChart(getResult);

   })
.fail(function () {
    $('#myPleaseWait').modal('hide');
    var errorMessage = '';
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
    $('#errorMsg').css('visibility', 'visible');
});

});

/********************************** EquipUptime Chart Chart ***********************************/

function DeductionChart(getResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'pie',
            RenderTo: 'DeductionChart',
            customDataLabels: "RM",
            Legend: { enabled: true },
            tooltip: {
                formatter: function () {
                    // return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y);
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + "RM " + addCommas(this.y.toFixed(2));
                }
            },
            Series: [{
                name: "Deduction",
                data: DeductionChartdataOptions(getResult)
            }]
        }
        CommonChart(ChartOptions);
    })();
}
function DeductionChartdataOptions(getResult) {

    var EquipmentCat = []; var Cost = []; var Perc = []; var arr = [];
    for (ind = 0; ind < getResult.DeductionChartData.length; ind++) {
        EquipmentCat = getResult.DeductionChartData[ind].Name;
        Cost = getResult.DeductionChartData[ind].Cost;
       // Perc = getResult.DeductionChartData[ind].Percentage;
        Col = ChartColor(ind);
        arr.push({ name: EquipmentCat, y: Cost, per:Perc, color: Col });
    }
    return arr;
}

function ChartColor(ind) {
    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']

    return colors[ind];
}