import qualified XMonad.StackSet as W

import System.IO (hPutStrLn)
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.ResizableTile
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)
import XMonad.Util.Loggers (logCmd)
import XMonad.Util.Run (spawnPipe)


main = do
	statBarPipe <- spawnPipe myStateBar
	xmonad $ ewmh desktopConfig		-- fix LibreOffice dialogs, and cooperation with dzen
		{ -- hooks
		  layoutHook	= myLayoutHook
		, logHook		= dynamicLogWithPP $ myStateBarPP statBarPipe
		, manageHook	= myManageHook <+> manageHook defaultConfig
		, startupHook	= setWMName "LG3D"		-- fix java gui
		  -- look
		, borderWidth	= 2
		, focusedBorderColor	= myColFgUrgent
		, normalBorderColor		= myColBgNormal
		  -- workspaces
		, workspaces	= ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
		  -- keys & mouse
		, modMask		= mod4Mask
		} `additionalKeysP` myKeys `additionalKeys`
			[ ((0, 0x1008ff11), spawn "amixer -q set Master 5%- unmute")
			, ((0, 0x1008ff12), spawn "amixer -q set Master mute")
			, ((0, 0x1008ff13), spawn "amixer -q set Master 5%+ unmute")
			]

-- alternates
-- apps
myBrowser		= "chromium --enable-greasemonkey"
myImgViewer		= "gthumb"
myPdfViewer		= "evince"
myRunner		= "dmenu_run -b -nb '"++ myColBgNormal ++ "' -nf '" ++ myColFgNormal ++ "' -fn '" ++ myFont ++ "' -p '$'"
myRunnerRoot	= "sudo dmenu_run -b -nb '"++ myColBgNormal ++ "' -nf '" ++ myColFgNormal ++ "' -sb '" ++ myColFgUrgent ++ "' -fn '" ++ myFont ++ "' -p '#'"
myStateBar		= "dzen2 -bg '" ++ myColBgNormal ++ "' -fn '" ++ myFont ++ "' -ta l -w 960 -h 24 -dock"
myTerminal		= "dbus-launch gnome-terminal"
myTextEditor	= "libreoffice"
-- look
myColBgNormal	= "#252a33"
myColFgFocus	= "#d18a75"
myColFgNormal	= "#d7dbe2"
myColFgUnimp	= "#6f7e98"
myColFgUrgent	= "#bf6971"
--  myFont			= "-*-dax-light-r-normal-*-17-*-*-*-p-*-iso8859-1"
--  myFont			= "-adobe-source code pro for powerline-medium-r-normal-*-17-*-*-*-n-*-iso8859-1"
myFont			= "-monotype-cousine for powerline-medium-r-normal-*-17-*-*-*-p-*-iso8859-1"


-- config
myKeys =
	[ -- xmonad
	  ("M-<F1>", spawn myRunner)
	, ("M-<F3>", spawn myRunnerRoot)
	, ("M-f", withFocused $ windows . W.sink)
	, ("M-q", kill)
	, ("M-s", spawn "/home/kamil/.dzen/dzen-stats.sh")
	, ("M-S-r", restart "xmonad" True)
	, ("M-u", spawn "touch .dzen-update-now")
	  -- apps
	, ("M-b", spawn myBrowser)
	, ("M-i", spawn myImgViewer)
	, ("M-m", spawn (myBrowser ++ " www.gmail.com"))
	, ("M-p", spawn myPdfViewer)
	, ("M-t", spawn myTextEditor)
	, ("M-<Return>", spawn myTerminal)
	  -- xkb
	, ("M-`", spawn "/home/kamil/conf/kbd/layout_switcher.sh often")
	, ("M-S-`", spawn "/home/kamil/conf/kbd/layout_switcher.sh menu")
	]


myLayoutHook = avoidStruts (resizableTall ||| resizableWide) where
	resizableTall	= ResizableTall 1 (3/100) (1/2) []
	resizableWide	= ResizableTall 2 (3/100) (1/2) []


myManageHook = manageDocks <+> composeAll
	[ className =? "desktop-data-manager" --> doIgnore
	, className =? "stalonetray"		--> doIgnore
	-- download windows
	, className =? "Download"			--> doShift "nine"
	-- dialogs
	, stringProperty "WM_WINDOW_TYPE"	=? "_NET_WIM_WINDOW_TYPE_DIALOG" --> doFloat
	-- fontforge
	, stringProperty "WM_NAME"			=? "Layers"	--> doFloat
	, stringProperty "WM_NAME"			=? "Tools"	--> doFloat
	-- geeqie fullscreen
	, stringProperty "WM_NAME"			=? "Full screen - Geeqie" --> doSink
	-- screen ruler
	, stringProperty "WM_NAME"			=? "Screen Ruler"	--> doFloat
	]
	<+> composeOne
	[ isFullscreen						-?> doFullFloat
	]


myStateBarPP handle = defaultPP
	{ -- content
	  ppExtras	= []
	, ppOrder	= \(ws:l:t:e) -> [ws] ++ e
	  -- look
	, ppCurrent	= dzenColor myColFgFocus ""
	, ppHidden	= dzenColor myColFgNormal ""
	, ppOutput	= hPutStrLn handle
	, ppSep		= " | "
	, ppUrgent	= dzenColor myColFgUrgent ""
	}


doSink :: ManageHook
doSink = ask >>= \w -> liftX (reveal w) >> doF (W.sink w)
