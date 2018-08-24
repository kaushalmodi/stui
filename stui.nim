#[
    Default Keyboard Shortcuts:
        F2: menu TODO
        F5: refresh screen
        F9: menu TODO
        F10: quit app

        TAB: add focus to next gui Controll; commit changes to Controll (pe:TextArea)
        ESC and ESC again: cancel editing, quit app

        PgUP/PgDown: on Window -> change Page; on TextArea: "scroll"

    Mouse:
        Wheel "Scrolls": Window->Page; TextArea
]#

#[
    Requires: Deja-Vu or other Font with good range of unicode character support
]#

#[
    TODO:
        main loop poll consumes cpu
        
        TimedAction needs to be revised to be paralell

        force colorMode - xterm reports 8! but true color seems supported...
]#


import unicode, terminal, colors, colors256, colors_extra, terminal_extra
import os, osproc, locks, threadpool
import parseutils, parsecfg, strutils, strformat, unicode
import tables
import random, times








const
    KeyUp* = "[A"
    KeyDown* = "[B"
    KeyRight* = "[C"
    KeyLeft* = "[D"
    KeyEnd* = "[F"
    KeyPos1* = "[H"
    KeyIns* = "[2~"
    KeyDel* = "[3~"
    KeyPgUp* = "[5~"
    KeyPgDown* = "[6~"
    KeyF1* = "OP"
    KeyF2* = "OQ"
    KeyF3* = "OR"
    KeyF4* = "OS"
    KeyF5* = "[15~"
    KeyF6* = "[17~"
    KeyF7* = "[18~"
    KeyF8* = "[19~"
    KeyF9* = "[20~"
    KeyF10* = "[21~"
    KeyF11* = "[23~"
    KeyF12* = "[24~"
    KeyApps* = "[29~"
    KeyWin* = "[34~"

    Ctrl2* = 0
    CtrlA* = 1
    CtrlB* = 2
    CtrlC* = 3
    CtrlD* = 4
    CtrlE* = 5
    CtrlF* = 6
    CtrlG* = 7
    CtrlH* = 8
    CtrlI* = 9
    CtrlJ* = 10
    CtrlK* = 11
    CtrlL* = 12
    CtrlM* = 13
    CtrlN* = 14
    CtrlO* = 15
    CtrlP* = 16
    CtrlQ* = 17
    CtrlR* = 18
    CtrlS* = 19
    CtrlT* = 20
    CtrlU* = 21
    CtrlV* = 22
    CtrlW* = 23
    CtrlX* = 24
    CtrlY* = 25
    CtrlZ* = 26
    Ctrl3* = 27
    Ctrl5* = 28
    Ctrl6* = 29
    Ctrl7* = 30










type
    StyleColor* = array[0..3, int] # 0: 8color; 1: 16color int(terminal.fgBlue); 2: 256 color int(colors256.Blue); 3: RGB int(colors.colBlue)or(colors_extras.packedRGB)
    StyleSheet* = tuple[fgColor: StyleColor, 
                        bgColor: StyleColor, 
                        padding: tuple[left,top,right,bottom:int], 
                        margin: tuple[left,top,right,bottom:int], 
                        border:string, 
                        textStyle: set[terminal.Style]  ]

    StyleSheetRef* = ref StyleSheet
    StyleSheets* = TableRef[string, StyleSheetRef]

    CursorStyle* = enum
        blinkingBlock = 1,
        steadyBlock,
        blinkingUnderline,
        steadyUnderline

#............................

    Rect* = tuple
        x1,y1,x2,y2:int


    TTUI* = ref object of RootObj
        id*:string
        #???

#............................
    Event* = ref object of RootObj

    KMEvent* = ref object of Event
        btn*, x*, y* :int
        c*:char
        source*, target*:  Controll
        evType*: string

        key*: string
        ctrlKey*: int



    Option = tuple[name, value:string, selected:bool]
    OptionList* = seq[ Option  ]
    OptionListRef* = ref OptionList

    Listener = tuple[name:string, actions: seq[proc(source:Controll):void]]
    #Listener[T] = tuple[name:string, actions: seq[proc(source:T):void]]
    ListenerList = seq[Listener]

    Controll* = ref object of TTUI
        x1*,y1*,x2*,y2*, width*,heigth*:int
        
        width_unit*: string # used (by Tile) to store width unit: %, auto, ch(aracter)
        width_value*:int # used (by Tile) for responsive width calc
        #heigth_unit*: string #? heigth unit is percent.
        heigth_value*: int # stores % value in int 0-100
        recalc*:       proc(this_elem: Controll):void # if not nil called by Window.recalc()

        visible*:    bool # if `value=` fires draw(), decide if not to draw
        disabled*:   bool # only copy, no events

        onClick*:     proc(this_elem: Controll, event: KMEvent):void
        onScroll*:    proc(this_elem: Controll, event: KMEvent):void
        onDrag*:      proc(this_elem: Controll, event: KMEvent):void # set style
        onDrop*:      proc(this_elem: Controll, event: KMEvent):void
        onKeypress*:  proc(this_elem: Controll, event: KMEvent):void

        focus*:       proc(this_elem: Controll):void # set style, no redraw
        blur*:        proc(this_elem: Controll):void # set style, no redraw, trigger("change")
        cancel*:      proc(this_elem: Controll):void # undo - preval, blur
        drawit*:      proc(this_elem: Controll, updateOnly: bool):void # for focus, Cast(this).draw()
                                               #updateOnly: bool = cache, and reduces flicker

        listeners*:   ListenerList  # p.e.: add validation here via "change" event

        app*:         App
        win*:         Window
        styles*:      StyleSheets   # TableRef[string, StyleSheetRef]
        activeStyle*: StyleSheetRef # for draw()
        prevStyle*:   StyleSheetRef # for focus()/blur() not for drag!

        tabStop*: int



#............................


    Page* = ref object of Controll
        controlls*: seq[Controll]

    Window* = ref object of Controll
        tile*:Controll

        pages*: seq[Page]
        controlls*: seq[Controll]
        currentPage*: int #ptr Page

        title*: string

        #backgroundColor

    Tile* = ref object of Controll
        windows*:seq[Window]


    WorkSpace* = ref object of TTUI
        tiles*:seq[Tile]
        app:App
        #name*:string


    TimedAction* = tuple[name:string,interval:float,action:proc(app:ptr App):void,lastrun:float] # epochTime:float
    App* = ref object of RootObj
        address*: ptr App
        colorMode*:int
        terminalWidth*:int
        terminalHeight*:int

        styles*: StyleSheets
        activeStyle*: StyleSheetRef

        workSpaces*:seq[WorkSpace]
        widgets*:seq[Controll] # TODO fixed controlls
        availRect*: Rect #terminal - widgets
        overlay*:Tile

        activeWorkSpace*:  WorkSpace
        activeTile*:       Tile
        activeControll*:   Controll
        #currentPage*: proc
        #activeWindow*: proc

        #visibleControlls*: seq[Controll]

        dragSource*: Controll

        cursorPos*: tuple[x,y:int] # widgets will use it as storage - one variable fits all

        onKeypress*: proc(app:App, event: KMEvent):bool

        termlock*: Lock

        listeners*: seq[tuple[name:string, actions: seq[proc():void]]]
        timers*: seq[TimedAction] #seq[tuple[name:string,interval:float,action:proc()]]




    PageBreak* = ref object of Controll
    ColumnBreak* = ref object of Controll








