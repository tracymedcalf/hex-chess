class Highlight
    constructor : (@color) ->
        @line = new PIXI.Graphics()
        @line.lineStyle 4, @color
    highlight : (hex) ->
        drawHex hex, @line
        app.stage.addChild @line
    unlight : ->
        @line.clear()
        @setup()
    setup : ->
        @line.lineStyle 4, @color

blueHighlight = new H 0x0000ff
yellowHighlight = new H 0xffff00
