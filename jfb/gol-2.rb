#!/usr/bin/env ruby

cells = []
(0..9).each { |i|
    cells[i] = [0,0,0,1,1,0,0,0,0,0] if i % 2 == 0
    cells[i] = [0,0,0,0,0,1,0,1,0,0] if i % 2 == 1
}

(0..(cells.size-1)).each { |row_self|
    puts cells[row_self].to_s
}

(0..(cells.size-1)).each { |row_self|

    row_up = (row_self - 1) % 10
    row_down = (row_self + 1) % 10

    (0..(cells[row_self].size-1)).each { |col_self|
	col_left = (col_self - 1) % 10
	col_right = (col_self + 1) % 10
	nbr = [
	    [col_left, row_up],
	    [col_self, row_up],
	    [col_right, row_up],
	    [col_left, row_self],
	    [col_right, row_self],
	    [col_left, row_down],
	    [col_self, row_down],
	    [col_right, row_down],
	]

	ncount = 0
	nbr.each { |n|
	    ncount += cells[n[1]][n[0]]
	}
	print "#{col_self},#{row_self} is " + (cells[col_self][row_self] == 1 ? "alive" : "dead") + " and has #{ncount} neighbors: will "
	if cells[col_self][row_self] == 1
	    case ncount
		when 0..1
		    puts "die"
		when 2..3
		    puts "live"
		else
		    puts "die"
	    end
	else
	    puts (ncount == 3) ? "spawn" : "stay dead"
	end
    }

}
