; Práctica sobre recomendación de rama
; Autor: Guillermo Galindo Ortuño

; El experto utilizará la siguiente información, almacenada en los siguientes predicados
;; 1. Si prefiere el hardware o el software.
;;; Predicado: (Respuesta 1 hardware/software)
;; 2. Nota media del alumno, discretizando en baja (5-7), media (7-9), alta (9-10).
;;; Predicados: (nota baja/media/alta), (Respuesta 3 <nota>)
;; 3. Si prefiere trabajar en una empresa privada, publica, o como docente.
;;; Predicado: (Respuesta 3 privada/publica/docente)
;; 4. Si le gustan o no las matemáticas.
;;; Predicado: (Respuesta 4 si/no)
;; 5. Si se considera o no una persona trabajadora.
;;; Predicado: (Respuesta 5 si/no)
;; 6. Si le gusta programar o no.
;;; Predicado: (Respuesta 6 si/no)
;; 7. Si le gusta el diseño web o no.
;;; Predicado: (Respuesta 7 si/no)

; Hechos para representar las ramas
    (deffacts Ramas
     (Rama Computacion_y_Sistemas_Inteligentes)
     (Rama Ingenieria_del_Software)
     (Rama Ingenieria_de_Computadores)
     (Rama Sistemas_de_Informacion)
     (Rama Tecnologias_de_la_Informacion)
    )

    ; Añade todos los posibles motivos para realizar una recomendación
    (deffacts motivos
     (Motivo 1 "te gustan las matematicas")
     (Motivo 2 "no te gustan las matematicas")

     (Motivo 3 "prefieres el hardware al software")
     (Motivo 4 "prefieres el software al hardware")

     (Motivo 6 "tu nota media es alta")
     (Motivo 7 "tienes buena nota media")
     (Motivo 8 "las asignaturas de esta rama son relativamente fáciles")

     (Motivo 9 "te gusta programar")
     (Motivo 10 "no te gusta programar")

     (Motivo 11 "eres una persona trabajadora")
     (Motivo 12 "esta rama tiene un carga de trabajo baja")

     (Motivo 13 "te gustaría trabajar en el sector privado")
     (Motivo 14 "te gustaría trabajar en el sector público")
     (Motivo 15 "te gustaría trabajar como docente")

     (Motivo 16 "te gusta el desarrollo web")
     (Motivo 17 "no te gusta el desarrollo web")
    )

    ; Almacena nombre de experto
    (deffacts experto
     (Experto "Luis Antonio Ortega")
    )

    ; Inicializar las puntaciones de cada rama
    (defrule Inicializar_puntuaciones
     (declare (salience 100))
     (Rama ?r)
     (not (Puntuacion ?r ?))
     =>
     (assert (Puntuacion ?r 0))
    )

    ; Inicializar strings con los argumentos para cada rama
    (defrule Inicializar_motivos
     (declare (salience 10))
     (Rama ?r)
     (not (String_motivos ?r ?))
     =>
     (assert (String_motivos ?r ""))
    )

    ; Regla para actualizar el string con todos los motivos para cada rama
    (defrule Actualizar_motivos
     ?f <- (String_motivos ?r ?str)
     ?g <- (Argumento ?r ?n)
     (Motivo ?n ?motivo)
     =>
     (retract ?f ?g)
     (assert (String_motivos ?r (str-cat ?str ?motivo ", ")))
    )

    ; Acabar cuando el usuario lo indique
    (defrule Salir
     (declare (salience 100))
     (Respuesta ? ?Respuesta)
     (test (eq finalizar ?Respuesta))
     =>
     (printout t "Ok. Realizaré la sugerencia con la información que tengo hasta el momento" crlf)
     (assert (finalizar))
    )

    ; Inicio del sistema
    (defrule Inicio
    (declare (salience 1))
     =>
     (printout t "Bienvenido al sistema de asesoramiento para elegir rama. Cuál es tu nombre? ")
     (assert (Usuario (readline)))
    )

    ; Muestra información sobre como funcionará el sistema
    (defrule Inicio2
     (declare (salience 1))
     (Usuario ?nombre)
     =>
     (printout t "Encantado " ?nombre ". A continuación te haré una serie de preguntas para realizar una recomendación de rama. Recuerda, en cualquier momento puedes escribir \"finalizar\", y realizaré una recomendación con la información que tenga hasta el momento." crlf)
    )

    ; -------- Realiza todas las preguntas del experto --------
    (defrule Pregunta1
     (not (finalizar))
     =>
     (printout t "¿Qué prefieres el software o el hardware? ")
     (bind ?Respuesta (readline))
     (assert (Respuesta 1 ?Respuesta))
    )

    (defrule Pregunta2
     (not (finalizar))
     =>
     (printout t "¿Cuál es tu nota media? ")
     (bind ?Respuesta (read))
     (assert (Respuesta 2 ?Respuesta))
    )

    (defrule Pregunta3
     (not (finalizar))
     =>
     (printout t "¿Te gustaría trabajar en una empresa privada, pública o como docente? ")
     (bind ?Respuesta (readline))
     (assert (Respuesta 3 ?Respuesta))
    )

    (defrule Pregunta4
     (not (finalizar))
     =>
     (printout t "¿Te gustan las matemáticas? ")
     (bind ?Respuesta (readline))
     (assert (Respuesta 4 ?Respuesta))
    )

    (defrule Pregunta5
     (not (finalizar))
     =>
     (printout t "¿Te consideras una persona trabajadora? ")
     (bind ?Respuesta (readline))
     (assert (Respuesta 5 ?Respuesta))
    )

    (defrule Pregunta6
     (not (finalizar))
     =>
     (printout t "¿Te gusta programar? ")
     (bind ?Respuesta (readline))
     (assert (Respuesta 6 ?Respuesta))
    )

    (defrule Pregunta7
     (not (finalizar))
     =>
     (printout t "¿Te gusta el diseño web? ")
     (bind ?Respuesta (readline))
     (assert (Respuesta 7 ?Respuesta) (finalizar))
    )
    ; ---------------------------------------------------------

    ; ----- Evaluamos la respuestas obtenidas --------

    ; Actualiza cuando responden hardware a la primera pregunta
    (defrule Resultado1H
     (finalizar)
     (Respuesta 1 ?Respuesta)
     (test (str-index "hardware" ?Respuesta))
     ?g <- (Puntuacion Ingenieria_de_Computadores ?IC)
     (not (Pregunta 1 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Ingenieria_de_Computadores (+ ?IC 10))
      (Argumento Ingenieria_de_Computadores 3)
      (Pregunta 1 evaluada)
     )
    )

    ; Actualiza cuando responden software primera pregunta
    (defrule Resultado1S
     (finalizar)
     (Respuesta 1 ?Respuesta)
     (test (str-index "software" ?Respuesta))
     ?g <- (Puntuacion Ingenieria_del_Software ?IS)
     ?h <- (Puntuacion Sistemas_de_Informacion ?SI)
     (not (Pregunta 1 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Ingenieria_del_Software (+ ?IS 5))
      (Puntuacion Sistemas_de_Informacion (+ ?SI 2))
      (Argumento Ingenieria_del_Software 4)
      (Argumento Sistemas_de_Informacion 4)
      (Pregunta 1 evaluada)
     )
    )

    ; Discretiza el valor de la nota pedido en la segunda pregunta
    (defrule Nota_baja
     (finalizar)
     (Respuesta 2 ?Respuesta)
     (test (<= ?Respuesta 7 ))
     =>
     (assert (nota baja))
    )

    (defrule Nota_media
     (finalizar)
     (Respuesta 2 ?Respuesta)
     (test (and (< 7 ?Respuesta) (<= ?Respuesta 9)))
     =>
     (assert (nota media))
    )

    (defrule Nota_alta
     (finalizar)
     (Respuesta 2 ?Respuesta)
     (test (< 9 ?Respuesta))
     =>
     (assert (nota alta))
    )

    ; Actualiza resultados de la segunda pregunta utilizando la
    ; discretización de la nota (alta media o baja)
    (defrule Respuesta2A
     (finalizar)
     (nota alta)
     (Respuesta 2 ?)
     ?g <- (Puntuacion Ingenieria_de_Computadores ?IC)
     ?h <- (Puntuacion Computacion_y_Sistemas_Inteligentes ?CSI)
     (not (Pregunta 2 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Ingenieria_de_Computadores (+ ?IC 2))
      (Puntuacion Computacion_y_Sistemas_Inteligentes (+ ?CSI 3))
      (Argumento Ingenieria_del_Software 6)
      (Argumento Computacion_y_Sistemas_Inteligentes 6)
      (Pregunta 2 evaluada)
     )
    )

    (defrule Respuesta2M
     (finalizar)
     (nota media)
     (Respuesta 2 ?)
     ?g <- (Puntuacion Ingenieria_de_Computadores ?IC)
     ?h <- (Puntuacion Sistemas_de_Informacion ?SI)
     ?i <- (Puntuacion Ingenieria_del_Software ?IS)
     (not (Pregunta 2 evaluada))
     =>
     (retract ?g ?h ?i)
     (assert
      (Puntuacion Ingenieria_de_Computadores (+ ?IC 2))
      (Puntuacion Sistemas_de_Informacion (+ ?SI 5))
      (Puntuacion Ingenieria_del_Software (+ ?IS 5))
      (Argumento Ingenieria_del_Software 7)
      (Argumento Computacion_y_Sistemas_Inteligentes 7)
      (Argumento Ingenieria_del_Software 7)
      (Pregunta 2 evaluada)
     )
    )

    (defrule Respuesta2B
     (finalizar)
     (nota baja)
     (Respuesta 2 ?)
     ?g <- (Puntuacion Tecnologias_de_la_Informacion ?TI)
     (not (Pregunta 2 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Tecnologias_de_la_Informacion (+ ?TI 5))
      (Argumento Tecnologias_de_la_Informacion 8)
      (Pregunta 2 evaluada)
     )
    )

    ; Actualiza los resultados respectivos a la tercera pregunta
    ; en funcion de si es publica, privada o docente
    (defrule Respuesta3Pub
     (finalizar)
     (Respuesta 3 ?Respuesta)
     (test (or (str-index "publica" ?Respuesta) (str-index "pública" ?Respuesta)))
     ?g <- (Puntuacion Sistemas_de_Informacion ?SI)
     (not (Pregunta 3 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Sistemas_de_Informacion (+ ?SI 5))
      (Argumento Sistemas_de_Informacion 14)
      (Pregunta 3 evaluada)
     )
    )

    (defrule Respuesta3Priv
     (finalizar)
     (Respuesta 3 ?Respuesta)
     (test (str-index "privada" ?Respuesta))
     ?g <- (Puntuacion Tecnologias_de_la_Informacion ?TI)
     ?h <- (Puntuacion Ingenieria_del_Software ?IS)
     (not (Pregunta 3 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Tecnologias_de_la_Informacion (+ ?TI 3))
      (Puntuacion Ingenieria_del_Software (+ ?IS 5))
      (Argumento Tecnologias_de_la_Informacion 13)
      (Argumento Ingenieria_del_Software 13)
      (Pregunta 3 evaluada)
     )
    )

    (defrule Respuesta3Doc
     (finalizar)
     (Respuesta 3 ?Respuesta)
     (test (str-index "doce" ?Respuesta))
     ?g <- (Puntuacion Computacion_y_Sistemas_Inteligentes ?CSI)
     (not (Pregunta 3 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Computacion_y_Sistemas_Inteligentes (+ ?CSI 5))
      (Argumento Computacion_y_Sistemas_Inteligentes 15)
      (Pregunta 3 evaluada)
     )
    )

    ; Actualización de los resultados sobre la pregunta de si le gustan
    ; o no las matemáticas
    (defrule Respuesta4Si
     (finalizar)
     (Respuesta 4 ?Respuesta)
     (test (str-index "si" ?Respuesta))
     ?g <- (Puntuacion Computacion_y_Sistemas_Inteligentes ?CSI)
     (not (Pregunta 4 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Computacion_y_Sistemas_Inteligentes (+ ?CSI 5))
      (Argumento Computacion_y_Sistemas_Inteligentes 2)
      (Pregunta 4 evaluada)
     )
    )

    (defrule Respuesta4No
     (finalizar)
     (Respuesta 4 ?Respuesta)
     (test (str-index "no" ?Respuesta))
     ?g <- (Puntuacion Computacion_y_Sistemas_Inteligentes ?CSI)
     (not (Pregunta 4 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Computacion_y_Sistemas_Inteligentes (- ?CSI 5))
      (Pregunta 4 evaluada)
     )
    )

    ; Acutaliza los resultados respectivos a la pregunta sobre si se
    ; considera alguien trabajador o no
    (defrule Respuesta5Si
     (finalizar)
     (Respuesta 5 ?Respuesta)
     (test (str-index "si" ?Respuesta))
     ?g <- (Puntuacion Ingenieria_de_Computadores ?IC)
     ?h <- (Puntuacion Sistemas_de_Informacion ?SI)
     (not (Pregunta 5 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Ingenieria_de_Computadores (+ ?IC 2))
      (Puntuacion Sistemas_de_Informacion (+ ?SI 2))
      (Argumento Ingenieria_de_Computadores 11)
      (Argumento Sistemas_de_Informacion 11)
      (Pregunta 5 evaluada)
     )
    )

    (defrule Respuesta5No
     (finalizar)
     (Respuesta 5 ?Respuesta)
     (test (str-index "no" ?Respuesta))
     ?g <- (Puntuacion Tecnologias_de_la_Informacion ?TI)
     (not (Pregunta 5 evaluada))
     =>
     (retract ?g)
     (assert
      (Puntuacion Tecnologias_de_la_Informacion (+ ?TI 5))
      (Argumento Tecnologias_de_la_Informacion 12)
      (Pregunta 5 evaluada)
     )
    )

    ; Actualiza los resultados referentes a la pregunta sobre si le
    ; gusta programar
    (defrule Respuesta6Si
     (finalizar)
     (Respuesta 6 ?Respuesta)
     (test (str-index "si" ?Respuesta))
     ?g <- (Puntuacion Ingenieria_del_Software ?IS)
     ?h <- (Puntuacion Computacion_y_Sistemas_Inteligentes ?CSI)
     (not (Pregunta 6 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Ingenieria_del_Software (+ ?IS 5))
      (Puntuacion Computacion_y_Sistemas_Inteligentes (+ ?CSI 3))
      (Argumento Ingenieria_del_Software 9)
      (Argumento Computacion_y_Sistemas_Inteligentes 9)
      (Pregunta 6 evaluada)
     )
    )

    (defrule Respuesta6No
     (finalizar)
     (Respuesta 6 ?Respuesta)
     (test (str-index "no" ?Respuesta))
     ?g <- (Puntuacion Ingenieria_de_Computadores ?IC)
     ?h <- (Puntuacion Tecnologias_de_la_Informacion ?TI)
     (not (Pregunta 6 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Ingenieria_de_Computadores (+ ?IC 5))
      (Puntuacion Tecnologias_de_la_Informacion (+ ?TI 3))
      (Argumento Ingenieria_de_Computadores 9)
      (Argumento Tecnologias_de_la_Informacion 9)
      (Pregunta 6 evaluada)
     )
    )

    ; Actualizacion de los resultados sobre la respuesta a la pregunta
    ; sobre diseño web
    (defrule Respuesta7Si
     (finalizar)
     (Respuesta 7 ?Respuesta)
     (test (str-index "si" ?Respuesta))
     ?g <- (Puntuacion Sistemas_de_Informacion ?SI)
     ?h <- (Puntuacion Tecnologias_de_la_Informacion ?TI)
     (not (Pregunta 7 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Sistemas_de_Informacion (+ ?SI 5))
      (Puntuacion Tecnologias_de_la_Informacion (+ ?TI 5))
      (Argumento Sistemas_de_Informacion 16)
      (Argumento Tecnologias_de_la_Informacion 16)
      (Pregunta 7 evaluada)
     )
    )

    (defrule Respuesta7No
     (finalizar)
     (Respuesta 7 ?Respuesta)
     (test (str-index "no" ?Respuesta))
     ?g <- (Puntuacion Sistemas_de_Informacion ?SI)
     ?h <- (Puntuacion Tecnologias_de_la_Informacion ?TI)
     (not (Pregunta 7 evaluada))
     =>
     (retract ?g ?h)
     (assert
      (Puntuacion Sistemas_de_Informacion (- ?SI 2))
      (Puntuacion Tecnologias_de_la_Informacion (- ?TI 2))
      (Pregunta 7 evaluada)
     )
    )

    ; Elige la rama con mayor puntuación de todas
    (defrule Consejo
     (declare (salience -10))
     (Puntuacion Computacion_y_Sistemas_Inteligentes ?n1)
     (Puntuacion Tecnologias_de_la_Informacion ?n2)
     (Puntuacion Ingenieria_de_Computadores ?n3)
     (Puntuacion Sistemas_de_Informacion ?n4)
     (Puntuacion Ingenieria_del_Software ?n5)
     (Puntuacion ?r ?n)
     (test (>= ?n ?n1))
     (test (>= ?n ?n2))
     (test (>= ?n ?n3))
     (test (>= ?n ?n4))
     (test (>= ?n ?n5))
     (String_motivos ?r ?motivos)
     (Experto ?nombre_exp)
     =>
     (assert (Consejo ?r ?motivos ?nombre_exp))
    )

    ; Muestra resultado final
    (defrule Resultado_final
     (Consejo ?r ?motivos ?nombre_exp)
     =>
     (printout t "La rama que te recomiento en base al conocimiento del experto " ?nombre_exp " es " ?r "." crlf)
     (printout t "Te recomiendo esta porque " ?motivos "así que pienso que se ajusta a tu perfil." crlf)
    )
