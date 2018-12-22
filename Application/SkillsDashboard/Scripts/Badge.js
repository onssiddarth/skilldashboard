$(document).ready(function () {
    setAutopopulateForExpert();
});

function setAutopopulateForExpert() {
    $("#txt_BadgeGivenToName").autocomplete({
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
            $("#hdn_BadgeGivenTo").val(ui.item.UserID)
            return false;
        }
    }).data("ui-autocomplete")._renderItem = function (ul, item) {
            return $('<li>')
                .append("<a>" + item.UserName + "</a>")
                .appendTo(ul);
        };
}