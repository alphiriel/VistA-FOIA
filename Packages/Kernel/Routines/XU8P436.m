XU8P436 ;SFISC/SO- SET AUSER XREF FOR HOLDERS OF XUORES KEY ;6:56 AM  11 Oct 2006
 ;;8.0;KERNEL;**436**;Jul 10, 1995;Build 2
 ;
 D MES^XPDUTL("Begin post install...")
 N IEN S IEN=0
 F  S IEN=$O(^XUSEC("XUORES",IEN)) Q:'IEN  D
 . I '$D(^VA(200,IEN,0))#2 Q
 . N NAME S NAME=$P(^VA(200,IEN,0),U)
 . S ^VA(200,"AUSER",NAME,IEN)=""
 . Q
 D MES^XPDUTL("Finished post install.")
 Q