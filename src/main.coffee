import * as PIXI from 'pixi.js'

config = require './config.json'

# add globals to window.


# load user modules after globals because some modules
# may depend on globals
import * as globals from './globals.coffee'
import { Sprite } from './sprites.coffee'
import * as select from './select.coffee'
import * as movements from './movements.coffee'
import { drawHex } from './drawUtils.coffee'

newNode = (className, type = 'DIV') =>
    (ret = document.createElement type).className +=
        className
    ret

textLayer = do ->
    view = globals.app.view
    document.body.appendChild container = newNode 'container'
    container.appendChild view

    # create the text layer
    container.appendChild textLayer = newNode 'text-layer'
    textLayer

addText = (text, {x, y}) =>
    textLayer.appendChild cont = newNode 'floating-div'
    cont.style.left = x + 'px'
    cont.style.top = y + 'px'
    cont.appendChild document.createTextNode text
    cont

draw = ->
    graphics = new PIXI.Graphics()
    graphics.lineStyle(1, 0x999999)
    count = 0
    for hex in globals.grid
        drawHex hex, graphics
    globals.app.stage.addChild graphics

draw()

roster = null
# upon spritesheet load, process config file
setup = ->
    sheet = PIXI.Loader.shared.resources['assets/spritesheet.json'].spritesheet
    roster = for {className, position, image} in config.pieces
        hex = globals.grid.get position
        globals.app.stage.addChild sprite = Sprite sheet, image, hex
        hex.piece = switch className
            when 'knight' then console.log 'knight'
            when 'bishop' then {
                className
                sprite
                movement: new movements.Straight
            }
        hex.piece

PIXI.Loader.shared.add('assets/spritesheet.json').load(setup)

document.addEventListener 'mousedown', (offsets) ->
    select.mousedownGrid offsets

document.addEventListener 'mouseup', (event) ->
    select.mouseupGrid event

coordinatesNodes = []

removeCoordinates = ->
    for node in coordinatesNodes
        node.remove()

displayCoordinates = (f) ->
    removeCoordinates()
    coordinatesNodes = for hex in globals.grid
        addText (f hex), hex.toPoint()

radioHandler = ({target}) ->
    switch target.value
        when 'cartesian' then displayCoordinates ({x, y}) ->
            "(#{x}, #{y})"
        when 'cube' then displayCoordinates (hex) ->
            {q, r, s} = globals.Hex().cartesianToCube hex
            "(#{q},#{r},#{s})"
        when 'off' then removeCoordinates()
for button in document.getElementsByTagName 'input'
    button.addEventListener 'change', radioHandler