######   ####  #    # #####  #####   ####  #####  #####    ###### #    # #    #
######  #      #    # #    # #    # #    # #    #   #      #      #    # ##   #
######   ####  #    # #    # #    # #    # #    #   #      #####  #    # # #  #
######       # #    # #####  #####  #    # #####    #      #      #    # #  # #
######  #    # #    # #      #      #    # #   #    #      #      #    # #   ##
######   ####   ####  #      #       ####  #    #   #      #       ####  #    #

#! import random
proc genId*(length: int = 5):string=
    randomize()
    var
        A = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','W','V','Z','Y']

    result = $rand(A)
    while result.len < length:
        result &= $rand(9)

#---------------------------------------------

# extrafun.nim :
proc `*`*(s:string, i:int):string=
    result = ""
    for a in 0..i-1:
        result = result & s

template tryit*(fun: untyped)=
        try:
            fun
        except:
            let
              e = getCurrentException()
              msg = getCurrentExceptionMsg()
            echo "Got exception ", repr(e), " with message ", msg
            #discard stdin.readLine()

#---------------------------------------------
###        ######  ######## ##    ## ##       ######## 
###       ##    ##    ##     ##  ##  ##       ##       
###       ##          ##      ####   ##       ##       
###        ######     ##       ##    ##       ######   
###             ##    ##       ##    ##       ##       
###       ##    ##    ##       ##    ##       ##       
###        ######     ##       ##    ######## ######## 
###       
###        
###         ######   #######  ##        #######  ########  
###       ##    ## ##     ## ##       ##     ## ##     ## 
###       ##       ##     ## ##       ##     ## ##     ## 
###       ##       ##     ## ##       ##     ## ########  
###       ##       ##     ## ##       ##     ## ##   ##   
###       ##    ## ##     ## ##       ##     ## ##    ##  
###        ######   #######  ########  #######  ##     ## 


#moved to terminal_extra
#[ proc getColorMode*(): int =
    var str = getEnv("COLORTERM") #$execProcess("printenv COLORTERM")
    if str notin ["truecolor", "24bit"]:
        str = $execProcess("tput colors")

        case str:
            of   "8\n": result = 0
            of  "16\n": result = 1
            of "256\n": result = 2
            else: result = 1
    else:
        result = 3
 ]#

proc resetColors*()=
    stdout.write "\e[0m"

# set uotput colors during Draw proc
proc setColors*(app:App, style:StyleSheet) =
    #terminal.resetAttributes()
    stdout.write "\e[0m"
    case app.colorMode:
        of 0,1:
            terminal.setBackgroundColor(BackgroundColor(style.bgColor[app.colorMode]))
            terminal.setForegroundColor(ForegroundColor(style.fgColor[app.colorMode]))
        of 2:
            setBackgroundColor(Color256(style.bgColor[app.colorMode]))
            setForegroundColor(Color256(style.fgColor[app.colorMode]))
        of 3:
            terminal.setBackgroundColor(Color(style.bgColor[3]))
            terminal.setForegroundColor(Color(style.fgColor[3]))
        else: discard
    if style.textStyle.card() > 0:
        terminal.setStyle(stdout, style.textStyle)

proc setColors*(app:App, style:StyleSheetRef)=setColors(app, style[])

proc setColors*(colorMode:int, style:StyleSheet) =
    #terminal.resetAttributes()
    stdout.write "\e[0m"
    case colorMode:
        of 0,1:
            terminal.setBackgroundColor(BackgroundColor(style.bgColor[colorMode]))
            terminal.setForegroundColor(ForegroundColor(style.fgColor[colorMode]))
        of 2:
            setBackgroundColor(Color256(style.bgColor[colorMode]))
            setForegroundColor(Color256(style.fgColor[colorMode]))
        of 3:
            terminal.setBackgroundColor(Color(style.bgColor[colorMode]))
            terminal.setForegroundColor(Color(style.fgColor[colorMode]))
        else: discard


proc copyColorsFrom*(this, style: StyleSheetRef)=
    this.fgColor = style.fgColor
    this.bgColor = style.bgColor
#---------------------------------------------


proc setTextStyle*(style: StyleSheetRef, textStyleStr: string)=
    case textStyleStr:
        of "": discard
        of "styleBright", "styleBold": style.textStyle.incl(styleBright)
        of "styleDim": style.textStyle.incl(styleDim)
        of "styleUnknown", "styleItalic", "styleStandout": style.textStyle.incl(styleUnknown)
        of "styleUnderscore", "styleUnderline": style.textStyle.incl(styleUnderscore)
        of "styleBlink": style.textStyle.incl(styleBlink)
        of "styleReverse", "styleInverse": style.textStyle.incl(styleReverse)
        of "styleHidden": style.textStyle.incl(styleHidden)


proc toggleBlink*(this:Controll, styleName:string="input")=
    if this.styles[styleName].textStyle.contains(styleBlink):
        this.styles[styleName].textStyle.excl(styleBlink)
    else:
        this.styles[styleName].textStyle.incl(styleBlink)

#---------------------------------------------

#[ #[  CursorStyle* = enum
        blinkingBlock = 1,
        steadyBlock,
        blinkingUnderline,
        steadyUnderline ]#
proc setCursorStyle*(Ps: CursorStyle)=
    stdout.write("\e[" & $int(Ps) & " q")
proc setCursorStyle*(Ps: int)=
    stdout.write("\e[" & $Ps & " q") ]#


#________________________________________________________________







proc styleSheetRef_fromConfig*(config: Config, section: string): StyleSheetRef =
    # supports newApp. read values from opened Config
    #
    result = new StyleSheetRef
    var value: string

    # background
    value = config.getSectionValue(section,"bgColor16")
    if value.len < 3:
        discard parseInt(value, result.bgColor[0])
    else:
        result.bgColor[0] = colors_extra.parseColor(value, 0) #colorNames16[ searchColorTable(colorNames16, value) ][1]

    value = config.getSectionValue(section,"bgColor16")
    if value.len < 3:
        discard parseInt(value, result.bgColor[1])
    else:
        result.bgColor[1] = colors_extra.parseColor(value, 1) #colorNames16[ searchColorTable(colorNames16, value) ][1]

    value = config.getSectionValue(section,"bgColor256")
    if value.len < 4:
        discard parseInt(value, result.bgColor[2])
    else:
        result.bgColor[2] = colors_extra.parseColor(value, 2) #colorNames256[ searchColorTable(colorNames256, value) ][1]

    value = config.getSectionValue(section,"bgColorRGB")
    if value.find(',') != -1:
        result.bgColor[3] = int(packRGB(value.split({','})))
    else:
        result.bgColor[3] = int(colors_extra.parseColor(value))
    
    #...................................................


    # background
    value = config.getSectionValue(section,"fgColor16")
    if value.len < 3:
        discard parseInt(value, result.fgColor[0])
    else:
        result.fgColor[0] = colors_extra.parseColor(value, 0) #colorNames16[ searchColorTable(colorNames16, value) ][1]

    value = config.getSectionValue(section,"fgColor16")
    if value.len < 3:
        discard parseInt(value, result.fgColor[1])
    else:
        result.fgColor[1] = colors_extra.parseColor(value, 1) #colorNames16[ searchColorTable(colorNames16, value) ][1]

    value = config.getSectionValue(section,"fgColor256")
    if value.len < 4:
        discard parseInt(value, result.fgColor[2])
    else:
        result.fgColor[2] = colors_extra.parseColor(value, 2) #colorNames256[ searchColorTable(colorNames256, value) ][1]

    value = config.getSectionValue(section,"fgColorRGB")
    if value.find(',') != -1:
        result.fgColor[3] = int(packRGB(value.split({','})))
    else:
        result.fgColor[3] = int(colors_extra.parseColor(value))

    #...................................................

    result.setTextStyle(config.getSectionValue(section,"textStyle"))

    result.border = config.getSectionValue(section,"border")
    if result.border == "": result.border = "none"



