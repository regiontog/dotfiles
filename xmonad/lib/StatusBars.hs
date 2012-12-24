module StatusBars (
    DzenConf (..)
  , TextAlignDzen (..)
  , ScreenNum
  , TrayConf (..)
  , VTextAlignTray (..)
  , HTextAlignTray (..)

  , defaultDzenConf
  , dzen

  , defaultDHConf
  , conkyDzen

  , defaultTrayConf
  , tray
  , getColors
  ) where

import XMonad.Core (X)
import Data.Char (chr)
import Data.List (isInfixOf, isPrefixOf, find)
import Data.Maybe (fromMaybe)
import System.IO (Handle, hPutStrLn)
import XMonad.Hooks.DynamicLog hiding (dzen)
import Colors

data DzenConf = DzenConf
  { xPosition :: Maybe Int
  , yPosition :: Maybe Int
  , screen    :: Maybe ScreenNum
  , width     :: Maybe Int
  , height    :: Maybe Int
  , alignment :: Maybe TextAlignDzen
  , font      :: Maybe String
  , colors    :: Maybe DzenColors
  , workSpaces :: Maybe [[String]]
  , layoutAliases :: Maybe [(String, String)]
  }

type ScreenNum = Int
data TextAlignDzen = LeftAlign | RightAlign | Centered
instance Show TextAlignDzen where
  show LeftAlign  = "l"
  show RightAlign = "r"
  show Centered   = "c"

getColors :: DzenConf -> DzenColors
getColors c = fromMaybe defaultDzenColors (colors c)

_ubuntuMonoFont :: String
_ubuntuMonoFont = "-*-ubuntu mono-medium-r-normal-*-11-*-*-*-*-*-*-*"

defaultDzenConf :: DzenConf
defaultDzenConf = DzenConf
  { xPosition = Just 0
  , yPosition = Just 0
  , screen    = Just 0
  , width     = Nothing
  , height    = Just 15
  , alignment = Just LeftAlign
  , font      = Nothing
  , colors    = Just defaultDzenColors
  , workSpaces = Nothing
  , layoutAliases = Nothing
  }

colorDelim :: Char
colorDelim = chr 127
colorDivider :: Char
colorDivider = '|'

