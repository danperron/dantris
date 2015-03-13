DECLARE SUB makebox (X!)
'Dantris
'A tetris clone by dan perron
GOSUB A001
GOSUB A002
GOSUB mainloop
END


'***startup Screen

A001:
CLS
SCREEN 11
PRINT
PRINT
PRINT "                                   DanTris"
PRINT "                                by Dan Perron"
PRINT
PRINT "                                   Version 1.1"
PRINT
PRINT "                            (press a key to start)"
DO WHILE INKEY$ = ""
 SLEEP
LOOP
DIM SolidBLock(0 TO 199)
DIM ActiveBlock(0 TO 199)
DIM ChangeBlock(0 TO 199)
RETURN

A002:
CLS
LINE (220, 5)-(420, 5)
LINE (220, 405)-(420, 405)
LINE (220, 5)-(220, 405)
LINE (420, 5)-(420, 405)
RETURN

'temporary gridlines
A003:
X = 220
Y = 5
FOR T = 0 TO 18
    Y = Y + 20
    LINE (220, Y)-(420, Y)
NEXT T
FOR T = 0 TO 8
    X = X + 20
    LINE (X, 5)-(X, 405)
NEXT T

RETURN

mainloop:
GOSUB dropblock
DO
CLS
GOSUB A002
GOSUB lineclear
LOCATE 20, 5: PRINT "Lines: ", Lines
LOCATE 20, 60: PRINT "P = Pause"

FOR I = 0 TO 199
    IF ChangeBlock(I) = 1 THEN
        SolidBLock(I) = 1
        ChangeBlock(I) = 0
    END IF
NEXT I

FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        makebox (I)
    END IF
    IF SolidBLock(I) = 1 THEN
        makebox (I)
    END IF
NEXT I

GOSUB peicefall

remit = TIMER
remit = remit + .25
DO UNTIL gmit >= remit
    gmit = TIMER
    GOSUB CheckKey
LOOP

IF GamePaused = 1 THEN
    LOCATE 10, 35: PRINT "Game Paused"
    SLEEP
END IF


LOOP

RETURN


'***drop a new block
dropblock:
FOR I = 3 TO 5
    IF SolidBLock(I) = 1 THEN
        GOSUB GameOver
    END IF
NEXT I

ActivePos = 3
RANDOMIZE TIMER
btype = INT(RND * 19) + 1
GOSUB SetBlock
RETURN
'****** PEICEFALL

peicefall:
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        IF (I + 10) > 199 THEN
            GOSUB STickblock
            RETURN
        END IF
   END IF
    IF ActiveBlock(I) = 1 THEN
        'IF Activeblock(I + 10) = 1 THEN
        '   gosub STickblock
         '   RETURN
        'END IF
        IF SolidBLock(I + 10) = 1 THEN
            GOSUB STickblock
            RETURN
            END IF
    END IF
NEXT I

ActivePos = ActivePos + 10
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        ActiveBlock(I) = 0
    END IF
NEXT I
GOSUB SetBlock
RETURN


STickblock:
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        ActiveBlock(I) = 0
        SolidBLock(I) = 1
    END IF
NEXT I
GOSUB dropblock
RETURN


moveright:
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        IF (I) - INT((I) / 10) * 10 = 9 THEN
            RETURN
        END IF
        IF SolidBLock(I + 1) = 1 THEN
            RETURN
        END IF
    END IF

NEXT I


FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        ActiveBlock(I) = 0
    END IF
NEXT I
ActivePos = ActivePos + 1

GOSUB SetBlock

RETURN
MoveLeft:
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        IF (I) - INT((I) / 10) * 10 = 0 THEN
            RETURN
        END IF
        IF SolidBLock(I - 1) = 1 THEN
            RETURN
        END IF
    END IF

NEXT I


FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        ActiveBlock(I) = 0
    END IF
NEXT I
ActivePos = ActivePos - 1

GOSUB SetBlock

RETURN

CheckKey:
keystf$ = INKEY$
IF keystf$ = "" THEN
    RETURN
END IF

keystf$ = RIGHT$(keystf$, 1)
SELECT CASE keystf$
CASE IS = "M"
    GOSUB moveright
CASE IS = "K"
    GOSUB MoveLeft
CASE IS = CHR$(27)
    CLS
    END
CASE IS = "H"
    GOSUB Rotate
CASE IS = "P"
    GOSUB FastDrop
CASE IS = "p"
    IF GamePaused = 0 THEN
        GamePaused = 1
    ELSE
        GamePaused = 0
    END IF


END SELECT
RETURN


Rotate:
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        ActiveBlock(I) = 0
    END IF
NEXT I


lasttype = btype
SELECT CASE btype
CASE IS = 1
    btype = 2
    ActivePos = ActivePos - 10
CASE IS = 2
    btype = 3
CASE IS = 3
    btype = 4
    ActivePos = ActivePos - 10
CASE IS = 4
    btype = 1
CASE IS = 5
    btype = 5
CASE IS = 6
    btype = 7
    ActivePos = ActivePos - 18
CASE IS = 7
    btype = 6
    ActivePos = ActivePos + 18
CASE IS = 8
    btype = 9
    ActivePos = ActivePos + 1
CASE IS = 9
    btype = 8
    ActivePos = ActivePos - 1
CASE IS = 10
    btype = 11
    ActivePos = ActivePos - 10
CASE IS = 11
    btype = 10
    ActivePos = ActivePos + 10
CASE IS = 12
    btype = 13
CASE IS = 13
    btype = 14
