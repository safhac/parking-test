module Components.View exposing (view)

import Html exposing (Html)
import Types exposing (Model, Msg(..), UserStatus(..))
import Components.Login as Login exposing (view)
import Components.Parkings as Parkings exposing (view)


view : Model -> Html Msg
view model =
    case model.user.status of
        Unanuthorised ->
            Login.view model

        Authorised ->
            Parkings.view model
