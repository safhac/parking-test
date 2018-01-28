module Types exposing (..)

import Date


type Msg
    = CaptchaLoad ()
    | CaptchaSubmit String


type alias Model =
    { user : User
    , parkings : List Parking
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
    , start : Maybe Date.Date
    , end : Maybe Date.Date
    }


type alias CityID =
    Int


type alias StreetID =
    Int
