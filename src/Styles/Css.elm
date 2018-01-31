module Styles.Css exposing (..)

import Html.Attributes exposing (href, src, property, style, alt, title)


{-| Named styling
@docs css


# Named css classes

-}
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


modalStyle =
    style
        [ ( "position", "fixed" )
        , ( "z-index", "1" )
        , ( "left", "0" )
        , ( "top", "0" )
        , ( "width", "100%" )
        , ( "height", "100%" )
        , ( "overflow", "auto" )
        , ( "background-color", "rgb(0,0,0)" )
        , ( "background-color", "rgba(0,0,0,0.4)" )
        ]


modalDisplayNone =
    style
        [ ( "display", "none" ) ]


modalDisplayBlock =
    style
        [ ( "display", "block" ) ]


modalContentStyle =
    style
        [ ( "width", "20%" )
        , ( "background-color", "#fefefe" )
        , ( "margin", "15% auto" )
        , ( "padding", "20px" )
        , ( "border", "1px solid #888" )
        , ( "box-shadow", "0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19)" )
        , ( "animation-name", "animatetop" )
        , ( "animation-duration", "0.4s" )
        ]


closeStyle =
    style
        [ ( "color", "#aaa" )
        , ( "float", "right" )
        , ( "font-size", "28px" )
        , ( "font-weight", "bold" )
        , ( "cursor", "pointer" )
        , ( "line-height", "41px" )
        ]


dropbtnStyle =
    style
        [ ( "color", "white" )
        , ( "border", "none" )
        , ( "cursor", "pointer" )
        ]


myInputStyle =
    style
        [ ( "border-box", "box-sizing" )
        , ( "background-image", "url('searchicon.png')" )
        , ( "background-position", "14px 12px" )
        , ( "background-repeat", "no-repeat" )
        ]


dropdownStyle =
    style
        [ ( "position", "relative" )
        , ( "display", "inline-block" )
        ]


dropdownContentStyle =
    style
        [ ( "display", "none" )
        , ( "position", "absolute" )
        , ( "background-color", "#f6f6f6" )
        , ( "min-width", "230px" )
        , ( "border", "1px solid #ddd" )
        , ( "z-index", "1" )
        ]


ddCntntLink =
    style
        [ ( "color", "black" )
        , ( "padding", "12px 16px" )
        , ( "text-decoration", "none" )
        , ( "display", "block" )
        ]


emphasisRecord =
    style
        [ ( "color", "black" )
        , ( "font-weight", "bold" )
        , ( "box-shadow", "0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19)" )
        , ( "background-color", "lightblue" )
        ]


noStyle =
    style []
