
class CMap
    def initialize(playerX: Window.width/2 - 5, playerY: Window.height/2 - 5, playerWidth: 10, playerHeight: 10)
        @playerwidth = playerWidth
        @playerheight = playerHeight
        @px = playerX
        @py = playerY
        @hitbox = Rectangle.new(
            x: @px - @playerwidth/2, y: @py - @playerheight/2,
            width: @playerwidth, height: @playerheight,
            color: 'teal',
            z: 20
        )
        @collup = false
        @colldown = false
        @collleft = false
        @collright = false
        @hitbox.color.opacity = 1
        
        @map = []
    end
    
    def collision?(x, y)
        check = false
        for i in 0...@map.length
            if @map[i].contains?(x, y) == true
                return true
            end
        end
        return false
    end

    def move(x, y)
        for i in 0...@map.length
            @map[i].move(x, y)
            
            
        end
    end

    def rectangle(x: 0, y: 0, width: 10, height: 10, color: 'black', collision: true, z: 10, opacity: 1)
        @map.append(MapObject.new(
            1, collision, [x, y, width, height, z, color, opacity]
        ))
    end

    def circle(x: 0, y: 0, radius: 5, color: 'black', collision: true, z: 10, opacity: 1)
        @map.append(MapObject.new(
            2, collisiom, [x, y, radius, z, color, opacity]
        ))
    end
     

    def collisionMove(x, y)
        falsex = x
        falsey = y
        @collright = false
        @collleft = false
        @collup = false
        @colldown = false
        @collrightboth = false
        @collleftboth = false
        @collupboth = false
        @colldownboth = false
        for i in 0...@map.length
            if @map[i].collClose(@px, @py) && @map[i].coll
                if (@map[i].contains?(@px - @playerwidth/2, @py - @playerheight/2) ||  @map[i].contains?(@px - @playerwidth/2, @py + @playerheight/2)) && x > 0
                    @collright = true
                elsif (@map[i].contains?(@px + @playerwidth/2, @py - @playerheight/2) || @map[i].contains?(@px + @playerwidth/2, @py + @playerheight/2)) && x < 0
                    @collleft = true
                elsif (@map[i].contains?(@px - @playerwidth/2, @py - @playerheight/2) || @map[i].contains?(@px + @playerwidth/2, @py - @playerheight/2) ) && y > 0
                    @collup = true
                elsif (@map[i].contains?(@px - @playerwidth/2, @py + @playerheight/2)  || @map[i].contains?(@px + @playerwidth/2, @py + @playerheight/2)) && y < 0
                    @colldown = true
                end

                if (@map[i].contains?(@px - @playerwidth/2, @py - @playerheight/2) &&  @map[i].contains?(@px - @playerwidth/2, @py + @playerheight/2))
                    @collrightboth = true
                elsif (@map[i].contains?(@px + @playerwidth/2, @py - @playerheight/2) && @map[i].contains?(@px + @playerwidth/2, @py + @playerheight/2))
                    @collleftboth = true
                elsif (@map[i].contains?(@px - @playerwidth/2, @py - @playerheight/2) && @map[i].contains?(@px + @playerwidth/2, @py - @playerheight/2) )
                    @collupboth = true
                elsif (@map[i].contains?(@px - @playerwidth/2, @py + @playerheight/2)  && @map[i].contains?(@px + @playerwidth/2, @py + @playerheight/2))
                    @colldownboth = true
                end
            end
        end
        if @collright
            if @collupboth || @colldownboth
            else
                falsex = 0
            end
        elsif @collleft
            if @collupboth || @colldownboth
            else
                falsex = 0
            end
        elsif @colldown
            if @collrightboth || @collleftboth
            else
                falsey = 0
            end
        elsif @collup
            if @collrightboth || @collleftboth
            else
                falsey = 0
            end
        end
        for i in 0...@map.length
            @map[i].move(falsex, falsey)
        end
    end
    

    
    def mapWrite(cat, place, arg)
        @map[cat][place] = arg
    end
end

class Camera

end

class MapObject

    attr_accessor :coll

    def initialize(type, coll, arr)
        @type = type
        @coll = coll
        if @type == 1
            @object = Rectangle.new(
                x: arr[0], y: arr[1],
                width: arr[2], height: arr[3],
                color: arr[5],
                z: arr[4],
                opacity: arr[6],
            )
            @midpointx = arr[0] + arr[2]/2
            @midpointy = arr[1] + arr[3]/2
        end
    end

    def move(x, y)
        if @type == 1
            @object.x += x
            @object.y += y
            @midpointx += x
            @midpointy += y
        end
    end

    def contains?(x, y)
        return @coll && @object.contains?(x, y)
    end

    def collClose(x, y)
        placeholderx = @midpointx - x
        placeholdery = @midpointy - y
        relation = Math.atan2(placeholdery, placeholderx)
        newx = x + Math.cos(relation)*10
        newy = y + Math.sin(relation)*10
        return @object.contains?(newx, newy)
    end

end

