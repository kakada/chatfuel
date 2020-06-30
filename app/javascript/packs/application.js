require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

window.$ = require("jquery")
require("bootstrap")
require("moment")
require("chartkick")
require("chart.js")
require("daterangepicker")
require("startbootstrap-sb-admin-2/js/sb-admin-2.min")

require("toastr")
Tagify = require("@yaireo/tagify")

require("shared/sidebar")
require("view/dictionary")
require("view/ticket")
require("view/template")
require("view/chart")
require("view/daterangepicker")
require("view/sidebar_toggle")
require("view/main")