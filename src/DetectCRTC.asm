
;; CRTC 5 (CRTC6345) detection by Cheshirecat https://thecheshirec.at/2024/05/07/un-crtc6345-sur-amstrad-cpc/
;; With the help of the compendium by LongShot https://shaker.logonsystem.eu/
;; PPI detection code by Rhino
;; Code adaptation by Lordheavy
; Detect CRTC type
; Output
; a = CRTC type (0,1,2,3,4,5)
GetCRTCType:
    ld    bc,#bc00+12   ; select register 12 (Display Start Address)
    out   (c),c
    ld    bc,#bd00+52   ; write value %0110100 (#C000/16kB)
    out   (c),c
    ld    bc,#bf00      ; read register 12 
    in    a,(c)
    cp    0
    jr    z,@CRTC_1_2   ; A null value is always returned on CRTC 1 and 2

    ; CRTC 0, 3, 4 or 5

    ld    bc,#bc00+52   ; select register 52 (means 12 on CRTC 3/4,20 on CRTC 0, 52 on CRTC 5)
    out   (c),c
    ld    bc,#bf00      ; read register 52 
    in    a,(c)
    cp    52
    jr    z,@CRTC_3_4   ; is only readable on CRTC 3 and 4, registers 20 or 52 return 0

    ; CRTC 0 or 5
  
    ld    bc,#bc00+44   ; select register 44 (means 12 on CRTC 0, 44 on CRTC 5)
    out   (c),c
    ld    bc,#bf00      ; read register 44 
    in    a,(c)
    cp    52            ; is only readable on CRTC 0, register 44 returns 0
    jr    z,@CRTC_0

    ; CRTC 5

    ld    a,5
    ret
    
    ; CRTC 0
@CRTC_0
    xor   a
    ret

    ; CRTC 1 or 2
@CRTC_1_2
    ld    bc,#bc00+31   ; select register 31 - only readable on CRTC 1
    out   (c),c
    ld    bc,#bf00      ; read register 31 
    in    a,(c)
    cp    0
    jr    nz,@CRTC_1
    
    ; CRTC 2

    ld    a,2
    ret

    ; CRTC 1
@CRTC_1
    ld    a,1       
    ret

    ; CRTC 3 or 4

@CRTC_3_4
    ld    bc,#f782
    out   (c),c
    dec   b
    ld    a,#0f
    out   (c),a
    inc   b
    out   (c),c
    dec   b
    in    c,(c)
    cp    c
    jr    nz,@CRTC_4

    ; CRTC 3

@CRTC_3
    ld    a,3
    ret

    ; CRTC 4

@CRTC_4
    ld    a,4
    ret
