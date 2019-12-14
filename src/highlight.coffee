import * as PIXI from 'pixi.js'
import * as globals from './globals.coffee'
import { drawHex } from './drawUtils.coffee'

class H
    constructor : (@color) ->
        @line = new PIXI.Graphics()
        @line.lineStyle 4, @color
    highlight : (hex) ->
        drawHex hex, @line
        globals.app.stage.addChild @line
    unlight : ->
        @line.clear()
        @setup()
    setup : ->
        @line.lineStyle 4, @color

blue = new H 0x0000ff
yellow = new H 0xffff00

export highlightHex = (hex) ->
    blue.unlight()
    blue.highlight hex

export highlightRange = (hex) ->
    yellow.unlight()
    for hex in hex.piece.movement.tiles hex
        yellow.highlight hex
