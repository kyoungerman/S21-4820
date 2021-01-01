package main

// Copyright (C) Philip Schlump, 2017-2020.

// Include templates in ./md into a file - usually index.html will be the file to
// keep updated.

// Ability to watch the directory and re-run when stuff changes.

// TODO
// 1. for every <script src=... - watch those files
// 2. var WatchPat = flag.String("watch-pattern", ".html,.js,.css", "Watch this list of file extensions.")	// xyzzy100
// 3. make this a list of directories, comma sep.  // xyzzy101
// 4. save config in a cache-burst.cfg file - use the --cache-burst only if no file, then --cache-burst-orverride re-writes file // xyzzy102

import (
	"bufio"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/filelib"
	"github.com/pschlump/godebug"
	"github.com/radovskyb/watcher"
	"gitlab.com/pschlump/PureImaginationServer/ReadConfig"
)

// Pass 1 (done)
// 		Done - list templates in ./mt - list all *.html files
// 		Later - use qt to generate the template includes

// Pass2 (done)
//	 Done - Implement CLI stuff and ./mtp.cfg.json

// Pass 3 (done)
// 	 Done - watch fns for change - if changed then re-gen

// Pass 4 (done)
// 	(done - sort of) - watch ./www-src/index.html
// 	(done) - Ability to update the cache burst flag every time.  $cache$ in file.
//		1. Read as a QT template and substitute?
//		2. Look for a pattern $$$cache-burst$$$ - and replace?
//		3. Save a permanent value in ?? where a .file?

// Pass 5
//	xyzzy - include other files?  Check to see if they have changed.

var Cfg = flag.String("cfg", "mtp.cfg.json", "config file for this call")
var DbFlag = flag.String("db_flag", "", "Additional Debug Flags")
var Watch = flag.Bool("watch", false, "Watch for changes and re-run on file update change.")
var CacheBurstOverride = flag.Int("cache-burst-override", 0, "For testing: override cache burst flag with constant, reset date to constant.")
var WatchDir = flag.String("watch-dir", "./www/js", "Watch for changes in any file in this directory.") // xyzzy101
var WatchPat = flag.String("watch-pattern", ".html,.js,.css", "Watch this list of file extensions.")    // xyzzy100
var Comment = flag.String("comment", "", "Commend for `ps -ef`")

type GlobalConfigData struct {
	Dest       string `json:"dest" default:"./www"`
	Mt         string `json:"mt" default:"./mt"`
	DebugFlag  string `json:"db_flag"`
	CacheBurst int    `json:"CacheBurst"`
}

var gCfg GlobalConfigData
var db_flag map[string]bool
var logFilePtr *os.File

func init() {
	logFilePtr = os.Stderr
	db_flag = make(map[string]bool)
}

func main() {

	flag.Parse() // Parse CLI arguments to this, --cfg <name>.json

	fns := flag.Args()

	// _ = fns

	// ------------------------------------------------------------------------------
	// Read in Configuraiton
	// ------------------------------------------------------------------------------
	// err := ReadConfig.ReadEncryptedFile(*Cfg, *PromptPassword, *Password, &gCfg)
	err := ReadConfig.ReadFile(*Cfg, &gCfg)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to read configuration: %s error %s\n", *Cfg, err)
		os.Exit(1)
	}

	gCfg.CacheBurst++
	ioutil.WriteFile(*Cfg, []byte(godebug.SVarI(gCfg)), 0644)

	if *CacheBurstOverride != 0 {
		gCfg.CacheBurst = *CacheBurstOverride
	}

	// ------------------------------------------------------------------------------
	// Debug Flag Processing
	// ------------------------------------------------------------------------------
	if gCfg.DebugFlag != "" {
		ss := strings.Split(gCfg.DebugFlag, ",")
		// fmt.Printf("gCfg.DebugFlag ->%s<-\n", gCfg.DebugFlag)
		for _, sx := range ss {
			// fmt.Printf("Setting ->%s<-\n", sx)
			db_flag[sx] = true
		}
	}
	if *DbFlag != "" {
		ss := strings.Split(*DbFlag, ",")
		// fmt.Printf("gCfg.DebugFlag ->%s<-\n", gCfg.DebugFlag)
		for _, sx := range ss {
			// fmt.Printf("Setting ->%s<-\n", sx)
			db_flag[sx] = true
		}
	}
	if db_flag["dump-db-flag"] {
		fmt.Fprintf(os.Stderr, "%sDB Flags Enabled Are:%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
		for x := range db_flag {
			fmt.Fprintf(os.Stderr, "%s\t%s%s\n", MiscLib.ColorGreen, x, MiscLib.ColorReset)
		}
	}

	// ----------------------------------------------------------------------------
	// main processing
	// ----------------------------------------------------------------------------
	for _, fn := range fns {
		includeMustacheTemplates(fn, gCfg.Dest, gCfg.Mt)
	}

	if *Watch {
		WatchAndRun(gCfg.Mt, fns[0], func() {
			gCfg.CacheBurst++
			for _, fn := range fns {
				includeMustacheTemplates(fn, gCfg.Dest, gCfg.Mt)
			}
		})
	}

}

