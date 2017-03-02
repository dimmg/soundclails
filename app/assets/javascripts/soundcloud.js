const WIDGET_TYPES_HEIGHT_SIZES = {
    playlist: 400,
    track: 100
}

function showWidget(uri, type) {
    var height = WIDGET_TYPES_HEIGHT_SIZES[type]

    return "\
        <iframe id=\"sc-widget\"src=\"https://w.soundcloud.com/player/?url=" + uri +
        "\"width=\"60%\" height=\""+ height +"\" scrolling=\"no\" frameborder=\"no\">\
        </iframe>";
};

