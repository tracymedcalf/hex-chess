import * as PIXI from 'pixi.js'
import * as Honeycomb from 'honeycomb-grid'

config = require './config.json'

# width and height in hexes
export width = 10
export height = 10
export Hex = Honeycomb.extendHex({
    size: 40
    offset: 1
})
export Grid = Honeycomb.defineGrid(Hex)
export grid = switch config.mapShape
    when 'rectangle' then Grid.rectangle {width, height}
    when 'hexagon' then Grid.hexagon { radius: 5, center: [5,5] }
export app = new PIXI.Application({ transparent: true, antialias: true })
