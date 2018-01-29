module Styles.Css exposing (..)

import Css exposing (..)
import Html exposing (..)
import Html.Attributes exposing (href, src, property, style, alt, title)


{-| Responsive functions
@docs responsive


# Responsive functions

-}
topPanelHeight : Px
topPanelHeight =
    (px 100)


{-| Named styling
@docs css


# Named css classes

-}
standardContainerStyle : Attribute msg
standardContainerStyle =
    style
        [ ( "width", "200px" )
        , ( "height", "200px" )
        , ( "display", "flex" )
        , ( "margin", "auto" )
        , ( "border", "solid 2px black" )
        ]


recaptchaStyle =
    style
        [ ( "data-sitekey", "6Ldd8kIUAAAAAMWDt3cljw_DssCykzu4Hc36vW_M" )
        ]


tablestStyle =
    style
        [ ( "cellpadding", "4" )
        , ( "cellspacing", "0" )
        , ( "width", "100%" )
        ]
