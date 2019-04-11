SetVirtualResolution(800, 600)
SetWindowSize(1240, 768, 0)

GoSub Loader

SetSpritePosition(1, spriteX, spriteY)
SetSpritePosition(2, 1000, 10)

enemyX = Random(0, layarW - enemyWidth)
enemyY = -100
SetSpritePosition(3, enemyX, enemyY)
speed = 10
PlaySound(4, 50, 1)
enemyMoveHorizontal = 2
enemyMoveVertical = 4
LaserShoot = 0
EnemyShoot = 0

LaserSpeed = 10

BackgroundSpeed = 1

PauseState = 0

GameOverState = 0

MenuState = 0

Score = 0

//main loop
do
	if MenuState = 0
		GoSub Menu
	else
		GoSub PlayerMovement
		GoSub PlayerShoot
		GoSub EnemyMovement
		GoSub EnemyShoot
		GoSub Collisions
		GoSub BackgroundMovement
		GoSub Scoring
		GoSub GameOver
	endif
	sync()
loop

Loader:
	layarW = GetVirtualWidth()
	layarH = GetVirtualHeight()
	
	LoadImage(6, "startmenu.jpg")
	
	LoadImage(4, "bg.jpg")
	CreateSprite(4,4)
	CreateSprite(5,4)
	SetSpriteSize(4, layarW, layarH)
	SetSpriteSize(5, layarW, layarH)
	
	LoadImage(2, "projectile.png")
	CreateSprite(2,2)
	SetSpriteSize(2, 10, 30)
	laserWidth = GetSpriteWidth(2)
	laserHeight = GetSpriteHeight(2)
	
	for i = 1 to 5
		CreateSprite (20 + i, 2)
		SetSpriteSize(20 + i, 10,30)
		SetSpritePosition(20 + i, 0, -1000)
	next
	
	LoadImage(1, "plane2.png")
	CreateSprite(1,1)
	SetSpriteSize(1, 100, 100)
	sWidth = GetSpriteWidth(1)
	sHeight = GetSpriteHeight(1)
	spriteX = layarW/2 - sWidth/2
	spriteY = layarH - sHeight/2
	
	LoadImage(3, "alien_ship.png")
	CreateSprite(3,3)
	SetSpriteSize(3, 50, 50)
	enemyWidth = GetSpriteWidth(3)
	enemyHeight = GetSpriteHeight(3)
	
	LoadSound(4, "bgsound.wav")
	LoadSound(1, "ashiap_shoot.wav")
	LoadSound(2, "ashiap_death.wav")
	LoadSound(3, "ashiap_kill.wav")
return

Menu:
	CreateText(5, "ASHIAAAP SHOOTER")
	SetTextSize(5, 50)
	SetTextPosition(5, layarW / 2 - GetTextTotalWidth(5) / 2, layarH / 2 - GetTextTotalHeight(5) / 2)
	CreateText(6, "Version 1.0.0")
	SetTextSize(6, 20)
	SetTextPosition(6, layarW / 2 - GetTextTotalWidth(6) / 2, layarH / 2 - GetTextTotalHeight(6) / 2 + 50)
	CreateText(7, "CLICK TO START")
	SetTextSize(7, 20)
	SetTextPosition(7, layarW / 2 - GetTextTotalWidth(7) / 2, layarH / 2 - GetTextTotalHeight(7) / 2 + 200)
	
	SetSpritePosition(3, -1000, 0)
	SetSpritePosition(1, -2000, 0)
	
	for i = 1 to 5
		SetSpritePosition(20 + i, -1000, 0)
	next
	
	CreateSprite(6,6)
	SetSpriteSize(6, layarW, layarH)
	
	repeat
		sync()
	until GetPointerPressed()
	
	MenuState = 1
	DeleteText (5)
	DeleteText (6)
	DeleteText (7)
	DeleteText (1)
	DeleteSprite(6)
return

PlayerMovement:
	spriteX = spriteX + GetJoystickX() * speed
	spriteY = spriteY + GetJoystickY() * speed
	if spriteX < 0
		spriteX = 0
		SetSpritePosition(1, spriteX, spriteY)
	elseif spriteX > layarW - 100
		spriteX = layarW - sWidth
		SetSpritePosition(1, spriteX, spriteY)
	else
		SetSpritePosition(1, spriteX, spriteY)
	endif
	if spriteY < 0
		spriteY = 0
		SetSpritePosition(1, spriteX, spriteY)
	elseif spriteY > layarH - sHeight
		spriteY = layarH - sHeight
		SetSpritePosition(1, spriteX, spriteY)
	else
		SetSpritePosition(1, spriteX, spriteY)
	endif
return

PlayerShoot:
	if LaserShoot = 0 then SetSpritePosition(2, -1000, 10)
	if laserY < -laserHeight
		LaserShoot = 0
	endif
	
	if GetRawKeyPressed(32) and LaserShoot = 0
		laserX = spriteX + sWidth/2 - laserWidth/2
		laserY = spriteY - laserHeight/2 + 30
		SetSpritePosition(2, laserX, laserY)
		LaserShoot = 1
		PlaySound (1)
	endif
	
	if LaserShoot = 1
		laserY = laserY - LaserSpeed
		SetSpritePosition(2, laserX, laserY)
	endif
return

