module Types exposing (..)

import Date
import RemoteData exposing (WebData)


type Msg
    = CaptchaLoad ()
    | CaptchaSubmit String
    | ShowParkingBy ParkingDisplay
    | OnFetchParkings (WebData (List Parking))


type alias Model =
    { user : User
    , parkings : WebData (List Parking)
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


type alias Parking =
    { id : Int
    , cityID : CityID
    , streetID : StreetID
    , start : String
    , end : String
    }


type alias CityID =
    Int


type alias StreetID =
    Int