#________________________________________________________________






proc setPadding*(this:Controll,dir:string, size:int)=
    for style in this.styles.values:
        case dir:
            of "top":
                style.padding.top = size
            of "bottom":
                style.padding.bottom = size
            of "left":
                style.padding.left = size
            of "right":
                style.padding.right = size
            of "all":
                style.padding.top = size
                style.padding.bottom = size
                style.padding.left = size
                style.padding.right = size
            else: discard


proc setMargin*(this:Controll,dir:string, size:int)=
    for style in this.styles.values:
        case dir:
            of "top":
                style.margin.top = size
            of "bottom":
                style.margin.bottom = size
            of "left":
                style.margin.left = size
            of "right":
                style.margin.right = size
            of "all":
                style.margin.top = size
                style.margin.bottom = size
                style.margin.left = size
                style.margin.right = size
            else: discard


# todo: remake [top, right,bottom,left]
proc setMargin*(this:Controll, args: varargs[string])=
    var i = 0
    while i < args.len:
        this.setMargin(args[i], parseInt(args[i+1]) )
        i += 2

#------------------------

proc setBorder*(this:Controll, border:string)=
    for style in this.styles.values:
        style.border = border


#------------------------


proc setDisabled*(this: Controll)=
    this.disabled = true
    this.activeStyle = this.styles["input:disabled"] #? change-all to disabled???
    this.drawit(this, true)

#________________________________________________________________



#      
#       ######  ##     ## ########   ######   #######  ########  
#      ##    ## ##     ## ##     ## ##    ## ##     ## ##     ## 
#      ##       ##     ## ##     ## ##       ##     ## ##     ## 
#      ##       ##     ## ########   ######  ##     ## ########  
#      ##       ##     ## ##   ##         ## ##     ## ##   ##   
#      ##    ## ##     ## ##    ##  ##    ## ##     ## ##    ##  
#       ######   #######  ##     ##  ######   #######  ##     ## 
#       
proc parkCursor*(app:App){.inline.} # FW declaration


proc saveCursorPosAndAttrs*(){.inline.}=
    stdout.write("\e7")
proc restoreCursorPosAndAttrs*(){.inline.}=
    stdout.write("\e8")


# app.cursorPos is a buffer for controlls, users to hold cursor pos
proc setCursorPos*(app: App){.inline.}=
    stdout.write "\e[1A\n" #! this should make cursor more visible after updates
    terminal.setCursorPos(app.cursorPos.x, app.cursorPos.y)

proc setCursorPos*(app: App, x,y: int){.inline.}=
    app.cursorPos.x = x
    app.cursorPos.y = y
    terminal.setCursorPos(app.cursorPos.x, app.cursorPos.y)

#[  CursorStyle* = enum <------- remark
        blinkingBlock = 1,
        steadyBlock,
        blinkingUnderline,
        steadyUnderline ]#
proc setCursorStyle*(Ps: CursorStyle){.inline.}=
    stdout.write("\e[" & $int(Ps) & " q")
proc setCursorStyle*(Ps: int){.inline.}=
    stdout.write("\e[" & $Ps & " q")
#[ proc hideCursor*()= <------- exists in terminal.nim
    stdout.write "\e[?25l"
proc showCursor*()=
    stdout.write "\e[?25l" ]#

#*******************************************************************************
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************


###   ##      ## #### ##    ## ########   #######  ##      ##    ###   ###   
###   ##  ##  ##  ##  ###   ## ##     ## ##     ## ##  ##  ##   ##       ##  
###   ##  ##  ##  ##  ####  ## ##     ## ##     ## ##  ##  ##  ##         ## 
###   ##  ##  ##  ##  ## ## ## ##     ## ##     ## ##  ##  ##  ##         ## 
###   ##  ##  ##  ##  ##  #### ##     ## ##     ## ##  ##  ##  ##         ## 
###   ##  ##  ##  ##  ##   ### ##     ## ##     ## ##  ##  ##   ##       ##  
###    ###  ###  #### ##    ## ########   #######   ###  ###     ###   ###   

proc draw*(this: Window)
proc draw*(this: App)

   
proc setControllsVisibility*(this: Window, visibility: bool)=
    # enable/disable draw for controlls
    for iC in 0..this.controlls.high :
        this.controlls[iC].visible = visibility
    this.currentPage = 0

proc setControllsVisibility*(this:Tile, visibility: bool)=
    # enable/disable draw for controlls
    for iW in 0..this.windows.high:
        setControllsVisibility(this.windows[iW], visibility)

proc setControllsVisibility*(this:App, visibility: bool)=
    # enable/disable draw for controlls
    for i_ws in 0..this.workSpaces.high :
        for iT in 0..this.workSpaces[i_ws].tiles.high:
            for iW in 0..this.workSpaces[i_ws].tiles[iT].windows.high:
                setControllsVisibility(this.workSpaces[i_ws].tiles[iT].windows[iW], visibility)



proc pgUp*(this: Window)=
    if this.currentPage > 0:
        for iC in 0..this.pages[this.currentPage].controlls.high :
            this.pages[this.currentPage].controlls[iC].visible = false

        if this.app.activeControll.blur != nil:
            this.app.activeControll.blur(this.app.activeControll)
        this.currentPage = this.currentPage - 1
        this.draw()
        this.app.activeControll = this

proc pgDown*(this:Window)=
    if this.currentPage < this.pages.high:
        for iC in 0..this.pages[this.currentPage].controlls.high :
            this.pages[this.currentPage].controlls[iC].visible = false

        if this.app.activeControll != nil and this.app.activeControll.blur != nil:
            this.app.activeControll.blur(this.app.activeControll)
        this.currentPage = this.currentPage + 1
        this.draw()
        this.app.activeControll = this

proc window_onScroll(this:Controll, event:KMEvent)=
    case event.evType:
        of "ScrollUp": Window(this).pgUp()
        of "ScrollDown": Window(this).pgDown()
        else: discard

