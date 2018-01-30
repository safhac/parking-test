port module Main exposing (..)

import Html exposing (Html)
import Types exposing (Model, Msg(..))
import Actions.Update exposing (init, update)
import Components.View exposing (view)


-- ports


port captchaLoad : (() -> msg) -> Sub msg


port captchaSubmit : (String -> msg) -> Sub msg



-- main


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.batch [ captchaLoad CaptchaLoad, captchaSubmit CaptchaSubmit ])
        }



-- Model
