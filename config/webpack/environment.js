const { environment } = require("@rails/webpacker");
const coffee = require("./loaders/coffee");
const erb = require("./loaders/erb");
const webpack = require("webpack");
const fileLoader = environment.loaders.get("file");
fileLoader.exclude = /node_modules[\\/]quill/;
environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    moment: "moment/moment",
    toastr: "toastr/toastr",
    Popper: ["popper.js", "default"],
  })
);
const svgLoader = {
  test: /\.svg$/,
  loader: "svg-inline-loader",
};

environment.loaders.prepend("svg", svgLoader);
environment.loaders.prepend("erb", erb);
environment.loaders.prepend("coffee", coffee);
module.exports = environment;
