import * as PIXI from 'pixi.js'
# assets are in /dist
export Sprite = (hex, picName) ->
    sprite = PIXI.Sprite.from "assets/#{picName}.png"
    sprite.anchor.x = 0
    sprite.anchor.y = 0
    tempHeight = hex.width()
    sprite.width /= sprite.height / tempHeight
    sprite.height = tempHeight
    point = hex.toPoint()
    sprite.position.x = point.x
    sprite.position.y = point.y
    hex.piece = sprite
    sprite
