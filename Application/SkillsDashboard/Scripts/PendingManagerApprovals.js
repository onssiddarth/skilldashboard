var UniqueID = '';

$(document).ready(function () {
    registerEvents();
    loadApprovals();
    initialiseDataTable();
});

function registerEvents() {
    $("#ddl_request").on("change", loadApprovals);
}

function initialiseDataTable() {
    $('#tbl_PendingManagerApprovals').DataTable({
        responsive: true
    });
}

function loadApprovals() {
    var requestType = $("#ddl_request").val();
    var parameters = { 'argRequestType': requestType };

    $.ajax({
        type: "POST",
        url: URL["GetPendingManagerApprovals"],
        data: parameters,
        success: function (response) {
            $("#div_PendingManagerApprovalGrid").html(response);
            initialiseDataTable();
        },
        error: function (response) {
            console.log(response);
            console.log("Some error in application!");
        }

    })
}

//This function is used to show popup
function OpenActionPopup(argID,argType) {
    //Set global variable
    UniqueID = argID;

    if (argType == 'BADGE'){
        openBadgeModel(argID);
    }
    else {
        //Hide the error message every time the popup opens
        $("#lbl_CommentErrorMessage").hide();
        //Reset textbox value
        $(".skill-text-area").val('');

        //Get the required values from DOM
        var requestedBy = $("#" + argID + "").closest('tr').find('.td_RequestedBy').text();
        var skill = $("#" + argID + "").closest('tr').find('.td_SkillName').text();
        var subSkill = $("#" + argID + "").closest('tr').find('.td_SubSkillName').text();
        var comments = $("#" + argID + "").closest('tr').find('.td_Comments').text();
        var points = $("#" + argID + "").closest('tr').find('.td_SkillPoints').text();
        var requestType = GetRequestType(argID);
        var filePath = $("." + argID + "-file-GUID").val();
        var fileName = $("." + argID + "-file-Name").val();

        if (fileName) {
            var fileExtension = fileName.substr((fileName.lastIndexOf('.')));

            var filePathWithExtension = "/Uploads/" + filePath + fileExtension + "";
        }

        //Set the values in label
        $("#lbl_RequestedBy").html(requestedBy);
        $("#lbl_Skill").html(skill);
        $("#lbl_Subskill").html(subSkill);
        $("#lbl_RequestorComments").html(comments);
        $("#lbl_Points").html(points);


        if (requestType == 'CERT') {
            //Set the anchor tab attributes
            $(".file-details").attr('href', filePathWithExtension);
            $(".file-details").attr('download', fileName);
            $(".file-details").text(fileName);

            //Display certificate panel
            $("#certificate-upload-details").show();
        }
        else {
            $("#certificate-upload-details").hide();
        }

        //Open bootstrap model
        $("#modal-approve-request").modal('show');
    }
    
}

function SaveManagerAction(argType) {
    
    //Check if valid contents are entered in text area
    var commentsEntered = $(".skill-text-area").val();
    var requestType = '';
    if (!commentsEntered || commentsEntered.trim().length < 1) {
        $("#lbl_CommentErrorMessage").show();
        return false;
    }
    else {
        $("#lbl_CommentErrorMessage").hide();
    }

    //get the type 
    requestType = GetRequestType(UniqueID);

    //Create approval object
    var argManagerApproval = new Object();
    argManagerApproval.UniqueID = UniqueID.split('-')[1];
    argManagerApproval.Comments = commentsEntered;
    argManagerApproval.Status = argType;
    argManagerApproval.Type = requestType;

    //AJAX POST request
    $.ajax({
        type: "POST",
        url: URL["SaveManagerApproval"],
        data: JSON.stringify(argManagerApproval),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $("#modal-approve-request").modal('hide');
            if (response != null && response) {
                //Display success message
                displayConfirmationMessage('Request updated successfully', 'alert-success');

                //Close bootstrap model
                $("#modal-approve-request").modal('hide');

                //Reload requests
                loadApprovals();
            }
            else {
                //Display error message
                displayConfirmationMessage('Request could not be updated successfully', 'alert-danger');
            }
        },
        error: function (a, b, c) {
            $("#modal-approve-request").modal('hide');
            displayConfirmationMessage('Request could not be updated successfully', 'alert-danger');
        }
    });  
}


function openBadgeModel(argID) {
    //Hide the error message every time the popup opens
    $("#lbl_BadgeCommentErrorMessage").hide();
    //Reset textbox value
    $(".skill-badge-text-area").val('');

    //Get the required values from DOM
    var requestedBy = $("#" + argID + "").closest('tr').find('.td_RequestedBy').text();
    var comments = $("#" + argID + "").closest('tr').find('.td_Comments').text();
    var badgeGivenFor = $("#" + argID + "").closest('tr').find('.td_BadgeGivenFor').text();
    
    var badgeURL = $("." + argID + "-badge-URL").val();
    var badgeName = $("." + argID + "-badge-Name").val();

    $("#lbl_BadgeRequestedBy").html(requestedBy);
    $("#lbl_BadgeRequestedFor").html(badgeGivenFor);
    $("#lbl_RequestorComments").html(comments);
    $("#img_Badge").prop('src', '/Images/' + badgeURL + '');

    $("#modal-approve-badge").modal('show');
}

function SaveBadge(argType) {
    var commentsEntered = $(".skill-badge-text-area").val();
    if (!commentsEntered || commentsEntered.trim().length < 1) {
        $("#lbl_BadgeCommentErrorMessage").show();
        return false;
    }
    else {
        $("#lbl_BadgeCommentErrorMessage").hide();
    }

    //Create approval object
    var argSaveBadge = new Object();
    argSaveBadge.UserBadgeID = UniqueID.split('-')[1];
    argSaveBadge.Comments = commentsEntered;
    argSaveBadge.Status = argType;

    //AJAX POST request
    $.ajax({
        type: "POST",
        url: URL["SaveManagerApprovalForBadge"],
        data: JSON.stringify(argSaveBadge),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $("#modal-approve-badge").modal('hide');
            if (response != null && response) {
                //Display success message
                displayConfirmationMessage('Request updated successfully', 'alert-success');

                //Close bootstrap model
                $("#modal-approve-badge").modal('hide');

                //Reload requests
                loadApprovals();
            }
            else {
                //Display error message
                displayConfirmationMessage('Request could not be updated successfully', 'alert-danger');
            }
        },
        error: function (a, b, c) {
            $("#modal-approve-badge").modal('hide');
            displayConfirmationMessage('Request could not be updated successfully', 'alert-danger');
        }
    });  
}

function removeBadgeValidation() {
    var commentsEntered = $(".skill-badge-text-area").val();
    if (!commentsEntered || commentsEntered.trim().length < 1) {
        $("#lbl_BadgeCommentErrorMessage").show();
    }
    else {
        $("#lbl_BadgeCommentErrorMessage").hide();
    }
}





