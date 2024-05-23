# Globala variabler för kamerans position
$globalCamerax = 0
$globalCameray = 0

# Klass som representerar kartan
class CMap
    attr_accessor :x, :y

    # Initialiserar kartan med spelarens position och egenskaper
    def initialize(playerX: Window.width/2 - 5, playerY: Window.height/2 - 5, playerWidth: 10, playerHeight: 10, opacity: 1)
        @playerwidth = playerWidth
        @playerheight = playerHeight
        @px = playerX
        @py = playerY

        # Skapar spelarens hitbox
        @hitbox = Rectangle.new(
            x: @px - @playerwidth/2, y: @py - @playerheight/2,
            width: @playerwidth, height: @playerheight,
            color: 'teal',
            z: 20
        )
        @hitbox.color.opacity = opacity
        @x = 0
        @y = 0

        # Lista som innehåller alla objekt på kartan
        @map = []
    end

    # Kontrollerar kollision för ett givet koordinatpar (x, y)
    def collision?(x, y)
        check = false
        for i in 0...@map.length
            if @map[i].contains?(x, y) == true
                return true
            end
        end
        return false
    end

    # Flyttar alla objekt på kartan med ett visst avstånd (x, y)
    def move(x, y)
        for i in 0...@map.length
            @map[i].move(x, y)
        end
    end

    # Flyttar ett specifikt objekt på kartan med ett visst avstånd (x, y)
    def moveObject(x, y, id)
        @map[id].move(x, y)
    end

    # Returnerar x-koordinaten för ett specifikt objekt på kartan
    def getX(id)
        return @map[id].getX
    end

    # Returnerar y-koordinaten för ett specifikt objekt på kartan
    def getY(id)
        return @map[id].getY
    end

    # Lägger till en rektangel till kartan
    def rectangle(x: 0, y: 0, width: 10, height: 10, color: 'black', collision: true, z: 10, opacity: 1)
        @map.append(MapObject.new(
            1, collision, [x, y, width, height, z, color, opacity]
        ))
        return @map.length - 1
    end

    # Lägger till en cirkel till kartan
    def circle(x: 0, y: 0, radius: 5, color: 'black', collision: true, z: 10, opacity: 1)
        @map.append(MapObject.new(
            2, collision, [x, y, radius, z, color, opacity]
        ))
        return @map.length - 1
    end

    # Lägger till en triangel till kartan
    def triangle(x1: 50, y1: 0, x2: 100, y2: 100, x3: 0, y3: 100, color: 'black', collision: true, z: 100, opacity: 1)
        @map.append(MapObject.new(
            3, collision, [x1, y1, x2, y2, x3, y3, color, z, opacity]
        ))
        return @map.length - 1
    end

    # Lägger till en bild till kartan
    def img(url: '', x: 0, y: 0, width: 10, height: 10, collision: true, z: 10, rotate: 0)
        if url == ''
            raise StandardError.new('no url when defining image')
        end
        @map.append(MapObject.new(
            4, collision, [url, x, y, width, height, z, rotate]
        ))
        return @map.length - 1
    end

    # Kontrollerar kollision och flyttar spelaren
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
        @tl = false
        @tr = false
        @bl = false
        @br = false

        # Kontrollera kollisioner med alla objekt på kartan
        for i in 0...@map.length
            if @map[i].collClose(@px, @py) && @map[i].coll
                if (@map[i].contains?(@px - @playerwidth/2, @py - @playerheight/2) ||  @map[i].contains?(@px - @playerwidth/2, @py + @playerheight/2)) && x > 0
                    @collleft = true
                end
                if (@map[i].contains?(@px + @playerwidth/2, @py - @playerheight/2) || @map[i].contains?(@px + @playerwidth/2, @py + @playerheight/2)) && x < 0
                    @collright = true
                end
                if (@map[i].contains?(@px - @playerwidth/2, @py - @playerheight/2) || @map[i].contains?(@px + @playerwidth/2, @py - @playerheight/2) ) && y > 0
                    @collup = true
                end
                if (@map[i].contains?(@px - @playerwidth/2, @py + @playerheight/2)  || @map[i].contains?(@px + @playerwidth/2, @py + @playerheight/2)) && y < 0
                    @colldown = true
                end
                if @map[i].contains?(@px -  @playerwidth/2, @py - @playerheight/2)
                    @tl = true
                end
                if @map[i].contains?(@px +  @playerwidth/2, @py - @playerheight/2)
                    @tr = true
                end
                if @map[i].contains?(@px -  @playerwidth/2, @py + @playerheight/2)
                    @bl = true
                end
                if @map[i].contains?(@px +  @playerwidth/2, @py + @playerheight/2)
                    @br = true
                end
            end
        end
        if @tl && @tr
            @collupboth = true
        end
        if @bl && @br
            @colldownboth = true
        end
        if @tl && @bl
            @collleftboth = true
        end
        if @tr && @br
            @collrightboth = true
        end


        # Bestämma riktning baserat på kollisioner
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
        if @collupboth && @collleftboth
            if x > 0
                falsex = 0
            elsif y > 0
                falsey = 0
            end
        end
        if @collupboth && @collrightboth
            if x < 0
                falsex = 0
            elsif y < 0
                falsey = 0
            end
        end
        if @colldownboth && @collleftboth
            if x > 0
                falsex = 0
            elsif y < 0
                falsey = 0
            end
        end
        if @colldownboth && @collrightboth
            if x < 0
                falsex = 0
            elsif y < 0
                falsey = 0
            end
        end
        
        

        # Flyttar alla objekt på kartan baserat på kollisionerna
        for i in 0...@map.length
            @map[i].move(falsex, falsey)
        end

        # Uppdaterar globala kamerans position
        $globalCamerax += falsex
        $globalCameray += falsey
    end

    # Uppdaterar en specifik plats på kartan
    def mapWrite(cat, place, arg)
        @map[cat][place] = arg
    end