proc window_onClick(this:Controll, event:KMEvent)=
    let win = Window(this)
    if event.y == win.y1: # header
        if event.x == win.x1 + 1: # menu
            discard

        elif win.pages.len > 1 :
            if event.x == win.x1 + 3: # pageUp
                win.pgUp()

            elif event.x == win.x1 + 6: # pageUp
                win.pgDown()


proc windowBlur(this:Controll)=
    discard
proc windowFocus(this:Controll)=
    discard
proc windowDrawit(this: Controll, updateOnly: bool = false)=
    discard


#*****************************************************************

proc swapWindows*(this:Tile, newWindows: seq[Window]): seq[Window] =
    # swap tiles window, returns old windows for store/swap back
    result = this.windows
    setControllsVisibility(this, false)
    this.windows = newWindows



#*****************************************************************


proc setActiveWorkSpace*(app:App, ws:WorkSpace)=
    for iT in app.activeWorkSpace.tiles:
        for iW in iT.windows:
            for iC in iW.controlls:
                iC.visible = false
    app.activeWorkSpace = ws
    app.activeTile = if ws.tiles.len > 0 : ws.tiles[0] else: nil
    app.draw()
    app.parkCursor()


proc setActiveWorkSpace*(app: App, id:string)=
    for wS in app.workSpaces:
        if wS.id == id:
            app.setActiveWorkSpace wS

            
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************


#                              #     # ####### #     #
#   #    # ###### #    #       ##    # #       #  #  #       #    # ###### #    #
#   ##   # #      #    #       # #   # #       #  #  #       ##   # #      #    #
#   # #  # #####  #    #       #  #  # #####   #  #  #       # #  # #####  #    #
#   #  # # #      # ## #       #   # # #       #  #  #       #  # # #      # ## #
#   #   ## #      ##  ##       #    ## #       #  #  #       #   ## #      ##  ##
#   #    # ###### #    #       #     # #######  ## ##        #    # ###### #    #
#


proc parseSizeStr*(width:string): tuple[width_unit:string,width_value:int]=
    var 
        width_unit:string
        width_value:int

    if width == "auto":
        width_unit = "auto"
    else:
        var w_str: string # discard
        var count_numeric = width.parseUntil(w_str, {'%', 'c', 'p'}, 0)
        width_unit = width.substr(count_numeric)
        discard width.parseInt(width_value)

    result.width_unit = width_unit
    result.width_value = width_value




proc newStyleSheets*(): StyleSheets = newTable[string, StyleSheetRef](8)

proc newColumnBreak*(win: Window): ColumnBreak =
    result = new ColumnBreak
    result.activeStyle = win.styles["panel"]
    win.controlls.add(result)

proc newPageBreak*(win: Window): PageBreak =
    result = new PageBreak
    #result.activeStyle = win.styles["panel"]
    win.controlls.add(result)

proc newPage*(): Page =
    result = new Page
    result.controlls = @[]

proc newPage*(win: Window): Page =
    result = new Page
    result.controlls = @[]
    result.app = win.app
    result.styles.deepCopy win.app.styles
    result.activeStyle = result.styles["panel"]
    win.pages.add(result)


#[ proc newWindow*(): Window {.deprecated.}=
    result = new Window
    result.pages = @[]
    result.controlls = @[]
    result.currentPage = 0
    result.onClick = window_onClick ]#

proc newWindow*(tile: Tile): Window =
    #result = newWindow()
    result = new Window
    result.pages = @[]
    result.controlls = @[]
    result.currentPage = 0
    result.tile = tile
    result.app = tile.app

    result.onClick = window_onClick
    result.onScroll = window_onScroll

    result.styles.deepCopy tile.app.styles
    result.activeStyle = result.styles["panel"]

    result.blur = windowBlur
    result.focus = windowFocus
    result.drawit = windowDrawit

    tile.windows.add(result)



proc newTile*(ws: WorkSpace, width: string) : Tile =
    result = new Tile
    #[ if width == "auto":
        result.width_unit = "auto"
    else:
        var w_str: string
        var count_numeric = width.parseUntil(w_str, {'%', 'c', 'p'}, 0)
        result.width_unit = width.substr(count_numeric)
        discard width.parseInt(result.width_value) ]#
    (result.width_unit, result.width_value) = parseSizeStr(width)

    result.windows = @[]
    result.styles.deepCopy ws.app.styles
    result.activeStyle = result.styles["panel"]
    result.app = ws.app
    ws.tiles.add(result)



proc newWorkSpace*(app: var App, id:string="default"): WorkSpace =
    result = new WorkSpace
    result.tiles = @[]
    result.app = app
    result.id = if id == "default": genID() else: id
    app.workSpaces.add(result)
    if app.activeWorkSpace == nil: # for convinience. but you better set/track it manually!
        app.activeWorkSpace = result

# FWD
proc appOnKeypress*(app:App, event: KMEvent):bool

proc newApp*(): App =
    result = new App

    result.address = addr result

    initLock(result.termlock)

    result.listeners = @[]
    result.timers = @[]

    result.onKeypress = appOnKeypress

    result.availRect.x1 = 1
    result.availRect.y1 = 1
    result.availRect.x2 = terminalWidth()
    result.availRect.y2 = terminalHeight()

    result.cursorPos.x = 2
    result.cursorPos.y = 1

    result.workSpaces = @[]

    # init StyleSheet
    result.colorMode = getColorMode()

    result.styles = newStyleSheets() #newTable[string, StyleSheetRef](8)
    block LOAD_TSS:

        # _Terminal_Style_Sheet
        var
            dict = loadConfig("theme.tss")

        # default background colors:

        # window background
        result.styles.add("panel",styleSheetRef_fromConfig(dict,"panel"))
        result.activeStyle = result.styles["panel"] # ???

        result.styles.add("dock",styleSheetRef_fromConfig(dict,"dock")) # alt. win style

        # Controll's defaults
        result.styles.add("input", styleSheetRef_fromConfig(dict,"input"))

        # inverse for progressbar, etc - alt. "input" style
        var styleInverse: StyleSheetRef = new StyleSheetRef
        styleInverse.deepcopy result.styles["input"]
        styleInverse.fgColor = result.styles["input"].bgColor
        styleInverse.fgColor[0] -= 10
        styleInverse.fgColor[1] -= 10
        styleInverse.bgColor = result.styles["input"].fgColor
        styleInverse.bgColor[0] += 10
        styleInverse.bgColor[1] += 10
        result.styles.add("input:inverse",styleInverse)

        result.styles.add("input:focus",styleSheetRef_fromConfig(dict,"input-focus"))

        result.styles.add("input:disabled",styleSheetRef_fromConfig(dict,"input-disabled"))

        result.styles.add("input:drag",styleSheetRef_fromConfig(dict,"input-drag"))

        #............








#*******************************************************************************
#*******************************************************************************
#*******************************************************************************
#*******************************************************************************


#
#             #####  ######  ####    ##   #       ####
#       ##### #    # #      #    #  #  #  #      #    # #####
# #####       #    # #####  #      #    # #      #            #####
#       ##### #####  #      #      ###### #      #      #####
#             #   #  #      #    # #    # #      #    #
#             #    # ######  ####  #    # ######  ####



