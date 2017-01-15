Type=Class
Version=6.5
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
Private Sub Class_Globals
End Sub
Private Sub Initialize
End Sub
Private Sub WebPDecodeARGB(encoded() As Byte, len As Long, width() As Int, height() As Int)As Byte()
	Dim jo As JavaObject
	jo.InitializeStatic("com.google.webp.libwebp")
	Return jo.RunMethod("WebPDecodeARGB",Array(encoded, len, width, height))
End Sub
Private Sub WebPEncodeBGRA(pixels() As Byte, width As Int, height As Int, stride As Int, quality As Float)As Byte()
	Dim jo As JavaObject
	jo.InitializeStatic("com.google.webp.libwebp")
	Return jo.RunMethod("WebPEncodeBGRA",Array(pixels, width, height, stride , quality))
End Sub
Private Sub getBytesFromInputStream(ips As InputStream) As Byte()
	Dim out As OutputStream
	out.InitializeToBytesArray(100) 'size not really important
	File.Copy2(ips, out)
	Return out.ToBytesArray
End Sub
Private Sub ArrayToInputStream (data()  As Byte) As InputStream
	Dim In As InputStream
	In.InitializeFromBytesArray(data, 0, data.Length)
	Return In
End Sub
Private Sub writeFileFromByteArray(wpPath As String,wpname As String,data() As Byte)
	File.OpenOutput(File.DirRootExternal,"a.webp",False).WriteBytes(data,0,data.Length)
End Sub
Sub webpToBitmap(inp As InputStream)As Bitmap
	Dim encoded() As Byte =getBytesFromInputStream(inp)
	Dim width(1) As Int
	width(0)=0
	Dim height(1) As Int
	height(0)=0
	
	Dim decoded() As Byte = WebPDecodeARGB(encoded, encoded.length, width, height)
	Dim b As ByteConverter
	Dim pixels() As Int=b.IntsFromBytes(decoded)
	Dim bi As BitmapExtended
	bi.Initialize("")
	Return bi.createBitmap5(pixels,width(0),height(0),bi.ARGB_8888)
End Sub

Sub bitmapToWebp(bmp As AGBitmap,wpPath As String,wpname As String,quality As Float)
	Dim bts As Int = bmp.getByteCount()
	Dim buffer As JNByteBuffer=Null
	buffer= buffer.allocate(bts)
	bmp.copyPixelsToBuffer(buffer)
	Dim pixels() As Byte  = buffer.array()

	Dim height As Int = bmp.getHeight
	Dim width As Int = bmp.getWidth
	Dim stride As Int = width * 4

	For  y = 0 To pixels.Length-1 Step 4
		Dim b As Byte =pixels(y)
		pixels(y) =  pixels(y+2)
		pixels(y+2) = b
	Next

	Dim encoded() As Byte = WebPEncodeBGRA(pixels, width, height, stride, quality)
	writeFileFromByteArray(wpPath,wpname, encoded)
End Sub
#if java
  static {
    System.loadLibrary("webp");
  } 
#End If