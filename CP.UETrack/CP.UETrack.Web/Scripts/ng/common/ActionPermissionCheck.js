function changeHashOnLoad() {
    
    $.get("/api/account/GetPermissionCheck", function (data) {       
        if(data==false)
        {
         window.location.href = "/account/Logoff";
        }
    });
       
    

}