proc outerHeigth(this: Controll): int {.inline.} =
    if this.activeStyle.border != "none" and this.activeStyle.border != nil:
        return this.heigth + this.activeStyle.margin.top + this.activeStyle.margin.bottom + 2
    else:
        return this.heigth + this.activeStyle.margin.top + this.activeStyle.margin.bottom

proc borderWidth*(this: Controll): int {.inline.} =
    return if this.activeStyle.border == "none" or this.activeStyle.border == nil or this.activeStyle.border == "": 0 else: 1



proc recalc*(this: Window, tile: Tile, layer: int) =

    this.x1 = tile.x1 #see: proc recalc*(this: WorkSpace, availRect: Rect) =
    this.y1 = tile.y1 + layer
    this.x2 = tile.x2
    this.y2 = tile.y2
    this.width = tile.width
    this.heigth = this.y2-this.y1


    var
        availH = this.heigth - this.activeStyle.padding.top
        #iPage: int = 0 # for pages
        # for multiple columns
        xC: int = this.x1 + this.activeStyle.padding.left
        maxX: int = this.x1
        maxAvailH: int = 0 #TODO maxAvailH
        page: Page
        tabStop: int = 0

    #....................................

    proc calcAvailH(): int =
        # number of rows available for controlls
        # 100% width controlls change maxAvailH, wich is the top
        # others change maxX - the starter column
        #TODO maxAvailH
        if maxAvailH == 0:
            result = this.heigth - this.activeStyle.padding.top
        else:
            result = maxAvailH #this.heigth - this.activeStyle.padding.top - (maxAvailH - this.y1)

    proc newPage()=
        page =  this.newPage()
        xC = this.x1 + this.activeStyle.padding.left
        maxX = 0
        maxAvailH = 0
        availH = calcAvailH()
        tabStop = 0

    proc newColumn()=
        xC = maxX + 1 # +1: next column, not the x2 of this controll!
        availH = calcAvailH()

    #....................................
    # clear pages for recalc
    if this.pages.len > 0:
        this.pages = @[]

    if this.controlls.len > 0:
        discard this.newPage()
        page = this.pages[this.pages.low]

        # Column: top to bottom - left to right layout:
        for iC in 0..this.controlls.len - 1:#....................................

            if this.controlls[iC] of PageBreak:
                newPage()
                continue
            if this.controlls[iC] of ColumnBreak:
                newColumn()
                continue

            # if the Controll calculates for self, then do it:
                # so the whole layout is up for the user to handle!
            if this.controlls[iC].recalc != nil:
                this.controlls[iC].recalc(this)
            else: # if values for width, heigth added - by int or percentage:
                # if relative width used:
                if this.controlls[iC].width_value != 0: # 0 by default == look for heigth prop
                    # 100% width, maybe not needed but...:
                    if this.controlls[iC].width_value == 100:
                        this.controlls[iC].width = (this.width) - 
                            (this.controlls[iC].activeStyle.margin.left + 
                            this.controlls[iC].activeStyle.margin.right + 
                            this.controlls[iC].borderWidth() * 2) - 1

                    else:
                        this.controlls[iC].width = int((this.width.float / 100) * 
                            this.controlls[iC].width_value.float) - 
                            (this.controlls[iC].activeStyle.margin.left + 
                            this.controlls[iC].activeStyle.margin.right + 
                            this.controlls[iC].borderWidth() * 2)

                # heigth and width should be calculated at this point

                # if no room on bottom / and on side: ------------------------
                #   x2 precalc to know if controll fits on page
                #   
                this.controlls[iC].x2 = xC + 
                    (this.controlls[iC].width - 1) + 
                    (this.controlls[iC].borderWidth() * 2) + 
                    this.controlls[iC].activeStyle.margin.left + 
                    this.controlls[iC].activeStyle.margin.right #!X2

                if this.controlls[iC].outerHeigth() >= availH + 1 or this.controlls[iC].x2 > this.x2: 
                    # if room on the right: new column
                    if maxX + 1 + this.controlls[iC].width + 
                        this.controlls[iC].activeStyle.margin.left + 
                        this.controlls[iC].activeStyle.margin.right + 
                        this.controlls[iC].borderWidth() * 2 < this.x2:

                        xC = maxX + 1 # +1: next column, not the x2 of this controll!

                        availH = calcAvailH()
                    else: # new page
                        newPage()
                        
                        this.controlls[iC].x2 = xC + (this.controlls[iC].width - 1) + 
                            (this.controlls[iC].borderWidth() * 2) + 
                            this.controlls[iC].activeStyle.margin.left + 
                            this.controlls[iC].activeStyle.margin.right #!X2

                        # todo: rethink error MSG
                        if this.controlls[iC].outerHeigth() >= availH + 1 or this.controlls[iC].x2 > this.x2: 
                            echo "ERR Controll cannot be placed on screen!"
                            discard stdin.readLine()
                            continue
                        



                this.controlls[iC].tabStop = tabStop
                page.controlls.add(this.controlls[iC])
                tabStop += 1
                

                this.controlls[iC].x1 = xC #! xC may changed by newColumn->x2 recalc!!!

                this.controlls[iC].y1 = this.y1 + (this.heigth - availH) + this.controlls[iC].activeStyle.margin.top + 1

                this.controlls[iC].x2 = this.controlls[iC].x1 + (this.controlls[iC].width - 1) + (this.controlls[iC].borderWidth() * 2) + this.controlls[iC].activeStyle.margin.left + this.controlls[iC].activeStyle.margin.right #!X2

                this.controlls[iC].y2 = this.controlls[iC].y1 + (this.controlls[iC].heigth - 1) + (this.controlls[iC].borderWidth() * 2) + this.controlls[iC].activeStyle.margin.top + this.controlls[iC].activeStyle.margin.bottom

                availH -= this.controlls[iC].outerHeigth()

                if this.controlls[iC].width_value == 100: maxAvailH = availH

                if maxX <  this.controlls[iC].x1 + 
                    (this.controlls[iC].width - 1) + 
                    (this.controlls[iC].borderWidth() * 2) + 
                    this.controlls[iC].activeStyle.margin.left + 
                    this.controlls[iC].activeStyle.margin.right and
                    this.controlls[iC].width_value != 100:

                    maxX =  this.controlls[iC].x1 + 
                        (this.controlls[iC].width - 1) + 
                        (this.controlls[iC].borderWidth() * 2) + 
                        this.controlls[iC].activeStyle.margin.left + 
                        this.controlls[iC].activeStyle.margin.right



