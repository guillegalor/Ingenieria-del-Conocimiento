;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; JUGADOR DE 3 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Version de 3 en raya clásico: fichas que se pueden poner libremente en cualquier posicion libre (i,j) con 0 < i,j < 4
;; y cuando se han puesto las 3 fichas las jugadas consisten en desplazar una ficha propia
;; de la posición en que se encuentra (i,j) a una contigua

; Hechos para representar un estado del juego
;; (Turno X|O)   representa a quien corresponde el turno (X maquina, O jugador)
;; (Posicion ?i ?j " "|X|O) representa que la posicion i,j del tablero esta vacia, o tiene una ficha de Clisp o tiene una ficha del contrincante

; Hechos para representar una jugadas

;; (Juega X|O ?origen_i ?origen_j ?destino_i ?destino_j) representa que la jugada consiste en desplazar la ficha de la posicion
;; (?origen_i,?origen_j) a la posición (?destino_i,?destino_j)
;; las fichas que se ponen inicialmente se supondrá que están en el posición (0,0)

; INICIALIZAR ESTADO

    (deffacts Tablero
     (Conectado 1 a horizontal 1 b)
     (Conectado 1 b horizontal 1 c)
     (Conectado 2 a horizontal 2 b)
     (Conectado 2 b horizontal 2 c)
     (Conectado 3 a horizontal 3 b)
     (Conectado 3 b horizontal 3 c)
     (Conectado 1 a vertical 2 a)
     (Conectado 2 a vertical 3 a)
     (Conectado 1 b vertical 2 b)
     (Conectado 2 b vertical 3 b)
     (Conectado 1 c vertical 2 c)
     (Conectado 2 c vertical 3 c)
     (Conectado 1 a diagonal 2 b)
     (Conectado 2 b diagonal 3 c)
     (Conectado 1 c diagonal_inversa 2 b)
     (Conectado 2 b diagonal_inversa 3 a)
    )

    (deffacts Estado_inicial
     (Posicion 1 a " ")
     (Posicion 1 b " ")
     (Posicion 1 c " ")
     (Posicion 2 a " ")
     (Posicion 2 b " ")
     (Posicion 2 c " ")
     (Posicion 3 a " ")
     (Posicion 3 b " ")
     (Posicion 3 c " ")
     (Fichas_sin_colocar O 3)
     (Fichas_sin_colocar X 3)
    )

    ; Añade predicados para saber si dos casillas están en linea
    (defrule En_linea
     (declare (salience 1))
     (Conectado ?i1 ?j1 ?forma ?i2 ?j2)
     (Conectado ?i2 ?j2 ?forma ?i3 ?j3)
     (test (or (neq ?i1 ?i3) (neq ?j1 ?j3)))
     =>
     (assert (en_linea ?forma ?i1 ?j1 ?i2 ?j2))
     (assert (en_linea ?forma ?i2 ?j2 ?i3 ?j3))
     (assert (en_linea ?forma ?i1 ?j1 ?i3 ?j3))
    )

    (defrule Conectado_es_simetrica
     (declare (salience 1))
     (Conectado ?i ?j ?forma ?i1 ?j1)
     =>
     (assert (Conectado ?i1 ?j1 ?forma ?i ?j))
    )

    (defrule Elige_quien_comienza
     =>
     (printout t "Quien quieres que empiece: (escribe X para la maquina, O para empezar tu) ")
     (assert (Turno (read)))
    )

    ; Comprueba si algún jugador tiene dos fichas en linea
    (defrule 2_en_linea
     (declare (salience 2))
     (logical
      (Posicion ?i1 ?j1 ?p)
      (Posicion ?i2 ?j2 ?p)
     )
     (en_linea ?forma ?i1 ?j1 ?i2 ?j2)
     (test (neq " " ?p))
     =>
     (assert (2_en_linea ?forma ?i1 ?j1 ?i2 ?j2 ?p))
    )

    ; Comprueba si algún jugador puede ganar colocando una ficha
    (defrule puede_ganar_colocando
     (declare (salience 1))
     (logical
      (Fichas_sin_colocar ?p 1)
     )
     (2_en_linea ?forma ?i1 ?j1 ?i2 ?j2 ?p)
     (en_linea ?forma ?i3 ?j3 ?i1 ?j1)
     (Posicion ?i3 ?j3 " ")
     =>
     (assert (puede_ganar_colocando ?i3 ?j3 ?p))
    )

    ; Comprueba si algún jugador puede ganar moviendo una ficha
    (defrule puede_ganar_moviendo
     (declare (salience 1))
     (logical
      (2_en_linea ?forma ?i1 ?j1 ?i2 ?j2 ?p)
      (Posicion ?i3 ?j3 " ")
      (Posicion ?i4 ?j4 ?p)
     )
     (Todas_fichas_en_tablero ?p)
     (en_linea ?forma ?i3 ?j3 ?i1 ?j1)
     (test (or (neq ?i4 ?i1) (neq ?j4 ?j1)))
     (test (or (neq ?i4 ?i2) (neq ?j4 ?j2)))
     (Conectado ?i3 ?j3 ?f ?i4 ?j4)
     =>
     (assert (puede_ganar_moviendo ?i4 ?j4 ?i3 ?j3 ?p))
    )

    ;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
    (defrule muestra_posicion
     (declare (salience 1))
     (muestra_posicion)
     (Posicion 1 a ?p11)
     (Posicion 1 b ?p12)
     (Posicion 1 c ?p13)
     (Posicion 2 a ?p21)
     (Posicion 2 b ?p22)
     (Posicion 2 c ?p23)
     (Posicion 3 a ?p31)
     (Posicion 3 b ?p32)
     (Posicion 3 c ?p33)
     =>
     (printout t crlf)
     (printout t "   a      b      c" crlf)
     (printout t "   -      -      -" crlf)
     (printout t "1 |" ?p11 "| -- |" ?p12 "| -- |" ?p13 "|" crlf)
     (printout t "   -      -      -" crlf)
     (printout t "   |  \\   |   /  |" crlf)
     (printout t "   -      -      -" crlf)
     (printout t "2 |" ?p21 "| -- |" ?p22 "| -- |" ?p23 "|" crlf)
    (printout t "   -      -      -" crlf)
    (printout t "   |   /  |  \\   |" crlf)
    (printout t "   -      -      -" crlf)
    (printout t "3 |" ?p31 "| -- |" ?p32 "| -- |" ?p33 "|"crlf)
    (printout t "   -      -      -" crlf)
    )

    (defrule muestra_posicion_turno_jugador
     (declare (salience 10))
     (Turno O)
     =>
     (assert (muestra_posicion))
    )

    (defrule jugada_contrario_fichas_sin_colocar
     ?f <- (Turno O)
     (Fichas_sin_colocar O ?n)
     =>
     (printout t "en que posicion colocas la siguiente ficha" crlf)
     (printout t "escribe la fila (1,2 o 3): ")
     (bind ?fila (read))
     (printout t "escribe la columna (a,b o c): ")
     (bind ?columna (read))
     (assert (Juega O 0 0 ?fila ?columna))
     (retract ?f)
    )

    (defrule juega_contrario_fichas_sin_colocar_check
     (declare (salience 1))
     ?f <- (Juega O 0 0 ?i ?j)
     (not (Posicion ?i ?j " "))
     =>
     (printout t "No puedes jugar en " ?i ?j " porque no esta vacio" crlf)
     (retract ?f)
     (assert (Turno O))
    )

    (defrule juega_contrario_fichas_sin_colocar_actualiza_estado
     ?f <- (Juega O 0 0 ?i ?j)
     ?g <- (Posicion ?i ?j " ")
     =>
     (retract ?f ?g)
     (assert (Turno X) (Posicion ?i ?j O) (reducir_fichas_sin_colocar O))
    )

    (defrule reducir_fichas_sin_colocar
     (declare (salience 2))
     ?f <- (reducir_fichas_sin_colocar ?jugador)
     ?g <- (Fichas_sin_colocar ?jugador ?n)
     =>
     (retract ?f ?g)
     (assert (Fichas_sin_colocar ?jugador (- ?n 1)))
    )

    (defrule todas_las_fichas_en_tablero
     (declare (salience 2))
     ?f <- (Fichas_sin_colocar ?jugador 0)
     =>
     (retract ?f)
     (assert (Todas_fichas_en_tablero ?jugador))
    )

    (defrule juega_contrario
     ?f <- (Turno O)
     (Todas_fichas_en_tablero O)
     =>
     (printout t "en que posicion esta la ficha que quieres mover?" crlf)
     (printout t "escribe la fila (1,2,o 3): ")
     (bind ?origen_i (read))
     (printout t "escribe la columna (a,b o c): ")
     (bind ?origen_j (read))
     (printout t "a que posicion la quieres mover?" crlf)
     (printout t "escribe la fila (1,2,o 3): ")
     (bind ?destino_i (read))
     (printout t "escribe la columna (a,b o c): ")
     (bind ?destino_j (read))
     (assert (Juega O ?origen_i ?origen_j ?destino_i ?destino_j))
     (printout t "Juegas mover la ficha de "  ?origen_i ?origen_j " a " ?destino_i ?destino_j crlf)
     (retract ?f)
    )

    (defrule juega_contrario_check_mueve_ficha_propia
     (declare (salience 1))
     ?f <- (Juega O ?origen_i ?origen_j ?destino_i ?destino_j)
     (Posicion ?origen_i ?origen_j ?X)
     (test (neq O ?X))
     =>
     (printout t "No es jugada valida porque en " ?origen_i ?origen_j " no hay una ficha tuya" crlf)
     (retract ?f)
     (assert (Turno O))
    )

    (defrule juega_contrario_check_mueve_a_posicion_libre
     (declare (salience 1))
     ?f <- (Juega O ?origen_i ?origen_j ?destino_i ?destino_j)
     (Posicion ?destino_i ?destino_j ?X)
     (test (neq " " ?X))
     =>
     (printout t "No es jugada valida porque " ?destino_i ?destino_j " no esta libre" crlf)
     (retract ?f)
     (assert (Turno O))
    )

    (defrule juega_contrario_check_conectado
     (declare (salience 1))
     (Todas_fichas_en_tablero O)
     ?f <- (Juega O ?origen_i ?origen_j ?destino_i ?destino_j)
     (not (Conectado ?origen_i ?origen_j ? ?destino_i ?destino_j))
     =>
     (printout t "No es jugada valida porque "  ?origen_i ?origen_j " no esta conectado con " ?destino_i ?destino_j crlf)
     (retract ?f)
     (assert (Turno O))
    )

    (defrule juega_contrario_actualiza_estado
     ?f <- (Juega O ?origen_i ?origen_j ?destino_i ?destino_j)
     ?h <- (Posicion ?origen_i ?origen_j O)
     ?g <- (Posicion ?destino_i ?destino_j " ")
     =>
     (retract ?f ?g ?h)
     (assert (Turno X) (Posicion ?destino_i ?destino_j O) (Posicion ?origen_i ?origen_j " ") )
    )

    ;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

    ; Actualiza estado tras jugada de clisp, pero no cambia el turno para poder comprobar
    ; que clips no pierde
    (defrule juega_clisp_actualiza_estado
     (declare (salience 1))
     ?f <- (Juega X ?origen_i ?origen_j ?destino_i ?destino_j)
     ?h <- (Posicion ?origen_i ?origen_j X)
     ?g <- (Posicion ?destino_i ?destino_j " ")
     =>
     (retract ?g ?h)
     (assert (Posicion ?destino_i ?destino_j X) (Posicion ?origen_i ?origen_j " ") )
    )

    ; Elimina el predicado que indica que pierde clisp al cambiar el turno
    (defrule elimina_pierde
     (declare (salience 5))
     (Turno O)
     ?f <- (Pierde)
     =>
     (retract ?f)
    )

    ; Elimina el predicado que indica que pierde clisp al hacer un movimiento
    ; al cambiar el turno
    (defrule elimina_pierdes
     (declare (salience 5))
     (Turno O)
     ?f <- (pierde_moviendo ? ? ? ?)
     =>
     (retract ?f)
    )

    ; Cambia el turno al jugador. (Salience negativo para que se haga después de comprobar que
    ; clips no pierde)
    (defrule acaba_turno
     (declare (salience -1))
     ?f <- (Juega X ?origen_i ?origen_j ?destino_i ?destino_j)
     =>
     (retract ?f)
     (assert (Turno O) )
    )

    ;;;;;;;;;;; CLISP JUEGA GREEDY ;;;;;;;;;;;
    ; Estas son las reglas con mayor salience de movimiento de clips.
    ; En caso de poder ganar moviendo o colocando, lo hace

    ; En caso de poder ganar colocando una ficha, gana
    (defrule clisp_juega_greedy_fichas_sin_colocar
     (declare (salience -9997))
     ?f<- (Turno X)
     (Fichas_sin_colocar X ?n)
     (puede_ganar_colocando ?i ?j X)
     ?g<- (Posicion ?i ?j " ")
     =>
     (printout t "Juego poner ficha en " ?i ?j crlf)
     (printout t "GREEDY" crlf)
     (retract ?f ?g)
     (assert (Posicion ?i ?j X) (Turno O) (reducir_fichas_sin_colocar X))
    )

    ; En caso de poder ganar moviendo una ficha, gana
    (defrule clisp_juega_greedy
     (declare (salience -9997))
     ?f<- (Turno X)
     (Todas_fichas_en_tablero X)
     (puede_ganar_moviendo ?origen_i ?origen_j ?destino_i ?destino_j X)
     =>
     (assert (Juega X ?origen_i ?origen_j ?destino_i ?destino_j))
     (printout t "Juego mover la ficha de "  ?origen_i ?origen_j " a " ?destino_i ?destino_j crlf)
     (printout t "GREEDY" crlf)
     (retract ?f)
    )

    ;;;;;;;;;;; CLISP NO DEJA GANAR ;;;;;;;;;;;;;;;;
    ; En caso de no poder ganar, intenta realizar una jugada que no permita
    ; que el usuario contrario gane

    ; En caso de que todavía tenga fichas por colocar, y pueda evitar que el contricante gane,
    ; lo hace
    (defrule clisp_juega_def_fichas_sin_colocar
     (declare (salience -9998))
     ?f<- (Turno X)
     (Fichas_sin_colocar X ?n)
     (or (puede_ganar_colocando ?i ?j O) (puede_ganar_moviendo ? ? ?i ?j O))
     ?g<- (Posicion ?i ?j " ")
     =>
     (printout t "Juego poner ficha en " ?i ?j crlf)
     (printout t "DEF" crlf)
     (retract ?f ?g)
     (assert (Posicion ?i ?j X) (Turno O) (reducir_fichas_sin_colocar X))
    )

    ; Al hacer un movimiento, antes de cambiar el turno, comprueba si deja ganar al usuario
    ; al hacer dicho movimiento. En ese caso, almacena que con esa jugada pierde (pierde_moviendo ...)
    ; y vuelve al turno de clips
    (defrule juega_clisp_check_no_deja_ganar
     ?f <- (Juega X ?origen_i ?origen_j ?destino_i ?destino_j)
     ?h <- (Posicion ?origen_i ?origen_j " ")
     ?g <- (Posicion ?destino_i ?destino_j X)
     (puede_ganar_moviendo ? ? ? ? O)
     (not (Pierde))
     =>
     (retract ?f ?g ?h)
     (assert
      (Posicion ?origen_i ?origen_j X)
      (Posicion ?destino_i ?destino_j " ")
      (pierde_moviendo ?origen_i ?origen_j ?destino_i ?destino_j)
      (Turno X)
     )
    )

    ; Realiza un movimiento "aleatorio" siempre que este no deje ganar al contrincante
    ; en la siguiente jugada
    (defrule clisp_juega_sin_dejar_ganar
     (declare (salience -9998))
     ?f<- (Turno X)
     (Todas_fichas_en_tablero X)
     (Posicion ?origen_i ?origen_j X)
     (Posicion ?destino_i ?destino_j " ")
     (Conectado ?origen_i ?origen_j ? ?destino_i ?destino_j)
     (not (pierde_moviendo ?origen_i ?origen_j ?destino_i ?destino_j))
     =>
     (assert (Juega X ?origen_i ?origen_j ?destino_i ?destino_j))
     (printout t "Juego mover la ficha de "  ?origen_i ?origen_j " a " ?destino_i ?destino_j crlf)
     (retract ?f)
    )

    ;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Jugar sin creterio. Esto se hace al colocar una ficha en caso de que no haya
    ; riesgo de perder, o en caso de que muevas lo que muevas permites ganar al
    ; adversario.

    ; Clisp coloca una ficha sin criterio. Esto lo hará en caso de que
    ; no haya amenaza de ganar por parte del adversario
    (defrule clisp_juega_sin_criterio_fichas_sin_colocar
     (declare (salience -9999))
     ?f<- (Turno X)
     (Fichas_sin_colocar X ?n)
     ?g<- (Posicion ?i ?j " ")
     =>
     (printout t "Juego poner ficha en " ?i ?j crlf)
     (retract ?f ?g)
     (assert (Posicion ?i ?j X) (Turno O) (reducir_fichas_sin_colocar X))
    )

    ; Clisp mueve una ficha sin criterio. Esto solo lo hará en el caso en el que
    ; cualquier jugada le siga permitiendo al contrincante ganar, y por eso
    ; añade el predicado (Pierde)
    (defrule clisp_juega_sin_criterio
     (declare (salience -9999))
     ?f<- (Turno X)
     (Todas_fichas_en_tablero X)
     (Posicion ?origen_i ?origen_j X)
     (Posicion ?destino_i ?destino_j " ")
     (Conectado ?origen_i ?origen_j ? ?destino_i ?destino_j)
     =>
     (assert (Juega X ?origen_i ?origen_j ?destino_i ?destino_j) (Pierde))
     (printout t "Juego mover la ficha de "  ?origen_i ?origen_j " a " ?destino_i ?destino_j crlf)
     (retract ?f)
    )

    ; Fin de partida
    (defrule tres_en_raya
     (declare (salience 9999))
     ?f <- (Turno ?X)
     (Posicion ?i1 ?j1 ?jugador)
     (Posicion ?i2 ?j2 ?jugador)
     (Posicion ?i3 ?j3 ?jugador)
     (Conectado ?i1 ?j1 ?forma ?i2 ?j2)
     (Conectado ?i2 ?j2 ?forma ?i3 ?j3)
     (test (neq ?jugador " "))
     (test (or (neq ?i1 ?i3) (neq ?j1 ?j3)))
     =>
     (printout t ?jugador " ha ganado pues tiene tres en raya " ?i1 ?j1 " " ?i2 ?j2 " " ?i3 ?j3 crlf)
     (retract ?f)
     (assert (muestra_posicion))
    )
