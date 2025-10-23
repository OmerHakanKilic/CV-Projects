require ("projectile")
require ("enemy")
require ("game")
require ("player")

function love.load()
    g=game:new()
    p=player:new()
    mouse_x=love.mouse.getX()
    mouse_y=love.mouse.getY()
    pop=love.audio.newSource("Balloon Pop 1.wav","static")
    bulletArray={}
    enemyArray={}
    enemyTimer=0
    score=0
    levelTimer=60
end

function love.update(dt)
    levelTimer=levelTimer-dt
    enemyTimer=enemyTimer+dt
    if(enemyTimer>2)
    then
        createEnemy()
        enemyTimer=0
    end
    mouse_x=love.mouse.getX()
    mouse_y=love.mouse.getY()
    p:calcPlayerRotation()
    playerInput()
    collision()
end

function love.draw()
    love.graphics.print(score,love.graphics.getWidth()-20)
    love.graphics.print(math.floor(levelTimer))
    love.graphics.draw(p.image,p.x,p.y,p.r,4,4,8,8)
    for i,v in ipairs(bulletArray) do
        drawBullet(bulletArray[i])   
    end   
    for i,v in ipairs(enemyArray) do
        drawEnemy(enemyArray[i])   
    end  
end

function love.mousepressed( x, y, button, istouch, presses )
    if button==1
    then
        createBullet()
        love.audio.play(pop)
    end
    if button==2
    then
        createEnemy()
    end
end

function playerInput()
    if(love.keyboard.isDown("w"))
    then
        p.y=p.y-5
    elseif (love.keyboard.isDown("s"))
    then
        p.y=p.y+5
    elseif (love.keyboard.isDown("d"))
    then
        p.x=p.x+5
    elseif (love.keyboard.isDown("a"))
    then
        p.x=p.x-5
    end
end

function collision()
    for i=1,#enemyArray,1
    do
        if not (bulletArray[i]==nil)
        then
            temp=game:checkCollision(p.x,p.y,enemyArray[i].x,enemyArray[i].y)
            if(temp)
            then
                love.event.quit(0)
            end
        end
    end
    for i,v in ipairs(bulletArray) 
    do
        for k,j in ipairs(enemyArray) 
        do
            if not (bulletArray[i]==nil or enemyArray[k]==nil) 
            then
                temp=game:checkCollision(bulletArray[i].x,bulletArray[i].y,enemyArray[k].x,enemyArray[k].y)
                if(temp)
                then
                    table.remove(bulletArray,i)
                    table.remove(enemyArray,k)
                    score=score+1
                end
            end
        end
    end
end

function createBullet()    
    temp=projectile:new(p.x-8,p.y-8,p.r)
    table.insert(bulletArray,temp)
end

function drawBullet(bullet)
    love.graphics.draw(bullet.image,bullet.x,bullet.y,bullet:getr(),2,2)
    bullet:MOVE(p)
end

function createEnemy()
    temp=enemy:new(100,100,0)
    table.insert(enemyArray,temp)
end

function drawEnemy(enemy)
    love.graphics.draw(enemy.image,enemy.x,enemy.y,0,4,4,8,8)
    enemy:MOVE()
end

