export newNode = (className, type = 'DIV') =>
    (ret = document.createElement type).className +=
        ' ' + className
    ret

export addText = (text, {x, y}) =>
    textLayer.appendChild cont = newNode 'floating-div'
    cont.style.left = x + 'px'
    cont.style.top = y + 'px'
    cont.appendChild document.createTextNode text
    cont

move = (source, target) ->
    target.piece = source.piece
    source.piece = null
