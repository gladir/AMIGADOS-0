{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2022
  @website(https://www.gladir.com/amigados-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program DIR;

Uses DOS;

Var
 P:Byte;
 Info:SearchRec;
 T:DateTime;
 CurrParam,ShowDir:String;

Function PadRight(S:String;Space:Byte):String;
Var
 I:Byte;
Begin
 If Length(S)<Space Then For I:=Length(S)+1 to Space do S:=S+' ';
 PadRight:=S;
End;

BEGIN
 P:=0;
 ShowDir:='*.*';
 Repeat
  Inc(P);
  CurrParam:=ParamStr(P);
  If Length(CurrParam)=0Then Break;
  If CurrParam='/?'Then Begin
   WriteLn('DIR   Cette commande permet d''afficher le contenu d''un repertoire dans l''unite de disque.');
   WriteLn;
   WriteLn('Syntaxe:');
   WriteLn;
   WriteLn('DIR [/?] [nom]');
   WriteLn;
   WriteLn(' /?   Ce parametre permet d''afficher l''aide sur cette commande');
   Exit;
  End
   Else
  ShowDir:=CurrParam;
  If P>99Then Break;
 Until CurrParam='';
 P:=0;
 FindFirst(ShowDir,AnyFile,Info);
 While DOSError=0 do Begin
  If(Info.Attr and Directory=Directory)Then Begin
   If(Info.Name<>'..')and(Info.Name<>'.')Then Begin
    Write(' '+' '+' '+' '+' '+PadRight(Info.Name+' (dir)',35));
   End;
  End
   Else
  Write('  '+PadRight(Info.Name,38));
  FindNext(Info);
 End;
 WriteLn;
END.