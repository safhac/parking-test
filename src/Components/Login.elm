module Components.Login exposing (view)

import Html exposing (Html, div, h2, text, img, label, br, input, a, button)
import Html.Attributes exposing (id, style, class, src, type_, value, href, attribute)
import Types exposing (Model, Msg(..))


view : Html Msg
view =
    div [ id "wrap" ]
        [ div [ class "row medbox" ]
            [ div [ class "col-md-8" ]
                [ h2 [] [ text "בדיקת בטיחות" ]
                ]
            , div [ class "row" ]
                [ div
                    [ id "captcha"
                    , attribute "class" "g-recaptcha"
                    , attribute "data-sitekey" "6Ldd8kIUAAAAAMWDt3cljw_DssCykzu4Hc36vW_M"
                    , attribute "data-callback" "onloadCallback"
                    ]
                    []
                ]
            ]
        ]
