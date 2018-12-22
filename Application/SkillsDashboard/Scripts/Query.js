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
            
        },
        error: function (a, b, c) {
           
        }
    });
}

function initialiseDataTable() {
    $('#tbl_GetQueryResults').DataTable({
        responsive: true
    });
}

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
        $.ajax({
            type: "POST",
            url: URL["GetQueryResults"],
            data: parameters,
            success: function (response) {
                $("#div_QueryResults").html(response);
                initialiseDataTable();
            },
            error: function (response) {
                console.log("Some error in application!");
            }

        })
    }
    else {
        return false;
    }
    
}