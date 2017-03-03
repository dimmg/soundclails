//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require soundcloud
//= require bootstrap.min
//= require_tree .


const ACTIVE = 'active';
const CHECKBOX_SWITCHER = 'onoffswitch-checkbox';

const FILTER_EVENTS = [
  'downloadable', 'asc_views', 'desc_views', 'asc_likes', 'desc_likes'
]

/**
 * Adds a class: `_class` to an element if it doesn't exist
 * or removes it otherwise.
 * Returns `false` if the class has been removed
 * Returns `true` if the class has been added
 */
function toggleClass(elm, _class) {
  if (elm.hasClass(_class)) {
    elm.removeClass(_class);

    return false;
  } else {
    elm.addClass(_class);
    removeClassFromElements(elm, _class);

    return true;
  }
};

function removeClassFromElements(elm, _class) {
  elms = $('.' + _class);
  elms.not(elm).removeClass(_class);
}

function filterEvent(filter) {
  _filter = $('#' + filter);
  _filter.on('click', function() {
    $('.' + CHECKBOX_SWITCHER).not(this).prop('checked', false);
    status = toggleClass($(this), ACTIVE);
    $.ajax({
      url: '/get-playlist-info',
      method: 'GET',
      data: {
        filter: filter,
        status: status
      }
    });
  });
};

$(document).on('turbolinks:load', function() {
    FILTER_EVENTS.forEach(function(filter) {
      filterEvent(filter);
    });

    $(document).on('click', '.track-title', function() {
      $.ajax({
        url: '/get-youtube-meta',
        method: 'GET',
        data: {
          title: this.innerText
        }
    });
    });
  }
);