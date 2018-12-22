//This function is used to fetch the request type
function GetRequestType(argUniqueID) {
    var requestLabel = $("#" + argUniqueID + "").closest('tr').find('.td_RequestType').text();
    var requestType = '';
    switch (requestLabel.toUpperCase()) {
        case "INITIAL SKILL REQUEST":
            requestType = 'INIT';
            break;

        case "DEMONSTRATION":
            requestType = 'DEMO';
            break;

        case "CERTIFICATION":
            requestType = 'CERT';
            break;

    }

    return requestType;
}

//On key press event for text area to handle error message
function removeValidation() {
    var commentsEntered = $(".skill-text-area").val();
    if (!commentsEntered || commentsEntered.trim().length < 1) {
        $("#lbl_CommentErrorMessage").show();
    }
    else {
        $("#lbl_CommentErrorMessage").hide();
    }

}

//This function is used to display error/success message at top of page
function displayConfirmationMessage(argMessage, argType) {
    var alertTemplate = "<div class='alert #message-type#'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a>#message#</div>";
    var resultTemplate = alertTemplate.replace("#message-type#", argType).replace("#message#", argMessage);
    $(".confirmation-message").html(resultTemplate);
}