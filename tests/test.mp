input huffman;

string charList[];
numeric frequency[];
%show_bits:=false;
%show_node_values:=false;
%show_leaf_values:=false;
%set_node_size(8pt);
beginfig(1);
charList[4]:="s_1"; frequency[4]:=0.04;
charList[5]:="s_2"; frequency[5]:=0.05;
charList[3]:="s_3"; frequency[3]:=0.06;
charList[1]:="s_4"; frequency[1]:=0.07;
charList[2]:="s_5"; frequency[2]:=0.1;
charList[6]:="s_6"; frequency[6]:=0.1;
charList[7]:="s_7"; frequency[7]:=0.18;
charList[8]:="s_8"; frequency[8]:=0.4;
newBinHuffman.myHuff(8)(charList,frequency)  "hbsep(.6cm)", "treeflip(false)", "hideleaves(true)","framed(true)";
myHuff.c=origin;
drawObj(myHuff);
endfig;
end