proc recalc*(this: WorkSpace, availRect: Rect) =
    var sum_fixTilesW, num_autoTiles: int
    for iT in 0..this.tiles.len - 1 :
        if this.tiles[iT].width_unit == "ch":
            sum_fixTilesW = sum_fixTilesW + this.tiles[iT].width_value
            this.tiles[iT].width = this.tiles[iT].width_value

    # calc flex tiles
    var flexAvailW = (availRect.x2 - availRect.x1) - sum_fixTilesW
    var sum_flexTilesW: int

    for iT in 0..this.tiles.len - 1 :
        if this.tiles[iT].width_unit == "%":
            this.tiles[iT].width = int(float(flexAvailW) * (float(this.tiles[iT].width_value) * 0.01))
            sum_flexTilesW = sum_flexTilesW + this.tiles[iT].width

        if this.tiles[iT].width_unit == "auto":
            num_autoTiles = num_autoTiles + 1

    var sum_autoTilesW : int
    if num_autoTiles > 0:
        for iT in 0..this.tiles.len - 1:
            if this.tiles[iT].width_unit == "auto":
                this.tiles[iT].width = (flexAvailW - sum_flexTilesW) div num_autoTiles
                sum_autoTilesW = sum_autoTilesW + this.tiles[iT].width

    #handle over/underrun:
    if sum_fixTilesW + sum_flexTilesW + sum_autoTilesW != (availRect.x2 - availRect.x1 + 1):
        if sum_fixTilesW + sum_flexTilesW + sum_autoTilesW > (availRect.x2 - availRect.x1 + 1):
            this.tiles[0].width = this.tiles[0].width - (sum_fixTilesW + sum_flexTilesW + sum_autoTilesW - (availRect.x2 - availRect.x1 + 1) )
        else:
            this.tiles[0].width = this.tiles[0].width + ((availRect.x2 - availRect.x1 + 1) - (sum_fixTilesW + sum_flexTilesW + sum_autoTilesW) )

    # calc x1 .... values
    var w_used: int = availRect.x1 #- 1
    for iT in 0..this.tiles.high :
        #w_used += 1
        this.tiles[iT].x1 = w_used
        this.tiles[iT].y1 = availRect.y1
        this.tiles[iT].x2 = w_used + this.tiles[iT].width - 1
        this.tiles[iT].y2 = availRect.y2

        # calc Windows
        #? relative Heigths?
        if this.tiles[iT].windows.len > 0:
            for iW in 0..this.tiles[iT].windows.high:
                recalc(this.tiles[iT].windows[iW], this.tiles[iT], iW)

        w_used += this.tiles[iT].width


proc recalc*(this: App) =
    #this.availRect.x1 = 1
    #this.availRect.y1 = 1
    #acquire(this.termlock)
    # todo: availrect widgets!!!
    this.availRect.x2 = terminalWidth()
    this.availRect.y2 = terminalHeight()
    this.setControllsVisibility(false)
    if this.workSpaces.len > 0:
        for i_ws in 0..this.workSpaces.high :
            this.workSpaces[i_ws].recalc(this.availRect)
    #release(this.termlock)










#
#                 #####  #####    ##   #    #
#           ##### #    # #    #  #  #  #    # #####
#     #####       #    # #    # #    # #    #       #####
#           ##### #    # #####  ###### # ## # #####
#                 #    # #   #  #    # ##  ##
#                 #####  #    # #    # #    #

#[  ═
┌─┐═
│ │
└─┘
┏━┓
┃ ┃
┗━┛
 ]#

proc leftX*(this: Controll) : int {.inline.} = 
    this.x1 + this.activeStyle.margin.left + this.borderWidth()

proc rightX*(this: Controll) : int {.inline.} =
    this.x2 - this.activeStyle.margin.right - this.borderWidth()

proc bottomY*(this: Controll) : int {.inline.} =
    this.y2 - this.activeStyle.margin.bottom - this.borderWidth()

proc topY*(this: Controll) : int {.inline.} =
    this.y1 + this.activeStyle.margin.top + this.borderWidth()



proc drawRect*(x1,y1,x2,y2:int){.inline.}=
    for y in y1..y2:
        terminal.setCursorPos(x1,y)
        stdout.write(" " * (x2 - x1 + 1) )


proc drawBorder*(borderStyle: string, x1,y1,x2,y2:int){.inline.}=
    case borderStyle:
        of "block":
            #top
            setCursorPos(x1,y1)
            stdout.write(" " * (x2 - x1 + 1) )
            #bottom
            setCursorPos(x1,y2)
            stdout.write(" " * (x2 - x1 + 1) )
            #left
            for i in y1..y2:
                setCursorPos(x1,i)
                stdout.write(" ")
            #right
            for i in y1..y2:
                setCursorPos(x2,i)
                stdout.write(" ")

        of "bold":
            #top
            setCursorPos(x1+1,y1)
            stdout.write("━" * (x2 - x1) )
            #bottom
            setCursorPos(x1+1,y2)
            stdout.write("━" * (x2 - x1) )
            #left
            for i in y1 + 1..y2-1:
                setCursorPos(x1,i)
                stdout.write("┃")
            #right
            for i in y1+1..y2-1:
                setCursorPos(x2,i)
                stdout.write("┃")
            #corners
            setCursorPos(x1,y1)
            stdout.write("┏")
            setCursorPos(x2,y1)
            stdout.write("┓")
            setCursorPos(x1,y2)
            stdout.write("┗")
            setCursorPos(x2,y2)
            stdout.write("┛")

        of "solid":
            #top
            setCursorPos(x1+1,y1)
            stdout.write("─" * (x2 - x1 - 1) )
            #bottom
            setCursorPos(x1+1,y2)
            stdout.write("─" * (x2 - x1 - 1) )
            #left
            for i in y1 + 1..y2-1:
                setCursorPos(x1,i)
                stdout.write("│")
            #right
            for i in y1+1..y2-1:
                setCursorPos(x2,i)
                stdout.write("│")
            #corners
            setCursorPos(x1,y1)
            stdout.write("┌")
            setCursorPos(x2,y1)
            stdout.write("┐")
            setCursorPos(x1,y2)
            stdout.write("└")
            setCursorPos(x2,y2)
            stdout.write("┘")
    

        of "double":
            #top
            setCursorPos(x1+1,y1)
            stdout.write("═" * (x2 - x1 - 1) )
            #bottom
            setCursorPos(x1+1,y2)
            stdout.write("═" * (x2 - x1 - 1) )
            #left
            for i in y1 + 1..y2-1:
                setCursorPos(x1,i)
                stdout.write("║")
            #right
            for i in y1+1..y2-1:
                setCursorPos(x2,i)
                stdout.write("║")
            #corners
            setCursorPos(x1,y1)
            stdout.write("╔")
            setCursorPos(x2,y1)
            stdout.write("╗")
            setCursorPos(x1,y2)
            stdout.write("╚")
            setCursorPos(x2,y2)
            stdout.write("╝")
    

        else: discard
#---------------------------------------------





#    [≡]═⟅Unnamed Document 1⟆════════════════════════════════════════════════════
#    [≡]═Unnamed Document 1════════════════════════════════════════════════════
#    [≡]═⦗Unnamed Document 1⦘════════════════════════════════════════════════════
#    [≡]▲ ▼╣Unnamed Document 1╠════════════════════════════════════════════════════  ╕╒
#    [≡]═[Unnamed Document 1]════════════════════════════════════════════════════
# ▲

