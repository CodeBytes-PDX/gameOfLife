#!/usr/bin/env ruby

require 'getoptlong'
require 'yaml'

opt = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--seconds', '-s', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--matrix',  '-m', GetoptLong::REQUIRED_ARGUMENT ],
)

sleepval = 0.5
matrix_name = 'matrix'

opt.each { |o, a|
    case o
	when '--help'
	    print <<-EOH.gsub(/^\t    /, '')
	    usage:\t#{__FILE__} [ {-m|--matrix} <matrix name> ] [ {-s|--seconds} <delay> ]
	    \t<delay> may be a float for fractions of seconds or 0 for maximum speed
	    EOH
	    exit
	when '--seconds'
	     sleepval = a.to_f
	when '--matrix'
	     matrix_name = a
    end # case o
}

cell_config = YAML.load_file('cell_config.yml')

cells = []

line_size = nil
(0..cell_config[matrix_name].size-1).each { |y|
    cells[y] = []
    row = cell_config[matrix_name][y] 

    # check grid values
    if row !~ /^[01]+$/
	$stderr.puts "Error in line #{y+1} of matrix #{matrix_name}: non-binary value found"
	exit(1)
    end # if row
    if ! line_size
	line_size = row.size
    elsif row.size != line_size
	$stderr.puts "Matrix #{matrix_name}: line 1 has length #{line_size}, but line #{y+1} has length #{row.size}"
	exit(1)
    end # if ! line_size

    (0..row.size-1).each { |x|
	cells[y].push row[x].to_i
    }
}

system 'clear'
cursor_home = `tput home`

frame_counter = 0
matrix_history = ['','']
while true do

    # print the cell matrix
    print cursor_home
    top_bottom_border = ''
    (1..(cells[0].size + 2)).each {
	top_bottom_border += '-'
    }
    print top_bottom_border + "\n"
    all_cells_str = ''
    cells.each { |row|
	print '|'
	row.each { |cell|
	    print (cell == 1) ? 'X' : ' '
	    all_cells_str += cell.to_s
	}
	puts '|'
    }
    print top_bottom_border + "\nIteration #{frame_counter}"
    frame_counter += 1

    if all_cells_str == matrix_history[0] or all_cells_str ==  matrix_history[1]
	print "\n\nEnded: "
	if all_cells_str =~ /1/
	    puts (all_cells_str == matrix_history[0]) ? 'only change is period 2 oscillation' : 'growth/death impossible'
	else
	    puts 'total death'
	end
	exit
    end
    matrix_history.push all_cells_str
    matrix_history.shift

    # results of game conditions will be recorded in cells_new
    cells_new = []

    (0..(cells.size-1)).each { |row_self|

	cells_new[row_self] = []

	# matrix wraps around the top and bottom edges
	row_up = (row_self - 1) % cells.size
	row_down = (row_self + 1) % cells.size

	(0..(cells[row_self].size-1)).each { |col_self|

	    # matrix also wraps around the left and right edges
	    col_left = (col_self - 1) % cells[0].size
	    col_right = (col_self + 1) % cells[0].size

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
    sleep(sleepval) unless sleepval == 0

end # while true
