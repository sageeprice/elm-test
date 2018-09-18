import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main = Browser.sandbox { init = init, update = (\a b -> b), view = view }

-- MODEL

type alias Model = {}

init : Model
init = Model


-- VIEW


view : Model -> Html msg
view model =
  div []
    [ h1 [] [ text "Sage Price" ]
    , h2 [] [ text "Is not good at examples" ]
    , span [] [ text "But he tries so hard, bless his soul." ]
    ]
