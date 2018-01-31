module Components.ParkingModal exposing (..)

import Dict
import Result
import Html exposing (Html, Attribute, div, h2, text, img, label, p, br, span, input, a, button, select, option, h2, table, thead, th, tr, td, tbody)
import Html.Attributes exposing (id, style, class, src, type_, value, href, attribute, required)
import Html.Events exposing (onClick, onBlur, onInput)
import Date exposing (Date, hour, minute)
import Date.Extra.Format exposing (isoDateString)
import Types exposing (Model, Msg(..), AppState(..), ParkingRecord, City, Street, CityID, StreetID, ParkingID, ParkingDisplay(..), PickerType(..), ParkingTimeType(..), ParkingProperty(..))
import Styles.Css exposing (..)
import DateTimePicker
import DateTimePicker.Config exposing (Config, DatePickerConfig, TimePickerConfig, defaultDatePickerConfig, defaultDateTimeI18n, defaultDateTimePickerConfig, defaultTimePickerConfig)
import DateTimePicker.Css


newParkingView : Dict.Dict Int City -> Dict.Dict Int Street -> ParkingRecord -> Html Msg
newParkingView cities streets newPark =
    div [ class "row medbox", modalStyle, modalDisplayBlock ]
        [ div [ modalContentStyle ]
            [ div []
                [ span [ onClick (ParkingMsg Normal), closeStyle ] [ text "X" ]
                , h2 [] [ text "הוספת חנייה" ]
                , br [] []
                , label [] [ text "התחלה:" ]
                , br [] []
                , input [ onInput (UpdateParking (newPark.id) StartTime), type_ "time", value newPark.start, class "form-control ltr", id "startTime", required True ] []
                ]
            , div []
                [ br [] []
                , label [] [ text "סיום:" ]
                , br [] []
                , input [ onInput (UpdateParking (newPark.id) EndTime), type_ "time", value newPark.end, class "form-control ltr", id "endTime" ] []
                , div [ dropdownStyle ]
                    [ br [] []
                    , label [] [ text "יישוב:" ]
                    , br [] []
                    , div []
                        [ select [ onInput (UpdateParking (newPark.id) CityChange), class "form-control ltr", id "city" ]
                            (List.map
                                (\c -> makeOption c newPark.cityID)
                                (Dict.values cities)
                            )
                        ]
                    ]
                ]
            , div [ dropdownStyle ]
                [ br [] []
                , label [] [ text "רחוב:" ]
                , br [] []
                , div []
                    [ select [ onInput (UpdateParking (newPark.id) StreetChange), class "form-control ltr", id "street" ]
                        (List.map (\c -> makeOption c newPark.streetID) (Dict.values streets))
                    ]
                ]
            , div [ class "row pull-left" ]
                [ br [] []
                , input [ onClick SubmitNewParking, type_ "submit", value "הוסף", class "button " ] []
                ]
            ]
        ]


deleteParkingView : ParkingID -> Html Msg
deleteParkingView pid =
    div [ class "row medbox", modalStyle, modalDisplayBlock ]
        [ div [ modalContentStyle ]
            [ div []
                [ span [ onClick (ParkingMsg Normal), closeStyle ] [ text "X" ]
                , h2 [] [ text "מחיקת חנייה" ]
                , br [] []
                , label [] [ text ("האם למחוק את חניה מספר" ++ toString pid) ]
                , br [] []
                ]
            , div [ class "row pull-left" ]
                [ br [] []
                , input [ onClick (ConfirmDeleteParking pid), type_ "submit", value "מחיקה", class "button " ] []
                ]
            ]
        ]


