module Components.Parkings exposing (view)

import Dict
import Html exposing (Html, div, h2, text, img, label, br, input, a, button, h2, table, thead, th, tr, td, tbody)
import Html.Attributes exposing (id, style, class, src, type_, value, href, attribute)
import Html.Events exposing (onClick)
import Date.Extra.Format exposing (isoString, utcIsoString, isoDateString, utcIsoDateString)
import Types exposing (Model, Msg(..), ModalState(..), ParkingRecord, City, Street, CityID, StreetID, ParkingID, ParkingDisplay(..))
import Styles.Css exposing (..)
import Components.NewParkingModal as NewParkingModal exposing (view)
import Actions.Common exposing (maybeList)


view : Model -> Html Msg
view model =
    let
        cities =
            maybeList model.cities
                |> List.map (\c -> ( c.id, c ))
                |> Dict.fromList

        streets =
            maybeList model.streets
                |> List.map (\s -> ( s.id, s ))
                |> Dict.fromList

        modalStyle =
            case model.uxState.popup of
                Off ->
                    modalDisplayNone

                On ->
                    modalDisplayBlock

        todayString =
            isoDateString model.today

        allParkings =
            maybeList model.parkings

        parkings =
            case model.uxState.filtering of
                FilterToday ->
                    allParkings
                        |> List.filter (\p -> p.date == todayString)

                _ ->
                    allParkings
    in
        div [ class "row tablebox" ]
            [ -- maybeParkingList model.parkings cities streets
              listParkings parkings cities streets
            , div []
                [ input [ onClick ShowNewParking, type_ "submit", value "+", class "button pull-left round-but", Html.Attributes.title "הוסף חנייה" ]
                    []
                ]
            , NewParkingModal.view modalStyle cities streets model.today model.datePickerState model.newParking
            ]


renderFilterButtons : Html Msg
renderFilterButtons =
    div [ class "tablebuttons" ]
        [ input
            [ onClick (FilterParkingsBy FilterToday), type_ "submit", value "סנן חניות להיום", class "button" ]
            []
        , input [ onClick (FilterParkingsBy EmphasizeToday), type_ "submit", value "הדגש חניות להיום", class "button" ]
            []
        , input [ onClick (FilterParkingsBy All), type_ "submit", value "הצג הכל", class "button" ]
            []
        ]



-- maybeParkingList : WebData (List ParkingRecord) -> Dict.Dict Int City -> Dict.Dict Int Street -> Html Msg
-- maybeParkingList parkings cities streets =
--     case parkings of
--         RemoteData.NotAsked ->
--             text ""
--         RemoteData.Loading ->
--             text "Loading..."
--         RemoteData.Success parkings ->
--             listParkings parkings cities streets
--         RemoteData.Failure error ->
--             text (toString error)


listParkings : List ParkingRecord -> Dict.Dict Int City -> Dict.Dict Int Street -> Html Msg
listParkings parkings cities streets =
    div []
        [ h2 [] [ text "חניות עבור משתמש דויד דוידי" ]
        , renderFilterButtons
        , table [ class "tablest", tablestStyle ]
            [ thead []
                [ th [ class "textcenter" ] [ text "מזהה חנייה" ]
                , th [ class "textcenter" ] [ text "תאריך" ]
                , th [ class "textcenter" ] [ text "התחלה" ]
                , th [ class "textcenter" ] [ text "סיום" ]
                , th [] [ text "יישוב" ]
                , th [] [ text "רחוב" ]
                , th [ class "textcenter" ] []
                ]
            , tbody []
                (parkings
                    |> List.map (\p -> parkingRow p cities streets)
                )
            ]
        ]


parkingRow : ParkingRecord -> Dict.Dict Int City -> Dict.Dict Int Street -> Html Msg
parkingRow parking cities streets =
    let
        city =
            getNameFrom parking.cityID cities

        street =
            getNameFrom parking.streetID streets
    in
        tr []
            [ td [] [ text (toString parking.id) ]
            , td [] [ text parking.date ]
            , td [] [ text parking.start ]
            , td [] [ text parking.end ]
            , td []
                [ text city ]
            , td []
                [ text street ]
            , td [ class "textcenter" ]
                [ input [ type_ "submit", value "עדכן", class "button pull-left" ]
                    []
                , input [ type_ "submit", value "מחק", class "button pull-left" ]
                    []
                ]
            ]


getNameFrom : Int -> Dict.Dict Int { a | desc : String } -> String
getNameFrom id dict =
    let
        maybeName =
            Dict.get id dict

        name =
            case maybeName of
                Nothing ->
                    "לא נמצא שם"

                Just { desc } ->
                    desc
    in
        name
