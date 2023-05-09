input metaobj;
if not known mplib: input latexmp fi;
input format; % pour avoir la fonction roundd(x,d)

show_empty_boxes:=true;

% variable globale pour numéroter les instances des arbres
% pour pouvoir appeler plusieurs fois le Huffman
_huffmanTreeNbr:=0;

def get_huffmanTreeNbr=
    _huffmanTreeNbr
enddef;

% taille des nœuds
_node_size:=13pt;
def set_node_size(expr c)=
    _node_size:=c;
enddef;

% les couleurs 
color _huffmanLeaf,_huffmanBit;
_huffmanLeaf:=(0.95,0.6,0.6);
_huffmanBit:=(0.7,0.1,0.1);

def set_leaf_color(expr c)=
    _huffmanLeaf:=c;
enddef;

def set_bit_color(expr c)=
    _huffmanBit:=c;
enddef;

boolean show_bits;
show_bits:=true;

boolean show_node_values;
show_node_values:=true;

boolean show_leaf_values;
show_leaf_values:=true;

% style d’une feuille caractère et proba
vardef newHuffmanLeaf@#(expr ch)(expr v) text options=
    % @# est l’identifiant de la feuille
    % c est le caractère considéré (ou la chaine)
    % v est la proba ou l’entier associé
    picture _text_v,_text_token;
    % on calcule le height max des deux écritures pour faire deux boites de même
    % hauteur 
    _text_v := textext(v);
    _text_token := textext("$"&ch&"$");
    _height_v := abs((ulcorner _text_v) - (llcorner _text_v));
    _width_v := abs(urcorner _text_v - ulcorner _text_v);
    _height_token := abs(ulcorner _text_token - llcorner _text_token);
    _width_token := abs(urcorner _text_token - ulcorner _text_token);
    _height_max := max(_height_token,_height_v);
    % on fabrique deux boîtes vides aux bonne dimensions
    % et on ajoute un label au centre de celles-ci 
    if(show_leaf_values):    
        newEmptyBox.scantokens(str @# & "ch1")(_width_token+4,2_height_max)
        "framed(true)","fillcolor(_huffmanLeaf)", "filled(true)", options;
        ObjLabel.Obj(scantokens(str @# & "ch1"))(textext("$" & ch & "$"));
        newEmptyBox.scantokens(str @# & "ch2")(_width_v+4,2_height_max)
        "framed(true)", options;
        ObjLabel.Obj(scantokens(str @# & "ch2"))(textext(v));
        % on fixe relativement les coordonnées des deux boites pour qu’elles se % touchent 
        scantokens(str @# & "ch1").e=scantokens(str @# & "ch2").w;
        % on fabrique un container qui les regroupes et qui sera la feuille
        newContainer.@#(scantokens(str @# & "ch1"),scantokens(str @# & "ch2"));
    else:
        newBox.@#(textext("$" & ch & "$"))
        "framed(true)","fillcolor(_huffmanLeaf)", "filled(true)", options;
    fi
enddef;

% style de l’arbre binaire de Huffman
vardef newHuffmanBinTree@#(suffix theroot)(text subtrees) text options=
    % un simple arbre
    newTree.@#(theroot)(subtrees) "Dalign(top)" , "hbsep(0.3cm)",options;
    if(show_bits):
        % et on met 0 et 1 sur ses deux connections
        ObjLabel.Obj(@#)(btex 0 etex)
        "labpathid(1)", "laberase(true)", "labcolor(_huffmanBit)";
        ObjLabel.Obj(@#)(btex 1 etex)
        "labpathid(2)", "laberase(true)", "labcolor(_huffmanBit)";
    fi
enddef;

% style d’un nœud interne (non feuille) de l’arbre 
vardef newHuffmanNode@#(expr v) text options=
    newCircle.@#("") "circmargin(_node_size)",options;
    if(show_node_values):
    ObjLabel.Obj(scantokens(str @#))(textext(v));
    fi
enddef;


% fonction de tri à bulle d’un tableau
vardef _sorttab(expr nbr)(suffix tab,chartab)=
    string _tempchar;
    for i:=nbr downto 1:
        for j:=1 upto i-1:
            if(tab[j+1]<tab[j]):
                _temptab:=tab[j+1];
                tab[j+1]:=tab[j];
                tab[j]:=_temptab;
                _tempchar:=chartab[j+1];
                chartab[j+1]:=chartab[j];
                chartab[j]:=_tempchar;
            fi
        endfor;
    endfor;
enddef;

% le constructeur d’un objet Tree du code de Hufmann
vardef newBinHuffman@#(expr nbr)(suffix ch, fr) text options=
    % nbr : taille des tableaux
    % ch : tableau des symboles à coder (string)
    % fr : tableau des valeurs associées (numeric)
    _huffmanTreeNbr:=_huffmanTreeNbr+1;
    save _frtab,_chtab,_nbr;
    % on copie les tableaux 
    numeric _frtab[];
    numeric _nbr;
    _nbr:=nbr;
    string _chtab[];
    for i:=1 upto nbr:
        _frtab[i]:=fr[i];
        _chtab[i]:=ch[i];
    endfor;
    % on va numéroter les nœuds fabriqués
    _nbrnode:=1;
    % on numérote les feuilles
    _nbrleaf:=0;
    forever: 
        % on sort s’il n’y a plus qu’un seul élément
        exitif(_nbr=1);
        % on trie pour avoir les deux plus petits en première et deuxième positions
        _sorttab(_nbr,_frtab,_chtab);
        for i:=1 upto nbr-1:
            % on teste les 4 cas possibles sur les deux premiers éléments
            % (symbole, symbole), (symbole, sousarbre), (sousarbre, symbole)
            % et (sousarbre,sousarbre)
            if(i=1):
                
                if(substring (0,1) of _chtab[1]<>"T"): %(symbole,*)
                    % on fabrique la feuille
                    _nbrleaf:=_nbrleaf+1;
                    newHuffmanLeaf.scantokens("leaf"&decimal
                    _nbrleaf&"_"&decimal _huffmanTreeNbr)(_chtab[1])(decimal
                    roundd(_frtab[1],2));
                    if(substring (0,1) of _chtab[2]<>"T"): %(symbole, symbole)
                        % on fabrique la feuille
                        _nbrleaf:=_nbrleaf+1;
                        newHuffmanLeaf.scantokens("leaf"&decimal
                        _nbrleaf&"_"&decimal _huffmanTreeNbr)(_chtab[2])(decimal
                        roundd(_frtab[2],2));
                        % on fabrique le nœud qui et l’arbre qui a les deux
                        % feuilles en descendants
                        _tmpsum:=_frtab[1]+_frtab[2];
                        newHuffmanNode.scantokens("node"&decimal
                        _nbrnode&"_"&decimal _huffmanTreeNbr)(decimal
                        roundd(_tmpsum,2));
                        if(_nbr=2): % dernier arbre, on nomme avec @#
                            newHuffmanBinTree@#(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens("leaf"&decimal(
                            _nbrleaf-1)&"_"&decimal
                            _huffmanTreeNbr),scantokens("leaf"&decimal(
                            _nbrleaf)&"_"&decimal
                            _huffmanTreeNbr)) options;
                        else:
                            newHuffmanBinTree.scantokens("Tree"&decimal
                            _nbrnode&"_"&decimal _huffmanTreeNbr)(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens("leaf"&decimal(
                            _nbrleaf-1)&"_"&decimal
                            _huffmanTreeNbr),scantokens("leaf"&decimal(
                            _nbrleaf)&"_"&decimal
                            _huffmanTreeNbr)) options;
                        fi                    
                    else:   %(symbole, sousarbre)
                        _tmpsum:=_frtab[1]+_frtab[2];
                        newHuffmanNode.scantokens("node"&decimal
                        _nbrnode&"_"&decimal _huffmanTreeNbr)(decimal
                        roundd(_tmpsum,2));
                        if(_nbr=2): % dernier arbre, on nomme avec @#
                            newHuffmanBinTree@#(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens("leaf"&decimal(
                            _nbrleaf)&"_"&decimal
                            _huffmanTreeNbr),scantokens(_chtab[2])) options;
                        else:
                            newHuffmanBinTree.scantokens("Tree"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr)(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens("leaf"&decimal(
                            _nbrleaf)&"_"&decimal
                            _huffmanTreeNbr),scantokens(_chtab[2])) options;
                        fi
                    fi
                else: %(sousarber,*)
                    if(substring (0,1) of _chtab[2]<>"T"): %(sousarbre,symbole)
                        _nbrleaf:=_nbrleaf+1;
                        newHuffmanLeaf.scantokens("leaf"&decimal(
                        _nbrleaf)&"_"&decimal
                        _huffmanTreeNbr)(_chtab[2])(decimal
                        roundd(_frtab[2],2));
                        _tmpsum:=_frtab[1]+_frtab[2];
                        newHuffmanNode.scantokens("node"&decimal _nbrnode&"_"&decimal _huffmanTreeNbr)(decimal
                        roundd(_tmpsum,2));
                        if(_nbr=2): % dernier arbre, on nomme avec @#
                            newHuffmanBinTree@#(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens(_chtab[1]),scantokens("leaf"&decimal(
                            _nbrleaf)&"_"&decimal
                            _huffmanTreeNbr)) options;
                        else:
                            newHuffmanBinTree.scantokens("Tree"&decimal
                            _nbrnode&"_"&decimal _huffmanTreeNbr)(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens(_chtab[1]),scantokens("leaf"&decimal(
                            _nbrleaf)&"_"&decimal
                            _huffmanTreeNbr)) options;
                        fi    
                    else:   % (sousarbre, sousarbre)
                        _tmpsum:=_frtab[1]+_frtab[2];
                        newHuffmanNode.scantokens("node"&decimal _nbrnode&"_"&decimal _huffmanTreeNbr)(decimal roundd(_tmpsum,2));
                        if(_nbr=2): % dernier arbre, on nomme avec @#
                            newHuffmanBinTree@#(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens(_chtab[1]),scantokens(_chtab[2]))
                            options;
                        else:
                            newHuffmanBinTree.scantokens("Tree"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr)(scantokens("node"&decimal
                            _nbrnode&"_"&decimal
                            _huffmanTreeNbr))(scantokens(_chtab[1]),scantokens(_chtab[2]))
                            options;
                        fi
                    fi
                fi
                % on indique dans la première case le nom de l’arbre créé
                _chtab[1]:="Tree"&decimal _nbrnode&"_"&decimal _huffmanTreeNbr;
                % et sa valeur
                _frtab[1]:=_frtab[1]+_frtab[2];
                _nbrnode:=_nbrnode+1;
            else:
                % on décale toutes les autres cases d’un vers la gauche
                _chtab[i]:=_chtab[i+1];
                _frtab[i]:=_frtab[i+1];
            fi
        endfor
        _nbr:=_nbr-1;    
    endfor;
    % on dublique l’objet en prenant comme nom ce qui est donné à l’utilisation
    % de newHuffman 
    %duplicateObj(@#,scantokens("Tree"&decimal(_nbrnode-1)&"_"&decimal
    %_huffmanTreeNbr));
enddef;




