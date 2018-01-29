module Types exposing (..)

import Date
import RemoteData exposing (WebData)


type Msg
    = CaptchaLoad ()
    | CaptchaSubmit String
    | ShowParkingBy ParkingDisplay
    | OnFetchParkings (WebData (List ParkingRecord))
    | OnFetchCities (WebData (List City))
    | OnFetchStreets (WebData (List Street))


type alias Model =
    { user : User
    , parkings : WebData (List ParkingRecord)
    , cities : WebData (List City)
    , streets : WebData (List Street)
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
    }


type alias Parking =
    { cities : List City
    , streets : List Street
    , parkings : List ParkingRecord
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
