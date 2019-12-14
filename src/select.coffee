import * as globals from './globals.coffee'
import * as highlight from './highlight.coffee'
# module is called when player has clicked grid


#lightCartesian = (x, y) ->
#    hex = grid.get {x, y}
#    if hex?
#        yellowHighlight.highlight(hex)

select = (coordinates) ->
    hex = globals.grid.get coordinates
    if hex?.piece
        highlight.highlightRange hex
        highlight.highlightHex hex

clickedHex = null

# Does not get the hex in the grid
getHexCoordinates = ({offsetX, offsetY}) ->
    globals.Grid.pointToHex(offsetX, offsetY)

export mousedownGrid = (offset) ->
    clickedHex = getHexCoordinates offset

export mouseupGrid = (event) ->
    # so we know whether user dragged over hex
    mouseupHex = getHexCoordinates event
    if mouseupHex.x == clickedHex.x and mouseupHex.y == clickedHex.y
        select mouseupHex
    
