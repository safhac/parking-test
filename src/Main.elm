port module Main exposing (..)

import Task
import Html exposing (Html)
import RemoteData exposing (WebData)
import View exposing (..)
import Types exposing (Model, Msg(..), User, Parking, UserStatus(..))
import Actions.Commands exposing (..)


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
    ({ user = initialUser, parkings = RemoteData.Loading }) ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg { user, parkings } =
    case msg of
        CaptchaSubmit key ->
            let
                loggedIn =
                    { user | status = Authorised }
            in
                ( (Model loggedIn parkings), fetchParkings )

        CaptchaLoad _ ->
            (Model user parkings) ! []

        ShowParkingBy _ ->
            (Model user parkings) ! []

        OnFetchParkings updatedParkings ->
            (Model user updatedParkings) ! []


initialUser : User
initialUser =
    { id = 0
    , name = ""
    , status = Unanuthorised
    }


toCmd : Msg -> Cmd Msg
toCmd msg =
    Task.succeed msg
        |> Task.perform identity
