//AJAX call used to get subskills on the basis of skill selected
function getSubskills() {
    var skill = $("#ddl_skill").val();

    var parameters = { 'argSkillID': skill };

    if (!skill) {
        $("#skill-error").show();
        $("#subskill-error").show();
        $("#ddl_subskill").html('');
    }
    else {
        $("#skill-error").hide();
        $("#subskill-error").hide();
    }

    $(".skill-dashboard-loader").show();


    $.ajax({
        type: "POST",
        url: URL["GetSubskills"],
        data: JSON.stringify(parameters),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $('#ddl_subskill').html('');
            var optionsAsString = "";
            
            for (var i = 0; i < response.length; i++) {
                optionsAsString += "<option value='" + response[i].SubSkillID + "'>" + response[i].SubSkillName + "</option>";
            }
            $('#ddl_subskill').append(optionsAsString);
            $(".skill-dashboard-loader").hide();
            
        },
        error: function (a, b, c) {
            $(".skill-dashboard-loader").hide();
        }
    });
}

//Initialise datatable for grid
function initialiseDataTable() {
    $('#tbl_GetQueryResults').DataTable({
        responsive: true
    });
}

//AJAX call to get Users on the basis of skill and subskill selected
function GetResolvers() {
    var skill = $("#ddl_skill").val();
    var subskill = $("#ddl_subskill").val();
    var IsInputDataValid = true;

    if (!skill) {
        IsInputDataValid = false;
        $("#skill-error").show();
    }
    else {
        $("#skill-error").hide();
    }

    if (!subskill) {
        IsInputDataValid = false;
        $("#subskill-error").show();
    }
    else {
        $("#subskill-error").hide();
    }

    var parameters = { 'argSkillID': skill, 'argSubSkillID': subskill };
    if (IsInputDataValid) {
        $(".skill-dashboard-loader").show();
        $.ajax({
            type: "POST",
            url: URL["GetQueryResults"],
            data: parameters,
            success: function (response) {
                $("#div_QueryResults").html(response);
                initialiseDataTable();
                $(".skill-dashboard-loader").hide();
            },
            error: function (response) {
                console.log("Some error in application!");
                $(".skill-dashboard-loader").hide();
            }

        })
    }
    else {
        return false;
    }
    
}