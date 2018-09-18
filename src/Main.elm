import Html exposing (..)


-- MODEL

type alias Model = {...}


-- UPDATE

type Msg = Reset | ...

update : Msg -> Model -> Model
update msg model =
  case mdg of
    Reset -> ...
    ...


-- VIEW

view : Model -> Html Msg
view model =
  ...

