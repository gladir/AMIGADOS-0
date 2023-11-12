{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2022
  @website(https://www.gladir.com/amigados-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program LIST;

Uses DOS;

Const
 Mon:Array[1..12]of String[3]=('Jan','Fev','Mar','Avr','Mai','Jui',
                               'Jul','Aou','Sep','Oct','Nov','Dec');
Var
 Option:Set of (QUICK);
 I:Integer;
 Info:SearchRec;
 Path:String;
 T:DateTime;
 NumFiles,NumDirectories:LongInt;

Function PadRight(S:String;Space:Byte):String;
Var
 I:Byte;
Begin
 If Length(S)<Space Then For I:=Length(S)+1 to Space do S:=S+' ';
 PadRight:=S;
End;

Function PadZeroLeft(Value:Integer;Space:Byte):String;
Var
 S:String;
Begin
 Str(Value,S);
 While Length(S)<Space do S:='0'+S;
 PadZeroLeft:=S;
End;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

Function IntToStr(I:Integer):String;
Var
 S:String;
Begin
 Str(I,S);
 IntToStr:=S;
End;

Function IntToStrPad(I,Pad:Integer):String;
Var
 S:String;
Begin
 Str(I:Pad,S);
 IntToStrPad:=S;
End;

Function Path2Ext(Const Path:String):String;
Var
 D:DirStr;
 N:NameStr;
 E:ExtStr;
Begin
 FSplit(Path,D,N,E);
 Path2Ext:=E;
End;


BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')Then Begin
  WriteLn('LIST : Cette commande permet d''afficher les fichiers d''un r‚pertoire.');
  WriteLn;
  WriteLn('Syntaxe : LIST [-l] [-s] [-t] [<repertoire>]');
 End
  Else
 Begin
  NumFiles:=0;
  NumDirectories:=0;
  Option:=[];
  Path:='*.*';
  I:=1;
  While I<10 do Begin
   If ParamStr(I)=''Then Break Else
   If StrToUpper(ParamStr(I))='QUICK'Then Include(Option,Quick)
                                     Else Path:=ParamStr(I);
   Inc(I);
  End;
  FindFirst(Path,AnyFile,Info);
  While DosError=0 do Begin
   If Not((Info.Name='.')or(Info.Name='..'))Then Begin
    If(Info.Attr and Directory=Directory)Then Inc(NumDirectories)
                                         Else Inc(NumFiles);
    Write(PadRight(Info.Name,40));
    If Not((Quick)in(Option))Then Begin
     If(Info.Attr and Directory=Directory)Then Begin
      Write('Dir'+'       '+' ');
     End
      Else
     Write(IntToStrPad((Info.Size shr 9)+Byte((Info.Size and$1FF)>0),10)+' ');
     Write('----r');
     If(Info.Attr and ReadOnly=ReadOnly)Then Write('-')
                                        Else Write('w');
     If Path2Ext(Info.Name)='.EXE'Then Write('e')
                                  Else Write('-');
     If(Info.Attr and Directory=Directory)Then Write('d')
                                          Else Write('-');
     Write(' ');
     UnpackTime(Info.Time,T);
     Write(' '+IntToStrPad(T.Day,2)+'-'+Mon[T.Month]+'-'+
           Copy(PadZeroLeft(T.Year,2),3,2));
     Write(' '+IntToStrPad(T.Hour,2)+':'+PadZeroLeft(T.Min,2)+' ');
    End;
    WriteLn('');
   End;
   FindNext(Info);
  End;
  WriteLn(IntToStr(NumFiles)+' fichiers - '+
          IntToStr(NumDirectories)+' r‚pertoires');
 End;
END.