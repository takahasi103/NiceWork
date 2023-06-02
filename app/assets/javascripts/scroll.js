// 無限スクロール
$(window).on('resize', function() {
  adjustContainerHeight();
  setHoverBackgroundColor();
  $('.items-scroll').jscroll('destroy'); // jscrollを一時的に無効化
  $('.items-scroll').jscroll({
    contentSelector: '.scroll-list',
    nextSelector: 'span.next:last a',
    loadingHtml: '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>',
    callback: function() {
      setHoverBackgroundColor(); // 新しい要素が読み込まれた後に背景色を適用
    }
  });
  setHoverBackgroundColor(); // 最初の要素にも背景色を適用
});

$(document).ready(function() {
  adjustContainerHeight();
  setHoverBackgroundColor(); // 最初の要素に背景色を適用
  $('.items-scroll').jscroll({
    contentSelector: '.scroll-list',
    nextSelector: 'span.next:last a',
    loadingHtml: '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>',
    callback: function() {
      setHoverBackgroundColor(); // 新しい要素が読み込まれた後に背景色を適用
    }
  });
});

function adjustContainerHeight() {
  var postsScroll = $('.items-scroll');
  if (postsScroll.length > 0) {
    var windowHeight = $(window).height();
    var containerHeight = windowHeight - postsScroll.offset().top;
    postsScroll.css('height', containerHeight + 'px');
  }
}

function setHoverBackgroundColor() {
  $('.scroll-item').hover(
    function() {
      $(this).css('background-color', 'rgba(192, 192, 192, 0.1)');
    },
    function() {
      $(this).css('background-color', '');
    }
  );
}