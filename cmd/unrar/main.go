package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/mholt/archiver/v3"
)

const usage = `Usage: unrar <command> <archive> [files...]

Commands:
  x         Extract files with full path

Switches:
  --        Stop switch scanning
  -o[+]	    Overwrite existing files
`

var overwrite = flag.Bool("o", false, "Overwrite existing files")
var overwritePlus = flag.Bool("o+", false, "Overwrite existing files")
var password = flag.String("p", "", "Set password (incompatible, TODO)")

// These no-op switches are defined solely for compatibility with UnRAR.
var _ = flag.Bool("ierr", false, "Send all messages to stderr")
var _ = flag.Bool("inul", false, "Disable all messages")
var _ = flag.Bool("kb", false, "Keep broken extracted files")
var _ = flag.Bool("p-", false, "Do not query password")
var _ = flag.Bool("r", false, "Recurse subdirectories")
var _ = flag.Bool("vp", false, "Pause before each volume")
var _ = flag.Bool("y", false, "Assume yes on all queries")

func init() {
	flag.Usage = func() {
		fmt.Print(usage)
	}
}

func main() {
	flag.Parse()

	if flag.NArg() != 2 && flag.Arg(0) != "x" {
		flag.Usage()
		os.Exit(2)
	}

	r := archiver.NewRar()
	r.OverwriteExisting = *overwrite || *overwritePlus
	r.Password = *password

	err := r.Unarchive(flag.Arg(1), ".")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
