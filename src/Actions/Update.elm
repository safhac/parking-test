module Actions.Update exposing (..)

import Task exposing (succeed, perform)
import Dict exposing (empty)
import Date exposing (now)
import Date.Extra.Core exposing (fromTime)
import Date.Extra.Format exposing (isoDateString)
import RemoteData exposing (WebData)
import Types exposing (Model, Msg(..), UXState, AppState(..), User, ParkingRecord, UserStatus(..), ParkingDisplay(..), ParkingProperty(..))
import Actions.Commands exposing (..)
import Actions.Common exposing (..)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetDate date ->
            ( { model | today = date }, Cmd.none )

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

        FilterParkingsBy filterBy ->
            let
                olUX =
                    model.uxState

                newUX =
                    { olUX | filtering = filterBy }
            in
                ( { model | uxState = newUX }, Cmd.none )

        OnFetchParkings parkList ->
            let
                park =
                    model.newParking

                parkWithId =
                    ({ park | id = (maybeList parkList |> getMaxParkIdFrom) })
            in
                ( { model
                    | newParking = parkWithId
                    , parkings = parkList
                  }
                , Cmd.none
                )

        OnFetchCities cityList ->
            ( { model | cities = cityList }, Cmd.none )

        OnFetchStreets streetList ->
            ( { model | streets = streetList }, Cmd.none )

        ParkingMsg parkMsg ->
            let
                _ =
                    Debug.log "parkmsg" parkMsg

                olUX =
                    model.uxState

                newUX =
                    case parkMsg of
                        Normal ->
                            { olUX | app = Normal }

                        Creating pid ->
                            { olUX | app = Creating pid }

                        Editing pid ->
                            { olUX | app = Editing pid }

                        Deleteing pid ->
                            { olUX | app = Deleteing pid }
            in
                ( { model | uxState = newUX }, Cmd.none )

        DatePickerChanged which state value ->
            ( { model
                | today =
                    case value of
                        Nothing ->
                            fromTime 0

                        Just date ->
                            date
              }
            , Cmd.none
            )

        OnParkingSave (Ok parking) ->
            ( model, fetchParkings )

        OnParkingSave (Err err) ->
            let
                _ =
                    Debug.log "err" err
            in
                model ! []

        UpdateParking pid parkingChangeType val ->
            let
                ( park, exists ) =
                    if (pid /= model.newParking.id) then
                        let
                            maybePark =
                                getParkById pid (maybeList model.parkings)
                        in
                            ( Maybe.withDefault model.newParking maybePark
                            , True
                            )
                    else
                        ( model.newParking, False )

                updatedPark =
                    case parkingChangeType of
                        StartTime ->
                            { park | start = val }

                        EndTime ->
                            { park | end = val }

                        DateChange ->
                            { park | date = val }

                        CityChange ->
                            { park | cityID = (Result.withDefault 0 (String.toInt val)) }

                        StreetChange ->
                            { park | streetID = (Result.withDefault 0 (String.toInt val)) }
            in
                if (exists == True) then
                    ( model, saveParkingCmd updatedPark )
                else
                    ( { model | newParking = updatedPark }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { user = initialUser
      , parkings = RemoteData.Loading
      , cities = RemoteData.Loading
      , streets = RemoteData.Loading
      , uxState = initialUXState
      , today = fromTime 0
      , datePickerState = Dict.empty
      , newParking = initialParkingRecord
      }
    , Date.now |> Task.perform SetDate
    )


initialUser : User
initialUser =
    { id = 0
    , name = ""
    , status = Unanuthorised
    }


initialParkingRecord : ParkingRecord
initialParkingRecord =
    { id = 0
    , cityID = 0
    , streetID = 0
    , date = ""
    , start = ""
    , end = ""
    , today = True
    }


initialUXState : UXState
initialUXState =
    { app = Normal
    , filtering = All
    }