editParkingView : Dict.Dict Int City -> Dict.Dict Int Street -> ParkingRecord -> Html Msg
editParkingView cities streets park =
    let
        _ =
            Debug.log "date" park.date

        _ =
            Debug.log "date" (Date.fromString park.date)
    in
        div [ class "row medbox", modalStyle, modalDisplayBlock ]
            [ div [ modalContentStyle ]
                [ div []
                    [ span [ onClick (ParkingMsg Normal), closeStyle ] [ text "X" ]
                    , h2 [] [ text ("עריכת חנייה " ++ toString park.id) ]
                    , br [] []
                    , label [] [ text "תאריך:" ]
                    , br [] []
                    , input [ onInput (UpdateParking (park.id) DateChange), type_ "date", value park.date, class "form-control ltr", id "date" ] []
                    , br [] []
                    , label [] [ text "התחלה:" ]
                    , br [] []
                    , input [ onInput (UpdateParking (park.id) StartTime), type_ "time", value park.start, class "form-control ltr", id "startTime" ] []
                    ]
                , div []
                    [ br [] []
                    , label [] [ text "סיום:" ]
                    , br [] []
                    , input [ onInput (UpdateParking (park.id) EndTime), type_ "time", value park.end, class "form-control ltr", id "endTime" ] []
                    , div [ dropdownStyle ]
                        [ br [] []
                        , label [] [ text "יישוב:" ]
                        , br [] []
                        , div []
                            [ select [ onInput (UpdateParking (park.id) CityChange), class "form-control ltr", id "city" ]
                                (List.map
                                    (\c -> makeOption c park.cityID)
                                    (Dict.values cities)
                                )
                            ]
                        ]
                    ]
                , div [ dropdownStyle ]
                    [ br [] []
                    , label [] [ text "רחוב:" ]
                    , br [] []
                    , div []
                        [ select [ onInput (UpdateParking (park.id) StreetChange), class "form-control ltr", id "street" ]
                            (List.map (\c -> makeOption c park.streetID) (Dict.values streets))
                        ]
                    ]
                , div [ class "row pull-left" ]
                    [ br [] []
                    , input [ onClick (ParkingMsg (Creating park.id)), type_ "submit", value "עדכן", class "button " ] []
                    ]
                ]
            ]


makeOption : { a | id : Int, desc : String } -> Int -> Html Msg
makeOption thing pid =
    let
        yesno =
            if (pid == thing.id) then
                True
            else
                False
    in
        option [ value (toString thing.id), Html.Attributes.selected yesno ] [ text thing.desc ]


unselected =
    option [ value "0" ] [ text "יש לבחור" ]


analogDateTimePickerConfig : Config (DatePickerConfig TimePickerConfig) Msg
analogDateTimePickerConfig =
    let
        defaultDateTimeConfig =
            defaultDateTimePickerConfig (DatePickerChanged AnalogDateTimePicker)
    in
        { defaultDateTimeConfig
            | timePickerType = DateTimePicker.Config.Analog
            , allowYearNavigation = False
        }


timePickerConfig : Config TimePickerConfig Msg
timePickerConfig =
    let
        defaultDateTimeConfig =
            defaultTimePickerConfig (DatePickerChanged TimePicker)
    in
        { defaultDateTimeConfig
            | timePickerType = DateTimePicker.Config.Analog
        }


viewPicker : PickerType -> ParkingTimeType -> Date -> DateTimePicker.State -> Html Msg
viewPicker which timeType today state =
    p []
        [ label []
            [ text (toString which)
            , text ":"
            , case which of
                AnalogDateTimePicker ->
                    DateTimePicker.dateTimePickerWithConfig analogDateTimePickerConfig [] state (Maybe.Just today)

                TimePicker ->
                    DateTimePicker.timePickerWithConfig timePickerConfig [] state (Maybe.Just today)
            ]
        ]



-- handleEvent : Int -> String -> Msg
-- handleEvent pid timeVal =
--     (UpdateParking pid (StartTime timeVal) <|
--         Json.succeed
--     )
-- handleUnFocusEvent : Int -> List (Attribute Msg)
-- handleUnFocusEvent sceneID =
--     if sceneID /= -1 then
--         List.map
--             (\te ->
--                 on te
--                     (Json.succeed <|
--                         (SwitchScene sceneID)
--                     )
--             )
--             [ "webkitTransitionEnd", "ontransitionend", "msTransitionEnd", "transitionend" ]
--     else
--         []
