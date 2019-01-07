
$(document).ready(function () {
    getDashBoardDetails();
    setAutopopulateForSearchEmployees();
    $("#btn_LoadEmployeeDetails").on("click", loadUserDetails);
    $("#lbl_UserTextError").hide();
});

//Onclick event for search button in dashboard
function loadUserDetails() {
   
    var UserSelected = $("#hdn_SearchDashboardFor").val();
    var UserName = $("#txt_SearchEmployee").val();

    if (!UserName || UserName.trim().length < 1) {
        $("#lbl_UserTextError").show();
        return false;
    }
    else {
        $("#lbl_UserTextError").hide();
        getDashBoardDetails(UserSelected);
    }
}

//This  function is used to fetch dashboard Details of user 
function getDashBoardDetails(argUserID) {

    $(".skill-dashboard-loader").show();

    var UserIDParam = '';
    if (argUserID && argUserID != null) {
        UserIDParam = argUserID;
    }
    else {
        UserIDParam = UserID;
    }
    var parameters = { 'argUserID': UserIDParam };

    $.ajax({
        type: "POST",
        url: URL["GetDashboardDetailsForUser"],
        data: parameters,
        success: function (response) {
            $("#div_dashboardDetails").html(response);
            $(".skill-dashboard-loader").hide();
        },
        error: function (response) {
            displayConfirmationMessage('Dashboard details could not be loaded successfully', 'alert-danger');
            $(".skill-dashboard-loader").hide();
        }

    })
}

//Set autocomplete for search textbox in dashboard
function setAutopopulateForSearchEmployees() {
    $("#txt_SearchEmployee").autocomplete({
        source: function (request, response) {
            $.ajax({
                url: URL["GetEmployeesByName"],
                type: "POST",
                dataType: "json",
                data: { argNamePrefix: request.term },
                success: function (data) {
                    response($.map(data, function (item) {
                        return { UserName: item.UserName, UserID: item.UserID };

                    }))
                }
            })
        },
        select: function (event, ui) {
            $(this).val(ui.item.UserName);
            $("#hdn_SearchDashboardFor").val(ui.item.UserID)
            return false;
        }
    }).data("ui-autocomplete")._renderItem = function (ul, item) {
        return $('<li>')
            .append("<a>" + item.UserName + "</a>")
            .appendTo(ul);
    };
}