CASE IS = 14
    btype = 15
CASE IS = 15
    btype = 12
CASE IS = 16
    btype = 17
CASE IS = 17
    btype = 18
CASE IS = 18
    btype = 19
CASE IS = 19
    btype = 16
END SELECT
GOSUB SetBlock

FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        IF SolidBLock(I) = 1 THEN
            btype = lasttype
            GOSUB SetBlock
        END IF
    END IF
NEXT I
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        IF (I) - INT((I) / 10) * 10 = 9 THEN
          btype = lasttype
          GOSUB SetBlock
        END IF
        IF SolidBLock(I + 1) = 1 THEN
           btype = lasttype
           GOSUB SetBlock
        END IF
    END IF
NEXT I
FOR I = 0 TO 199
    IF ChangeBlock(I) = 1 THEN
        ActiveBlock(I) = 1
        ChangeBlock(I) = 0
    END IF
NEXT I

GOSUB SetBlock
RETURN


lineclear:
FOR I = 19 TO 0 STEP -1
    LCNT% = 0
    FOR T = 0 TO 9
        IF SolidBLock((I * 10) + T) = 1 THEN
            LCNT% = LCNT% + 1
        END IF
        BCNT% = I
    NEXT T
    IF LCNT% = 10 THEN
        FOR G = (I * 10) TO (I * 10) + 9
            IF SolidBLock(G) = 1 THEN
                SolidBLock(G) = 0
            END IF
        NEXT G
        FOR F = 0 TO (I * 10) + 9
            IF SolidBLock(F) = 1 THEN
                SolidBLock(F) = 0
                ChangeBlock(F + 10) = 1
            END IF
        NEXT F
        Lines = Lines + 1
   
   
    END IF

NEXT I





RETURN

GameOver:
CLEAR
CLS
PRINT
PRINT
PRINT
PRINT
PRINT "                              GAME"
PRINT "                              OVER"
PRINT
PRINT "                 Press any key to play again"
PRINT
SLEEP
GOSUB mainloop

RETURN

FastDrop:
Gah = 0
DO UNTIL Gah = 1
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        IF (I + 10) > 199 THEN
            GOSUB STickblock
            Gah = 1
        END IF
   END IF
    IF ActiveBlock(I) = 1 THEN
        IF SolidBLock(I + 10) = 1 THEN
            GOSUB STickblock
            Gah = 1
        END IF
    END IF
NEXT I

ActivePos = ActivePos + 10
FOR I = 0 TO 199
    IF ActiveBlock(I) = 1 THEN
        ActiveBlock(I) = 0
    END IF
NEXT I
GOSUB SetBlock
LOOP
RETURN

SetBlock:
SELECT CASE btype
CASE IS = 1
' *
'***
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 9) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 11) = 1
CASE IS = 2
'*
'**
'*
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 11) = 1
ActiveBlock(ActivePos + 20) = 1
CASE IS = 3
'***
' *
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 2) = 1
ActiveBlock(ActivePos + 11) = 1
CASE IS = 4
' *
'**
' *
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 9) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 20) = 1
CASE IS = 5
'**
'**
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 11) = 1
CASE IS = 6
'****
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 2) = 1
ActiveBlock(ActivePos + 3) = 1
CASE IS = 7
'*
'*
'*
'*
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 20) = 1
ActiveBlock(ActivePos + 30) = 1
CASE IS = 8
'**
' **
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 11) = 1
ActiveBlock(ActivePos + 12) = 1
CASE IS = 9
' *
'**
'*
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 9) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 19) = 1
CASE IS = 10
' **
'**
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 9) = 1
ActiveBlock(ActivePos + 10) = 1
CASE IS = 11
'*
'**
' *
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 11) = 1
ActiveBlock(ActivePos + 21) = 1
CASE IS = 12
'*
'*
'**
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 20) = 1
ActiveBlock(ActivePos + 21) = 1
CASE IS = 13
'***
'*
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 2) = 1
ActiveBlock(ActivePos + 10) = 1
CASE IS = 14
'**
' *
' *
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 11) = 1
ActiveBlock(ActivePos + 21) = 1
CASE IS = 15
'  *
'***
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 8) = 1
ActiveBlock(ActivePos + 9) = 1
ActiveBlock(ActivePos + 10) = 1
CASE IS = 16
' *
' *
'**
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 19) = 1
ActiveBlock(ActivePos + 20) = 1
CASE IS = 17
'*
'***
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 11) = 1
ActiveBlock(ActivePos + 12) = 1
CASE IS = 18
'**
'*
'*
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 10) = 1
ActiveBlock(ActivePos + 20) = 1
CASE IS = 19
'***
'  *
ActiveBlock(ActivePos) = 1
ActiveBlock(ActivePos + 1) = 1
ActiveBlock(ActivePos + 2) = 1
ActiveBlock(ActivePos + 12) = 1
END SELECT
RETURN

SUB makebox (X)
SCREEN 11
IF X >= 10 THEN
    Y = INT(X / 10)
    X = X - (INT(X / 10) * 10)

ELSE
Y = 0
X = X
END IF
X = (X * 20) + 230
Y = (Y * 20) + 15

LINE (X - 10, Y - 10)-(X + 10, Y - 10)
LINE (X - 10, Y - 10)-(X - 10, Y + 10)
LINE (X - 10, Y + 10)-(X + 10, Y + 10)
LINE (X + 10, Y + 10)-(X + 10, Y - 10)
'this makes a box
'confusing as ^HELL^


PAINT (X, Y)

END SUB

