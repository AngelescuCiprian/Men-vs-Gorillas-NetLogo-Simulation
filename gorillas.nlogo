turtles-own
[
 energy
]
to setup
  clear-all
  setupPeople
  setupGorillas
  setupPatches
  clear-plot
  reset-ticks
end
to go
  if not any? turtles with [shape = "person"] or not any? turtles with [shape = "gorilla"]
  [
    stop
  ]
  move
  fight
  eliminate
  tick
end
to move
  ask turtles
  [
   right random 360
   fd 1
   ;set energy energy - 1
    ifelse show-energy
    [
     set label energy
    ]
    [
      set label ""
    ]
  ]
end

to setupPeople
  ;; creeaza oamenii deasupra drumului (sus)
  create-turtles people
  [
    set energy 100

   ifelse show-energy
    [
     set label energy
    ]
    [
      set label ""
    ]
    set size 1
    set color blue
    set shape "person"
    separate-turtles
    setxy random-xcor (3 + random (max-pycor - 2)) ;; y > 2
  ]
end
  ;; creeaza gorilele dedesubtul drumului (jos)

to setupGorillas
  ;creeaza gorilele sub drum(jos)
     create-turtles gorillas
  [
    set energy 300
    ifelse show-energy
    [
     set label energy
    ]
    [
      set label ""
    ]
    set size 3
    set color brown
    set shape "gorilla"
    setxy random-xcor (-3 - random (abs min-pycor - 2)) ;; y < -2
    separate-turtles
    set energy 300
  ]
end

to setup-road
  if pycor < 3 and pycor > 0 [ set pcolor black]
  if pycor < 0 and pycor > -3 [ set pcolor black]
  if pycor = 0 [ set pcolor red ]
  if pxcor mod 2 = 0 and pycor = 0 [ set pcolor white ]
end
to setupPatches
  ask patches
  [
    set pcolor 54 setup-road
  ]
end
to separate-turtles
  if any? other turtles-here
  [
    fd 1
    separate-turtles
  ]

end
to fight
  ask turtles with [shape = "person"] [
    let enemy one-of other turtles-here with [shape = "gorilla"]
    if enemy != nobody [
      ; Persoana atacă gorila
      ask enemy [
        set energy energy - 10
        if energy <= 0 [ die ]
      ]
      ; Gorila atacă persoana
      set energy energy - 75
      if energy <= 0 [ die ]
    ]
  ]
end

to eliminate
 ask turtles
  [
   if energy <= 0 [ die ]
  ]
end

