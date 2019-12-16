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
                test: /\.(js|jsx|coffee)$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [
                            '@babel/preset-env',
                            "@babel/preset-react"
                        ]
                    }
                }
            },
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
