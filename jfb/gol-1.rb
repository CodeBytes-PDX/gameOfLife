#!/usr/bin/env ruby

class Cell
    attr_accessor :x, :y
    def initialize(world, x=0, y=0)
	@x = x
	@y = y
	@world = world
    end

    def die!
	@world.cells.delete_if { |cell| cell == self }
    end

    def neighbors(cell)
	if (self.x - cell.x).abs <= 1 and (self.y - cell.y).abs <= 1
	    return true
	else
	    return false
	end
    end
end

class World
    attr_accessor :cells
    def initialize
	@cells = []
	@cells << Cell.new(self)
	@cells << Cell.new(self, 0, 1)
	@cells << Cell.new(self, 1, 0)
	@cells << Cell.new(self, 2, 0)
	@cells << Cell.new(self, 5, 5)
    end
end

world = World.new
#world.cells << Cell.new(world)
#world.cells << Cell.new(world, 1, 1)

puts world.inspect

puts world.cells[0].neighbors(world.cells[1])

puts world.inspect
