

turtles-own [
  broodingThresh
  defenseThresh
  foragingThresh
;
  broodTime
  defenseTime
  forageTime

  broodFraction
  defenseFraction
  forageFraction
]
;
patches-own [
  food                 ;; amount of food on this patch (0, 1, or 2)
  nest?                ;; true on nest patches, false elsewhere
  task-number          ;; number (1, 2, or 3) to identify the food sources
  task
]
;
globals[
  broodingSignal
  defenseSignal
  foragingSignal
  learning
  forgetting
]
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Setup procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
;
to setup
  clear-all
  set-default-shape turtles "bug"

  ;; signals/demands
   ifelse demand-schedule?
  [ set broodingSignal brooding-demand
    set defenseSignal defense-demand
    set foragingSignal foraging-demand
  ] [
    set broodingSignal random 5
    set defenseSignal random 5
    set foragingSignal random 5
  ]

  ifelse caste-system? [create-caste]
  [create-t[ create-population]

  ;;constants
  set learning 10
  set forgetting 1

  ;; red = not carrying food
  setup-patches
  reset-ticks
end
;
to go  ;; forever button
  ask turtles
  [ if who >= ticks [ stop ] ;; delay initial departure
    if color != white
    [
      do-task       ;;
      wiggle
  ]
     fd 1 ]
  update-signal
;  show (list broodingProbability foragingProbability defenseProbability)
  tick
end
;
;
to do-task
  let broodingProbability (broodingSignal ^ 2)/ (broodingSignal ^ 2 + broodingThresh ^ 2)
  let foragingProbability (foragingSignal ^ 2)/ (foragingSignal ^ 2 + foragingThresh ^ 2)
  let defenseProbability (defenseSignal ^ 2)/ (defenseSignal ^ 2 + defenseThresh ^ 2)

  ifelse random-float 1 < broodingProbability [brooding-task]
[
  ifelse random-float 1 < foragingProbability [foraging-task]
  [
    if random-float 1 < defenseProbability [defense-task]
  ]
]

  let minThresh min (list broodingThresh foragingThresh defenseThresh)
  if minThresh = broodingThresh [if broodingThresh < 100 [set color yellow]]
  if minThresh = foragingThresh [if foragingThresh < 100 [set color violet]]
  if minThresh = defenseThresh [if defenseThresh < 100 [set color green]]
  if minThresh > 100 [set color red]

  set broodFraction (broodTime / ticks)
  set defenseFraction (defenseTime / ticks)
  set forageFraction (forageTime / ticks)

  set foragingThresh max list 1 foragingThresh
  set foragingThresh min list 1000 foragingThresh
  set broodingThresh broodingThresh - broodFraction * learning + (1 - broodFraction) * forgetting
  set broodingThresh max list 1 broodingThresh
  set broodingThresh min list 1000 broodingThresh
  set defenseThresh defenseThresh - defenseFraction * learning + (1 - defenseFraction) * forgetting
  set defenseThresh max list 1 defenseThresh
  set defenseThresh min list 1000 defenseThresh
end
;
;
to brooding-task  ;; turtle procedure

  facexy 0 0
  set broodTime broodTime + 1
;  set color yellow

  ;;update thresholds
;  set broodingThresh broodingThresh - learning
;  set broodingThresh max list 1 broodingThresh
;  set broodingThresh min list 1000 broodingThresh
;  set defenseThresh defenseThresh + forgetting
;  set defenseThresh max list 1 defenseThresh
;  set defenseThresh min list 1000 defenseThresh
;  set foragingThresh foragingThresh + forgetting
;  set foragingThresh max list 1 foragingThresh
;  set foragingThresh min list 1000 foragingThresh

end
;
;
;
to foraging-task
  facexy (-0.6 * max-pxcor) (-0.6 * max-pycor)
  set forageTime forageTime + 1
;  set color violet
;
;  ;;update thresholds
;  set foragingThresh foragingThresh - broodFraction * learning + (1 - broodFraction)
;  set foragingThresh max list 1 foragingThresh
;  set foragingThresh min list 1000 foragingThresh
;  set broodingThresh broodingThresh + forgetting
;  set broodingThresh max list 1 broodingThresh
;  set broodingThresh min list 1000 broodingThresh
;  set defenseThresh defenseThresh + forgetting
;  set defenseThresh max list 1 defenseThresh
;  set defenseThresh min list 1000 defenseThresh

end
;
;
;
to defense-task
  facexy (-0.8 * max-pxcor) (0.8 * max-pycor)
  set defenseTime defenseTime + 1
;  set color green
;
;
;  ;;update thresholds
;  set foragingThresh foragingThresh + forgetting
;  set foragingThresh max list 1 foragingThresh
;  set foragingThresh min list 1000 foragingThresh
;  set broodingThresh broodingThresh + forgetting
;  set broodingThresh max list 1 broodingThresh
;  set broodingThresh min list 1000 broodingThresh
;  set defenseThresh defenseThresh - learning
;  set defenseThresh max list 1 defenseThresh
;  set defenseThresh min list 1000 defenseThresh

  ;show defenseThresh
;  fd 1
end
;
;
;
to update-signal  ;; turtle procedure
  let broodCount 0
  let forageCount 0
  let defenseCount 0
  let antCount 0

  let broodxsum 0
  let foragexsum 0
  let defensexsum 0

  ask turtles[

    if color != white [
      set broodxsum broodxsum + broodFraction

      set foragexsum foragexsum + forageFraction

      set defensexsum defensexsum + defenseFraction

      set antCount antCount + 1
    ]
  ]
  set broodingSignal (broodingSignal + random-float 1 - (2 / antCount) * broodxsum )
  set broodingSignal max list .1 broodingSignal

  set foragingSignal (foragingSignal + random-float 1 - (2 / antCount) * foragexsum )
  set foragingSignal max list .1 foragingSignal

  set defenseSignal (defenseSignal + random-float 1 - (2 / antCount) * defensexsum )
  set defenseSignal max list .1 defenseSignal

  ;;show(defenseSignal)

;  if broodCount >= 0 [
;    set broodingSignal (broodingSignal + .8 - (2 / antCount) * broodxsum )
;    set broodingSignal max list 0.1 broodingSignal
;  ]
;  if forageCount > 0 [
;    set foragingSignal (foragingSignal + .8 - (2 / antCount) * foragexsum )
;    set foragingSignal max list 0.1 foragingSignal
;  ]
;  if defenseCount > 0 [
;    set defenseSignal (defenseSignal + 1 - (2 / antCount) * defensexsum )
;    set defenseSignal max list 0.1 defenseSignal
;  ]
end
;
to create-population
  create-turtles population
    [ set size 2         ;; easier to see
      set color red
      set broodingThresh random 1000
      set defenseThresh random 1000
      set foragingThresh random 1000 ]
end
;
to setup-patches
  ask patches
  [ setup-nest
    setup-tasks
    recolor-patch ]
end
;
to setup-tasks  ;; patch procedure
  ;; setup food source one on the right
  ;;task 1 is nest
  ;; setup food source two on the lower-left
  if (distancexy (-0.6 * max-pxcor) (-0.6 * max-pycor)) < 5
  [ set task-number 2 ]
  ;; setup food source three on the upper-left
  if (distancexy (-0.8 * max-pxcor) (0.8 * max-pycor)) < 5
  [ set task-number 3 ]
  ;; set "food" at sources to either 1 or 2, randomly
end
;
to wiggle  ;; turtle procedure
  rt random 40
  lt random 40
  if not can-move? 1 [ rt 180 ]
end
;
to setup-nest  ;; patch procedure
  ;; set nest? variable to true inside the nest, false elsewhere
  set nest? (distancexy 0 0) < 5
end
;
to recolor-patch  ;; patch procedure
  ;; give color to nest and food sources
  if nest? [ set pcolor violet ]
  if task-number = 2 [ set pcolor green ]  ;; foraging task
  if task-number = 3 [ set pcolor yellow ] ;; defense task
end
;
to removal

  let green-ants turtles with [color = green] ; find all green ants
  if any? green-ants[
  ask n-of 1 green-ants
  [
    set color white
    show turtles with [color = white]
    ;; move to the right upper area
    facexy (0.1 * max-pxcor) (0.1 * max-pycor)
    wiggle
  ] ]
end

to reintro

  let white-ants turtles with [color = white] ; find all green ants
  if any? white-ants[
  ask n-of 1 white-ants
  [
    do-task
    show (list broodingSignal defenseSignal foragingSignal)

  ] ]
end

to create-caste
  create-turtles 5
  [ set size 2         ;; easier to see
    set color yellow
    set broodingThresh 99
    set defenseThresh 999
    set foragingThresh 999]

  create-turtles 5
  [ set size 2         ;; easier to see
    set color green
    set broodingThresh 999
    set defenseThresh 99
    set foragingThresh 999]

  create-turtles 5
  [ set size 2         ;; easier to see
    set color violet
    set broodingThresh 999
    set defenseThresh 999
    set foragingThresh 99]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
715
516
-1
-1
7.0
1
10
1
1
1
0
0
0
1
-35
35
-35
35
1
1
1
ticks
30.0

SLIDER
3
34
175
67
population
population
0
100
5.0
1
1
NIL
HORIZONTAL

BUTTON
2
71
68
104
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
112
71
175
104
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
3
157
84
190
removal
removal
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
87
157
178
190
reintroduction
reintro
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
9
286
183
319
demand-schedule?
demand-schedule?
0
1
-1000

SLIDER
9
325
181
358
brooding-demand
brooding-demand
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
8
364
180
397
defense-demand
defense-demand
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
8
402
180
435
foraging-demand
foraging-demand
0
100
100.0
1
1
NIL
HORIZONTAL

SWITCH
10
224
156
257
caste-system?
caste-system?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
