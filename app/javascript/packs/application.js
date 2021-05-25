require("@rails/ujs").start();
global.Rails = Rails;
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

window.$ = require("jquery");
require("bootstrap");
require("moment");
window.chartDataLabels = require("chartjs-plugin-datalabels");
require("startbootstrap-sb-admin-2/js/sb-admin-2.min");
require("toastr");
require("select2");
require("packs/social-share-button.js.erb");

require("application/pumi");
window._ = require("underscore");
require("./quill-editor.js");

import "bootstrap-toggle/js/bootstrap-toggle";
import flatpickr from "flatpickr";
import { Khmer } from "flatpickr/dist/l10n/km";

require("application/namespace");
require("application/util");
require("application/loader");

require("charts/index");
require("sites/settings/setting");
require("sites/api_keys/show");
require("sites/index");
require("templates/index");
require("dashboard/show");
require("home/index");
require("welcomes/index");
require("listview/index");
require("developer_guides/index");
require("dictionaries/edit");
require("dictionaries/index");

require("shared/sidebar");
require("view/ticket");
require("view/chart");
require("view/sidebar_toggle");
require("view/users");
require("provincial_usages");
require("schedules/index");
require("welcomes/index");
