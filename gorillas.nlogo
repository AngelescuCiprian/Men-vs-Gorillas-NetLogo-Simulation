turtles-own
[
 energy ;; 
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
  ;; opreste simularea daca nu mai exista oameni sau gorile
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

   ;; afiseaza energia daca optiunea e activata
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
  ;; creeaza oamenii deasupra drumului (y > 2)
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
    separate-turtles ;; evita suprapunerea la creare

    ;; pozitioneaza aleator pe X si deasupra drumului (y > 2)
    ;; (ex: daca max-pycor = 25, y va fi intre 3 si 25)
    setxy random-xcor (3 + random (max-pycor - 2))
  ]
end

to setupGorillas
  ;; creeaza gorilele sub drum (y < -2)
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

    separate-turtles ;; evita suprapunerea la creare

    ;; pozitioneaza aleator pe X si sub drum (y < -2)
    ;; ex: daca min-pycor = -25, y va fi intre -25 si -3
    setxy random-xcor (-3 - random (abs min-pycor - 2))
  ]
end

to setup-road
  ;; coloreaza drumul pe mijlocul hartii
  if pycor < 3 and pycor > 0 [ set pcolor black ] ;; zona superioara a drumului
  if pycor < 0 and pycor > -3 [ set pcolor black ] ;; zona inferioara a drumului
  if pycor = 0 [ set pcolor red ] ;; linia rosie pe centru
  if pxcor mod 2 = 0 and pycor = 0 [ set pcolor white ] ;; marcaje albe alternative
end

to setupPatches
  ask patches
  [
    set pcolor 54 
    setup-road 
  ]
end

to separate-turtles
  ;; daca alt turtle este pe acelasi patch, se misca inainte pana gaseste spatiu liber
  if any? other turtles-here
  [
    fd 1
    separate-turtles
  ]
end

to fight
  ;; oameni si gorile se lupta daca sunt pe acelasi patch
  ask turtles with [shape = "person"]
  [
    let enemy one-of other turtles-here with [shape = "gorilla"]
    if enemy != nobody
    [
      ;; persoana ataca gorila (scade -10 energie)
      ask enemy [
        set energy energy - 10
        if energy <= 0 [ die ]
      ]

      ;; gorila contraataca (scade -75 energie la persoana)
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
