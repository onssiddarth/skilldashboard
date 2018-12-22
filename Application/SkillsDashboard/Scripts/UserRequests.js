$(document).ready(function () {
    registerEvents();
    loadRequests();
    initialiseDataTable();//
});

function registerEvents() {
    $("#ddl_request").on("change", loadRequests);
}

function initialiseDataTable() {
    $('#tbl_UserRequests').DataTable({
        responsive: true
    });
}

function loadRequests() {
    var requestType = $("#ddl_request").val();
    var parameters = { 'argRequestType': requestType };

    $.ajax({
        type: "POST",
        url: URL["GetUserRequests"],
        data: parameters,
        success: function (response) {
            $("#div_UserRequestGrid").html(response);
            initialiseDataTable();
        },
        error: function (response) {
            console.log("Some error in application!");
        }

    })
}