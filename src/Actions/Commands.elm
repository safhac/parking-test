module Actions.Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import RemoteData exposing (WebData)
import Types exposing (Model, Msg(..), ParkingID, ParkingRecord, City, Street, ParkingDisplay(..))


{-| Commands
@docs Commands


# Named Commands

-}
fetchParkings : Cmd Msg
fetchParkings =
    Http.get (fetchUrls "Parking") parkingsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchParkings


fetchCities : Cmd Msg
fetchCities =
    Http.get (fetchUrls "Cities") citiesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchCities


fetchStreets : Cmd Msg
fetchStreets =
    Http.get (fetchUrls "Streets") streetsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchStreets


saveParkingCmd : ParkingRecord -> Cmd Msg
saveParkingCmd parking =
    saveParkingRequest parking
        |> Http.send OnParkingSave


createParkingCmd : ParkingRecord -> Cmd Msg
createParkingCmd parking =
    createParkingRequest parking
        |> Http.send OnParkingSave


deleteParkingCmd : ParkingID -> Cmd Msg
deleteParkingCmd pid =
    deleteParkingRequest pid
        |> Http.send OnParkingDeleted


{-| URLs
@docs URLs


# Named URLs

-}
fetchUrls : String -> String
fetchUrls items =
    "http://localhost:4000/" ++ items


saveParkingUrl : ParkingID -> String
saveParkingUrl pid =
    "http://localhost:4000/Parking?id=" ++ (toString pid)


updateParkingUrl : ParkingID -> String
updateParkingUrl parkingId =
    "http://localhost:4000/Parking/" ++ (toString parkingId)


{-| Decoders
@docs Decoders


# Decoders

-}
parkingsDecoder : Decode.Decoder (List ParkingRecord)
parkingsDecoder =
    Decode.list parkingDecoder


citiesDecoder : Decode.Decoder (List City)
citiesDecoder =
    Decode.list cityDecoder


streetsDecoder : Decode.Decoder (List Street)
streetsDecoder =
    Decode.list streetDecoder


parkingDecoder : Decode.Decoder ParkingRecord
parkingDecoder =
    decode ParkingRecord
        |> required "id" Decode.int
        |> required "cityID" Decode.int
        |> required "streetID" Decode.int
        |> required "date" Decode.string
        |> required "start" Decode.string
        |> required "end" Decode.string
        |> hardcoded False


cityDecoder : Decode.Decoder City
cityDecoder =
    decode City
        |> required "CityID" Decode.int
        |> required "CityDesc" Decode.string


streetDecoder : Decode.Decoder Street
streetDecoder =
    decode Street
        |> required "CityID" Decode.int
        |> required "StreetID" Decode.int
        |> required "StreetDesc" Decode.string


{-| Encoders
@docs Encoders


# encoders

-}
parkingEncoder : ParkingRecord -> Encode.Value
parkingEncoder parking =
    let
        attributes =
            [ ( "id", Encode.int parking.id )
            , ( "cityID", Encode.int parking.cityID )
            , ( "streetID", Encode.int parking.streetID )
            , ( "date", Encode.string parking.date )
            , ( "start", Encode.string parking.start )
            , ( "end", Encode.string parking.end )
            ]
    in
        Encode.object attributes


{-| RemoteData
@docs Http requests


# requests

-}
saveParkingRequest : ParkingRecord -> Http.Request ParkingRecord
saveParkingRequest parking =
    Http.request
        { body = parkingEncoder parking |> Http.jsonBody
        , expect = Http.expectJson parkingDecoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , url = updateParkingUrl parking.id
        , withCredentials = False
        }


createParkingRequest : ParkingRecord -> Http.Request ParkingRecord
createParkingRequest parking =
    Http.request
        { body = parkingEncoder parking |> Http.jsonBody
        , expect = Http.expectJson parkingDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = saveParkingUrl parking.id
        , withCredentials = False
        }


deleteParkingRequest : ParkingID -> Http.Request ()
deleteParkingRequest pid =
    Http.request
        { body = Http.emptyBody
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , headers = []
        , method = "DELETE"
        , timeout = Nothing
        , url = updateParkingUrl pid
        , withCredentials = False
        }
