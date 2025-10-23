game={}
game.__index=game

function game:new()
    love.window.setFullscreen(true,"desktop")
    love.graphics.setDefaultFilter("nearest","nearest")
    love.filesystem.setIdentity("2")
    print(love.filesystem.getIdentity())
    
end

function game:gameplayDraw(score, levelTimer,p,bulletArray,enemyArray)
    love.graphics.print(score,love.graphics.getWidth()-40)
    love.graphics.print(math.floor(levelTimer))
    love.graphics.draw(p.image,p.x,p.y,p.r,4,4,8,8)
    for i,v in ipairs(bulletArray) do
        drawBullet(bulletArray[i])   
    end   
    for i,v in ipairs(enemyArray) do
        drawEnemy(enemyArray[i])   
    end  
end

function game:gameplayUpdate()
    
end

function game:menuDraw()
    local image=love.graphics.newImage("Assets/main menu.png")
    love.graphics.draw(image,0,0,0,love.graphics.getWidth()/255,love.graphics.getHeight()/160)
    --love.graphics.print("Click to start...")
    love.graphics.print("W,A,S,D for movement. Click to shoot")
end

function game:scoreboardDraw(scores)
    
    local image=love.graphics.newImage("Assets/scoreboard.png")
    love.graphics.draw(image,0,0,0,love.graphics.getWidth()/255,love.graphics.getHeight()/160)
    table.sort(scores, function(a, b) return a > b end)
    for i,v in ipairs(scores)
    do     
        love.graphics.print(scores[i],love.graphics.getWidth()*0.39,love.graphics.getHeight()*0.1+love.graphics.getHeight()*0.19*i,0,4)
        if(i==5)
        then
            break;
        end
    end
end

function game:distance2d(x1,x2,y1,y2)
    return (math.sqrt( math.pow((x1-x2),2) + math.pow((y1-y2),2)))
end

function game:checkCollision(x1,y1,x2,y2,z)
    i=0
    if(x1-z<x2 and x1+z>x2)
    then
        i=i+1
    end
    if(y1-z<y2 and y1+z>y2)
    then
        i=i+1
    end
    if(i==2)
    then
        return true   
    else 
        return false    
    end
end

function game:savescores(scores)
    data=""
    print("Saving...")
    for i=1,#scores,1
    do
        data=data .. tostring(scores[i])
        data=data .. "#"
    end
    print(data)
    local success, message=love.filesystem.write("savefile",data)
    print(success)
end

function game:loadscores()
    temp=love.filesystem.read("savefile")
    --return strSplit("#",temp)
end

function strSplit(delim,str)
    local t = {}

    for substr in string.gmatch(str, "[^".. delim.. "]*") do
        if substr ~= nil and string.len(substr) > 0 then
            print(substr)
            table.insert(t,tonumber(substr))
        end
    end

    return t
end
