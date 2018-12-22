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
    
    $.ajax({
        type: "POST",
        url: URL["GetSubskills"],
        data: parameters,
        success: function (response) {
            $("#div_subskills").html(response);
            $("#div_subskillWrapper").show();
        },
        error: function (response) {
            console.log("Some error in application!");
        }

    })
}