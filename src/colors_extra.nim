import colors, strutils, colors256, colorsRGBto256, terminal_extra
import os, osproc


#type ColorTable = array[int, tuple[name: string, color:int]]

var colorNames16* = [
    ("fgBlack",30),
    ("fgRed",31),
    ("fgGreen",32),
    ("fgYellow",33),
    ("fgBlue",34),
    ("fgMagenta",35),
    ("fgCyan",36),
    ("fgWhite",37),

    ("bgBlack",40),
    ("bgRed",41),
    ("bgGreen",42),
    ("bgYellow",43),
    ("bgBlue",44),
    ("bgMagenta",45),
    ("bgCyan",46),
    ("bgWhite",47)
]


type packedRGB*  = distinct int32

proc extractRGB*(a: int): tuple[r, g, b: range[0..255]] =
    ## extracts the red/green/blue components of the color `a`.
    result.r = a.int shr 16 and 0xff
    result.g = a.int shr 8 and 0xff
    result.b = a.int and 0xff
proc extractRGB*(a: packedRGB): tuple[r, g, b: range[0..255]] = extractRGB(int(a))

proc packRGB*(r,g,b:int): packedRGB =
    result = packedRGB(r shl 16 or g shl 8 or b)
proc packRGB*(a:seq[string]): packedRGB =
    var
        r,g,b:int

    r = parseInt(a[0])
    g = parseInt(a[1])
    b = parseInt(a[2])

    result = packedRGB(r shl 16 or g shl 8 or b)

proc `$`*(a: packedRGB): string =
    $int(a)



proc setBackgroundColor*(f: File, col: Color256) =
    f.write("\e[48;5;" & $int(col) & "m")

proc setBackgroundColor*(col: Color256) =
    setBackgroundColor(stdout, col)

proc setForegroundColor*(f: File, col: Color256) =
    f.write("\e[38;5;" & $int(col) & "m")

proc setForegroundColor*(col: Color256) =
    setForegroundColor(stdout, col)



proc searchColorTable*(colorTable: openArray[tuple[name: string, col: int]],
                       colorName: string): int =
    #echo colorTable.high
    result = -1 #int.high
    for i in 0..colorTable.high:
        if toLowerAscii(colorTable[i].name) == toLowerAscii(colorName): return colorTable[i].col
        #echo i


#[ proc getColorMode(): int =
    var str = getEnv("COLORTERM") #$execProcess("printenv COLORTERM")
    if str notin ["truecolor", "24bit"]:
        str = $execProcess("tput colors")

        case str:
            of   "8\n": result = 0
            of  "16\n": result = 1
            of "256\n": result = 2
            else: result = 1
    else:
        result = 3 ]#



proc parseColor*(colorName: string, colorMode: int): int =
    case colorMode:
        of 0,1: result = searchColorTable(colorNames16, colorName) #colorNames16[ searchColorTable(colorNames16, colorName) ][1]
        of 2:   
            result = searchColorTable(colorNames256, colorName) #colorNames256[ searchColorTable(colorNames256, colorName) ][1]
            if result == -1:
                result = searchColorTable(colorNamesRGBto256, colorName)
        of 3: result = int(colors.parseColor( toLowerAscii(colorName)))
            
        
        
        else: result = 0

proc parseColor*(colorName: string): int = parseColor(colorName, getColorMode())




when isMainModule:#------------------------------------------------
    echo packRGB(214,200,113)
    echo extractRGB(packRGB(214,200,113))
