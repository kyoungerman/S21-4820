package main

import (
	"fmt"
	"image"
	"image/color"
	"image/draw"
	"io"
	"io/ioutil"
	"os"
	"strings"

	"github.com/fogleman/gg"
	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/simg"
)

func UserDecorateQR(pth string, beg, end int, Tag, ImageTag string) {

	// -------------------------------------------------------------------------------
	// Add labels to original PNG file. -- Just do the 1st one.
	// -------------------------------------------------------------------------------
	const S = 407 // Image size 407x407
	for ii := beg; ii <= end; ii++ {
		pngFn := fmt.Sprintf("%s/q%05d.png", pth, ii) // for i in q?????.png ; do
		idFn := fmt.Sprintf("%s/q%05d.id", pth, ii)
		theIdBytes, err := ioutil.ReadFile(idFn) // theid=$(cat ${BN}.id)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: Unable to open %s, error %s at:%s\n", idFn, err, godebug.LF())
			fmt.Fprintf(logFilePtr, "Error: Unable to open %s, error %s at:%s\n", idFn, err, godebug.LF())
			return
		}
		theId := strings.TrimSuffix(string(theIdBytes), "\n")

		im, err := gg.LoadImage(pngFn)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: Unable to load image %s, error %s at:%s\n", pngFn, err, godebug.LF())
			fmt.Fprintf(logFilePtr, "Error: Unable to load image %s, error %s at:%s\n", pngFn, err, godebug.LF())
			return
		}

		dc := gg.NewContext(S, S)
		dc.SetRGB(1, 1, 1)
		dc.Clear()
		dc.SetRGB(0, 0, 0)
		// if err := dc.LoadFontFace("/Library/Fonts/Arial.ttf", 24); err != nil {
		if err := dc.LoadFontFace(gCfg.ArialFont, 24); err != nil {
			panic(err)
		}
		dc.DrawImage(im, 0, 0)
		w, h := dc.MeasureString(Tag)
		fmt.Printf("->%s<- w %v h %v, pos_w %v\n", Tag, w, h, (w/2)+12)
		dc.DrawStringAnchored(Tag, (w/2)+12, 23, 0.5, 0.5) // dc.DrawStringAnchored(Tag, 92, 23, 0.5, 0.5)
		dc.DrawStringAnchored(theId, 195, 382, 0.5, 0.5)
		dc.Clip()

		outFn3 := fmt.Sprintf("%s/q%05d.1.png", pth, ii)
		dc.SavePNG(outFn3)

		// -------------------------------------------------------------------------------
		// Combine Logo Image Now
		// -------------------------------------------------------------------------------

		m := image.NewRGBA(image.Rect(0, 0, 407, 407))
		blue := color.RGBA{0, 0, 255, 255}
		draw.Draw(m, m.Bounds(), &image.Uniform{blue}, image.ZP, draw.Src)

		img, err := simg.ReadImg(outFn3)
		if err != nil {
			fmt.Printf("Error on read image: %s\n", err) // xyzzy new
		}

		ov, err := simg.ReadImg(ImageTag)
		if err != nil {
			fmt.Printf("Error on read image: %s\n", err) // xyzzy new
		}

		sr0 := img.Bounds()
		dp0 := image.Point{0, 0}
		r0 := image.Rectangle{dp0, dp0.Add(sr0.Size())}
		draw.Draw(m, r0, img, sr0.Min, draw.Src)

		sr := ov.Bounds()
		dp := image.Point{407 - 60, 0}
		r := image.Rectangle{dp, dp.Add(sr.Size())}
		draw.Draw(m, r, ov, sr.Min, draw.Src)

		outFn4 := fmt.Sprintf("%s/q%05d.2.png", pth, ii)
		simg.WriteImg(outFn4, m)
	}

	// --------------------------------------------------------------------------------------------------------------------------------

	lnLocalAbs := gCfg.LnLocal
	if lnLocalAbs[0:2] == "./" {
		lnLocalAbs = curDir + lnLocalAbs[1:]
	} else if lnLocalAbs[0:1] == "/" {
	} else {
		lnLocalAbs = curDir + lnLocalAbs
	}

	// fmt.Printf("AT: %s lnLocalAbs ->%s<- pth ->%s<-\n", godebug.LF(), lnLocalAbs, pth)
	for ii := beg; ii <= end; ii++ {

		LastGen = fmt.Sprintf("%s%s/q%05d.4.png", lnLocalAbs, pth, ii)

		if DbOn["lnLink"] {
			fmt.Printf("%sLnLocalAbs=[%s] at:%s %s\n", MiscLib.ColorCyan, lnLocalAbs, godebug.LF(), MiscLib.ColorReset)
		}

		if gCfg.LnLocal != "" {
			fn0 := lnLocalAbs + pth
			err := os.MkdirAll(fn0, 0775)
			if err != nil {
				fmt.Fprintf(os.Stderr, "User Unable to create [%s] error : %s\n", fn0, err)
			}

			fn0 = fmt.Sprintf("%s/q%05d.1.png", pth, ii)
			fn1 := fmt.Sprintf("%s%s/q%05d.1.png", lnLocalAbs, pth, ii)
			fn3 := fmt.Sprintf("%s%s/q%05d.3.png", lnLocalAbs, pth, ii)
			os.Remove(fn1)
			err = os.Link(fn0, fn1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "User Unable to link [%s] to [%s] error : %s\n", fn0, fn1, err)
			}
			CopyData(fn1, fn3)

			fn0 = fmt.Sprintf("%s/q%05d.2.png", pth, ii)
			fn1 = fmt.Sprintf("%s%s/q%05d.2.png", lnLocalAbs, pth, ii)
			fn3 = fmt.Sprintf("%s%s/q%05d.4.png", lnLocalAbs, pth, ii)
			os.Remove(fn1)
			err = os.Link(fn0, fn1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "User Unable to link [%s] to [%s] error : %s\n", fn0, fn1, err)
			}
			CopyData(fn1, fn3)
		}

	}

}

func CopyData(src, dst string) (int64, error) {
	source, err := os.Open(src)
	if err != nil {
		return 0, err
	}
	defer source.Close()

	// destination, err := os.Create(dst)
	destination, err := os.OpenFile(dst, os.O_RDWR, 0644)
	if err != nil {
		return 0, err
	}
	defer destination.Close()
	nBytes, err := io.Copy(destination, source)
	return nBytes, err
}
