# Game of Life code

* `gol-1.rb` is an object-oriented take, including my own tweaks to code
  develped with Nick App and Nader Mortazavi. The extremely basic output
  correctly indicates that `0,0` is a neighbor with `0,1` but not `5,5`.

* `gol-2.rb` is a functional (as opposed to OO) implementation with more
  output: first, the 10x10 grid is displayed, and then each cell's
  status is displayed along with neighbor counts and what should happen
  to it based on the four rules.  Even though I told everyone that I had
  the row/column handling correct after some amount of fighting, it's
  still not, but at least the results are correct.

* `gol-2a.rb` is a completion of `gol-2.rb` (with row/column stuff fixed
  for realsies). The cell matrix is animated with one-second pauses
  between frames.

* `gol-2b.rb` is further work on `gol-2a.rb`. Command-line options are now
   available, and the initial matrix is read from `cell_config.yml`. During
   run-time, the number of iterations is now displayed, and the cursor is
   merely homed between redraws instead of a full screen-clear. The script
   exits if a period 2 oscillation is encountered or if cell growth and
   death become impossible (fixed matrix).

* `gol-3.py` is essentially the same as `gol-2.rb`, but implemented in python.
  Besides the language, the main change is that the array of neighbors contains
  live/dead status rather than coordinates as in the ruby version.

* `gol.go` is a Go implementation.
  * The inter-frame delay can be specified on the command line.
  * The matrix filename and matrix name are hardcoded.
  * The program does not detect a fixed matrix or a period 2 oscillation.
