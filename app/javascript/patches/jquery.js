(function ($) {
  $.fn.replaceClass = function (pFromClass, pToClass) {
    return this.removeClass(pFromClass).addClass(pToClass);
  };
}(jQuery));