method drawTitle*(this: Window) {.base.} =
    acquire(this.app.termlock)
    setColors(this.app, this.activeStyle[])
    terminal.setCursorPos(this.x1, this.y1)
    stdout.write("[≡]") # ▪ ≡ ✽  ☰
    var used = 3
    if this.pages.len > 1 and this.width > 7:
        if this.currentPage + 1 > 9 :
            stdout.write("▲" & $(this.currentPage + 1) & "▼")
        else:
            stdout.write("▲ " & $(this.currentPage + 1) & "▼")
        used = used + 4

    if this.width - used >= this.title.runeLen + 2:
        stdout.write("═⟅") # ┨ ╡ ┤ | ▌  ▐
        stdout.write(this.title)
        stdout.write("⟆") # ╞
        stdout.write("═" * (this.width - used - this.title.runeLen - 2 - 1))
    elif this.width - used > 0 :
        stdout.write("⟅") #
        stdout.write(this.title.runeSubstr(0,   (this.width - used - 2) ))
        stdout.write("⟆")
    release(this.app.termlock)


method draw*(this: Controll) {.base.} =
    discard

proc draw*(this: Window) =
    # titlebar: ▲▼ »« ‹› × ̊ ⁰
    acquire(this.app.termlock)
    setColors(this.app, this.activeStyle[])
    drawRect(this.x1, this.y1+1, this.x2, this.y2)
    release(this.app.termlock)

    this.drawTitle()

    if this.pages.len > 0 :
        if this.pages[this.currentPage].controlls.len > 0:
            for iC in 0..this.pages[this.currentPage].controlls.high :
                this.pages[this.currentPage].controlls[iC].visible = true
                if this.pages[this.currentPage].controlls[iC].drawit != nil:
                    this.pages[this.currentPage].controlls[iC].drawit(this.pages[this.currentPage].controlls[iC], false)
            #acquire(this.app.termlock)
            #setCursorPos(this.x1 + 1, this.y1) #? todo?
            parkCursor(this.app)
            #release(this.app.termlock)



method draw*(this: Tile) =
    if this.windows.len > 0 :
        this.windows[this.windows.len - 1].draw()


proc draw*(this: App) =
    #todo draw app widgets
    #...
    #this.setColors( this.activeStyle[])
    hideCursor()
    for i_tiles in 0..this.activeWorkSpace.tiles.len - 1 :
        this.activeWorkSpace.tiles[i_tiles].draw()

    #this.setColors (this.activeStyle[])
    showCursor()

#------------------------------------





                                
                                                                                      
#      I8                                                                           ,dPYb,
#      I8                                                                           IP'`Yb
#   88888888                                         gg                             I8  8I
#      I8                                            ""                             I8  8'
#      I8     ,ggg,    ,gggggg,   ,ggg,,ggg,,ggg,    gg    ,ggg,,ggg,     ,gggg,gg  I8 dP 
#      I8    i8" "8i   dP""""8I  ,8" "8P" "8P" "8,   88   ,8" "8P" "8,   dP"  "Y8I  I8dP  
#     ,I8,   I8, ,8I  ,8'    8I  I8   8I   8I   8I   88   I8   8I   8I  i8'    ,8I  I8P   
#    ,d88b,  `YbadP' ,dP     Y8,,dP   8I   8I   Yb,_,88,_,dP   8I   Yb,,d8,   ,d8b,,d8b,_ 
#   88P""Y88888P"Y8888P      `Y88P'   8I   8I   `Y88P""Y88P'   8I   `Y8P"Y8888P"`Y88P'"Y88
#[
XTERM conf
    http://www.futurile.net/2016/06/14/xterm-setup-and-truetype-font-configuration/

~/.Xresources :
    xterm*faceName: DejaVu Sans Mono
    xterm*faceSize: 12
    xterm*renderFont: true
    xterm*background: Black
    xterm*foreground: White

Merge .Xresources and check

    $ xrdb -merge .Xresources
    $ xterm &

For color: env TERM=xterm-256color xterm
 ]#

include termios                                  

proc closeTerminal() {.noconv.} =
    echo "\e[?1006l\e[?1002l" # mouse
    #echo "\ec\e[0m" # ? reset
    #resetAttributes()
    #echo "\e[?1049l" #switchToNormalBuffer
    switchToNormalBuffer()
    setCursorStyle(CursorStyle.blinkingBlock)
    showCursor()
    disableCanon()
    
proc closeTerminal*(app:App)=
    closeTerminal()

proc initTerminal*(app:App)=
    #resetAttributes() #?
    system.addQuitProc(closeTerminal)
    system.addQuitProc(resetAttributes)
    echo "\ec\e[0m" # ? reset
    echo "\e[?1002h\e[?1006h" # mouse enable + mode
    echo "\e%G" # ? set UTF8
    echo "\e[7l" # dont wrap
    switchToAlternateBuffer()
    enableCanon()
    hideCursor()

    if getColorMode() == 3: terminal.enableTrueColors()
    app.terminalHeight = terminalHeight()
    app.terminalWidth = terminalWidth()
    setCursorStyle(CursorStyle.steadyUnderline)












############          #    ######  ######
############         # #   #     # #     #    ###### #    # #    #
############        #   #  #     # #     #    #      #    # ##   #
############       #     # ######  ######     #####  #    # # #  #
############       ####### #       #          #      #    # #  # #
############       #     # #       #          #      #    # #   ##
############       #     # #       #          #       ####  #    #



# todo: make paralell:
proc runTimers*(this:App)=
    var time = epochTime()
    if this.timers.len > 0:
        for iT in 0..this.timers.high:
            if time - this.timers[iT].lastrun >= this.timers[iT].interval:
                this.timers[iT].action(this.address)
                this.timers[iT].lastrun = time

#-------------------------------------------------------------------------------
#[
    # activate is written before check for prevStyle != nil was inserted into blur()

    activate is useful to pass focus to other controll like selectbox->chooser
]#
proc activate*(app: App, controll:Controll)=
    if app.activeControll != nil:
        if app.activeControll.blur != nil:
            app.activeControll.blur(app.activeControll)
            app.activeControll.drawit(app.activeControll, false)

    if controll.focus != nil: controll.focus(controll)
    app.activeControll = controll
    controll.drawit(controll, false)



proc `activeWindow`*(this:App): Window {.inline.} =
    return this.activeTile.windows[this.activeTile.windows.high]

proc `activePage`*(this:App): Page {.inline.} =
    return this.activeTile.windows[this.activeTile.windows.high].pages[this.activeTile.windows[this.activeTile.windows.high].currentPage]


proc parkCursor*(app:App){.inline.}=
    ## move cursor to "parking" position
    ## proc blur() uses it mostly
    withLock app.termlock:
        terminal.setCursorPos(app.activeWindow.x1 + 1, app.activeWindow.y1 + 2)
        app.cursorPos.x = app.activeWindow.x1 + 1
        app.cursorPos.y = app.activeWindow.y1


    

###############################################################################
###############################################################################


