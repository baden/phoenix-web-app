module Components.UI.Battery exposing (..)


powerLevelClass : Float -> String
powerLevelClass v =
    if v > 90 then
        "full"

    else if v > 60 then
        "high"

    else if v > 30 then
        "medium"

    else
        "low"
