###################################################################################
#
#    This file was generated using Parse::Eyapp version 1.06.
#
# (c) Parse::Yapp Copyright 1998-2001 Francois Desarmenien.
# (c) Parse::Eyapp Copyright 2006 Casiano Rodriguez-Leon. Universidad de La Laguna.
#        Don't edit this file, use source file "SC.yp" instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
###################################################################################
package SC;
use strict;
use base qw ( Parse::Eyapp::Driver );
use Parse::Eyapp::Node;



#line 1 "SC.yp"

use IO::File;
use Data::Dumper;
use Carp;
our $reserved = {INT => "int", LONG => "long", IF => "if", ELSE => "else", BREAK => "break", CONTINUE => "continue",
		 STRUCT => "struct", RETURN => "return", WHILE => "while"};

our $lexema = {'='=> "ASSIGN", '==' => "EQUAL", '+=' => "PLUSEQUAL", '-=' => "MINUSEQUAL", '*=' => "TIMESEQUAL",
	 	'/=' => "DIVEQUAL", '%=' => "MODEQUAL", '|' => "OR", '&' => "AND", '!=' => "NOTEQUAL", '<' => "LESS",
		'>' => "GREATER", '<=' => "LESSEQUAL", '>=' => "GREATEREQUAL", '+' => "PLUS", '-' => "MINUS",
		'*' => "TIMES", '/' => "DIV", '%' => "MOD", '++' => "INC", '--' => "DEC", '{' => "LEFTKEY",
		'}' => "RIGHTKEY", ',' => "COMMA", ';' => "SEMICOLON", '(' => "LEFTPARENTHESIS", ')' => "RIGHTPARENTHESIS",
		'[' => "LEFTBRAQUET", ']' => "RIGHTBRAQUET",'**' => "EXP"};




sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.06',
                                  yyGRAMMAR  =>
