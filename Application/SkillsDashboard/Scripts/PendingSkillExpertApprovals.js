var uniqueIDScheduleDemo = '';
var uniqueIDApproveReject = '';

$(document).ready(function () {
    registerEvents();
    loadApprovals();
    initialiseDataTable();
});

function registerEvents() {
    $("#ddl_request").on("change", loadApprovals);
}

function initialiseDataTable() {
    $('#tbl_PendingSkillExpertApprovals').DataTable({
        responsive: true
    });
}

function loadApprovals() {
    var requestType = $("#ddl_request").val();
    var parameters = { 'argRequestType': requestType };

    $.ajax({
        type: "POST",
        url: URL["GetPendingSkillExpertApprovals"],
        data: parameters,
        success: function (response) {
            $("#div_PendingSkillExpertApprovalGrid").html(response);
            initialiseDataTable();
        },
        error: function (a,b,c) {
            displayErrorMessage('Pending approvals could not be loaded successfully.', 'alert-danger');
        }

    })
}

//This function is used to show the popup based on reqyest type and status
function OpenActionPopup(argUniqueID) {

    
    //Get the request type
    var requestType = GetRequestType(argUniqueID);
    var status = $("#" + argUniqueID + "").closest('tr').find('.td_Status').text();

    if (requestType == 'DEMO' && status.toUpperCase() == 'MANAGER APPROVED') {
        showDemoSchedulePopup(argUniqueID);// Display popup to schedule demo
    }
    else {
        showApproveRejectPopup(argUniqueID);//display popup to approve/reject
    }
}


function showDemoSchedulePopup(argID) {
    
    //Hide the error message every time the popup opens
    $(".skill-error").hide();
    //Reset textbox value
    $(".skill-text-area").val('');
    $("#text_room").val('');
    $("#text_schedule").val('');

    //Get the required values from DOM
    var requestedBy = $("#" + argID + "").closest('tr').find('.td_RequestedBy').text();
    var skill = $("#" + argID + "").closest('tr').find('.td_SkillName').text();
    var subSkill = $("#" + argID + "").closest('tr').find('.td_SubSkillName').text();
    var userComments = $("#" + argID + "").closest('tr').find('.td_UserComments').text();
    var managerComments = $("#" + argID + "").closest('tr').find('.td_ManagerComments').text();
    var points = $("#" + argID + "").closest('tr').find('.td_SkillPoints').text();

    $("#lbl_RequestedBy").html(requestedBy);
    $("#lbl_Skill").html(skill);
    $("#lbl_Subskill").html(subSkill);
    $("#lbl_RequestorComments").html(userComments);
    $("#lbl_Points").html(points);
    $("#lbl_ManagerComments").html(managerComments);

    $('#datetimepicker').datetimepicker({ format: 'DD/MM/YYYY hh:mm a'}).on('dp.change', function (event) {
        $("#lbl_CommentScheduleError").hide();
    });

    uniqueIDScheduleDemo = argID;

    $("#modal-schedule-demo").modal("show");
}

function showApproveRejectPopup(argUniqueID) {
    //Set global variable
    uniqueIDApproveReject = argUniqueID;
    //Hide the error message every time the popup opens
    $("#lbl_ActionableCommentErrorMessage").hide();
    //Reset textbox value
    $(".skill-text-area").val('');

    //Get the requireed values
    var requestedBy = $("#" + argUniqueID + "").closest('tr').find('.td_RequestedBy').text();
    var skill = $("#" + argUniqueID + "").closest('tr').find('.td_SkillName').text();
    var subSkill = $("#" + argUniqueID + "").closest('tr').find('.td_SubSkillName').text();
    var userComments = $("#" + argUniqueID + "").closest('tr').find('.td_UserComments').text();
    var managerComments = $("#" + argUniqueID + "").closest('tr').find('.td_ManagerComments').text();
    var points = $("#" + argUniqueID + "").closest('tr').find('.td_SkillPoints').text();
    var filePath = $("." + argUniqueID + "-file-GUID").val();
    var fileName = $("." + argUniqueID + "-file-Name").val();
    var demoSchedule = $("." + argUniqueID + "-DemoSchedule").val();
    var demoRoom = $("." + argUniqueID + "-Room").val();
    var requestType = GetRequestType(argUniqueID);

    if (fileName) {
        var fileExtension = fileName.substr((fileName.lastIndexOf('.')));
        var filePathWithExtension = "/Uploads/" + filePath + fileExtension + "";
    }

    


    $("#lbl_ActionableRequestedBy").html(requestedBy);
    $("#lbl_ActionableSkill").html(skill);
    $("#lbl_ActionableSubskill").html(subSkill);
    $("#lbl_ActionableRequestorComments").html(userComments);
    $("#lbl_ActionablePoints").html(points);
    $("#lbl_ManagerComments").html(managerComments);
    $("#lbl_ActionableManagerComments").html(managerComments)

   
    if (requestType == 'CERT') {
        //Set the anchor tab attributes
        $(".action-file-details").attr('href', filePathWithExtension);
        $(".action-file-details").attr('download', fileName);
        $(".action-file-details").text(fileName);

        //Display certificate panel
        $("#actionable-certificate-upload-details").show();
    }
    else {
        $("#actionable-certificate-upload-details").hide();
    }

    if (requestType == 'DEMO') {
        $("#lbl_DemoSchedule").html(demoSchedule);
        $("#lbl_Room").html(demoRoom);
        $("#actionable-demo-details").show();
    }
    else {
        $("#actionable-demo-details").hide();
    }
      
    //Open bootstrap model
    $("#modal-skillexpert-approve-request").modal('show');
}