func includeMustacheTemplates(fn, dest, mt string) {

	target := GenTarget(fn, dest)

	tfp, err := filelib.Fopen(target, "w")
	if err != nil {
		fmt.Printf("Error on open of %s error:%s at:%s fn [%s] dest [%s] mt [%s]\n", target, err, godebug.LF(), fn, dest, mt)
		return
	}

	if db0 {
		fmt.Printf("Processing From: [%s] Target: [%s] AT:%s\n", fn, target, godebug.LF())
	}

	t := time.Now()
	formatted := fmt.Sprintf("%d-%02d-%02dT%02d:%02d:%02d",
		t.Year(), t.Month(), t.Day(),
		t.Hour(), t.Minute(), t.Second())
	if *CacheBurstOverride != 0 {
		formatted = "2019-12-18T00:00:00"
	}

	_, lof, _ := IndexDir(mt)
	if db81 {
		fmt.Printf("List of files in template directory (mt=[%s]) is %s\n", mt, godebug.SVarI(lof))
	}

	nf := 0
	err = ReadFileAsLines(fn, func(line, fn string, line_no int) (err error) {
		// fmt.Printf("LineNo: %d Line: %s\n", line_no, line)
		if strings.HasPrefix(line, "$templates$") {
			nf++
			fmt.Fprintf(tfp, "<!-- Found at line %d at:%s -->\n", line_no, godebug.LF())

			for _, inputTmpl := range lof {
				baseFn := filepath.Base(filelib.RmExt(inputTmpl))
				body, err := ioutil.ReadFile(inputTmpl)
				if err != nil {
					fmt.Printf("Error: missing file %s error %s\n", inputTmpl, err)
					return err
				}

				// <script type="text/html" id="dom-template-TitleMainPage" src="/mt/TitleMainPage.html"></script>
				// <script type="text/html" id="dom-template-Pin2fa" src="/mt/Pin2fa.html"></script>
				// <script type="text/html" id="dom-template-Register" src="/mt/Register.html"></script>
				fmt.Fprintf(tfp, `
<script type="text/html" id="dom-template-%s">
%s</script>
`, baseFn, body)

			}
		} else if strings.HasPrefix(line, "$setup-templates$") {
			// $setup-templates$
			// 		genRenderFuncs ( "TitleMainPage" );
			for _, inputTmpl := range lof {
				baseFn := filepath.Base(filelib.RmExt(inputTmpl))
				fmt.Fprintf(tfp, "\t\tgenRenderFuncs ( %q );\n", baseFn)
			}
		} else if strings.Contains(line, "$$$cache-burst$$$") {
			line = strings.Replace(line, "$$$cache-burst$$$", fmt.Sprintf("%04d", gCfg.CacheBurst), -1)
			line = strings.Replace(line, "$$$gen-date$$$", formatted, -1)
			fmt.Fprintf(tfp, "%s\n", line)
		} else if strings.Contains(line, "$$$gen-date$$$") {
			line = strings.Replace(line, "$$$cache-burst$$$", fmt.Sprintf("%04d", gCfg.CacheBurst), -1)
			line = strings.Replace(line, "$$$gen-date$$$", formatted, -1)
			fmt.Fprintf(tfp, "%s\n", line)
		} else {
			fmt.Fprintf(tfp, "%s\n", line)
		}
		return
	})

	if nf != 1 {
		fmt.Printf("Error: Failed to find $templates$ in %s\n", fn)
	}
	if err != nil {
		fmt.Printf("Error: on file %s is %s\n", fn, err)
	}
}

func GenTarget(fn, dest string) (rfn string) {
	if fn[0:2] == "./" {
		fn = fn[2:]
	}
	ss := strings.Split(fn, "/")
	ss[0] = dest
	rfn = strings.Join(ss, "/")
	return
}

