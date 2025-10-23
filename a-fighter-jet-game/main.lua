require ("Scripts/projectile")
require ("Scripts/enemy")
require ("Scripts/game")
require ("Scripts/player")
require ("Scripts/snakenemy")

function love.load()
    g=game:new()
    p=player:new()
    mouse_x=love.mouse.getX()
    mouse_y=love.mouse.getY()
    pop=love.audio.newSource("Assets/22LR Single Isolated WAV3.wav","static")
    font=love.graphics.newFont("Minecrafter.Reg.ttf",20)
    font:setFilter( "nearest", "nearest")
    love.graphics.setFont(font)
    warningImage=love.graphics.newImage("Assets/warning.png")
    bulletArray={}
    enemyArray={}
    --scores=game:loadscores()
    scores = {}
    warnings={}
    buttons={}
    warningTimer=-3
    enemyTimer=-3
    score=0
    levelTimer=60
    random=0
    gameplay=false
    menu=true
    scoreboard=false
    print(love.graphics.getWidth())--1536
    print(love.graphics.getHeight())--864
    createButtons()
end

function love.update(dt)
    mouse_x=love.mouse.getX()
    mouse_y=love.mouse.getY()
    if gameplay
    then  
        levelTimer=levelTimer-dt
        enemyTimer=enemyTimer+dt
        warningTimer=warningTimer+dt
        if(warningTimer>0.5 and warningTimer<1)
        then
            random=createWarning()
            warningTimer=1
        elseif(warningTimer>1.25)
        then
            table.remove(warnings,1)
            warningTimer=0
        end
        if(enemyTimer>0.5)
        then
            createEnemy(random)
            enemyTimer=0              
        end
        if(levelTimer<=0)
        then 
            gameplay=false
            table.insert(scores,score)
            game:savescores(scores)
            scoreboard=true
        end
        p:calcPlayerRotation()
        playerInput()
        collision()
    end
end

function love.draw()
    if menu
    then
        drawButton()
    elseif gameplay
    then
    game:gameplayDraw(score,levelTimer,p,bulletArray,enemyArray)
    drawWarning()
    elseif scoreboard
    then
        game:scoreboardDraw(scores)
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    if gameplay
    then
        if button==1
        then
            createBullet()
            love.audio.play(pop)
        end
    elseif menu
    then
        if button==1
        then
        buttonCollision()
        end
    elseif scoreboard
    then
        if button==1
        then
            menu=true
            scoreboard=false
            enemyArray={}
            bulletArray={}
            warnings={}
            levelTimer=60
            enemyTimer=-3
            warningTimer=-3
            score=0
            p.x=1000
            p.y=600
        end
    end    
end

function playerInput()
    if(love.keyboard.isDown("w") and p.y>0)
    then
        p.y=p.y-5
    elseif (love.keyboard.isDown("s") and p.y<850)
    then
        p.y=p.y+5
    elseif (love.keyboard.isDown("d") and p.x<1500)
    then
        p.x=p.x+5
    elseif (love.keyboard.isDown("a") and p.x>0)
    then
        p.x=p.x-5
    end
end

function collision()
    for i=1,#enemyArray,1
    do
        if not (enemyArray[i]==nil)
        then
            temp=game:checkCollision(p.x,p.y,enemyArray[i].x,enemyArray[i].y,32)
            if(temp)
            then
                scoreboard=true
                table.insert(scores,score)
                game:savescores(scores)
                gameplay=false
            end
        end
    end
    for i,v in ipairs(bulletArray) 
    do
        for k,j in ipairs(enemyArray) 
        do
            if not (bulletArray[i]==nil or enemyArray[k]==nil) 
            then
                temp=game:checkCollision(bulletArray[i].x,bulletArray[i].y,enemyArray[k].x,enemyArray[k].y,32)
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
    --recoil
    if(p.y>0 and p.y<850 and  p.x<1500 and p.x>0)
    then
        p.x=p.x+math.cos(temp.r+math.pi/2)*20
        p.y=p.y+math.sin(temp.r+math.pi/2)*20
    end
    table.insert(bulletArray,temp)
end

function drawBullet(bullet)
    love.graphics.draw(bullet.image,bullet.x,bullet.y,bullet:getr(),2,2)
    bullet:MOVE(p)
end

function createWarning()
    local i=math.random(1,10)
    if(i<7)
    then
    warning={x=100,y=i*100}
    elseif(i>6)
    then
        warning={x=p.x,y=100}
    end
    table.insert(warnings,warning)
    return i
end

function drawWarning()
    for i,v in ipairs(warnings) do
        love.graphics.draw(warningImage,warnings[i].x,warnings[i].y,0,4,4,8,8)
    end
end

function createEnemy(i) 
    if(i>6)
    then
        temp=snakenemy:new(p.x,0,0)
    end
    if(i==6)
    then
        temp=enemy:new(100,p.y,0)
    end
    if(i<6)
    then
        temp=enemy:new(100,i*100,0)
    end
    table.insert(enemyArray,temp)
end

function drawEnemy(enemy)
    love.graphics.draw(enemy.image,enemy.x,enemy.y,0,4,4,8,8)
    enemy:MOVE()
end

function createButtons()
    startButton={}
    startButton.image=love.graphics.newImage("Assets/playbutton.png")
    startButton.x=love.graphics.getWidth()*0.42
    startButton.y=love.graphics.getHeight()*0.18
    settingsButton={x=love.graphics.getWidth()*0.42,y=love.graphics.getHeight()*0.47,image=love.graphics.newImage("Assets/settingbutton.png")}
    exitButton={x=love.graphics.getWidth()*0.42,y=love.graphics.getHeight()*0.68,image=love.graphics.newImage("Assets/exitbutton.png")}
    buttons={startButton,settingsButton,exitButton}
end

function drawButton()
    for i,v in ipairs(buttons)
    do
        love.graphics.draw(buttons[i].image,buttons[i].x,buttons[i].y,0,4,4)
    end
end

function buttonCollision()
    for i,v in ipairs(buttons)
    do
        temp=game:checkCollision(mouse_x,mouse_y,buttons[i].x+76,buttons[i].y+76,76)
        if(temp)
        then
            if(i==1)
            then
                menu=false
                gameplay=true
            elseif(i==2)
            then
            elseif(i==3)
            then
                love.event.quit()
            end
        end
    end
end
