const path = require('path');

module.exports = {
    mode : 'development',
    entry: './src/index.js',
    devtool : 'inline-source-map',
    devServer : {
        contentBase : './dist',
    },
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist'),
    },
    module: {
     rules: [
       {
         test: /\.coffee$/,

         use: [
             'coffee-loader',
         ],
       },
       {
         test: /\.css$/,

         use: [
           'style-loader',
           'css-loader',
         ],
       },
     ],
    },
    resolve: {
        extensions: ['.js', '.coffee']
    }
};