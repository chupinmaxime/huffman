input metaobj;

vardef newArbre@#(expr v)=
% premier sous arbre
newBox.noeud1("0.14");
newBox.aa("a");
newBox.bb("b");
newTree.arbre1(noeud1)(aa,bb);
%arbre1.c=origin;
%drawObj(arbre1);
%ncarcbox(aa)(bb);
duplicateObj(@#,arbre1);
enddef;

beginfig(0);
newArbre.testA("");
testA.c=origin;
drawObj(testA);
% je veux tracer la boite qui contient l'équivalent des boites aa et bb pour
% arbre2 
%ncarcbox(aa)(bb);

endfig;
end.
