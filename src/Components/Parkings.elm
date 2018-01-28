module Components.Parkings exposing (view)

import Html exposing (Html, div, h2, text, img, label, br, input, a, button, h2, table, thead, th, tr, td, tbody)
import Html.Attributes exposing (id, style, class, src, type_, value, href, attribute)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData)
import Types exposing (Model, Msg(..), Parking, ParkingDisplay(..))


view : Model -> Html Msg
view { parkings } =
    div [ class "row tablebox" ]
        [ maybeList parkings
        , div []
            [ input [ type_ "submit", value "+", class "button pull-left round-but", Html.Attributes.title "הוסף חנייה" ]
                []
            ]
        ]


renderFilterButtons : Html Msg
renderFilterButtons =
    div [ class "tablebuttons" ]
        [ input
            [ onClick (ShowParkingBy FilterToday), type_ "submit", value "סנן חניות להיום", class "button" ]
            []
        , input [ onClick (ShowParkingBy EmphasizeToday), type_ "submit", value "הדגש חניות להיום", class "button" ]
            []
        , input [ onClick (ShowParkingBy All), type_ "submit", value "הצג הכל", class "button" ]
            []
        ]


maybeList : WebData (List Parking) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success parkings ->
            listParkings parkings

        RemoteData.Failure error ->
            text (toString error)


listParkings parkings =
    div []
        [ h2 [] [ text "חניות עבור משתמש דויד דוידי" ]
        , renderFilterButtons
        , table [ class "tablest" ]
            [ tr []
                [ th [ class "textcenter" ] [ text "מזהה חנייה" ]
                , th [ class "textcenter" ] [ text "תאריך" ]
                , th [ class "textcenter" ] [ text "התחלה" ]
                , th [ class "textcenter" ] [ text "סיום" ]
                , th [] [ text "יישוב" ]
                , th [] [ text "רחוב" ]
                , th [ class "textcenter" ] []
                ]
            , tbody [] (List.map parkingRow parkings)
            ]
        ]


parkingRow : Parking -> Html Msg
parkingRow parking =
    tr []
        [ td [] [ text (toString parking.id) ]
        , td [] [ text (toString parking.start) ]
        , td [] [ text (toString parking.end) ]
        , td []
            []
        ]



-- , tr []
--                 [ td [ class "textcenter" ]
--                     [ text "1" ]
--                 , td [ class "textcenter" ]
--                     [ text "1.1.2018" ]
--                 , td [ class "textcenter" ]
--                     [ text "08:40" ]
--                 , td [ class "textcenter" ]
--                     [ text "12:00" ]
--                 , td []
--                     [ text "רמת גן" ]
--                 , td []
--                     [ text "בן גוריון 2" ]
--                 , td [ class "textcenter" ]
--                     [ input [ type_ "submit", value "עדכן", class "button pull-left" ]
--                         []
--                     , input [ type_ "submit", value "מחק", class "button pull-left" ]
--                         []
--                     ]
--                 ]
