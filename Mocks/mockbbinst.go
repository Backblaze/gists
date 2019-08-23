package main

/*************************
 * MOCKBBINST: A program run in place of the Backblaze installer that
 * generates random debugging output and a random return code of 1 or
 * 0. All the return codes listed are possible codes for the actual
 * MacOS installer.
 *************************/

import (
	"fmt"
	"math/rand"
	"os"
	"time"
)

/***************
 * For historical purposes, success means a write of
 *    BZERROR:1001
 * for success. Other BZERROR:XXXX codes indicate errors.
 ***************/

func main() {
	rand.Seed(time.Now().UnixNano())
	errNumber := []int{1000, 1001, 1013, 1014, 1015, 1018, 1016, 1017, 190}
	ix := rand.Int() % len(errNumber)
	fmt.Fprintf(os.Stdout, "STDOUT-BZERROR:%d\n", errNumber[ix])
	ix = rand.Int() % len(errNumber)
	fmt.Fprintf(os.Stderr, "STDERR-BZERROR:%d\n", errNumber[ix])
	// Without this defer, output to stderr might be lost on macosx
	defer func() {
		os.Stderr.Sync()
		os.Stdout.Sync()
	}()

	os.Exit(rand.Int() % 2)
}