import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Svg exposing ( svg, rect, circle, line )
import Svg.Attributes exposing ( fill, cx, cy, r, x, y, width, height, rx, ry, viewBox, x1, x2, y1, y2, stroke )
import Task
import Time


-- MAIN

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  , isPaused : Bool
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) False
  , Task.perform AdjustTimeZone Time.here
  )


-- UPDATE

type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | Pause

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )
    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )
    Pause ->
      ( { model | isPaused = not model.isPaused }
      , Cmd.none
      )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.isPaused then Time.every 1000000000 Tick
  else Time.every 1000 Tick


-- VIEW

view : Model -> Html Msg
view model =
  let
    -- ints
    iHour   = Time.toHour   model.zone model.time
    iMinute = Time.toMinute model.zone model.time
    iSecond = Time.toSecond model.zone model.time
    hmDegFromNinety = toFloat(iMinute)/2.0 + toFloat(30 * (modBy 12 iHour))
    hmRadFromNinety = pi/180.0 * hmDegFromNinety
    -- strings
    hour    = lpadZero <| String.fromInt iHour
    minute  = lpadZero <| String.fromInt iMinute
    second  = lpadZero <| String.fromInt iSecond
  in
    div 
      [ style "font-family" "monospace" 
      , style "margin" "auto"
      , style "width" "25%"
      , style "padding" "150px 0"
      , style "text-align" "center"
      ]
      [ h1 [] [ text ( hour ++ ":" ++ minute ++ ":" ++ second ) ]
      , button [ onClick Pause ] [ text <| if model.isPaused then "Resume" else "Pause" ]
      , div [ style "padding" "30px 0" ]
        -- Example SVG of clock updated each second.
        [ svg 
          [ width "120"
          , height "120"
          , viewBox "0 0 120 120"
          ] 
          [ circle -- backdrop circle for clock
            [ cx "60"
            , cy "60"
            , r "60"
            , fill "black"
            ]
            []
          , line -- hour hand
            [ x1 "60"
            , x2 <| String.fromFloat <| minuteHandXCoord hmRadFromNinety
            , y1 "60"
            , y2 <| String.fromFloat <| minuteHandYCoord hmRadFromNinety
            , stroke "white"
            ]
            []
          , line -- second hand
            [ x1 "60"
            , x2 <| String.fromFloat <| secondHandXCoord iSecond
            , y1 "60"
            , y2 <| String.fromFloat <| secondHandYCoord iSecond
            , stroke "red"
            ]
            []
          ]
        ]
      ]

-- Helper to left pad a string to 2 digits in length with zeros.
lpadZero : String -> String
lpadZero s = String.padLeft 2 '0' s


-- Math helpers for figuring out SVG clock hand coordinates.
secondHandXCoord : Int -> Float
secondHandXCoord s =
  60.0 * (1 + cos (-pi/2.0 + (pi / 30.0 * toFloat s)))
secondHandYCoord : Int -> Float
secondHandYCoord s =
  60.0 * (1 + sin (-pi/2.0 + (pi / 30.0 * toFloat s)))
minuteHandXCoord : Float -> Float
minuteHandXCoord m =
  60.0 * (1 + 0.5 * cos(pi/2.0 - m))
minuteHandYCoord : Float -> Float
minuteHandYCoord m =
  60.0 * (1 - 0.5 * sin(pi/2.0 - m))

