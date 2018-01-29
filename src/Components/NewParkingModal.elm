module Components.NewParkingModal exposing (view)

import Dict
import Html exposing (Html, div, h2, text, img, label, br, span, input, a, button, h2, table, thead, th, tr, td, tbody)
import Html.Attributes exposing (id, style, class, src, type_, value, href, attribute)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData)
import Types exposing (Model, Msg(..), ModalIs(..), ParkingRecord, City, Street, CityID, StreetID, ParkingID, ParkingDisplay(..))
import Styles.Css exposing (..)


view displayStyle cities streets =
    div [ class "row medbox", modalStyle, displayStyle ]
        [ div [ modalContentStyle ]
            [ div []
                [ span [ onClick ShowNewParking, closeStyle ] [ text "X" ]
                , h2 []
                    [ text "הוספת חנייה" ]
                , br []
                    []
                , label []
                    [ text "התחלה:" ]
                , br []
                    []
                , input [ type_ "time", value "", class "form-control ltr", id "startTime" ]
                    []
                ]
            , div []
                [ br []
                    []
                , label []
                    [ text "סיום:" ]
                , br []
                    []
                , input [ type_ "time", value "", class "form-control ltr", id "endTime" ]
                    []
                , div [ dropdownStyle ]
                    [ br []
                        []
                    , label []
                        [ text "יישוב:" ]
                    , br []
                        []
                    , div []
                        [ input [ type_ "text", value "", class "form-control ltr", id "city" ]
                            (cities
                                |> Dict.values
                                |> List.map (\c -> cityLink c)
                            )
                        ]
                    ]
                ]
            , div [ dropdownStyle ]
                [ br []
                    []
                , label []
                    [ text "רחוב:" ]
                , br []
                    []
                , div []
                    [ input [ type_ "text", value "", class "form-control ltr", id "street" ]
                        (streets
                            |> Dict.values
                            |> List.map (\c -> cityLink c)
                        )
                    ]
                ]
            , div [ class "row pull-left" ]
                [ br []
                    []
                , input [ type_ "submit", value "הוסף", class "button " ]
                    []
                ]
            ]
        ]


cityLink city =
    a [ href "" ] [ text city.desc ]
