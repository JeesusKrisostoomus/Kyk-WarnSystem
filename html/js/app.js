window.addEventListener('message', function (event) {
    switch(event.data.action) {
        case 'notif':
            DoKykWarn(event.data);
            break;
    }
});

function DoKykWarn(data) {
    var $notification = $('.notification.template').clone();
    $notification.removeClass('template');
    $notification.addClass(data.type);
    $notification.html(data.text);
    $notification.fadeIn();
    $('.notif-container').append($notification);
    setTimeout(function() {
        $.when($notification.fadeOut()).done(function() {
            $notification.remove()
        });
    }, 7500);
}