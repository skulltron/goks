SetVirtualResolution(800, 600)
SetWindowSize(1240, 768, 0)

GoSub Loader

SetSpritePosition(1, spriteX, spriteY)
SetSpritePosition(2, 1000, 10)

enemyX = Random(0, layarW - enemyWidth)
enemyY = -100
SetSpritePosition(3, enemyX, enemyY)
bgY = -100
SetSpritePosition(5, 0, -bgHeight)
speed = 10
PlaySound(4, 50, 1)
enemyMoveHorizontal = 2
enemyMoveVertical = 4
LaserShoot = 0

LaserSpeed = 10

PauseState = 0

GameOverState = 0

if GameOverState = 1 then PlaySound (2)

//main loop
do
	GoSub PlayerMovement
	GoSub PlayerShoot
	GoSub EnemyMovement
	GoSub Collisions
	GoSub BackgroundMovement
	GoSub Pause
	Print(LaserShoot)
	sync()
loop

Loader:
	layarW = GetVirtualWidth()
	layarH = GetVirtualHeight()
	
	LoadImage(4, "bg.jpg")
	CreateSprite(4,4)
	SetSpriteSize(4, 600, layarH)
	bgWidth = GetSpriteWidth(4)
	bgHeight = GetSpriteHeight(4)
	
	LoadImage(5, "bg.jpg")
	CreateSprite(5,5)
	SetSpriteSize(5, 600, layarH)
	bg2Width = GetSpriteWidth(5)
	bg2Height = GetSpriteHeight(5)
	
	LoadImage(2, "projectile.png")
	CreateSprite(2,2)
	SetSpriteSize(2, 10, 30)
	laserWidth = GetSpriteWidth(2)
	laserHeight = GetSpriteHeight(2)
	
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
	if GameOverState = 1 and LaserShoot = 1
			speed = 0
			enemyMoveHorizontal = 0
			enemyMoveVertical = 0
			LaserSpeed = 0
		endif
		if GameOverState = 1 and LaserShoot = 0
			
			speed = 0
			enemyMoveHorizontal = 0
			enemyMoveVertical = 0
			LaserSpeed = 0
			LaserShoot = 1
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

Collisions:
	if GetSpriteCollision(2, 3)
		enemyY = 0 - 500
		SetSpritePosition(3, enemyY, enemyY)
		LaserShoot = 0
		PlaySound (3)
	endif
	
	//death
	if GetSpriteCollision(1, 3) and GameOverState = 0
		GameOverState = 1
		LaserShoot = 1
		print ("Game Over")
	endif
return

Pause:
return

BackgroundMovement:
	bgY = bgY + 1
	SetSpritePosition(4, 0, bgY)
	if bgY > layarH - bgHeight
			Print("memek")
			bgY = bgY + 1
			SetSpritePosition(5, 0, 0 - bgHeight + bgY)
			SetSpritePosition(4, 0, bgY) 
	endif
return
