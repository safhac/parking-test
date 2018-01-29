module Actions.Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData
import Types exposing (Model, Msg(..), ParkingRecord, City, Street, ParkingDisplay(..))


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


fetchUrls : String -> String
fetchUrls items =
    "http://localhost:4000/" ++ items


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
