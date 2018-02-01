module Actions.Common exposing (..)

import RemoteData exposing (WebData)
import Types exposing (ParkingRecord, ParkingID, AppState(..))


maybeList : WebData (List a) -> List a
maybeList data =
    case data of
        RemoteData.Success list ->
            list

        _ ->
            []


getMaxParkIdFrom : List ParkingRecord -> Int
getMaxParkIdFrom parkings =
    let
        ids =
            parkings
                |> List.map (\p -> getId p)

        maxId =
            List.maximum ids |> Maybe.withDefault 0
    in
        (maxId + 1)


getId : { a | id : Int } -> Int
getId something =
    something.id


getParkById : ParkingID -> List ParkingRecord -> Maybe ParkingRecord
getParkById pid parkings =
    parkings
        |> List.filter (\p -> p.id == pid)
        |> List.head