[
  [ _SUPERSTART => '$start', [ 'program', '$end' ] ],
  [ program_1 => 'program', [ 'definitions' ] ],
  [ definitions_2 => 'definitions', [ 'definition' ] ],
  [ definitions_3 => 'definitions', [ 'definitions', 'definition' ] ],
  [ definitions_4 => 'definitions', [ 'error' ] ],
  [ definitions_5 => 'definitions', [ 'definitions', 'error' ] ],
  [ definition_6 => 'definition', [ 'funcDef' ] ],
  [ definition_7 => 'definition', [ 'type', 'funcDef' ] ],
  [ definition_8 => 'definition', [ 'declaration' ] ],
  [ type_9 => 'type', [ 'StructType' ] ],
  [ type_10 => 'type', [ 'SimpleType' ] ],
  [ StructType_11 => 'StructType', [ 'STRUCT', '{', 'FieldDefPart', '}' ] ],
  [ SimpleType_12 => 'SimpleType', [ 'INT' ] ],
  [ SimpleType_13 => 'SimpleType', [ 'LONG' ] ],
  [ FieldDefPart_14 => 'FieldDefPart', [  ] ],
  [ FieldDefPart_15 => 'FieldDefPart', [ 'FieldDef' ] ],
  [ FieldDef_16 => 'FieldDef', [ 'type', 'FieldList', ';' ] ],
  [ FieldDef_17 => 'FieldDef', [ 'FieldDef', 'type', 'FieldList' ] ],
  [ FieldList_18 => 'FieldList', [ 'Field' ] ],
  [ FieldList_19 => 'FieldList', [ 'FieldList', ',', 'Field' ] ],
  [ Field_20 => 'Field', [ 'ID', 'arrayPart' ] ],
  [ funcDef_21 => 'funcDef', [ 'ID', '(', 'opParList', ')', 'paramDecls', 'compStat' ] ],
  [ opParList_22 => 'opParList', [  ] ],
  [ opParList_23 => 'opParList', [ 'paramList' ] ],
  [ paramList_24 => 'paramList', [ 'ID' ] ],
  [ paramList_25 => 'paramList', [ 'ID', ',', 'paramList' ] ],
  [ paramList_26 => 'paramList', [ 'error' ] ],
  [ paramList_27 => 'paramList', [ 'error', 'paramList' ] ],
  [ paramList_28 => 'paramList', [ 'ID', 'error', 'paramList' ] ],
  [ paramList_29 => 'paramList', [ 'error', ',', 'paramList' ] ],
  [ paramDecls_30 => 'paramDecls', [  ] ],
  [ paramDecls_31 => 'paramDecls', [ 'paramDecls', 'paramDecl' ] ],
  [ paramDecls_32 => 'paramDecls', [ 'paramDecls', 'error' ] ],
  [ paramDecl_33 => 'paramDecl', [ 'type', 'paramDeclList', ';' ] ],
  [ paramDeclList_34 => 'paramDeclList', [ 'ID' ] ],
  [ paramDeclList_35 => 'paramDeclList', [ 'paramDeclList', ',', 'ID' ] ],
  [ paramDeclList_36 => 'paramDeclList', [ 'error' ] ],
  [ paramDeclList_37 => 'paramDeclList', [ 'paramDeclList', 'error' ] ],
  [ paramDeclList_38 => 'paramDeclList', [ 'paramDeclList', 'error', 'ID' ] ],
  [ paramDeclList_39 => 'paramDeclList', [ 'paramDeclList', ',', 'error' ] ],
  [ compStat_40 => 'compStat', [ '{', 'declarations', 'statements', '}' ] ],
  [ declarations_41 => 'declarations', [  ] ],
  [ declarations_42 => 'declarations', [ 'declarations', 'declaration' ] ],
  [ declaration_43 => 'declaration', [ 'type', 'declList', ';' ] ],
  [ declList_44 => 'declList', [ 'ID', 'arrayPart' ] ],
  [ declList_45 => 'declList', [ 'declList', ',', 'ID', 'arrayPart' ] ],
  [ arrayPart_46 => 'arrayPart', [  ] ],
  [ arrayPart_47 => 'arrayPart', [ 'arrayList' ] ],
  [ arrayList_48 => 'arrayList', [ '[', 'ICONST', ']' ] ],
  [ arrayList_49 => 'arrayList', [ 'arrayList', '[', 'ICONST', ']' ] ],
  [ statements_50 => 'statements', [  ] ],
  [ statements_51 => 'statements', [ 'statement', 'statements' ] ],
  [ statement_52 => 'statement', [ 'expression', ';' ] ],
  [ statement_53 => 'statement', [ ';' ] ],
  [ statement_54 => 'statement', [ 'BREAK', ';' ] ],
  [ statement_55 => 'statement', [ 'CONTINUE', ';' ] ],
  [ statement_56 => 'statement', [ 'RETURN', ';' ] ],
  [ statement_57 => 'statement', [ 'RETURN', 'expression', ';' ] ],
  [ statement_58 => 'statement', [ 'compStat' ] ],
  [ statement_59 => 'statement', [ 'ifPrefix', 'statement' ] ],
  [ statement_60 => 'statement', [ 'ifPrefix', 'statement', 'ELSE', 'statement' ] ],
  [ statement_61 => 'statement', [ 'loopPrefix', 'statement' ] ],
  [ ifPrefix_62 => 'ifPrefix', [ 'IF', '(', 'expression', ')' ] ],
  [ ifPrefix_63 => 'ifPrefix', [ 'IF', 'error' ] ],
  [ loopPrefix_64 => 'loopPrefix', [ 'WHILE', '(', 'expression', ')' ] ],
  [ loopPrefix_65 => 'loopPrefix', [ 'WHILE', 'error' ] ],
  [ expression_66 => 'expression', [ 'binary' ] ],
  [ expression_67 => 'expression', [ 'expression', ',', 'binary' ] ],
  [ expression_68 => 'expression', [ 'error', ',', 'binary' ] ],
  [ expression_69 => 'expression', [ 'expression', 'error' ] ],
  [ expression_70 => 'expression', [ 'expression', ',', 'error' ] ],
  [ Variable_71 => 'Variable', [ 'Vararray' ] ],
  [ Variable_72 => 'Variable', [ 'Varstruct' ] ],
  [ Vararray_73 => 'Vararray', [ 'ID' ] ],
  [ Vararray_74 => 'Vararray', [ 'ID', 'accessList' ] ],
  [ Varstruct_75 => 'Varstruct', [ 'ID', 'fieldaccess' ] ],
  [ accessList_76 => 'accessList', [ '[', 'binary', ']' ] ],
  [ accessList_77 => 'accessList', [ 'accessList', '[', 'binary', ']' ] ],
  [ fieldaccess_78 => 'fieldaccess', [ 'fieldaccess', '.', 'Vararray' ] ],
  [ fieldaccess_79 => 'fieldaccess', [ '.', 'Vararray' ] ],
  [ Primary_80 => 'Primary', [ 'ICONST' ] ],
  [ Primary_81 => 'Primary', [ 'LCONST' ] ],
  [ Primary_82 => 'Primary', [ '(', 'expression', ')' ] ],
  [ Primary_83 => 'Primary', [ '(', 'error', ')' ] ],
  [ Primary_84 => 'Primary', [ 'ID', '(', 'opArgList', ')' ] ],
  [ Unary_85 => 'Unary', [ '++', 'Variable' ] ],
  [ Unary_86 => 'Unary', [ '--', 'Variable' ] ],
  [ Unary_87 => 'Unary', [ 'Primary' ] ],
  [ binary_88 => 'binary', [ 'Unary' ] ],
  [ binary_89 => 'binary', [ 'binary', '+', 'binary' ] ],
  [ binary_90 => 'binary', [ 'binary', '-', 'binary' ] ],
  [ binary_91 => 'binary', [ 'binary', '*', 'binary' ] ],
  [ binary_92 => 'binary', [ 'binary', '/', 'binary' ] ],
  [ binary_93 => 'binary', [ 'binary', '%', 'binary' ] ],
  [ binary_94 => 'binary', [ 'binary', '<', 'binary' ] ],
  [ binary_95 => 'binary', [ 'binary', '>', 'binary' ] ],
  [ binary_96 => 'binary', [ 'binary', '>=', 'binary' ] ],
  [ binary_97 => 'binary', [ 'binary', '<=', 'binary' ] ],
  [ binary_98 => 'binary', [ 'binary', '==', 'binary' ] ],
  [ binary_99 => 'binary', [ 'binary', '=', 'binary' ] ],
  [ binary_100 => 'binary', [ 'binary', '!=', 'binary' ] ],
  [ binary_101 => 'binary', [ 'binary', '&', 'binary' ] ],
  [ binary_102 => 'binary', [ 'binary', '**', 'binary' ] ],
  [ binary_103 => 'binary', [ 'binary', '|', 'binary' ] ],
  [ binary_104 => 'binary', [ 'Variable', '=', 'binary' ] ],
  [ binary_105 => 'binary', [ 'Variable', '+=', 'binary' ] ],
  [ binary_106 => 'binary', [ 'Variable', '-=', 'binary' ] ],
  [ binary_107 => 'binary', [ 'Variable', '*=', 'binary' ] ],
  [ binary_108 => 'binary', [ 'Variable', '/=', 'binary' ] ],
  [ binary_109 => 'binary', [ 'Variable', '%=', 'binary' ] ],
  [ opArgList_110 => 'opArgList', [  ] ],
  [ opArgList_111 => 'opArgList', [ 'argList' ] ],
  [ argList_112 => 'argList', [ 'binary' ] ],
  [ argList_113 => 'argList', [ 'argList', ',', 'binary' ] ],
  [ argList_114 => 'argList', [ 'error' ] ],
  [ argList_115 => 'argList', [ 'argList', 'error' ] ],
  [ argList_116 => 'argList', [ 'argList', ',', 'error' ] ],
],
                                  yyTERMS  =>
{ '$end' => 0, '!=' => 0, '%' => 0, '%=' => 0, '&' => 0, '(' => 0, ')' => 0, '*' => 0, '**' => 0, '*=' => 0, '+' => 0, '++' => 0, '+=' => 0, ',' => 0, '-' => 0, '--' => 0, '-=' => 0, '.' => 0, '/' => 0, '/=' => 0, ';' => 0, '<' => 0, '<=' => 0, '=' => 0, '==' => 0, '>' => 0, '>=' => 0, 'ELSE' => 0, '[' => 0, ']' => 0, '{' => 0, '|' => 0, '}' => 0, BREAK => 1, CONTINUE => 1, ICONST => 1, ID => 1, IF => 1, INT => 1, LCONST => 1, LONG => 1, RETURN => 1, STRUCT => 1, WHILE => 1, error => 1 },
                                  yyFILENAME  =>
