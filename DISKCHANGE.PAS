{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/amigados-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program DISKCHANGE;

Var
 Letter:Char;
 CurrParam:String;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

BEGIN
 CurrParam:=ParamStr(1);
 If CurrParam='/?'Then Begin
  WriteLn('DISKCHANGE   Cette commande permet de changer l''unit‚ de disque courant.');
  WriteLn('');
  WriteLn('Syntaxe:');
  WriteLn('');
  WriteLn('DISKCHANGE [/?] [dr]');
  WriteLn('');
  WriteLn(' /?   Ce parametre permet d''afficher l''aide sur cette commande');
  WriteLn('dr    Ce paramŠtre permet d''indiquerle nouvel unit‚ de disque');
 End
  Else
 If(Length(CurrParam)=4)and(CurrParam[4]=':')Then Begin
  Letter:='@';
  If StrToUpper(CurrParam)='DF0:'Then Letter:='A' Else
  If StrToUpper(CurrParam)='DF1:'Then Letter:='B' Else
  If StrToUpper(Copy(CurrParam,1,2))='HD'Then Begin
   Letter:=Chr(Ord('C')+(Ord(UpCase(CurrParam[3]))-Ord('0')));
  End
   Else
  Begin
   WriteLn('Disque invalide !');
   Halt;
  End;
  If Letter='@'Then Begin
   WriteLn('Disque non reconnu !');
   Halt;
  End;
  {$I-}ChDir(Letter+':\');{$I+}
  If IoResult<>0 Then Begin
   WriteLn('Impossible de changer d''unit‚ de disque.');
   Halt;
  End;
 End;
END.