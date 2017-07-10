package main

import (
    "flag"
    "fmt"
    "encoding/json"
    "io/ioutil"
    "log"
    "os"
    "os/exec"
    s "strings"
    "time"
)

type Config struct {
    Matrix map[string][]string `json:"matrices"`
}

func matrix_print(matrix []string) {

    header_footer := " "
    for i := 0; i < len(matrix[0]); i++ {
	header_footer = s.Join([]string{header_footer, "-"}, "")
    }
    fmt.Print(header_footer, "\n")
    for _, line := range matrix{
	fmt.Print("|")
	for _, char := range line{
	    if char == '1' {
		fmt.Print("O")
	    } else {
		fmt.Print(" ")
	    }
	}
	fmt.Print("|\n")
    }
    fmt.Print(header_footer, "\n")
}

func matrix_iterate(matrix []string)([]string) {

    var rowbytes = make([]byte, len(matrix[0]))
    var matrix_new = make([]string, len(matrix))
    y_size := len(matrix)
    x_size := len(matrix[0])

    neighbors := [8][2]int{
	    // {x, y}
	    {-1,-1}, {0,-1}, {1,-1},
	    {-1,0},          {1,0},
	    {-1,1},  {0,1},  {1,1} }

    for y, row := range matrix {
	copy(rowbytes, row[0:])

	for x, self := range row {
	    n_alive := 0
	    for _, coords := range neighbors {
		if matrix[(y_size+y+coords[1])%y_size][(x_size+x+coords[0])%x_size] == '1' {
		    n_alive++
		}
	    }
	    if self == '1' {
		if n_alive == 2 || n_alive == 3 {
		    rowbytes[x] = '1'
		} else {
		    rowbytes[x] = '0'
		}
	    } else {
		if n_alive == 3 {
		    rowbytes[x] = '1'
		} else {
		    rowbytes[x] = '0'
		}
	    }
	}

	matrix_new[y] = string(rowbytes)
    }
    return matrix_new

}

func main() {

    var config Config

    delay_sec := flag.Float64("delay", 1.0, "delay between frames in seconds, non-integer values OK")
    flag.Parse()

    matrix_name := "matrix_50x40_3095"

    source, err := ioutil.ReadFile("cell_config.json")
    if err != nil {
        panic(err)
    }

    err = json.Unmarshal(source, &config)
    if err != nil {
	log.Fatalf("error: %v", err)
    }

    matrix := config.Matrix[matrix_name]

    // because I haven't figured out (n)curses in go:
    // shell out to clear the screen
    cmd := exec.Command("clear")
    cmd.Stdout = os.Stdout
    cmd.Run()
    // and then shell out to capture the string for homing the cursor
    cmd = exec.Command("tput", "home")
    cursor_home, err := cmd.Output()

    for iter := 0;; iter++ {
	fmt.Print(string(cursor_home))
	matrix_print(matrix)
	fmt.Print("Iteration ", iter)

	if *delay_sec > 0 {
	    time.Sleep(time.Duration(*delay_sec * 1000) * time.Millisecond)
	}
	matrix = matrix_iterate(matrix)

    }

}

// ex:ai:sw=4:
