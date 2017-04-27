#!/usr/bin/env ruby

cells = []

# quick-and-dirty pattern with all cells having 0-5 neighbors.
# this doesn't result in a terribly interesting visual, but it
# doesn't die off, have a super-short repetition, or reach a
# no-repetition equilibrium.
(0..9).each { |i|
    cells[i] = [0,0,0,1,1,0,0,0,0,0] if i % 2 == 0
    cells[i] = [0,0,0,0,0,1,0,1,0,0] if i % 2 == 1
}

while true do

    # print the cell matrix
    system 'clear'
    print '  '
    (0..9).each { |col| print col }
    print "\n"
    top_bottom_border = ' '
    (1..(cells[0].size + 2)).each { 'x'
	top_bottom_border += '-'
    }
    print top_bottom_border + "\n"
    i = 0
    cells.each { |row|
	print "#{i}|"
	row.each { |cell|
	    print (cell == 1) ? cell : ' '
	}
	print "|\n"
	i += 1
    }
    print top_bottom_border + "\n"

    # results of game conditions will be recorded in cells_new
    cells_new = []

    (0..(cells.size-1)).each { |row_self|

	cells_new[row_self] = []

	# matrix wraps around the top and bottom edges
	row_up = (row_self - 1) % 10
	row_down = (row_self + 1) % 10

	(0..(cells[row_self].size-1)).each { |col_self|

	    # matrix also wraps around the left and right edges
	    col_left = (col_self - 1) % 10
	    col_right = (col_self + 1) % 10

	    # coordinates of neighbor cells
	    neighbors = [
		[row_up, col_left],
		[row_up, col_self],
		[row_up, col_right],
		[row_self, col_left],
		[row_self, col_right],
		[row_down, col_left],
		[row_down, col_self],
		[row_down, col_right],
	    ]

	    ncount = 0
	    neighbors.each { |n|
		ncount += cells[n[0]][n[1]]
	    }

	    # evaluate cell growth/death per game rules
	    if cells[row_self][col_self] == 1
		if ncount == 2 or ncount == 3
		    cells_new[row_self][col_self] = 1
		else
		    cells_new[row_self][col_self] = 0
		end # if ncount
	    else
		cells_new[row_self][col_self] = (ncount == 3) ? 1 : 0
	    end # if cells[row_self][col_self]
	}
    }

    # place results of evaluations back into original 'cells' variable
    cells = cells_new

    # pause to allow human comprehension of the display
    sleep(1)

end # while true
