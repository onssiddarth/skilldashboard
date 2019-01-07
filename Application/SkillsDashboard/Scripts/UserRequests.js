$(document).ready(function () {
    registerEvents();
    loadRequests();
    initialiseDataTable();
});

//Register change events for page
function registerEvents() {
    $("#ddl_request").on("change", loadRequests);
}

//Initialise datatable for grid
function initialiseDataTable() {
    $('#tbl_UserRequests').DataTable({
        responsive: true
    });
}

//AJAX call to load user requests
function loadRequests() {
    var requestType = $("#ddl_request").val();
    var parameters = { 'argRequestType': requestType };

    $(".skill-dashboard-loader").show();

    $.ajax({
        type: "POST",
        url: URL["GetUserRequests"],
        data: parameters,
        success: function (response) {
            $("#div_UserRequestGrid").html(response);
            initialiseDataTable();
            $(".skill-dashboard-loader").hide();
        },
        error: function (response) {
            console.log("Some error in application!");
            $(".skill-dashboard-loader").hide();
        }

    })
}