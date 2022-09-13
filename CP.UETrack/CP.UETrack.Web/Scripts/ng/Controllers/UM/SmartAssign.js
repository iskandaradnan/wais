$(document).ready(function () {
    $("#jQGridCollapse1").click(function () {
        $(".jqContainer").toggleClass("hide_container");
    })
    $('#jQGridCollapse1').click();
    SmartAssignGetAll();
    function SmartAssignGetAll() {

        //$.get("/api/smartAssigning/SmartAssignGetAll")
        //         .done(function (result) {

        //         })
        //         .fail(function () {
 
        //         });
    }

    $("#btnFetch").click(function () {
        $.get("/api/smartAssigning/RunSmartAssign")
                 .done(function (result) {

                 })
                 .fail(function () {

                 });
    });
    function SmartAssign() {

        $.get("/api/smartAssigning/RunSmartAssign")
                 .done(function (result) {

                 })
                 .fail(function () {

                 });
    }
});