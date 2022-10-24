const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
    mode:'development',
    entry: "./src/index.js",
    output: {
        filename: 'main.js',
        path: path.resolve(__dirname, 'dist'),
    },
    devServer: {
      static: {
        directory: path.join(__dirname, 'dist'),
      },
      compress: true,
      port: 8000,
    },
    module: {
        rules: [
          {
            test: /\.css$/i,
            use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader'],
          },
          {
            test: /\.png$/i,
            type: 'asset/resource',
          }
        ],
      },
    plugins: [new HtmlWebpackPlugin({
        template: "/public/index.html",
        title: "rescript-template"
    }),
    new MiniCssExtractPlugin({filename: "[name].css",
    chunkFilename: "[id].css",})]
}