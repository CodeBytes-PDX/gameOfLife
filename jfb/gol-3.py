#!/usr/bin/env python

import random

grid = [ [0,0,1,1,0,0,0,1,0,0] for j in range(10) ]

for i, row in enumerate(grid):
    row_up = (i-1) % 10
    row_down = (i+1) % 10
    for j, col in enumerate(row):
        col_left = (j-1) % 10
        col_right = (j+1) % 10

        neighbors = [
            grid[row_up][col_left], grid[row_up][j], grid[row_up][col_right],
            grid[i][col_left], grid[i][col_right],
            grid[row_down][col_left], grid[row_down][j], grid[row_down][col_right],
        ]

        n_alive_count = 0
        for n_alive in neighbors:
            n_alive_count += n_alive

        if grid[i][j]:
            if n_alive_count < 2:
                action = "die"
            elif n_alive_count < 4:
                action = "live"
            else:
                action = "die"
        else:
            if n_alive_count == 3:
                action = "come to life"
            else:
                action = "stay dead"


        print j, ",", i, " is ", grid[i][j], " and has ", n_alive_count, " live neighbors and will " + action
