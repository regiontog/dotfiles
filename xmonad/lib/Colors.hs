module Colors(DzenColor, DzenColors (..), defaultDzenColors, getColor) where

import Data.Maybe (fromMaybe)

focusedBorder :: String
focusedBorder = "#33CC33"

unfocusedBorder :: String
unfocusedBorder = "#333333"

type DzenColor = (String, String)
data DzenColors = DzenColors
    { background   :: Maybe String
    , foreground   :: Maybe String
    , focusedWS    :: Maybe DzenColor -- Active WS
    , unfocusedWS  :: Maybe DzenColor -- WS on secondary monitor
    , hiddenWS     :: Maybe DzenColor -- WS w/ windows, but not visible
    , emptyWS      :: Maybe DzenColor -- WS w/o windows, not visible
    , urgentWS     :: Maybe DzenColor -- WS has triggered an UrgencyHook
    , activeTitle  :: Maybe DzenColor -- Title of focused window
    , activeLayout :: Maybe DzenColor -- Name of focused WS' layout
    }

defaultDzenColors :: DzenColors
defaultDzenColors = DzenColors
    { background   = Just "#333333"
    , foreground   = Just "#eeeeee"
    , focusedWS    = Nothing
    , unfocusedWS  = Nothing
    , hiddenWS     = Nothing
    , emptyWS      = Nothing
    , urgentWS     = Nothing
    , activeTitle  = Nothing
    , activeLayout = Nothing
    }

getColor :: Maybe DzenColor -> DzenColor
getColor c = fromMaybe ("#333333", "#eeeeee") c
