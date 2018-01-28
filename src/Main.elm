port module Main exposing (..)

import Html exposing (Html)
import View exposing (..)
import Types exposing (Model, Msg(..), User, Parking, UserStatus(..))


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


init : ( Model, Cmd Msg )
init =
    ({ user = initialUser, parkings = [] }) ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg { user, parkings } =
    case msg of
        CaptchaSubmit key ->
            let
                loggedIn =
                    { user | status = Authorised }
            in
                (Model loggedIn parkings) ! []

        CaptchaLoad _ ->
            (Model user parkings) ! []


initialUser : User
initialUser =
    { id = 0
    , name = ""
    , status = Unanuthorised
    }
