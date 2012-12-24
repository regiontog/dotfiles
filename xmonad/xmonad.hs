import XMonad

import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP)

import XMonad.Prompt (defaultXPConfig)
import XMonad.Prompt.Shell (shellPrompt)

import XMonad.Util.EZConfig
import XMonad.Util.Run

import StatusBars
import Colors

main = do
    workspaceBar <- spawnPipe $ dzen dzenWorkspace
    xmonad $ defaultConfig
        { terminal    = "urxvt"
        , workspaces  = concat myWokspaces
        , layoutHook  = avoidStruts  $  layoutHook defaultConfig
        , manageHook  = manageDocks <+> manageHook defaultConfig
        , logHook     = defaultDHConf workspaceBar dzenWorkspace
        , borderWidth = 0
        } `additionalKeys`
            [ ((mod1Mask , xK_r), shellPrompt defaultXPConfig) ]

myWokspaces = [["main", "www", "code", "chat", "media", "other"],["2nd screen"]]

workspaceColors = defaultDzenColors
    { background   = Just bg
    , foreground   = Just fg
    , focusedWS    = Just (    bg   , "#339933")
    , unfocusedWS  = Just (    bg   , "#3399FF")
    , hiddenWS     = Just (    fg   , "#444444")
    , emptyWS      = Just ("#999999",    bg    )
    , urgentWS     = Just (    bg   , "#CCCC33")
    , activeTitle  = Just ("#66CC66",    bg    )
    , activeLayout = Just (    fg   , "#3939EE")
    } where
        bg = "#333333"
        fg = "#eeeeee"

dzenWorkspace = defaultDzenConf
    { font          = Just "-*-ubuntu mono-medium-r-normal-*-15-*-*-*-*-*-*-*"
    , colors        = Just workspaceColors
    , workSpaces    = Just myWokspaces
    , layoutAliases = Just
        [ ("Tall", " T ")
        , ("Mirror Tall", " MT")
        , ("Full", " F ")
        ]
    }