EnemyMovement:
	enemyY = enemyY + enemyMoveHorizontal
	enemyX = enemyX + enemyMoveVertical
	SetSpritePosition(3, enemyX, enemyY)
	
	if enemyX > layarW - enemyWidth then enemyMoveVertical = -4
	if enemyX < 0 then enemyMoveVertical = 4
	
	if enemyY > layarH
		enemyY = 0 - enemyHeight //always make variable first
		SetSpritePosition(3, enemyY, enemyY)
	endif
return

EnemyShoot:
	if EnemyShoot = 0
		for i = 1 to 5
			SetSpritePosition(20 + i, -1000, -1000)
		next
	endif
	if Random(1, 25) = 1 and EnemyShoot = 0
		for i = 1 to 5
			SetSpritePosition(20 + i, GetSpriteX(3) + enemyWidth / 2, GetSpriteY(3) + enemyHeight)
		next
		EnemyShoot = 1
		PlaySound(1)
	endif
	
	if EnemyShoot = 1
		
		EnemyLaserSpeed = GetSpriteY(21) + 5
		
		
		SetSpritePosition(21, GetSpriteX(21) - 5, EnemyLaserSpeed)
		SetSpritePosition(22, GetSpriteX(22) - 2.5, EnemyLaserSpeed)
		SetSpritePosition(23, GetSpriteX(23) - 0, EnemyLaserSpeed)
		SetSpritePosition(24, GetSpriteX(24) + 2.5, EnemyLaserSpeed)
		SetSpritePosition(25, GetSpriteX(25) + 5, EnemyLaserSpeed)
		Print(enemyX)
	endif
	
	if GetSpriteY(21) > layarW
		EnemyShoot = 0
	endif
return

Collisions:
	//bullet to enemy
	if GetSpriteCollision(2, 3)
		enemyY = 0 - 500
		SetSpritePosition(3, enemyY, enemyY)
		LaserShoot = 0
		PlaySound (3)
		Score = Score + 100
		SetTextString(1, "Score : " + Str(score))
	endif
	
	//death
	if GetSpriteCollision(1, 3)
		GameOverState = 1
		PlaySound(2)
	endif
	
	for i = 1 to 5
		if GetSpriteCollision (20 + i , 1)
			GameOverState = 1
			PlaySound(2)
		endif
	next
return

GameOver:
	if GameOverState = 1
		DeleteSprite(1)
		DeleteSprite(2)
		LaserShoot = 1
		CreateText(2, "GAME OVER")
		SetTextSize(2, 50)
		CreateText(3, "Final Score : " + Str(Score))
		SetTextSize(3, 20)
		CreateText(4, "Press Space To Restart or Esc to Menu")
		SetTextSize(4, 20)
		SetTextPosition(2, layarW/2-GetTextTotalWidth(2)/2, layarH/2)
		SetTextPosition(3, layarW/2-GetTextTotalWidth(3)/2, layarH/2 + 50)
		SetTextPosition(4, layarW/2-GetTextTotalWidth(4)/2, layarH/2 + 75)
	endif
	
	if GetRawKeyPressed(32) and GameOverState = 1
		GameOverState = 0
		EnemyShoot = 0
		
		DeleteText(2)
		DeleteText(3)
		DeleteText(4)
		
		Score = 0
		SetTextString(1, "Score : " + Str(score))
		
		CreateSprite(1,1)
		SetSpriteSize(1, 100, 100)
		sWidth = GetSpriteWidth(1)
		sHeight = GetSpriteHeight(1)
		spriteX = layarW/2 - sWidth/2
		spriteY = layarH - sHeight/2
		
		CreateSprite(2,2)
		SetSpriteSize(2, 10, 30)
		LaserShoot = 0
		laserWidth = GetSpriteWidth(2)
		laserHeight = GetSpriteHeight(2)
		
		enemyX = Random(0, layarW - enemyWidth)
		enemyY = -100
		
		SetSpritePosition(3, enemyX, enemyY)
		
	elseif GetRawKeyPressed(27) and GameOverState = 1
		MenuState = 0
		GameOverState = 0
		
		DeleteText(2)
		DeleteText(3)
		DeleteText(4)
		
		Score = 0
		SetTextString(1, "Score : " + Str(score))
		
		CreateSprite(1,1)
		SetSpriteSize(1, 100, 100)
		sWidth = GetSpriteWidth(1)
		sHeight = GetSpriteHeight(1)
		spriteX = layarW/2 - sWidth/2
		spriteY = layarH - sHeight/2
		
		CreateSprite(2,2)
		SetSpriteSize(2, 10, 30)
		LaserShoot = 0
		laserWidth = GetSpriteWidth(2)
		laserHeight = GetSpriteHeight(2)
		
		enemyX = Random(0, layarW - enemyWidth)
		enemyY = -100
		SetSpritePosition(3, enemyX, enemyY)
		SetSpritePosition(20 + i, 0, -1000)
	endif
return

BackgroundMovement:
	atas = GetSpriteY(4) + BackgroundSpeed
	
	if atas > layarH then atas = 0
	
	SetSpritePosition(4, 0, atas)
	SetSpritePosition(5, 0, GetSpriteY(4)-layarH)
return

Scoring:
	CreateText(1, "Score : " + Str(score))
	SetTextSize(1, 20)
	SetTextPosition(1, 0, 0)
return
