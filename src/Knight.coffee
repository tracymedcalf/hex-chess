import { Straight } from './movements.coffee'

export default class Knight
    constructor: (hex, @sprite) ->
        @position = hex
        @movement = Straight
