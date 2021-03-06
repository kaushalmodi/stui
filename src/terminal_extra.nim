import os, osproc
import termios

proc getColorMode*(): int =
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

proc switchToAlternateBuffer*()=
    stdout.write "\e[?1049h\e[H" #and move to home position

proc switchToNormalBuffer*()=
    stdout.write "\e[?1049l"

#[ 

# not working as espected - disabling ECHO should remove mouse output on screen
# and enable Channels/sleep on main thread but it hides cursor (?)

proc disableEchoAndCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag and not Cflag(ECHO)
    cur.c_lflag = cur.c_lflag or Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr) #TCSADRAIN

proc enableEchoAndCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag or Cflag(ECHO)
    cur.c_lflag = cur.c_lflag and not Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr)
 ]#

# looks like resetting terminal resets this too, bt anyway...
proc disableCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag or Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr) #TCSADRAIN

# if not used, after stdout.write a '\n' needs to be written!! for screen update
# looks like \n needs to be written anyway... ?!
proc enableCanon*()=
    # from terminal readPassword
    let fd = stdin.getFileHandle()
    var cur: Termios
    discard fd.tcgetattr(cur.addr)
    cur.c_lflag = cur.c_lflag and not Cflag(ICANON)
    discard fd.tcsetattr(TCSANOW, cur.addr)