// ----------------------------------------------------------------------------------------------------------------------------------------
// Watch for changes and call fucntion
// ----------------------------------------------------------------------------------------------------------------------------------------

func WatchAndRun(dir, fn string, fx func()) {
	theWatcher := watcher.New()

	// Only files that match the regular expression during file listings will be watched.
	r := regexp.MustCompile(".*(\\.html|\\.js|\\.css)") // xyzzy100
	theWatcher.AddFilterHook(watcher.RegexFilterHook(r, false))

	go func() {
		for {
			select {
			case event := <-theWatcher.Event:
				if db3 {
					fmt.Println(event) // Print the event's info.
				}
				fx()
			case err := <-theWatcher.Error:
				log.Fatalln(err)
			case <-theWatcher.Closed:
				return
			}
		}
	}()

	// Watch this folder for changes.
	if err := theWatcher.AddRecursive(dir); err != nil {
		log.Fatalln(err)
	}

	// fmt.Printf("Setup for ./www/js\n")
	fmt.Printf("Setup for %s\n", *WatchDir)
	// if err := theWatcher.AddRecursive("./www/js"); err != nil {
	if err := theWatcher.AddRecursive(*WatchDir); err != nil {
		log.Fatalln(err)
	}

	// Look at the directory above the file - not an ideal solution - but works for the moment
	pathToFn := filepath.Dir(fn)
	if err := theWatcher.Add(pathToFn); err != nil {
		log.Fatalln(err)
	}

	// Print a list of all of the files and folders currently being watched and their paths.
	fmt.Printf("List of files being watched\n")
	for pathOf, f := range theWatcher.WatchedFiles() {
		fmt.Printf("%s: %s\n", pathOf, f.Name())
	}
	fmt.Println()

	// Start the watching process - it'll check for changes every 100ms.
	if err := theWatcher.Start(time.Millisecond * 100); err != nil {
		log.Fatalln(err)
	}
}

// ----------------------------------------------------------------------------------------------------------------------------------------
// Read and process lines in a file
// ----------------------------------------------------------------------------------------------------------------------------------------

// Called for each line, takes the line, file_name and the current line number.  If err is not-nil, then quit reading and return.
type FileProcess func(line, file_name string, line_no int) (err error)

func ReadFileAsLines(filePath string, fx FileProcess) (err error) {

	// with the file...
	var fp *os.File

	if filePath == "-" {
		fp = os.Stdin
	} else {
		fp, err = os.Open(filePath)
		if err != nil {
			return err
		}
	}

	// ... for each line ...
	line_no := 0
	scanner := bufio.NewScanner(fp)
	for scanner.Scan() {
		line := scanner.Text() // no \n or \r\n on line - already chomped - os independent:w
		line_no++

		// process line
		err = fx(line, filePath, line_no)
		if err != nil {
			fp.Close()
			return
		}
	}
	if err = scanner.Err(); err != nil {
		fp.Close()
		return fmt.Errorf("Error scanning %s file: %s", filePath, err.Error())
	}

	fp.Close()
	return
}

// ----------------------------------------------------------------------------------------------------------------------------------------
// Recursive directory list
// ----------------------------------------------------------------------------------------------------------------------------------------

func indexDir(dir string, nDocs *int, lof *[]string) error {
	df, err := os.Open(dir)
	if err != nil {
		return err
	}
	defer df.Close()
	fileList, err := df.Readdir(-1)
	if err != nil || len(fileList) == 0 {
		return err
	}
	for _, aFile := range fileList {
		Fn := aFile.Name()
		if aFile.IsDir() {
			indexDir(path.Join(dir, Fn), nDocs, lof)
		} else if MatchExtension(Fn) {
			if IndexFile(path.Join(dir, Fn), lof) {
				(*nDocs)++
			}
		}
	}
	return nil
}

var UseFileExt = map[string]bool{
	".html": true,
	".js":   true,
	".css":  true,
}

func MatchExtension(Fn string) bool {
	ext := filepath.Ext(Fn)
	return UseFileExt[ext]
}

// IndexDir takes a path in `dir` and recursively looks for all files below
// this path and collects them into lof.
func IndexDir(dir string) (nDocs int, lof []string, err error) {
	nDocs = 0
	err = indexDir(dir, &nDocs, &lof)
	if db1 {
		fmt.Printf("%d Templates Found\n", nDocs)
	}
	return
}

func IndexFile(fn string, lof *[]string) bool {
	*lof = append(*lof, fn)
	return true
}

var db0 = false
var db1 = false
var db3 = true
var db81 = true
