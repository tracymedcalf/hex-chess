import * as PIXI from 'pixi.js'
# assets are in /dist
export Sprite = (sheet, picName, hex) ->
    sprite = new PIXI.Sprite sheet.textures["#{picName}.png"]
    sprite.anchor.x = 0
    sprite.anchor.y = 0
    tempHeight = hex.width()
    sprite.width /= sprite.height / tempHeight
    sprite.height = tempHeight
    point = hex.toPoint()
    sprite.position.x = point.x
    sprite.position.y = point.y
    sprite