defaultDHConf :: Handle -> DzenConf -> X ()
defaultDHConf h c = dynamicLogWithPP $ defaultPP
  { ppHiddenNoWindows = wrapWS      (getColor . emptyWS      . getColors $ c) . \x -> dropWS $ x
  , ppHidden          = wrapWS      (getColor . hiddenWS     . getColors $ c) . \x -> dropWS $ x
  , ppUrgent          = wrapWS      (getColor . urgentWS     . getColors $ c) . \x -> dropWS $ x
  , ppCurrent         = wrapWS      (getColor . focusedWS    . getColors $ c) . \x -> dropWS $ x
  , ppVisible         = wrapWS      (getColor . unfocusedWS  . getColors $ c) . \x -> dropWS $ x
  , ppTitle           = wrapTitle  . getColor . activeTitle  . getColors $ c
  , ppLayout          = wrapLayout . getColor . activeLayout . getColors $ c
  , ppSep             = [colorDivider]
  , ppWsSep           = [colorDivider]
  , ppOrder           = \(ws:l:t:_) -> [l,ws,t]
  , ppOutput          = (\x -> hPutStrLn h $ cleanStatus x)
  }
  where
    cleanStatus s = concat $ map filterDividers $ strSplit colorDelim s
    wrapWS _ "" = ""
    wrapWS (fg,bg) name = (postBG bg) ++ (makeFG fg) ++ " " ++ name ++ " " ++ (preBG bg)
    wrapLayout (fg,bg) name = (makeBG bg) ++ (makeFG fg) ++ " " ++
        (lookup' name $ trans (fromMaybe [("","")] (layoutAliases c)) name) ++ " " ++ (preBG bg)
    wrapTitle (fg,bg) name = (postBG bg) ++ (makeFG fg) ++ "  " ++ name
    postBG bg = bg ++ [colorDelim]
    preBG bg = [colorDelim] ++ bg
    makeFG fg = "^fg(" ++ fg ++ ")"
    makeBG bg = "^bg(" ++ bg ++ ")"
    trans table item = lookup item table
    workspaces' = fromMaybe [[""]] . workSpaces $ c
    currWS = workspaces' !! fromMaybe 0 (screen c)
    lookup' orig trans'
      | trans' == Nothing = orig
      | otherwise = fromMaybe "" trans'
    dropWS ws = fromMaybe "" $ find (==ws) currWS
    --dropWS ws
    --  | ws = lookup' ws $ trans workspaces' ws
    --  | otherwise = ""

dzen :: DzenConf -> String
dzen c = unwords $ ["dzen2"]
    ++ addArg ("-fn", fmap quote $ font c)
    ++ addArg ("-fg", fmap quote $ foreground (getColors c))
    ++ addArg ("-bg", fmap quote $ background (getColors c))
    ++ addArg ("-ta", fmap show $ alignment c)
    ++ addArg ("-x",  fmap show $ xPosition c)
    ++ addArg ("-y",  fmap show $ yPosition c)
    ++ addArg ("-w",  fmap show $ width c)
    ++ addArg ("-h",  fmap show $ height c)
    ++ addArg ("-xs", fmap show $ fmap (+1) $ screen c)
  where
    quote = ("'" ++ ) . ( ++ "'")
    addArg (_, Nothing) = []
    addArg (opt, Just val) = [opt, val]

conkyDzen :: String -> DzenConf -> String
conkyDzen "" _ = ""
conkyDzen conkyrc dzenconfig = conky ++ " | " ++ (dzen dzenconfig)
  where
    conky = "conky -c " ++ conkyrc

data TrayConf = TrayConf
  { edge :: Maybe VTextAlignTray
  , hAlignment :: Maybe HTextAlignTray
  , pStrut :: Maybe Bool
  , height' :: Maybe Int
  , tint :: Maybe String
  , transparent :: Maybe Bool
  }

tray :: TrayConf -> String
tray conf = unwords $ ["trayer"]
  ++ addArg ("--edge", fmap show $ edge conf)
  ++ addArg ("--SetPartialStrut", fmap show $ pStrut conf)
  ++ addArg ("--align", fmap show $ hAlignment conf)
  ++ addArg ("--height", fmap show $ height' conf)
  ++ ["--widthtype", "request"]
  ++ addArg ("--tint", fmap show $ tint conf)
  ++ addArg ("--transparent", fmap show $ transparent conf)
  where
    addArg (_, Nothing) = []
    addArg (opt, Just val) = [opt, val]

defaultTrayConf :: TrayConf
defaultTrayConf = TrayConf
  { edge = Just BottomAlign
  , hAlignment = Just LeftAlign'
  , pStrut = Just True
  , height' = Just 16
  , tint = Just "0x333333"
  , transparent = Just True
  }

data VTextAlignTray = TopAlign | BottomAlign
instance Show VTextAlignTray where
  show TopAlign = "top"
  show BottomAlign = "bottom"
data HTextAlignTray = LeftAlign' | RightAlign'
instance Show HTextAlignTray where
  show LeftAlign' = "left"
  show RightAlign' = "right"

-- DynamicHook fixers
mkSolidDivider :: String -> String -> Int -> String
mkSolidDivider _ _ 0 = ""
mkSolidDivider fg bg n = (colorLead $ concat $ map mkRect $ map scaleSizes sizes) ++ "^p()"
  where
    sizes = [0..(n-1)]
    scaleSizes = (\x -> n*3 - x*3)
    mkRect = (\x -> "^r(1x" ++ show (x) ++ ")")
    colorLead rects = "^pa(;0)^fg(" ++ fg ++ ")^bg(" ++ bg ++ ")" ++ rects ++ "^pa(;2)"

mkLineDivider :: String -> Int -> String
mkLineDivider _ 0 = ""
mkLineDivider color n = (colorLine $ concat $ map mkRect $ map scaleSizes sizes) ++ "^p()"
  where
    sizes = [0..(n-1)]
    scaleSizes = (\x -> (n-1)*3 - x*3)
    mkRect = (\x -> "^pa(;" ++ show x ++ ")^r(1x3)")
    colorLine rects = "^fg(" ++ color ++ ")" ++ rects ++ "^pa(;2)"

strSplit :: Char -> String -> [String]
strSplit _ "" = []
strSplit c str = case dropWhile (== c) str of
    "" -> []
    str' -> w : strSplit c str''
        where (w, str'') = break (== c) str'

filterDividers :: String -> String
filterDividers str
  | length str == 15 && [colorDivider] `isInfixOf` str = makeDivider $ strSplit colorDivider str
  | otherwise = str
  where
    makeDivider (fg:bg:_)
      | fg /= bg = mkSolidDivider fg bg 5
      | otherwise = mkLineDivider "#666666" 5
