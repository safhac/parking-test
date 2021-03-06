module Types exposing (..)

import Date
import Dict
import Http
import RemoteData exposing (WebData)
import DateTimePicker


type Msg
    = SetDate Date.Date
    | CaptchaLoad ()
    | CaptchaSubmit String
    | OnFetchParkings (WebData (List ParkingRecord))
    | OnFetchCities (WebData (List City))
    | OnFetchStreets (WebData (List Street))
    | ParkingMsg AppState
    | OnParkingSave (Result Http.Error ParkingRecord)
    | UpdateParking Int ParkingProperty String
    | FilterParkingsBy ParkingDisplay
    | SubmitNewParking
    | ConfirmDeleteParking ParkingID
    | OnParkingDeleted (Result Http.Error ())


type alias Model =
    { user : User
    , parkings : WebData (List ParkingRecord)
    , cities : WebData (List City)
    , streets : WebData (List Street)
    , uxState : UXState
    , today : Date.Date
    , datePickerState : Dict.Dict String DateTimePicker.State
    , newParking : ParkingRecord
    }


type alias User =
    { name : String
    , id : Int
    , status : UserStatus
    }


type UserStatus
    = Authorised
    | Unanuthorised


type ParkingDisplay
    = All
    | FilterToday
    | EmphasizeToday


type alias City =
    { id : CityID
    , desc : String
    }


type alias Street =
    { cityID : CityID
    , id : StreetID
    , desc : String
    }


type alias ParkingRecord =
    { id : ParkingID
    , cityID : CityID
    , streetID : StreetID
    , date : String
    , start : String
    , end : String
    , today : Bool
    }


type EntityType
    = ParkingType
    | CityType
    | StreetType


type alias CityID =
    Int


type alias StreetID =
    Int


type alias ParkingID =
    Int


type alias UXState =
    { app : AppState
    , filtering : ParkingDisplay
    }


type AppState
    = Normal
    | Creating ParkingID
    | Editing ParkingID
    | Deleteing ParkingID


type ParkingProperty
    = StartTime
    | EndTime
    | DateChange
    | CityChange
    | StreetChange
