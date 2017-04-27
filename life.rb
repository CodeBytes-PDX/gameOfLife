def gameOfLife (world, x, y, newWorld, duplications)
	world = [[true, false, true, false, false], [true, false, true, false, false], [true, false, true, false, false], [true, false, true, false, false], [true, false, true, false, false]]
	x = 0
	y = 0
	duplications = 0
	newWorld = []
	cellPositions = [[0, -1], [0, 1], [1, 0],[-1,0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    if world[x,y] == true
    	cellPositions.each{|cells| cells  }
    	#first rule
    	#second rule
    	#third rule
    else #forth rule
    # if newWorld is fully populated replace world clear newWorld
    # stop if world & newWord match more then 5 time
    # stop if world is empty