end

# Klass som representerar ett objekt på kartan
class MapObject
    attr_accessor :coll

    # Initialiserar ett objekt med angiven typ, kollision och egenskaper
    def initialize(type, coll, arr)
        @type = type
        @coll = coll

        if @type == 1
            @object = Rectangle.new(
                x: arr[0], y: arr[1],
                width: arr[2], height: arr[3],
                color: arr[5],
                z: arr[4],
                opacity: arr[6]
            )
            @midpointx = arr[0] + arr[2]/2
            @midpointy = arr[1] + arr[3]/2
        elsif @type == 2
            @object = Circle.new(
                x: arr[0], y: arr[1],
                radius: arr[2],
                color: arr[

4],
                z: arr[3],
                opacity: arr[5]
            )
            @midpointx = arr[0]
            @midpointy = arr[1]
        elsif @type == 3
            @object = Triangle.new(
                x1: arr[0], y1: arr[1],
                x2: arr[2], y2: arr[3],
                x3: arr[4], y3: arr[5],
                color: arr[6],
                z: arr[7],
                opacity: arr[8]
            )
            @midpointx = (arr[0] + arr[2] + arr[4])/3
            @midpointy = (arr[1] + arr[3] + arr[5])/3
        elsif @type == 4
            @object = Image.new(
                arr[0],
                x: arr[1], y: arr[2],
                width: arr[3], height: arr[4],
                z: arr[5],
                rotate: arr[6]
            )
            @midpointx = arr[1] + arr[3]/2
            @midpointy = arr[2] + arr[4]/2
        end
    end

    # Returnerar objektets x-koordinat justerat med globala kamerans position
    def getX
        return @object.x - $globalCamerax
    end

    # Returnerar objektets y-koordinat justerat med globala kamerans position
    def getY
        return @object.y - $globalCameray
    end

    # Flyttar objektet med angivet avstånd (x, y)
    def move(x, y)
        @midpointx += x
        @midpointy += y

        if @type == 1
            @object.x += x
            @object.y += y
        elsif @type == 2
            @object.x += x
            @object.y += y
        elsif @type == 3
            @object.x1 += x
            @object.x2 += x
            @object.x3 += x
            @object.y1 += y
            @object.y2 += y
            @object.y3 += y
        elsif @type == 4
            @object.x += x
            @object.y += y
        end
    end

    # Kontrollerar om objektet innehåller en given punkt (x, y)
    def contains?(x, y)
        return @coll && @object.contains?(x, y)
    end

    # Kontrollerar om objektet är nära en given punkt (x, y)
    def collClose(x, y)
        placeholderx = @midpointx - x
        placeholdery = @midpointy - y
        relation = Math.atan2(placeholdery, placeholderx)
        newx = Math.cos(relation)
        newy = Math.sin(relation)
        if @object.contains?(newx*5 + x, newy*5 + y) || @object.contains?(newx*10 + x, newy*10 + y) || @object.contains?(newx*15 + x, newy*15 + y) || @object.contains?(newx*20 + x, newy*20 + y)
            return true
        else
            return false
        end
    end
end

# Klass som representerar ett rörligt objekt på kartan
class MovableRectangle
    # Initialiserar ett rörligt rektangulärt objekt
    def initialize(camera, x: 0, y: 0, width: 10, height: 10, color: 'black', collision: true, z: 10, opacity: 1 )
        @id = camera.rectangle(x: x, y: y, width: width, height: height, color: color, collision: collision, z: z, opacity: opacity)
    end

    # Flyttar objektet med angivet avstånd (x, y) via kameran
    def move(x, y, camera)
        camera.moveObject(x, y, @id)
    end

    # Returnerar objektets x-koordinat via kameran
    def getX(camera)
        return camera.getX(@id)
    end

    # Returnerar objektets y-koordinat via kameran
    def getY(camera)
        return camera.getY(@id)
    end
end
