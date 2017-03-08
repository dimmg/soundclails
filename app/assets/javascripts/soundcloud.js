const WIDGET_TYPES_HEIGHT_SIZES = {
    playlist: 400,
    track: 100
}

function showWidget(uri, type) {
    var height = WIDGET_TYPES_HEIGHT_SIZES[type]

    return "\<div class=\""+type+"--iframe"+"\">\
              <iframe id=\"sc-widget\"src=\"https://w.soundcloud.com/player/?url=" + uri +
              "\"width=\"80%\" height=\""+ height +"\" scrolling=\"no\" frameborder=\"no\">\
              </iframe>\
              <div class=\"close--modal\">+</div>\
            </div>";
};

