#irWebp
webp library for b4a(Decode&Encode)

##How to use it?

Convert webp to bitmap

```basic
	Dim webp As irWebp
	Dim bmp As Bitmap=webp.webpToBitmap(File.OpenInput(File.DirAssets,"a.webp"))
``` 
convert bitmap to webp

```basic
	Dim webp As irWebp
	webp.bitmapToWebp(LoadBitmap(File.DirAssets,"a.jpg"),File.DirRootExternal,"/a.webp",50.0f)
``` 