proc getUIElementAtPos*(app:App, x,y:int, setActive: bool = false): Controll =
    ## gets Controll at mouse pos, make it activ if asked
    result = nil
    
    # todo: WIDGETS!!!!!
    # todo: WIDGETS!!!!!
    # todo: WIDGETS!!!!!
    # todo: WIDGETS!!!!!

    for iT in 0..app.activeWorkSpace.tiles.len - 1: # TODO WORKSPACES...TODO WORKSPACES...TODO WORKSPACES...
        let tile = app.activeWorkSpace.tiles[iT]

        if  tile.x1 <= x and tile.x2 >= x and tile.y1 <= y and tile.y2 >= y:
            #echo tile.id
            #echo tile.windows[tile.windows.high].currentPage
            app.activeTile = app.activeWorkSpace.tiles[iT]

            if tile.windows.len > 0 and tile.windows[tile.windows.high].pages.len > 0:
                let page = tile.windows[tile.windows.high].pages[tile.windows[tile.windows.high].currentPage]

                for iE in 0..page.controlls.len - 1:
                    if  page.controlls[iE].x1 <= x and 
                        page.controlls[iE].x2 >= x and 
                        page.controlls[iE].y1 <= y and 
                        page.controlls[iE].y2 >= y and
                        page.controlls[iE].visible :
                        #echo "FOUNDIT"

                        if setActive :
                            #var currentControll = page.controlls[iE]
                            # blur active controll:
                            if app.activeControll != nil #[ and app.activeControll != page.controlls[iE] ]# :
                                if app.activeControll.blur != nil:
                                    app.activeControll.blur(app.activeControll)
                                    app.activeControll.drawit(app.activeControll, false)
                                #[ else:
                                    echo repr app.activeControll.blur
                            else:
                                echo "?-?" ]#

                            # set active controll
                            app.activeControll = page.controlls[iE]
                            if app.activeControll.focus != nil: app.activeControll.focus(app.activeControll)

                        return page.controlls[iE]

            # if no controll found but Tile
            if app.activeControll != nil and setActive:
                if app.activeControll.blur != nil:
                    app.activeControll.blur(app.activeControll)
                    app.activeControll.drawit(app.activeControll, false)
            if setActive:
                app.activeControll = app.activeTile.windows[app.activeTile.windows.high] #app.workSpaces[0].tiles[iT]
                result = app.activeControll #app.workSpaces[0].tiles[iT]
            else:
                result = app.activeTile.windows[app.activeTile.windows.high]



###############################################################################
###############################################################################



proc appOnKeypress*(app:App, event: KMEvent):bool=
    result = false
    case event.evType:

        of "FnKey":
            case event.key:
                of KeyPgDown:
                    app.activeWindow.pgDown()   
                of KeyPgUp:
                    app.activeWindow.pgUp()
                of KeyF5:
                    app.recalc()
                    app.draw()
                of KeyF10:
                    acquire(app.termlock)
                    app.closeTerminal()
                    quit()
                else: #! new feature test!
                    if app.listeners.len > 0:
                        for i in 0..app.listeners.high:
                            if app.listeners[i].name == event.key:
                                for j in 0..app.listeners[i].actions.high:
                                    app.listeners[i].actions[j]()

        of "CtrlKey":
            case event.ctrlKey:
                of 9: # TAB 
                    # HINT: pageBreak is not added to controlls :)
                    if app.activeControll != nil:
                        var newTabStop: int = app.activeControll.tabStop

                        if app.activeControll.tabStop < app.activePage.controlls.high and not (app.activeControll of Window):
                            newTabStop += 1
                        else:
                            newTabStop = 0

                        if app.activeControll.blur != nil:    
                            app.activeControll.blur(app.activeControll) 
                            app.activeControll.drawit(app.activeControll, false)

                        app.activeControll = app.activePage.controlls[newTabStop]

                        if app.activeControll.focus != nil:    
                            app.activeControll.focus(app.activeControll)
                            app.activeControll.drawit(app.activeControll, false)
                            
                        result = true
                    else:
                        echo "???"

                else: discard

        else: discard
        
#------------------------------------------------------------------------

###############################################################################
###############################################################################


#########      ###### #    # ###### #    # #####  ####
#########      #      #    # #      ##   #   #   #
#########      #####  #    # #####  # #  #   #    ####
#########      #      #    # #      #  # #   #        #
#########      #       #  #  #      #   ##   #   #    #
#########      ######   ##   ###### #    #   #    ####


proc mouseEventHandler*(app: App, event: KMEvent):void =
    #echo event.evType  #repr(event)
    #echo repr(event)

    if event.evType == "Drop" : # needed to remove "drag path" from screen
        app.draw()

    var eventTarget: Controll
    if event.evType in ["Release","Drag", "ScrollDown","ScrollUp"]: # getuielement fires blur and sets activecontroll if asked
        eventTarget = app.getUIElementAtPos(event.x,event.y, false)
    else:
        eventTarget = app.getUIElementAtPos(event.x,event.y, true)

    if eventTarget != nil:
        event.target = eventTarget
        if event.evType == "Click" :
            if eventTarget.onClick != nil:
                eventTarget.onClick(eventTarget, event)

        if event.evType == "Drag" and app.dragSource == nil #[ and app.activeControll != nil ]#:
            if app.activeControll != eventTarget: #! patch - if dragged controll is not the activecontroll
                app.activate(eventTarget)
                
            app.dragSource = app.activeControll
            if app.dragSource.onDrag != nil: app.dragSource.onDrag(eventTarget, event)

        if event.evType == "Drop" :
            if app.dragSource != eventTarget and not app.dragSource.disabled and not eventTarget.disabled: # dont fire drop on itself OR disabled
                event.source = app.dragSource
                if eventTarget.onDrop != nil : eventTarget.onDrop(eventTarget, event)
            else:
                if eventTarget.focus != nil :
                    eventTarget.blur(eventTarget)
                    eventTarget.focus(eventTarget) # focus blurs source -> style reset

            app.dragSource = nil

        if event.evType in ["ScrollDown", "ScrollUp"] :
            if eventTarget.onScroll != nil : eventTarget.onScroll(eventTarget, event)





proc addEventListener*(controll:Controll, evtname:string, fun:proc(source:Controll):void)=
    var exists = false
    var newListener: Listener
    for i in 0..controll.listeners.high:
        if controll.listeners[i].name == evtname:
            controll.listeners[i].actions.add(fun)
            exists = true
    if not exists:
        newListener.name = evtname
        newListener.actions = @[]
        newListener.actions.add(fun)
        controll.listeners.add(newListener)


proc removeEventListener*(controll:Controll, evtname:string, fun:proc(source:Controll):void)=
    for i in 0..controll.listeners.high:
        if controll.listeners[i].name == evtname:
            for j in 0..controll.listeners[i].actions.high:
                if controll.listeners[i].actions[j] == fun:
                    controll.listeners[i].actions.del(j)


proc trigger*(controll:Controll, evtname:string )=
    for i in 0..controll.listeners.high:
        if controll.listeners[i].name == evtname:
            for j in 0..controll.listeners[i].actions.high:
                controll.listeners[i].actions[j](controll)


proc trigger*[T](obj:T, evtname:string )=
    for i in 0..obj.listeners.high:
        if obj.listeners[i].name == evtname:
            for j in 0..obj.listeners[i].actions.high:
                obj.listeners[i].actions[j](obj)



##############################################################
#[
Notes:

    Label and Border wont have style other than Panel:
        Controll styling seems sufficient

]#
##############################################################
when isMainModule:
    if isTrueColorSupported():
        terminal.enableTrueColors()
        setBackgroundColor(stdout, colDarkBlue)
    else:
        setBackgroundColor(bgBlue)
    eraseScreen()

