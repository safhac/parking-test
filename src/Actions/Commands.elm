module Actions.Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData
import Types exposing (Model, Msg(..), Parking, ParkingDisplay(..))


fetchParkings : Cmd Msg
fetchParkings =
    Http.get (fetchUrls "Parking") parkingsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchParkings


fetchUrls : String -> String
fetchUrls items =
    "http://localhost:4000/" ++ items


parkingsDecoder : Decode.Decoder (List Parking)
parkingsDecoder =
    Decode.list parkingDecoder


parkingDecoder : Decode.Decoder Parking
parkingDecoder =
    decode Parking
        |> required "id" Decode.int
        |> required "cityID" Decode.int
        |> required "streetID" Decode.int
        |> required "start" Decode.string
        |> required "end" Decode.string