"SC.yp",
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'ID' => 1,
			'INT' => 5,
			'error' => 11,
			'STRUCT' => 6,
			'LONG' => 13
		},
		GOTOS => {
			'declaration' => 10,
			'funcDef' => 4,
			'StructType' => 3,
			'SimpleType' => 2,
			'type' => 12,
			'definitions' => 7,
			'program' => 9,
			'definition' => 8
		}
	},
	{#State 1
		ACTIONS => {
			"(" => 14
		}
	},
	{#State 2
		DEFAULT => -10
	},
	{#State 3
		DEFAULT => -9
	},
	{#State 4
		DEFAULT => -6
	},
	{#State 5
		DEFAULT => -12
	},
	{#State 6
		ACTIONS => {
			"{" => 15
		}
	},
	{#State 7
		ACTIONS => {
			'' => -1,
			'ID' => 1,
			'INT' => 5,
			'error' => 17,
			'STRUCT' => 6,
			'LONG' => 13
		},
		GOTOS => {
			'declaration' => 10,
			'funcDef' => 4,
			'StructType' => 3,
			'SimpleType' => 2,
			'type' => 12,
			'definition' => 16
		}
	},
	{#State 8
		DEFAULT => -2
	},
	{#State 9
		ACTIONS => {
			'' => 18
		}
	},
	{#State 10
		DEFAULT => -8
	},
	{#State 11
		DEFAULT => -4
	},
	{#State 12
		ACTIONS => {
			'ID' => 19
		},
		GOTOS => {
			'funcDef' => 20,
			'declList' => 21
		}
	},
	{#State 13
		DEFAULT => -13
	},
	{#State 14
		ACTIONS => {
			'ID' => 22,
			'error' => 25,
			")" => -22
		},
		GOTOS => {
			'paramList' => 23,
			'opParList' => 24
		}
	},
	{#State 15
		ACTIONS => {
			'INT' => 5,
			'STRUCT' => 6,
			'LONG' => 13
		},
		DEFAULT => -14,
		GOTOS => {
			'StructType' => 3,
			'SimpleType' => 2,
			'FieldDefPart' => 26,
			'FieldDef' => 27,
			'type' => 28
		}
	},
	{#State 16
		DEFAULT => -3
	},
	{#State 17
		DEFAULT => -5
	},
	{#State 18
		DEFAULT => 0
	},
	{#State 19
		ACTIONS => {
			"(" => 14,
			"[" => 30
		},
		DEFAULT => -46,
		GOTOS => {
			'arrayList' => 29,
			'arrayPart' => 31
		}
	},
	{#State 20
		DEFAULT => -7
	},
	{#State 21
		ACTIONS => {
			";" => 32,
			"," => 33
		}
	},
	{#State 22
		ACTIONS => {
			'error' => 35,
			"," => 34,
			")" => -24
		}
	},
	{#State 23
		DEFAULT => -23
	},
	{#State 24
		ACTIONS => {
			")" => 36
		}
	},
	{#State 25
		ACTIONS => {
			'ID' => 22,
			'error' => 25,
			"," => 38,
			")" => -26
		},
		GOTOS => {
			'paramList' => 37
		}
	},
	{#State 26
		ACTIONS => {
			"}" => 39
		}
	},
	{#State 27
		ACTIONS => {
			'INT' => 5,
			'STRUCT' => 6,
			'LONG' => 13
		},
		DEFAULT => -15,
		GOTOS => {
			'StructType' => 3,
			'SimpleType' => 2,
			'type' => 40
		}
	},
	{#State 28
		ACTIONS => {
			'ID' => 41
		},
		GOTOS => {
			'FieldList' => 43,
			'Field' => 42
		}
	},
	{#State 29
		ACTIONS => {
			"[" => 44
		},
		DEFAULT => -47
	},
	{#State 30
		ACTIONS => {
			'ICONST' => 45
		}
	},
	{#State 31
		DEFAULT => -44
	},
	{#State 32
		DEFAULT => -43
	},
	{#State 33
		ACTIONS => {
			'ID' => 46
		}
	},
	{#State 34
		ACTIONS => {
			'ID' => 22,
			'error' => 25
		},
		GOTOS => {
			'paramList' => 47
		}
	},
	{#State 35
		ACTIONS => {
			'ID' => 22,
			'error' => 25
		},
		GOTOS => {
			'paramList' => 48
		}
	},
	{#State 36
		DEFAULT => -30,
		GOTOS => {
			'paramDecls' => 49
		}
	},
	{#State 37
		DEFAULT => -27
	},
	{#State 38
		ACTIONS => {
			'ID' => 22,
			'error' => 25
		},
		GOTOS => {
			'paramList' => 50
		}
	},
	{#State 39
		DEFAULT => -11
	},
	{#State 40
		ACTIONS => {
			'ID' => 41
		},
		GOTOS => {
			'FieldList' => 51,
			'Field' => 42
		}
	},
	{#State 41
		ACTIONS => {
			"[" => 30
		},
		DEFAULT => -46,
		GOTOS => {
			'arrayList' => 29,
			'arrayPart' => 52
		}
	},
	{#State 42
		DEFAULT => -18
	},
	{#State 43
		ACTIONS => {
			";" => 53,
			"," => 54
		}
	},
	{#State 44
		ACTIONS => {
			'ICONST' => 55
		}
	},
	{#State 45
		ACTIONS => {
			"]" => 56
		}
	},
	{#State 46
		ACTIONS => {
			"[" => 30
		},
		DEFAULT => -46,
		GOTOS => {
			'arrayList' => 29,
			'arrayPart' => 57
		}
	},
	{#State 47
		DEFAULT => -25
	},
	{#State 48
		DEFAULT => -28
	},
	{#State 49
		ACTIONS => {
			'INT' => 5,
			'error' => 59,
			"{" => 58,
			'STRUCT' => 6,
			'LONG' => 13
		},
		GOTOS => {
			'StructType' => 3,
			'SimpleType' => 2,
			'paramDecl' => 60,
			'compStat' => 62,
			'type' => 61
		}
	},
	{#State 50
		DEFAULT => -29
	},
	{#State 51
		ACTIONS => {
			"," => 54
		},
		DEFAULT => -17
	},
	{#State 52
		DEFAULT => -20
	},
	{#State 53
		DEFAULT => -16
	},
	{#State 54
		ACTIONS => {
			'ID' => 41
		},
		GOTOS => {
			'Field' => 63
		}
	},
	{#State 55
		ACTIONS => {
			"]" => 64
		}
	},
	{#State 56
		DEFAULT => -48
	},
	{#State 57
		DEFAULT => -45
	},
	{#State 58
		DEFAULT => -41,
		GOTOS => {
			'declarations' => 65
		}
	},
	{#State 59
		DEFAULT => -32
	},
	{#State 60
		DEFAULT => -31
	},
	{#State 61
		ACTIONS => {
			'ID' => 66,
			'error' => 68
		},
		GOTOS => {
			'paramDeclList' => 67
		}
	},
	{#State 62
		DEFAULT => -21
	},
	{#State 63
		DEFAULT => -19
	},
	{#State 64
		DEFAULT => -49
	},
	{#State 65
		ACTIONS => {
			"}" => -50,
			'ID' => 85,
			'BREAK' => 69,
			";" => 86,
			'ICONST' => 87,
			"++" => 89,
			'RETURN' => 91,
			'IF' => 72,
			'error' => 92,
			'WHILE' => 94,
			"--" => 75,
			'LONG' => 13,
			'INT' => 5,
			"{" => 58,
			'STRUCT' => 6,
			'CONTINUE' => 79,
			"(" => 78,
			'LCONST' => 81
		},
		GOTOS => {
			'statements' => 84,
			'StructType' => 3,
			'Vararray' => 70,
			'declaration' => 88,
			'Varstruct' => 90,
			'statement' => 71,
			'expression' => 73,
			'Primary' => 74,
			'compStat' => 93,
			'SimpleType' => 2,
			'Unary' => 76,
			'binary' => 77,
			'ifPrefix' => 95,
			'loopPrefix' => 80,
			'type' => 82,
			'Variable' => 83
		}
	},
	{#State 66
		DEFAULT => -34
	},
	{#State 67
		ACTIONS => {
			";" => 96,
			'error' => 98,
			"," => 97
		}
	},
	{#State 68
		DEFAULT => -36
	},
	{#State 69
		ACTIONS => {
			";" => 99
		}
	},
	{#State 70
		DEFAULT => -71
	},
	{#State 71
		ACTIONS => {
			"}" => -50,
			'ID' => 85,
			'BREAK' => 69,
			";" => 86,
			'ICONST' => 87,
			"++" => 89,
			'RETURN' => 91,
			'IF' => 72,
			'error' => 92,
			'WHILE' => 94,
			"--" => 75,
			"{" => 58,
			'CONTINUE' => 79,
			"(" => 78,
			'LCONST' => 81
		},
		GOTOS => {
			'statements' => 100,
			'Unary' => 76,
			'binary' => 77,
			'Vararray' => 70,
			'statement' => 71,
			'Varstruct' => 90,
			'ifPrefix' => 95,
			'expression' => 73,
			'Primary' => 74,
			'loopPrefix' => 80,
			'compStat' => 93,
			'Variable' => 83
		}
	},
	{#State 72
		ACTIONS => {
			"(" => 101,
			'error' => 102
		}
	},
	{#State 73
		ACTIONS => {
			";" => 103,
			'error' => 105,
			"," => 104
		}
	},
	{#State 74
		DEFAULT => -87
	},
	{#State 75
		ACTIONS => {
			'ID' => 107
		},
		GOTOS => {
			'Varstruct' => 90,
			'Vararray' => 70,
			'Variable' => 106
		}
	},
	{#State 76
		DEFAULT => -88
	},
	{#State 77
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -66
	},
	{#State 78
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'error' => 124,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'expression' => 123,
			'binary' => 77,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 79
		ACTIONS => {
			";" => 125
		}
	},
	{#State 80
		ACTIONS => {
			'ID' => 85,
			'BREAK' => 69,
			";" => 86,
			"{" => 58,
			'ICONST' => 87,
			"++" => 89,
			"(" => 78,
			'CONTINUE' => 79,
			'RETURN' => 91,
			'IF' => 72,
			'error' => 92,
			'LCONST' => 81,
			'WHILE' => 94,
			"--" => 75
		},
		GOTOS => {
			'Unary' => 76,
			'binary' => 77,
			'Vararray' => 70,
			'statement' => 126,
			'Varstruct' => 90,
			'ifPrefix' => 95,
			'expression' => 73,
			'Primary' => 74,
			'loopPrefix' => 80,
			'compStat' => 93,
			'Variable' => 83
		}
	},
	{#State 81
		DEFAULT => -81
	},
	{#State 82
		ACTIONS => {
			'ID' => 127
		},
		GOTOS => {
			'declList' => 21
		}
	},
	{#State 83
		ACTIONS => {
			"*=" => 128,
			"-=" => 129,
			"=" => 133,
			"+=" => 132,
			"%=" => 131,
			"/=" => 130
		}
	},
	{#State 84
		ACTIONS => {
			"}" => 134
		}
	},
	{#State 85
		ACTIONS => {
			"(" => 136,
			"[" => 135,
			"." => 138
		},
		DEFAULT => -73,
		GOTOS => {
			'fieldaccess' => 137,
			'accessList' => 139
		}
	},
	{#State 86
		DEFAULT => -53
	},
	{#State 87
		DEFAULT => -80
	},
	{#State 88
		DEFAULT => -42
	},
	{#State 89
		ACTIONS => {
			'ID' => 107
		},
		GOTOS => {
			'Varstruct' => 90,
			'Vararray' => 70,
			'Variable' => 140
		}
	},
	{#State 90
		DEFAULT => -72
	},
	{#State 91
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			";" => 142,
			'error' => 92,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'expression' => 141,
			'binary' => 77,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 92
		ACTIONS => {
			"," => 143
		}
	},
	{#State 93
		DEFAULT => -58
	},
	{#State 94
		ACTIONS => {
			"(" => 144,
			'error' => 145
		}
	},
	{#State 95
		ACTIONS => {
			'ID' => 85,
			'BREAK' => 69,
			";" => 86,
			"{" => 58,
			'ICONST' => 87,
			"++" => 89,
			"(" => 78,
			'CONTINUE' => 79,
			'RETURN' => 91,
			'IF' => 72,
			'error' => 92,
			'LCONST' => 81,
			'WHILE' => 94,
			"--" => 75
		},
		GOTOS => {
			'Unary' => 76,
			'binary' => 77,
			'Vararray' => 70,
			'statement' => 146,
			'Varstruct' => 90,
			'ifPrefix' => 95,
			'expression' => 73,
			'Primary' => 74,
			'loopPrefix' => 80,
			'compStat' => 93,
			'Variable' => 83
		}
	},
	{#State 96
		DEFAULT => -33
	},
	{#State 97
		ACTIONS => {
			'ID' => 147,
			'error' => 148
		}
	},
	{#State 98
		ACTIONS => {
			'ID' => 149
		},
		DEFAULT => -37
	},
	{#State 99
		DEFAULT => -54
	},
	{#State 100
		DEFAULT => -51
	},
	{#State 101
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'error' => 92,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'expression' => 150,
			'binary' => 77,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 102
		DEFAULT => -63
	},
	{#State 103
		DEFAULT => -52
	},
	{#State 104
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'error' => 152,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 151,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 105
		DEFAULT => -69
	},
	{#State 106
		DEFAULT => -86
	},
	{#State 107
		ACTIONS => {
			"[" => 135,
			"." => 138
		},
		DEFAULT => -73,
		GOTOS => {
			'fieldaccess' => 137,
			'accessList' => 139
		}
	},
	{#State 108
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 153,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 109
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 154,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 110
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 155,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 111
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 156,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 112
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 157,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 113
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 158,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 114
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 159,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 115
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 160,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 116
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 161,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 117
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 162,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 118
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 163,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 119
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 164,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 120
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 165,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 121
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 166,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 122
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 167,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 123
		ACTIONS => {
			'error' => 105,
			"," => 104,
			")" => 168
		}
	},
	{#State 124
		ACTIONS => {
			"," => 143,
			")" => 169
		}
	},
	{#State 125
		DEFAULT => -55
	},
	{#State 126
		DEFAULT => -61
	},
	{#State 127
		ACTIONS => {
			"[" => 30
		},
		DEFAULT => -46,
		GOTOS => {
			'arrayList' => 29,
			'arrayPart' => 31
		}
	},
	{#State 128
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 170,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 129
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 171,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 130
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 172,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 131
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 173,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 132
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 174,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 133
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 175,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 134
		DEFAULT => -40
	},
	{#State 135
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 176,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 136
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'error' => 179,
			'LCONST' => 81,
			")" => -110,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'argList' => 180,
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 178,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83,
			'opArgList' => 177
		}
	},
	{#State 137
		ACTIONS => {
			"." => 181
		},
		DEFAULT => -75
	},
	{#State 138
		ACTIONS => {
			'ID' => 183
		},
		GOTOS => {
			'Vararray' => 182
		}
	},
	{#State 139
		ACTIONS => {
			"[" => 184
		},
		DEFAULT => -74
	},
	{#State 140
		DEFAULT => -85
	},
	{#State 141
		ACTIONS => {
			";" => 185,
			'error' => 105,
			"," => 104
		}
	},
	{#State 142
		DEFAULT => -56
	},
	{#State 143
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 186,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 144
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'error' => 92,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'expression' => 187,
			'binary' => 77,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 145
		DEFAULT => -65
	},
	{#State 146
		ACTIONS => {
			"ELSE" => 188
		},
		DEFAULT => -59
	},
	{#State 147
		DEFAULT => -35
	},
	{#State 148
		DEFAULT => -39
	},
	{#State 149
		DEFAULT => -38
	},
	{#State 150
		ACTIONS => {
			'error' => 105,
			"," => 104,
			")" => 189
		}
	},
	{#State 151
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -67
	},
	{#State 152
		DEFAULT => -70
	},
	{#State 153
		ACTIONS => {
			"**" => 117,
			"%" => 110,
			"*" => 113,
			"/" => 121
		},
		DEFAULT => -90
	},
	{#State 154
		ACTIONS => {
			"-" => 108,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"*" => 113,
			"/" => 121
		},
		DEFAULT => -94
	},
	{#State 155
		ACTIONS => {
			"**" => 117
		},
		DEFAULT => -93
	},
	{#State 156
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			">=" => 112,
			"*" => 113,
			"/" => 121,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -98
	},
	{#State 157
		ACTIONS => {
			"-" => 108,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"*" => 113,
			"/" => 121
		},
		DEFAULT => -96
	},
	{#State 158
		ACTIONS => {
			"**" => 117
		},
		DEFAULT => -91
	},
	{#State 159
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -103
	},
	{#State 160
		ACTIONS => {
			"-" => 108,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"*" => 113,
			"/" => 121
		},
		DEFAULT => -97
	},
	{#State 161
		ACTIONS => {
			"-" => 108,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"*" => 113,
			"/" => 121
		},
		DEFAULT => -95
	},
	{#State 162
		ACTIONS => {
			"**" => 117
		},
		DEFAULT => -102
	},
	{#State 163
		ACTIONS => {
			"**" => 117,
			"%" => 110,
			"*" => 113,
			"/" => 121
		},
		DEFAULT => -89
	},
	{#State 164
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			">=" => 112,
			"*" => 113,
			"/" => 121,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -100
	},
	{#State 165
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"/" => 121,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -101
	},
	{#State 166
		ACTIONS => {
			"**" => 117
		},
		DEFAULT => -92
	},
	{#State 167
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -99
	},
	{#State 168
		DEFAULT => -82
	},
	{#State 169
		DEFAULT => -83
	},
	{#State 170
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -107
	},
	{#State 171
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -106
	},
	{#State 172
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -108
	},
	{#State 173
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -109
	},
	{#State 174
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -105
	},
	{#State 175
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -104
	},
	{#State 176
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"]" => 190,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		}
	},
	{#State 177
		ACTIONS => {
			")" => 191
		}
	},
	{#State 178
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -112
	},
	{#State 179
		DEFAULT => -114
	},
	{#State 180
		ACTIONS => {
			'error' => 193,
			"," => 192,
			")" => -111
		}
	},
	{#State 181
		ACTIONS => {
			'ID' => 183
		},
		GOTOS => {
			'Vararray' => 194
		}
	},
	{#State 182
		DEFAULT => -79
	},
	{#State 183
		ACTIONS => {
			"[" => 135
		},
		DEFAULT => -73,
		GOTOS => {
			'accessList' => 139
		}
	},
	{#State 184
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 195,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 185
		DEFAULT => -57
	},
	{#State 186
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -68
	},
	{#State 187
		ACTIONS => {
			'error' => 105,
			"," => 104,
			")" => 196
		}
	},
	{#State 188
		ACTIONS => {
			'ID' => 85,
			'BREAK' => 69,
			";" => 86,
			"{" => 58,
			'ICONST' => 87,
			"++" => 89,
			"(" => 78,
			'CONTINUE' => 79,
			'RETURN' => 91,
			'IF' => 72,
			'error' => 92,
			'LCONST' => 81,
			'WHILE' => 94,
			"--" => 75
		},
		GOTOS => {
			'Unary' => 76,
			'binary' => 77,
			'Vararray' => 70,
			'statement' => 197,
			'Varstruct' => 90,
			'ifPrefix' => 95,
			'expression' => 73,
			'Primary' => 74,
			'loopPrefix' => 80,
			'compStat' => 93,
			'Variable' => 83
		}
	},
	{#State 189
		DEFAULT => -62
	},
	{#State 190
		DEFAULT => -76
	},
	{#State 191
		DEFAULT => -84
	},
	{#State 192
		ACTIONS => {
			'ID' => 85,
			"++" => 89,
			"(" => 78,
			'error' => 199,
			'LCONST' => 81,
			'ICONST' => 87,
			"--" => 75
		},
		GOTOS => {
			'Varstruct' => 90,
			'Unary' => 76,
			'binary' => 198,
			'Primary' => 74,
			'Vararray' => 70,
			'Variable' => 83
		}
	},
	{#State 193
		DEFAULT => -115
	},
	{#State 194
		DEFAULT => -78
	},
	{#State 195
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"]" => 200,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		}
	},
	{#State 196
		DEFAULT => -64
	},
	{#State 197
		DEFAULT => -60
	},
	{#State 198
		ACTIONS => {
			"-" => 108,
			"<" => 109,
			"+" => 118,
			"**" => 117,
			"%" => 110,
			"==" => 111,
			">=" => 112,
			"*" => 113,
			"!=" => 119,
			"&" => 120,
			"/" => 121,
			"=" => 122,
			"|" => 114,
			"<=" => 115,
			">" => 116
		},
		DEFAULT => -113
	},
	{#State 199
		DEFAULT => -116
	},
	{#State 200
		DEFAULT => -77
	}
],
                                  yyrules  =>
