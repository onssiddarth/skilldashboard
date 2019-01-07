$(document).ready(function () {
    registerEvents();
});

//This function is used to register all click/change events in page
function registerEvents() {
    $("#ddl_skill").on("change", selectSubskill); //change event for skills dropdown
}

//Ajax function to populate subskills on the basis of skill selection
function selectSubskill() {

    var skill = $("#ddl_skill").val();
    var parameters = { 'argSkillID': skill };

    $(".skill-dashboard-loader").show();

    $.ajax({
        type: "POST",
        url: URL["GetSubskills"],
        data: parameters,
        success: function (response) {
            $("#div_subskills").html(response);
            $("#div_subskillWrapper").show();
            $(".skill-dashboard-loader").hide();
        },
        error: function (response) {
            displayConfirmationMessage('Subskills could not be loaded', 'alert-danger'); 
            $(".skill-dashboard-loader").hide();
        }

    })
}