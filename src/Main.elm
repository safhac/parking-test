port module Main exposing (..)

import Task
import Html exposing (Html)
import RemoteData exposing (WebData)
import View exposing (..)
import Types exposing (Model, Msg(..), ModalIs(..), User, ParkingRecord, UserStatus(..))
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
    ({ user = initialUser
     , parkings = RemoteData.Loading
     , cities = RemoteData.Loading
     , streets = RemoteData.Loading
     , state = Off
     }
    )
        ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CaptchaSubmit key ->
            let
                olUser =
                    model.user

                loggedIn =
                    { olUser | status = Authorised }
            in
                ( { model | user = loggedIn }, Cmd.batch [ fetchParkings, fetchCities, fetchStreets ] )

        CaptchaLoad _ ->
            model ! []

        ShowParkingBy _ ->
            model ! []

        OnFetchParkings parkList ->
            ( { model | parkings = parkList }, Cmd.none )

        OnFetchCities parkList ->
            ( { model | cities = parkList }, Cmd.none )

        OnFetchStreets parkList ->
            ( { model | streets = parkList }, Cmd.none )

        ShowNewParking ->
            case model.state of
                Off ->
                    ( { model | state = On }, Cmd.none )

                On ->
                    ( { model | state = Off }, Cmd.none )


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
