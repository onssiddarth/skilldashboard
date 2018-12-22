$(document).ready(function () {
    registerEvents();
    SetVisibilityOfFileUpload();
});

//This function is used to register all click/change events in page
function registerEvents() {
    $("#ddl_mode").on("change", SetVisibilityOfFileUpload);//change event for mode dropdown
    $("#ddl_skill").on("change", selectSubskill); //change event for skills dropdown
}

function SetVisibilityOfFileUpload() {
    var modeSelected = $("#ddl_mode").val();

    if (modeSelected.toUpperCase() == "CERTIFICATE") {
        $(".file-upload").show();
    }
    else {
        $(".file-upload").hide();
    }
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