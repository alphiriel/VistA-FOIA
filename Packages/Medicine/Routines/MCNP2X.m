MCNP2X ;HIRMFO/DAD-NEW PERSON CONVERSION FILE XREF ;5/8/96  09:17
 ;;2.3;Medicine;;09/13/1996
 ;
XREF(MCD0,MCX,MCPIECE,MCACTION) ; *** AA/AB Xref set / kill logic
 ;  MCD0    = file (#690.99) IEN
 ;  MCX    = The value of the field
 ;  MCPIECE = The piece position of the field
 ;  MCACTION = Xref action (S - Set, K - Kill)
 ;
 N MCZERO,MCFIL,MCFLD,MCSUB,MCIEN
 S MCZERO=$G(^MCAR(690.99,+MCD0,0))
 S MCFIL=$S(MCPIECE=4:MCX,1:$P(MCZERO,U,4))
 S MCFLD=$S(MCPIECE=3:MCX,1:$P(MCZERO,U,3))
 S MCSUB=$S(MCPIECE=2:MCX,1:$P(MCZERO,U,2))
 S MCIEN=$S(MCPIECE=1:MCX,1:$P(MCZERO,U,1))
 I (MCFIL="")!(MCFLD="")!(MCIEN="") Q
 I MCFIL=700,MCFLD=21 D
 . I MCSUB="" Q
 . I MCACTION="S" D
 .. S ^MCAR(690.99,"AB",MCFIL,MCFLD,MCIEN,MCSUB,MCD0)=""
 .. Q
 . I MCACTION="K" D
 .. K ^MCAR(690.99,"AB",MCFIL,MCFLD,MCIEN,MCSUB,MCD0)
 .. Q
 . Q
 E  D
 . I MCACTION="S" D
 .. S ^MCAR(690.99,"AA",MCFIL,MCFLD,MCIEN,MCD0)=""
 .. Q
 . I MCACTION="K" D
 .. K ^MCAR(690.99,"AA",MCFIL,MCFLD,MCIEN,MCD0)
 .. Q
 . Q
 Q
