; Práctica sobre recomendación de rama
; Autor: Guillermo Galindo Ortuño

;  Hechos para representar las ramas
    (deffacts Ramas
     (Rama Computación_y_Sistemas_Inteligentes)
     (Rama Ingeniería_del_Software)
     (Rama Ingeniería_de_Computadores)
     (Rama Sistemas_de_Información)
     (Rama Tecnologías_de_la_Información)
    )

; Inicializar las puntaciones de cada rama
    (defrule Inicializar_puntuaciones
     (Rama ?r)
     (not (Puntuacion ?r ?))
     =>
     (Puntuacion ?r 0)
    )

; Añade todos los posibles motivos para realizar una recomendación
(Motivo 1 "te gustan las matematicas")
(Motivo 2 "no te gustan las matematicas")

(Motivo 3 "prefieres el hardware al software")
(Motivo 4 "prefieres el software al hardware")

(Motivo 6 "tu nota media es alta")
(Motivo 7 "tu nota está en la media")
(Motivo 8 "te nota no es suficientemente alta")

(Motivo 9 "te gusta programar")
(Motivo 10 "no te gusta programar")

(Motivo 11 "eres una persona trabajadora")
(Motivo 12 "esta rama tiene un carga de trabajo alta")

(Motivo 13 "te gustaría trabajar en el sector privado")
(Motivo 14 "te gustaría trabajar en el sector público")
(Motivo 15 "te gustaría trabajar como docente")

(Motivo 16 "te gusta el desarrollo web")
(Motivo 17 "no te gusta el desarrollo web")

; Acabar cuando el usuario lo indique
    (defrule Salir
     (Respuesta ? finalizar)
     =>
     (finalizar)
    )

; Puntación inicial para cada rama
    (defrule Inicio
     =>
     (printout t "Bienvenido al sistema de asesoramiento para elegir rama. Cuál es tu nombre?")
     (assert (Usuario (read) (Inicio2)))
    )

; Información sobre como funcionará el sistema
    (defrule Inicio2
     ?f <- (Inicio2)
     (Usuario ?nombre)
     =>
     (printout t "Encantado " ?nombre ". A continuación te haré una serie de preguntas para realizar una recomendación de rama. Recuerda, en cualquier momento puedes escribir \"finalizar\", y realizaré una recomendación con la información que tenga hasta el momento.")
     (retract ?f)
    )

; Realiza todas las preguntas del experto
    (defrule Pregunta1
     (not (finalizar))
     =>
     (printout t "¿Qué prefieres el software o el hardware?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 1 ?Respuesta))
    )

    (defrule Pregunta2
     (not (finalizar))
     =>
     (printout t "¿Cuál es tu nota media?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 2 ?Respuesta))
    )

    (defrule Pregunta3
     (not (finalizar))
     =>
     (printout t "¿Te gustaría trabajar en una empresa privada, pública o como docente?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 3 ?Respuesta))
    )

    (defrule Pregunta4
     (not (finalizar))
     =>
     (printout t "¿Te gustan las matemáticas?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 4 ?Respuesta))
    )

    (defrule Pregunta5
     (not (finalizar))
     =>
     (printout t "¿Te consideras una persona trabajadora?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 5 ?Respuesta))
    )

    (defrule Pregunta6
     (not (finalizar))
     =>
     (printout t "¿Te gusta programar?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 6 ?Respuesta))
    )

    (defrule Pregunta7
     (not (finalizar))
     =>
     (printout t "¿Te gusta el diseño web?")
     (bind ?Respuesta (explode$ (readline)))
     (assert (Respuesta 7 ?Respuesta) (finalizar))
    )

    (defrule Resultados1
     (Respuesta 1 ?Respuesta)
     (test (str-index "software" ?Respuesta))
     =>
     (printout t "Te gusta el hardware")
    )
