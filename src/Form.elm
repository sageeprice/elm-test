import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = 
  { name : String
  , password : String
  , passwordAgain : String
  , age : Int
  }

init : Model
init =
  Model "" "" "" 0


-- UPDATE

type Msg
  = Name String
  | Password String
  | PasswordAgain String
  | Age String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }
    Password pw ->
      { model | password = pw }
    PasswordAgain pw ->
      { model | passwordAgain = pw }
    Age a ->
      { model | age = Maybe.withDefault 0 (String.toInt a)}


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ viewInput "text" "Name" model.name Name
    , input [type_ "number", placeholder "Age", value(String.fromInt(model.age)), onInput Age] []
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter password" model.passwordAgain PasswordAgain
    , viewValidation model
    ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

viewValidation : Model -> Html msg
viewValidation model =
  if not(isUsernameLongEnough model.name) then
    div [ style "color" "red" ] [ text "Username must be at least 8 characters" ]
  else if not(isOldEnough model.age) then
    div [ style "color" "red" ] [ text "Must be at least 18 years" ]
  else if not(passwordsMatch model.password model.passwordAgain) then
    div [ style "color" "red" ] [ text "Passwords do not match" ]
  else
    div [ style "color" "green" ] [ text "OK" ]

isUsernameLongEnough : String -> Bool
isUsernameLongEnough u = String.length u >= 8

isOldEnough : Int -> Bool
isOldEnough a = a > 17

passwordsMatch : String -> String -> Bool
passwordsMatch p1 p2 = p1 == p2 && (p1 /= "")