function ScheduleDemo() {
    var commentsEntered = '';
    var roomEntered = '';
    var demoSchedule = '';
    var IsDataValid = true;

    roomEntered = $("#text_room").val();
    demoSchedule = $("#text_schedule").val();
    commentsEntered = $(".skill-text-area").val();

    if (!commentsEntered || commentsEntered.trim().length < 1) {
        $("#lbl_CommentErrorMessage").show();
        IsDataValid = false;
    }
    else {
        $("#lbl_CommentErrorMessage").hide();
    }

    if (!roomEntered || roomEntered.trim().length < 1) {
        $("#lbl_CommentRoomError").show();
        IsDataValid = false;
    }
    else {
        $("#lbl_CommentRoomError").hide();
    }

    if (!demoSchedule || demoSchedule.trim().length < 1) {
        $("#lbl_CommentScheduleError").show();
        IsDataValid = false;
    }
    else {
        $("#lbl_CommentScheduleError").hide();
    }

    if (IsDataValid == false) {
        return false;
    }
    else {
        //Create approval object
        var argScheduleDemo = new Object();
        argScheduleDemo.UniqueID = uniqueIDScheduleDemo.split('-')[1];
        argScheduleDemo.Comments = commentsEntered;
        argScheduleDemo.DemoSchedule = demoSchedule;
        argScheduleDemo.Room = roomEntered;
        

        //AJAX POST request
        $.ajax({
            type: "POST",
            url: URL["ScheduleDemo"],
            data: JSON.stringify(argScheduleDemo),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                $("#modal-schedule-demo").modal('hide');
                if (response != null && response) {
                    //Display success message
                    displayConfirmationMessage('Demo scheduled successfully', 'alert-success');

                    //Reload requests
                    loadApprovals();
                }
                else {
                    //Display error message
                    displayConfirmationMessage('Demo could not be scheduled successfully', 'alert-danger');
                }
            },
            error: function (a, b, c) {
                $("#modal-schedule-demo").modal('hide');
                displayConfirmationMessage('Demo could not be scheduled successfully', 'alert-danger');
            }
        });  
    }

}


function removeValidationFromRoomText() {
    var roomEntered = $("#text_room").val();
    if (!roomEntered || roomEntered.trim().length < 1) {
        $("#lbl_CommentRoomError").show();
    }
    else {
        $("#lbl_CommentRoomError").hide();
    }

}

function removeValidationApproveReject() {
    var textEntered = $("#actionable-skilltext-area").val();
    if (!textEntered || textEntered.trim().length < 1) {
        $("#lbl_ActionableCommentErrorMessage").show();
    }
    else {
        $("#lbl_ActionableCommentErrorMessage").hide();
    }
}

function removeValidationForScheduleDemo() {
    var textEntered = $("#txt-demo").val();
    if (!textEntered || textEntered.trim().length < 1) {
        $("#lbl_DemoScheduleErrorMessage").show();
    }
    else {
        $("#lbl_DemoScheduleErrorMessage").hide();
    }
}


function SaveSkillExpertAction(argType) {

    //Check if valid contents are entered in text area
    var commentsEntered = $("#actionable-skilltext-area").val();
    var requestType = '';
    if (!commentsEntered || commentsEntered.trim().length < 1) {
        $("#lbl_ActionableCommentErrorMessage").show();
        return false;
    }
    else {
        $("#lbl_ActionableCommentErrorMessage").hide();
    }

    //get the type 
    requestType = GetRequestType(uniqueIDApproveReject);

    //Create approval object
    var argSkillExpertApproval = new Object();
    argSkillExpertApproval.UniqueID = uniqueIDApproveReject.split('-')[1];
    argSkillExpertApproval.Comments = commentsEntered;
    argSkillExpertApproval.Status = argType;
    argSkillExpertApproval.Type = requestType;

    //AJAX POST request
    $.ajax({
        type: "POST",
        url: URL["SaveSkillExpertApproval"],
        data: JSON.stringify(argSkillExpertApproval),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $("#modal-skillexpert-approve-request").modal('hide');
            if (response != null && response) {
                //Display success message
                displayConfirmationMessage('Request updated successfully', 'alert-success');

                //Close bootstrap model
                $("#modal-skillexpert-approve-request").modal('hide');

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