MODULE Module1
    CONST robtarget pHome:=[[1011.127973694,-14.682089851,1151.693012705],[0,1,-0.00000006,0],[-1,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !RobTarget for Grab above
    CONST robtarget pGrabBox_20:=[[1152.787235638,1368.350644952,977.194987412],[0,1,0,0],[0,0,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !GrabFine
    CONST robtarget pGrabBox_10:=[[1152.787235638,1368.350644952,728.994264642],[0,1,0,0],[0,0,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !RobTarget for Drop
    CONST robtarget pDropBox:=[[171.852547253,215.701836235,299.374835453],[0.000560976,0.707046881,0.707166231,0.000560881],[-1,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !Internal counters
    VAR num nBoxDrop:=0;
    VAR num nBoxDropInRoW:=0;
    VAR num nActRoW:=0;
    VAR num nActLayer:=0;
    !Dimensions of box + space between boxes
    CONST num nBoxSizeX:=300+30;
    CONST num nBoxSizeY:=300+30;
    CONST num nBoxSizeZ:=300+30;
    !Variables for calculating offsets
    VAR num nActBoxZOff:=0;
    VAR num nActBoxXOff:=0;
    VAR num nActBoxYOff:=0;
    !Settings
    CONST num nBoxInRoW:=3;
    CONST num nRowsInLayer:=2;

    PROC main()
        WHILE TRUE DO
            rHome;
            rSpawnNewBox;
            rGetBox;
            rCalcPos;
            rPlaceBox;
            rCounter;
        ENDWHILE
    ENDPROC

    PROC rGetBox()
        MoveL pGrabBox_20,v1000,fine,tool0\WObj:=wobj0;
        WaitDI BoxInPos,1;
        MoveL pGrabBox_10,v100,fine,tool0\WObj:=wobj0;
        Set Gripper;
        WaitTime\InPos,1;
        MoveL pGrabBox_20,v100,fine,tool0\WObj:=wobj0;
        MoveJ pHome,v1000,z100,tool0\WObj:=wobj0;
    ENDPROC

    PROC rHome()
        MoveJ pHome,v1000,z100,tool0\WObj:=wobj0;
    ENDPROC

    PROC rSpawnNewBox()
        Reset SpawnBox;
        Set SpawnBox;
    ENDPROC

    PROC rCalcPos()
        IF nBoxDropInRoW=nBoxInRoW THEN
            nBoxDropInRoW:=0;
            Incr nActRoW;
        ENDIF
        IF nActRoW>=nRowsInLayer THEN
            Incr nActLayer;
            nActBoxZOff:=nActLayer*nBoxSizeZ;
            nActRoW:=0;
        ENDIF
        nActBoxXOff:=fCalcPosX();
        nActBoxYOff:=fCalcPosY();
    ENDPROC

    PROC rPlaceBox()
        MoveJ Offs(pDropBox,0+nActBoxXOff,0+nActBoxYOff,400+nActBoxZOff),v1000,fine,tool0\WObj:=wPaleta;
        MoveL Offs(pDropBox,0+nActBoxXOff,0+nActBoxYOff,0+nActBoxZOff),v100,fine,tool0\WObj:=wPaleta;
        Reset Gripper;
        WaitTime\InPos,1;
        MoveJ Offs(pDropBox,0+nActBoxXOff,0+nActBoxYOff,400+nActBoxZOff),v100,fine,tool0\WObj:=wPaleta;
    ENDPROC

    FUNC num fCalcPosX()
        VAR num value:=0;
        value:=nActRoW*nBoxSizeX;
        RETURN value;
    ENDFUNC

    FUNC num fCalcPosY()
        VAR num value:=0;
        value:=nBoxDropInRoW*nBoxSizeY;
        RETURN value;
    ENDFUNC

    PROC rCounter()
        Incr nBoxDrop;
        Incr nBoxDropInRoW;
    ENDPROC

ENDMODULE
