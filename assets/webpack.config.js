const path = require('path');
const glob = require('glob');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
    optimization: {
        minimizer: [
            new UglifyJsPlugin({
                cache: true,
                parallel: true,
                sourceMap: false
            }),
            new OptimizeCSSAssetsPlugin({})
        ]
    },
    entry: {
        app: ['./js/app.js'],
        admin: ['./js/admin.js']
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, '../priv/static/js')
    },
    module: {
        rules: [{
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader'
                }
            },
            {
                test: /\.(css|sass|scss)$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    {
                        loader: 'css-loader',
                        options: {
                            importLoaders: 2,
                            sourceMap: true
                        }
                    },
                    {
                        loader: 'sass-loader',
                        options: {
                            sourceMap: true
                        }
                    }
                ]
            },
            {
                test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        outputPath: 'fonts/'
                    }
                }]
            }
        ]
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: '../css/[name].css',
            chunkFilename: "../css/[name].css"
        }),
        new  CopyWebpackPlugin([{
            from: 'node_modules/@fortawesome/fontawesome-free/webfonts',
            to: '../css/fonts'
        }]), 
        new CopyWebpackPlugin([{
            from: 'static/',
            to: '../'
        }]),
       new webpack.ProvidePlugin({
          $: "jquery",
          jQuery: "jquery",
          "window.jQuery": "jquery",
          Popper: ['popper.js', 'default'],
          Alert: "exports-loader?Alert!bootstrap/js/dist/alert",
          Button: "exports-loader?Button!bootstrap/js/dist/button",
          Carousel: "exports-loader?Carousel!bootstrap/js/dist/carousel",
          Collapse: "exports-loader?Collapse!bootstrap/js/dist/collapse",
          Dropdown: "exports-loader?Dropdown!bootstrap/js/dist/dropdown",
          Modal: "exports-loader?Modal!bootstrap/js/dist/modal",
          Popover: "exports-loader?Popover!bootstrap/js/dist/popover",
          Scrollspy: "exports-loader?Scrollspy!bootstrap/js/dist/scrollspy",
          Tab: "exports-loader?Tab!bootstrap/js/dist/tab",
          Tooltip: "exports-loader?Tooltip!bootstrap/js/dist/tooltip",
          Util: "exports-loader?Util!bootstrap/js/dist/util"
        })
    ]
});