[
	[#Rule _SUPERSTART
		 '$start', 2, undef
	],
	[#Rule program_1
		 'program', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definitions_2
		 'definitions', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definitions_3
		 'definitions', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definitions_4
		 'definitions', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definitions_5
		 'definitions', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definition_6
		 'definition', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definition_7
		 'definition', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule definition_8
		 'definition', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule type_9
		 'type', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule type_10
		 'type', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule StructType_11
		 'StructType', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule SimpleType_12
		 'SimpleType', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule SimpleType_13
		 'SimpleType', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule FieldDefPart_14
		 'FieldDefPart', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule FieldDefPart_15
		 'FieldDefPart', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule FieldDef_16
		 'FieldDef', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule FieldDef_17
		 'FieldDef', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule FieldList_18
		 'FieldList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule FieldList_19
		 'FieldList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Field_20
		 'Field', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule funcDef_21
		 'funcDef', 6,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule opParList_22
		 'opParList', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule opParList_23
		 'opParList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramList_24
		 'paramList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramList_25
		 'paramList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramList_26
		 'paramList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramList_27
		 'paramList', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramList_28
		 'paramList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramList_29
		 'paramList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDecls_30
		 'paramDecls', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDecls_31
		 'paramDecls', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDecls_32
		 'paramDecls', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDecl_33
		 'paramDecl', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDeclList_34
		 'paramDeclList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDeclList_35
		 'paramDeclList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDeclList_36
		 'paramDeclList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDeclList_37
		 'paramDeclList', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDeclList_38
		 'paramDeclList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule paramDeclList_39
		 'paramDeclList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule compStat_40
		 'compStat', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule declarations_41
		 'declarations', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule declarations_42
		 'declarations', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule declaration_43
		 'declaration', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule declList_44
		 'declList', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule declList_45
		 'declList', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule arrayPart_46
		 'arrayPart', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule arrayPart_47
		 'arrayPart', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule arrayList_48
		 'arrayList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule arrayList_49
		 'arrayList', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statements_50
		 'statements', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statements_51
		 'statements', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_52
		 'statement', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_53
		 'statement', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_54
		 'statement', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_55
		 'statement', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_56
		 'statement', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_57
		 'statement', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_58
		 'statement', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_59
		 'statement', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_60
		 'statement', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule statement_61
		 'statement', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule ifPrefix_62
		 'ifPrefix', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule ifPrefix_63
		 'ifPrefix', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule loopPrefix_64
		 'loopPrefix', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule loopPrefix_65
		 'loopPrefix', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule expression_66
		 'expression', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule expression_67
		 'expression', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule expression_68
		 'expression', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule expression_69
		 'expression', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule expression_70
		 'expression', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Variable_71
		 'Variable', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Variable_72
		 'Variable', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Vararray_73
		 'Vararray', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Vararray_74
		 'Vararray', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Varstruct_75
		 'Varstruct', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule accessList_76
		 'accessList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule accessList_77
		 'accessList', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule fieldaccess_78
		 'fieldaccess', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule fieldaccess_79
		 'fieldaccess', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Primary_80
		 'Primary', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Primary_81
		 'Primary', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Primary_82
		 'Primary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Primary_83
		 'Primary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Primary_84
		 'Primary', 4,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Unary_85
		 'Unary', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Unary_86
		 'Unary', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule Unary_87
		 'Unary', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_88
		 'binary', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_89
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_90
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_91
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_92
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_93
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_94
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_95
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_96
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_97
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_98
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_99
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_100
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_101
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_102
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_103
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_104
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_105
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_106
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_107
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_108
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule binary_109
		 'binary', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule opArgList_110
		 'opArgList', 0,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule opArgList_111
		 'opArgList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule argList_112
		 'argList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule argList_113
		 'argList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule argList_114
		 'argList', 1,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule argList_115
		 'argList', 2,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	],
	[#Rule argList_116
		 'argList', 3,
sub {
#line 18 "SC.yp"
 goto &Parse::Eyapp::Driver::YYBuildAST }
	]
],
                                  @_);
    bless($self,$class);

    $self->make_node_classes( qw{TERMINAL _OPTIONAL _STAR_LIST _PLUS_LIST 
         _SUPERSTART
         program_1
         definitions_2
         definitions_3
         definitions_4
         definitions_5
         definition_6
         definition_7
         definition_8
         type_9
         type_10
         StructType_11
         SimpleType_12
         SimpleType_13
         FieldDefPart_14
         FieldDefPart_15
         FieldDef_16
         FieldDef_17
         FieldList_18
         FieldList_19
         Field_20
         funcDef_21
         opParList_22
         opParList_23
         paramList_24
         paramList_25
         paramList_26
         paramList_27
         paramList_28
         paramList_29
         paramDecls_30
         paramDecls_31
         paramDecls_32
         paramDecl_33
         paramDeclList_34
         paramDeclList_35
         paramDeclList_36
         paramDeclList_37
         paramDeclList_38
         paramDeclList_39
         compStat_40
         declarations_41
         declarations_42
         declaration_43
         declList_44
         declList_45
         arrayPart_46
         arrayPart_47
         arrayList_48
         arrayList_49
         statements_50
         statements_51
         statement_52
         statement_53
         statement_54
         statement_55
         statement_56
         statement_57
         statement_58
         statement_59
         statement_60
         statement_61
         ifPrefix_62
         ifPrefix_63
         loopPrefix_64
         loopPrefix_65
         expression_66
         expression_67
         expression_68
         expression_69
         expression_70
         Variable_71
         Variable_72
         Vararray_73
         Vararray_74
         Varstruct_75
         accessList_76
         accessList_77
         fieldaccess_78
         fieldaccess_79
         Primary_80
         Primary_81
         Primary_82
         Primary_83
         Primary_84
         Unary_85
         Unary_86
         Unary_87
         binary_88
         binary_89
         binary_90
         binary_91
         binary_92
         binary_93
         binary_94
         binary_95
         binary_96
         binary_97
         binary_98
         binary_99
         binary_100
         binary_101
         binary_102
         binary_103
         binary_104
         binary_105
         binary_106
         binary_107
         binary_108
         binary_109
         opArgList_110
         opArgList_111
         argList_112
         argList_113
         argList_114
         argList_115
         argList_116} );
    $self;
}

#line 223 "SC.yp"



1;
