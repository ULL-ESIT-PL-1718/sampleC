####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package small;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 1 "small.yp"


use IO::File;
use Data::Dumper;
use Carp;
our $reserved = {
	INT => "int", 
	STRING => "string", 
	IF => "if", 
	ELSE => "else",
	BREAK => "break",
	CONTINUE => "continue",
	PRINT => "print",
	WHILE => "while", 
	RETURN => "return"};
	
our $lexema = { 
	'=' => "ASSIGN", 
	'==' => "EQUAL", 
	'!=' => "NOTEQUAL", 
	'&' => "AND",
	'|' => "OR", 
	',' => "COMMA", 
	'[' => "LEFTBRACKET", 
	']' => "RIGHTBRACKET", 
	'{' => "LEFTKEY", 
	'}' => "RIGHTKEY",
	'(' => "LEFTPARENTHESIS", 
	')' => "RIGHTPARENTHESIS", 
	'<=' => "LESSTHAN",
	'<' => "LESS", 
	'>' => "GREATER", 
	'>=' => "GREATERTHAN", 
	'+=' => "PLUSASSIGN",
	'-=' => "MINUSASSIGN",
	'*=' => "TIMESASSIGN",
	'/=' => "DIVASSIGN",
	'%=' => "MODASSIGN",
	'+' => "PLUS", 
	'-' => "MINUS", 
	'*' => "TIMES", 
	'/' => "DIV",
	'%' => "MOD",
	'**' => "EXP",
	'++' => "INC",
	'--' => "DEC", 
	';' => "SEMICOLON"};
	
our $numlineas = 1;
our $prueba = "";
our $cadena ="";
our $fhi;
our $entrado;
our $erro = 0;
our $debug = 0;
our @ST;
our $numtablas = 0;
our $symbol_table;
our $borra = 0;
our @localvar =();
our @stscode =();
our @paramcode =();
our @concreteparam = ();
our @labels = ();
our $numlabel = 1;
our $whilelabel = 1;
our $scope=0;
our $temp;
$Data::Dumper::Indent = 1;
$Data::Dumper::Deepcopy = 1;
#======================================================================
# Variables para la generacion de codigo
#======================================================================
our $header ="";				# Cabecera de funcion
our $body ="";					# Cuerpo de la funcion
our $code="";					# Codigo global
our $ifcode="";					# Codigo if
our $elsecode="";				# Codigo else
our @labelstack = ();				# Pila de etiquetas
our %globalvars;				# Hash de globales
our $count = 1;
our $int_reg = 1;				# inicio de los I
our $str_reg = 1;				# inicio de los S
#======================================================================
# Comprueba que un identificador este o no declarado
#======================================================================

sub check_declared {
  my $id = shift;
  my($existe,$type,$tabla) = existe($id);
  if ($existe == 0) {
    die("$id no ha sido declarado\n");
  }
  return ($type,$tabla);
}


#======================================================================
# Subrutina que crea una entrada en la tabla de simbolos para
# cada identificador en @vars con tipo $type
#======================================================================

sub set_types {
  my $type = shift;
  my @vars = @_;

	
  foreach my $var (@vars) {
    if (!exists($symbol_table->{$var->{VAL}})) { $symbol_table->{$var->{VAL}}->{TYPE} = $type; }
    else { die("$var->{VAL} se ha declarado dos veces en el mismo ambito\n"); }
  }
}


sub set_subtypes {
  my ($type,$sub) = @_;

  if (!exists($symbol_table->{$sub->{ID}->{VAL}})) { 
	$symbol_table->{$sub->{ID}->{VAL}}->{TYPE} = $type;
  	if (exists($sub->{PARAMETERS})) {
		$symbol_table->{$sub->{ID}->{VAL}}->{PARAMETERS} = $sub->{PARAMETERS};
	}
  }
  else {die("$sub->{ID}->{VAL} se ha declarado dos veces en el mismo ambito\n");}	
		
}

#======================================================================
# Subrutina que crea una nueva tabla de simbolos, y la establece
# como predefinida
#======================================================================

sub new_block {
  my %tabla;
  push @ST,\%tabla;
  $numtablas = @ST;
  $symbol_table = $ST[$numtablas - 1];
  #return $numtablas;
}

#======================================================================
# Subrutina que elimina la ultima tabla de simbolos, y establece
# como predefinida la tabla anterior
#======================================================================

sub delete_block {
  pop @ST;
	if ($borra == 1) {
		pop @ST;
	}
  $numtablas = @ST;
  $symbol_table = $ST[$numtablas - 1];
	$borra = 0;
  return $numtablas;
}


#======================================================================
# Subrutina que comprueba que un identificador ha sido declarado
# en este ambito o en uno de los anteriores
#======================================================================

sub existe {
        my $id = shift;
        my @TS;
        my $tabla;
        while (0 < @ST) {
                if (!exists($symbol_table->{$id})) {
                        if ($numtablas > 1) {
                                push @TS,pop @ST;
                                $numtablas = @ST;
                                $symbol_table = $ST[$numtablas - 1];
                        }
                        else {
                                while (0 < @TS) {
                                        push @ST,pop @TS;
                                }
                                $numtablas = @ST;
                                $symbol_table = $ST[$numtablas - 1];
                                return 0;
                        }
                }
                else {
                        my $type = $symbol_table->{$id}->{TYPE};
                        $tabla = $symbol_table;
                        while (0 < @TS) {
                                push @ST,pop @TS;
                        }
                        $numtablas = @ST;
                        $symbol_table = $ST[$numtablas - 1];
                        return (1,$type,$tabla);
                }
        }
}

sub global {
	my $var = shift;
	my $length = @ST;
	my @temporal = @ST;
	my $tab;
	while (0 < @temporal) {
		$tab = pop @temporal;
		if ((exists($tab->{$var})) & (@temporal == 0)) {
			return $globalvars{$var};
		}
    elsif (exists($tab->{$var})) {
      return $var;
    }
	}
	return $var;
}
#======================================================================
# Subrutina que vuelca el codigo de un conjunto de statement y enlaza
# el codigo de todos ellos en un string y lo devuelve
#======================================================================
sub stscode {
	my $body = "";
	my $num = @stscode;
	if ($num > 0) {
	foreach my $cod (@stscode) {
		$body = $cod . "\n" . $body;
	}
	}
	@stscode = ();
	return $body;
}

#======================================================================
# Subrutina que vuelca el codigo de un conjunto de variables y enlaza
# el codigo de todos ellos en un string y lo devuelve
#======================================================================
sub datadefcode {
	my $data = "";
	foreach my $code (@localvar) {
		$data .= ".local " . $code->{SYMTABLE}->{$code->{VAL}}->{TYPE}->{TYPE} . " " . $code->{VAL} . "\n";
	}
	#$data = ".local " . $data . "\n" if $data;
	@localvar = ();
	return $data;
}

#======================================================================
# Subrutina que vuelca el codigo de un conjunto de parametros y enlaza
# el codigo de todos ellos en un string y lo devuelve
#======================================================================
sub paramcode {
	my $param = "";
	foreach my $tipo (@paramcode) {
		$param .= " .param $tipo->[0] $tipo->[1]\n";
	}
	@paramcode = ();
	return $param;
}


#======================================================================
# Subrutina que vuelca el codigo de un conjunto de parametros y enlaza
# el codigo de todos ellos en un string y lo devuelve
#======================================================================
sub concreteparamcode {
	my $param = "";
	my $val = 0;
	foreach my $tipo (@concreteparam) {
		if ($val != 0) {
			$param .= ",";
		}
		$param .= " $tipo";
		$val++;
	}
	@concreteparam = ();
	return $param;
}

#======================================================================
#
#======================================================================
sub createlabel {
	my $label = shift;
	my $number = shift;
	return $label . $number;
}
#======================================================================
#
#======================================================================
sub code_rama {
	my ($code,$tmp) = @_;
	if ($code =~ m/(\$\w+)\s*=[^=]*$/) {
		return ($code,$1);
	}
	my $return = $tmp . " = " . $code;
	return ($return,$tmp);
}

#======================================================================
#
#======================================================================
sub exp_code {
	my ($left_struct,$right_struct,$symbol) = @_;
	my $code = "";
	my $temp = "";
	my $val = 0;
	my $val2 = 0;
	if ($left_struct->{TYPE} eq "OP") {
		($code,$temp) = code_rama($left_struct->{CODE},"\$tm");
		$val2 = 1;
	}
	else {
		$code .= "$left_struct->{CODE} ";
	}
	if ($val2 == 1) {
		$code .= "\$t$count = $temp ";
		$val2 = 0;
	}
	$code .= $symbol;
	if ($right_struct->{TYPE} eq "OP") {
		($code,$temp) = code_rama($right_struct->{CODE},"\$tmp");
		$val = 1;
	}
	else {
		$code .= " $right_struct->{CODE}\n";
	}
	if ($val == 1) {
		$code .= "$temp\n";
		$val = 0;
	}
	$count++;
	return $code;
}

#======================================================================
#
#======================================================================
sub create_exp {
	my ($lvalue,$exp,$op) = @_;
	if (!exists($exp->{RIGHT})) {
		return "$lvalue $op $exp->{CODE}\n";	
	}
	my $left_struct = $exp->{LEFT};
	my $right_struct = $exp->{RIGHT};
	my $symbol = $exp->{OP};
	my $code = "";
	my $code2 = "";
	my $val = 0;
	my $val2 = 0;
	my $temp = "";
	my $temp2 = "";
	if ($right_struct->{TYPE} eq "OP") {
		($code2,$temp2) = code_rama($right_struct->{CODE},"\$tmp");
		$val = 1;
	}
	if ($left_struct->{TYPE} eq "OP") {
		($code,$temp) = code_rama($left_struct->{CODE},"\$tm");
		$val2 = 1;
	}
	$code = $code . $code2;
	$code .= "$lvalue $op ";
	if ($val2 == 1) {
		$code .= "$temp ";
		$val2 = 0;
	}
	if ($left_struct->{TYPE} eq "VAL") {
		$code .= $left_struct->{CODE};
	}
	$code .= $symbol;
	if ($right_struct->{TYPE} eq "VAL") {
		$code .= $right_struct->{CODE};
	}
	if ($val == 1) {
		$code .= "$temp2\n";
		$val = 0;
	}
	$count = 1;
	return $code;
}
#=========================================================================
#
#=========================================================================
sub check_params {
	my @args = @_;
	my @actuales = @{$args[1]};
	my ($type,$table) = &check_declared($args[0]);	
	my @globales = @{$table->{$args[0]}->{PARAMETERS}};
	my $globales = @globales;
	my %table_actual = %{$globales[0]{DECLARATOR}{VAL}{SYMTABLE}};
	my $param_size = @{$args[1]};
	my $tam = @args;
	if ($param_size != $globales) {
		die "Discordancia de parametros\n";
	}
	if (defined(@{$table->{$args[0]}->{PARAMETERS}})) {
		if ($tam == 1) {
			die "No concuerda la cabecera de la funcion en la linea $numlineas\n";
		}
		else {
			my $i = 0;
			my $glob_actual;
			foreach my $y (@actuales) {
				$glob_actual = $globales[$i]{DECLARATOR}{VAL}{VAL};
				if ($y->{P_TYPE}->{TYPE} ne $table_actual{$glob_actual}{TYPE}{TYPE}) {
					print "error\n";
				}
				$i++;
			}
		}
		
	}
}

#================================================================================
#
#================================================================================
sub globalvars {
	my $defs = shift;
	my @lista = @{$defs->{DECLARATORLIST}};
	my $length = @lista;
	my %lista = %{$lista[0]{SYMTABLE}};
	#print Dumper (@lista);
	#print "$length\n";
	foreach my $elem (@lista) {
		if ($lista{$elem->{VAL}}->{TYPE}->{TYPE} eq "int") {
			$globalvars{$elem->{VAL}} = "I$int_reg";
			$int_reg++;
		}
		else {
			$globalvars{$elem->{VAL}} = "S$str_reg";
			$str_reg++;
		}
	}
}




sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'error' => 7,
			"ID" => 8,
			"STRING" => 10,
			"INT" => 2
		},
		GOTOS => {
			'datadefinition' => 6,
			'dibujar' => 9,
			'functiondefinition' => 1,
			'functionheader' => 11,
			'definitions' => 3,
			'program' => 5,
			'basictype' => 4
		}
	},
	{#State 1
		DEFAULT => -5
	},
	{#State 2
		DEFAULT => -15
	},
	{#State 3
		ACTIONS => {
			'' => -2,
			'error' => 7,
			"ID" => 8,
			"STRING" => 10,
			"INT" => 2
		},
		GOTOS => {
			'datadefinition' => 6,
			'functiondefinition' => 1,
			'functionheader' => 11,
			'definitions' => 3,
			'program' => 12,
			'basictype' => 4
		}
	},
	{#State 4
		ACTIONS => {
			"ID" => 15
		},
		GOTOS => {
			'declarator' => 13,
			'declaratorlist' => 14,
			'functionheader' => 16
		}
	},
	{#State 5
		DEFAULT => -1
	},
	{#State 6
		DEFAULT => -4
	},
	{#State 7
		ACTIONS => {
			";" => 17
		}
	},
	{#State 8
		ACTIONS => {
			"(" => 18
		}
	},
	{#State 9
		ACTIONS => {
			'' => 19
		}
	},
	{#State 10
		DEFAULT => -16
	},
	{#State 11
		ACTIONS => {
			"{" => 20
		},
		GOTOS => {
			'functionbody' => 21
		}
	},
	{#State 12
		DEFAULT => -3
	},
	{#State 13
		ACTIONS => {
			"," => 22
		},
		DEFAULT => -8
	},
	{#State 14
		ACTIONS => {
			";" => 23
		}
	},
	{#State 15
		ACTIONS => {
			"(" => 18,
			"[" => 25
		},
		DEFAULT => -11,
		GOTOS => {
			'constantexplist' => 24
		}
	},
	{#State 16
		ACTIONS => {
			"{" => 20
		},
		GOTOS => {
			'functionbody' => 26
		}
	},
	{#State 17
		DEFAULT => -7
	},
	{#State 18
		ACTIONS => {
			")" => 28
		},
		DEFAULT => -18,
		GOTOS => {
			'@1-2' => 27
		}
	},
	{#State 19
		DEFAULT => 0
	},
	{#State 20
		DEFAULT => -22,
		GOTOS => {
			'@2-1' => 29
		}
	},
	{#State 21
		DEFAULT => -14
	},
	{#State 22
		ACTIONS => {
			"ID" => 31
		},
		GOTOS => {
			'declarator' => 13,
			'declaratorlist' => 30
		}
	},
	{#State 23
		DEFAULT => -6
	},
	{#State 24
		DEFAULT => -10
	},
	{#State 25
		ACTIONS => {
			"++" => 39,
			"(" => 38,
			"NUM" => 34,
			"ID" => 41,
			"--" => 42,
			"STR" => 36
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 32,
			'constantexp' => 40,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 26
		DEFAULT => -13
	},
	{#State 27
		ACTIONS => {
			"STRING" => 10,
			"INT" => 2
		},
		GOTOS => {
			'parameters' => 44,
			'basictype' => 43
		}
	},
	{#State 28
		DEFAULT => -17
	},
	{#State 29
		ACTIONS => {
			"}" => -24,
			";" => -24,
			"NUM" => -24,
			"++" => -24,
			"PRINT" => -24,
			'error' => 7,
			"STRING" => 10,
			"--" => -24,
			"{" => -24,
			"INT" => 2,
			"RETURN" => -24,
			"STR" => -24,
			"IF" => -24,
			"(" => -24,
			"WHILE" => -24,
			"ID" => -24
		},
		GOTOS => {
			'datadefinition' => 47,
			'datadefs' => 45,
			'basictype' => 46
		}
	},
	{#State 30
		DEFAULT => -9
	},
	{#State 31
		ACTIONS => {
			"[" => 25
		},
		DEFAULT => -11,
		GOTOS => {
			'constantexplist' => 24
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"!=" => 49,
			"&" => 53,
			"/" => 55,
			"|" => 58,
			"<=" => 60,
			">" => 61
		},
		DEFAULT => -38
	},
	{#State 33
		ACTIONS => {
			"*=" => 62,
			"-=" => 63,
			"/=" => 64,
			"%=" => 67,
			"=" => 66,
			"+=" => 65
		},
		DEFAULT => -66
	},
	{#State 34
		DEFAULT => -67
	},
	{#State 35
		DEFAULT => -62
	},
	{#State 36
		DEFAULT => -68
	},
	{#State 37
		DEFAULT => -59
	},
	{#State 38
		ACTIONS => {
			"++" => 39,
			"(" => 38,
			"NUM" => 34,
			"ID" => 41,
			"--" => 42,
			"STR" => 36
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 68,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 39
		ACTIONS => {
			"ID" => 70
		},
		GOTOS => {
			'lvalue' => 69
		}
	},
	{#State 40
		ACTIONS => {
			"]" => 71
		}
	},
	{#State 41
		ACTIONS => {
			"[" => 74,
			"(" => 73
		},
		DEFAULT => -70,
		GOTOS => {
			'explist' => 72
		}
	},
	{#State 42
		ACTIONS => {
			"ID" => 70
		},
		GOTOS => {
			'lvalue' => 75
		}
	},
	{#State 43
		ACTIONS => {
			"ID" => 31
		},
		GOTOS => {
			'declarator' => 76
		}
	},
	{#State 44
		ACTIONS => {
			")" => 77
		}
	},
	{#State 45
		ACTIONS => {
			"}" => -26,
			";" => 78,
			"{" => 20,
			"NUM" => 34,
			"RETURN" => 84,
			"STR" => 36,
			"IF" => 85,
			"(" => 38,
			"++" => 39,
			"WHILE" => 86,
			"PRINT" => 79,
			'error' => 81,
			"ID" => 41,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 82,
			'statement' => 80,
			'lvalue' => 33,
			'sts' => 87,
			'functionbody' => 83,
			'primary' => 35
		}
	},
	{#State 46
		ACTIONS => {
			"ID" => 31
		},
		GOTOS => {
			'declarator' => 13,
			'declaratorlist' => 14
		}
	},
	{#State 47
		ACTIONS => {
			"}" => -24,
			";" => -24,
			"NUM" => -24,
			"++" => -24,
			"PRINT" => -24,
			'error' => 7,
			"STRING" => 10,
			"--" => -24,
			"{" => -24,
			"INT" => 2,
			"RETURN" => -24,
			"STR" => -24,
			"IF" => -24,
			"(" => -24,
			"WHILE" => -24,
			"ID" => -24
		},
		GOTOS => {
			'datadefinition' => 47,
			'datadefs' => 88,
			'basictype' => 46
		}
	},
	{#State 48
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 89,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 49
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 90,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 50
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 91,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 51
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 92,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 52
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 93,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 53
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 94,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 54
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 95,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 55
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 96,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 56
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 97,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 57
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 98,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 58
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 99,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 59
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 100,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 60
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 101,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 61
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 102,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 62
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 103,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 63
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 104,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 64
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 105,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 65
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 106,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 66
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 107,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 67
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 108,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 68
		ACTIONS => {
			"-" => 48,
			"!=" => 49,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"&" => 53,
			"/" => 55,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"|" => 58,
			"*" => 59,
			"<=" => 60,
			")" => 109,
			">" => 61
		}
	},
	{#State 69
		DEFAULT => -60
	},
	{#State 70
		ACTIONS => {
			"[" => 74
		},
		DEFAULT => -70,
		GOTOS => {
			'explist' => 72
		}
	},
	{#State 71
		ACTIONS => {
			"[" => 25
		},
		DEFAULT => -11,
		GOTOS => {
			'constantexplist' => 110
		}
	},
	{#State 72
		DEFAULT => -69
	},
	{#State 73
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			")" => 111,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 112,
			'lvalue' => 33,
			'primary' => 35,
			'argumentlist' => 113
		}
	},
	{#State 74
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 114,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 75
		DEFAULT => -61
	},
	{#State 76
		ACTIONS => {
			"," => 115
		},
		DEFAULT => -20
	},
	{#State 77
		DEFAULT => -19
	},
	{#State 78
		DEFAULT => -28
	},
	{#State 79
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 116,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 80
		ACTIONS => {
			"}" => -26,
			";" => 78,
			"{" => 20,
			"NUM" => 34,
			"RETURN" => 84,
			"STR" => 36,
			"IF" => 85,
			"(" => 38,
			"++" => 39,
			"WHILE" => 86,
			"PRINT" => 79,
			'error' => 81,
			"ID" => 41,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 82,
			'statement' => 80,
			'lvalue' => 33,
			'sts' => 117,
			'functionbody' => 83,
			'primary' => 35
		}
	},
	{#State 81
		DEFAULT => -30
	},
	{#State 82
		ACTIONS => {
			"-" => 48,
			"!=" => 49,
			"<" => 50,
			";" => 118,
			"+" => 52,
			"**" => 51,
			"&" => 53,
			"/" => 55,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"|" => 58,
			"*" => 59,
			"<=" => 60,
			">" => 61
		}
	},
	{#State 83
		DEFAULT => -31
	},
	{#State 84
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			";" => 119,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 120,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 85
		ACTIONS => {
			"(" => 121
		}
	},
	{#State 86
		ACTIONS => {
			"(" => 122
		}
	},
	{#State 87
		ACTIONS => {
			"}" => 123
		}
	},
	{#State 88
		DEFAULT => -25
	},
	{#State 89
		ACTIONS => {
			"%" => 54,
			"*" => 59,
			"**" => 51,
			"/" => 55
		},
		DEFAULT => -54
	},
	{#State 90
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			">=" => 57,
			"*" => 59,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"/" => 55
		},
		DEFAULT => -48
	},
	{#State 91
		ACTIONS => {
			"-" => 48,
			"%" => 54,
			"*" => 59,
			"**" => 51,
			"+" => 52,
			"/" => 55
		},
		DEFAULT => -49
	},
	{#State 92
		ACTIONS => {
			"**" => 51
		},
		DEFAULT => -58
	},
	{#State 93
		ACTIONS => {
			"%" => 54,
			"*" => 59,
			"**" => 51,
			"/" => 55
		},
		DEFAULT => -53
	},
	{#State 94
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"/" => 55
		},
		DEFAULT => -45
	},
	{#State 95
		ACTIONS => {
			"**" => 51
		},
		DEFAULT => -57
	},
	{#State 96
		ACTIONS => {
			"**" => 51
		},
		DEFAULT => -56
	},
	{#State 97
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			">=" => 57,
			"*" => 59,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"/" => 55
		},
		DEFAULT => -47
	},
	{#State 98
		ACTIONS => {
			"-" => 48,
			"%" => 54,
			"*" => 59,
			"**" => 51,
			"+" => 52,
			"/" => 55
		},
		DEFAULT => -52
	},
	{#State 99
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"/" => 55
		},
		DEFAULT => -46
	},
	{#State 100
		ACTIONS => {
			"**" => 51
		},
		DEFAULT => -55
	},
	{#State 101
		ACTIONS => {
			"-" => 48,
			"%" => 54,
			"*" => 59,
			"**" => 51,
			"+" => 52,
			"/" => 55
		},
		DEFAULT => -51
	},
	{#State 102
		ACTIONS => {
			"-" => 48,
			"%" => 54,
			"*" => 59,
			"**" => 51,
			"+" => 52,
			"/" => 55
		},
		DEFAULT => -50
	},
	{#State 103
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"&" => 53,
			"/" => 55
		},
		DEFAULT => -42
	},
	{#State 104
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"&" => 53,
			"/" => 55
		},
		DEFAULT => -41
	},
	{#State 105
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"&" => 53,
			"/" => 55
		},
		DEFAULT => -43
	},
	{#State 106
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"&" => 53,
			"/" => 55
		},
		DEFAULT => -40
	},
	{#State 107
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"&" => 53,
			"/" => 55
		},
		DEFAULT => -39
	},
	{#State 108
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"|" => 58,
			"<=" => 60,
			">" => 61,
			"**" => 51,
			"+" => 52,
			"!=" => 49,
			"&" => 53,
			"/" => 55
		},
		DEFAULT => -44
	},
	{#State 109
		DEFAULT => -63
	},
	{#State 110
		DEFAULT => -12
	},
	{#State 111
		DEFAULT => -64
	},
	{#State 112
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"%" => 54,
			"," => 124,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"!=" => 49,
			"&" => 53,
			"/" => 55,
			"|" => 58,
			"<=" => 60,
			">" => 61
		},
		DEFAULT => -72
	},
	{#State 113
		ACTIONS => {
			")" => 125
		}
	},
	{#State 114
		ACTIONS => {
			"-" => 48,
			"!=" => 49,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"&" => 53,
			"/" => 55,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"|" => 58,
			"*" => 59,
			"<=" => 60,
			"]" => 126,
			">" => 61
		}
	},
	{#State 115
		ACTIONS => {
			"INT" => 2,
			"STRING" => 10
		},
		GOTOS => {
			'parameters' => 127,
			'basictype' => 43
		}
	},
	{#State 116
		ACTIONS => {
			"-" => 48,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"*" => 59,
			"!=" => 49,
			"&" => 53,
			"/" => 55,
			"|" => 58,
			"<=" => 60,
			">" => 61
		},
		DEFAULT => -32
	},
	{#State 117
		DEFAULT => -27
	},
	{#State 118
		DEFAULT => -29
	},
	{#State 119
		DEFAULT => -36
	},
	{#State 120
		ACTIONS => {
			"-" => 48,
			"!=" => 49,
			"<" => 50,
			";" => 128,
			"+" => 52,
			"**" => 51,
			"&" => 53,
			"/" => 55,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"|" => 58,
			"*" => 59,
			"<=" => 60,
			">" => 61
		}
	},
	{#State 121
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 129,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 122
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 130,
			'lvalue' => 33,
			'primary' => 35
		}
	},
	{#State 123
		DEFAULT => -23
	},
	{#State 124
		ACTIONS => {
			"(" => 38,
			"++" => 39,
			"NUM" => 34,
			"ID" => 41,
			"STR" => 36,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 112,
			'lvalue' => 33,
			'primary' => 35,
			'argumentlist' => 131
		}
	},
	{#State 125
		DEFAULT => -65
	},
	{#State 126
		ACTIONS => {
			"[" => 74
		},
		DEFAULT => -70,
		GOTOS => {
			'explist' => 132
		}
	},
	{#State 127
		DEFAULT => -21
	},
	{#State 128
		DEFAULT => -37
	},
	{#State 129
		ACTIONS => {
			"-" => 48,
			"!=" => 49,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"&" => 53,
			"/" => 55,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"|" => 58,
			"*" => 59,
			"<=" => 60,
			")" => 133,
			">" => 61
		}
	},
	{#State 130
		ACTIONS => {
			"-" => 48,
			"!=" => 49,
			"<" => 50,
			"+" => 52,
			"**" => 51,
			"&" => 53,
			"/" => 55,
			"%" => 54,
			"==" => 56,
			">=" => 57,
			"|" => 58,
			"*" => 59,
			"<=" => 60,
			")" => 134,
			">" => 61
		}
	},
	{#State 131
		DEFAULT => -73
	},
	{#State 132
		DEFAULT => -71
	},
	{#State 133
		ACTIONS => {
			";" => 78,
			"{" => 20,
			"NUM" => 34,
			"RETURN" => 84,
			"STR" => 36,
			"IF" => 85,
			"(" => 38,
			"++" => 39,
			"WHILE" => 86,
			"PRINT" => 79,
			'error' => 81,
			"ID" => 41,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 82,
			'statement' => 135,
			'lvalue' => 33,
			'functionbody' => 83,
			'primary' => 35
		}
	},
	{#State 134
		ACTIONS => {
			";" => 78,
			"{" => 20,
			"NUM" => 34,
			"RETURN" => 84,
			"STR" => 36,
			"IF" => 85,
			"(" => 38,
			"++" => 39,
			"WHILE" => 86,
			"PRINT" => 79,
			'error' => 81,
			"ID" => 41,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 82,
			'statement' => 136,
			'lvalue' => 33,
			'functionbody' => 83,
			'primary' => 35
		}
	},
	{#State 135
		ACTIONS => {
			"ELSE" => 137
		},
		DEFAULT => -33
	},
	{#State 136
		DEFAULT => -35
	},
	{#State 137
		ACTIONS => {
			";" => 78,
			"{" => 20,
			"NUM" => 34,
			"RETURN" => 84,
			"STR" => 36,
			"IF" => 85,
			"(" => 38,
			"++" => 39,
			"WHILE" => 86,
			"PRINT" => 79,
			'error' => 81,
			"ID" => 41,
			"--" => 42
		},
		GOTOS => {
			'unary' => 37,
			'exp' => 82,
			'statement' => 138,
			'lvalue' => 33,
			'functionbody' => 83,
			'primary' => 35
		}
	},
	{#State 138
		DEFAULT => -34
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'dibujar', 1,
sub
#line 448 "small.yp"
{
							   if (($erro == 0) && ($debug == 1)) {
							      print Dumper($_[1]);
							   }
							}
	],
	[#Rule 2
		 'program', 1,
sub
#line 456 "small.yp"
{bless [$_[1]],'program'}
	],
	[#Rule 3
		 'program', 2,
sub
#line 457 "small.yp"
{push @{$_[2]}, $_[1]; $_[2]}
	],
	[#Rule 4
		 'definitions', 1,
sub
#line 461 "small.yp"
{  globalvars($_[1]);
							   bless {DATADEFINITION => $_[1]},'definitions'
							}
	],
	[#Rule 5
		 'definitions', 1,
sub
#line 464 "small.yp"
{
							   print $_[1]->{CODE}; 
	               					   bless {FUNCTIONDEFINITION => $_[1]}, 'definitions'
							}
	],
	[#Rule 6
		 'datadefinition', 3,
sub
#line 471 "small.yp"
{
							   &set_types($_[1],@{$_[2]});
						 	   if ($scope > 0) {
							   	@localvar = @{$_[2]};
							}
							   bless {TYPE => $_[1],DECLARATORLIST => $_[2]},'datadefinition'
							}
	],
	[#Rule 7
		 'datadefinition', 2,
sub
#line 478 "small.yp"
{$_[0]->YYErrok ; print "Me he recuperado del error\n"}
	],
	[#Rule 8
		 'declaratorlist', 1,
sub
#line 482 "small.yp"
{bless [$_[1]->{VAL}],'declaratorlist'}
	],
	[#Rule 9
		 'declaratorlist', 3,
sub
#line 483 "small.yp"
{push @{$_[3]}, $_[1]->{VAL}; $_[3]}
	],
	[#Rule 10
		 'declarator', 2,
sub
#line 487 "small.yp"
{
							   $_[1]->{SYMTABLE} = $symbol_table;
							   bless {VAL => $_[1], CONSTANTEXPLIST => $_[2]}, 'declarator'
							}
	],
	[#Rule 11
		 'constantexplist', 0,
sub
#line 494 "small.yp"
{bless [],'constantexplist'}
	],
	[#Rule 12
		 'constantexplist', 4,
sub
#line 495 "small.yp"
{push @{$_[4]}, $_[2]; $_[4]}
	],
	[#Rule 13
		 'functiondefinition', 3,
sub
#line 499 "small.yp"
{  
							   $_[2]->{ID}->{SYMTABLE} = $symbol_table;
							   my $return = bless {TYPE => $_[1], HEADER => $_[2], BODY => $_[4],
							          CODE => "$_[2]->{CODE} $_[3]->{CODE}.end\n"}, 
							   'functiondefinition';
							   &set_subtypes($_[1],$_[2]);
							   $return
							   
							}
	],
	[#Rule 14
		 'functiondefinition', 2,
sub
#line 508 "small.yp"
{
							   $_[1]->{ID}->{SYMTABLE} = $symbol_table;
							   my $return = bless {HEADER => $_[1], BODY => $_[2],
							          CODE => "$_[1]->{CODE} $_[2]->{CODE}.end\n"}, 
						    	   'functiondefinition';
							   &set_subtypes('void',$_[1]);
							   $return
							}
	],
	[#Rule 15
		 'basictype', 1,
sub
#line 519 "small.yp"
{bless {TYPE => 'int'},'basictype'}
	],
	[#Rule 16
		 'basictype', 1,
sub
#line 520 "small.yp"
{bless {TYPE => 'string'},'basictype'}
	],
	[#Rule 17
		 'functionheader', 3,
sub
#line 524 "small.yp"
{
							   my $ambito = "";
							   if ($_[1]->{VAL} eq "main") {
							   	$ambito = ":main";
							   }
							   $header =".sub $_[1]->{VAL} $ambito\n";
							   bless {ID => $_[1], CODE =>"$header"},
							   'functionheader' 
							}
	],
	[#Rule 18
		 '@1-2', 0,
sub
#line 533 "small.yp"
{
							   $header .=".sub $_[1]->{VAL}\n";
							   $borra = 1; &new_block
							}
	],
	[#Rule 19
		 'functionheader', 5,
sub
#line 537 "small.yp"
{
							   my $ambito = "";
							   if ($_[1]->{VAL} eq "main ") {
							   	$ambito = ":main";
							   }
							   bless {ID => $_[1], PARAMETERS => $_[4],
							   CODE => ".sub $_[1]->{VAL} $ambito\n" . paramcode()
							}, 'functionheader'}
	],
	[#Rule 20
		 'parameters', 2,
sub
#line 548 "small.yp"
{
							   push @paramcode,[$_[1]->{TYPE},$_[2]->{VAL}->{VAL}];
							   &set_types($_[1],$_[2]->{VAL});
							   bless [{TYPE => $_[1], DECLARATOR => $_[2]}], 'parameters'
							}
	],
	[#Rule 21
		 'parameters', 4,
sub
#line 553 "small.yp"
{
							   push @paramcode,[$_[1]->{TYPE},$_[2]->{VAL}->{VAL}];
							   &set_types($_[1],$_[2]->{VAL});
							   push @{$_[4]}, {TYPE => $_[1], DECLARATOR => $_[2]}; 
							   $_[4]
							}
	],
	[#Rule 22
		 '@2-1', 0,
sub
#line 562 "small.yp"
{
							   $scope++; 
							}
	],
	[#Rule 23
		 'functionbody', 5,
sub
#line 566 "small.yp"
{
							   my $codsts = "";
							   if ($scope == 1) {
							   	$codsts = datadefcode() . stscode();
							   }
							   else { $codsts = stscode(); }
							   $scope --;
							   bless {DATADEFS => $_[3], STS => $_[5],
							   	  CODE => $codsts }, 
						           'functionbody'
							}
	],
	[#Rule 24
		 'datadefs', 0,
sub
#line 580 "small.yp"
{bless [],'datadefs'}
	],
	[#Rule 25
		 'datadefs', 2,
sub
#line 581 "small.yp"
{push @{$_[2]},$_[1]; $_[2]}
	],
	[#Rule 26
		 'sts', 0,
sub
#line 585 "small.yp"
{bless [], 'sts'}
	],
	[#Rule 27
		 'sts', 2,
sub
#line 586 "small.yp"
{push @stscode,$_[1]->{CODE};push @{$_[2]},$_[1]; $_[2]}
	],
	[#Rule 28
		 'statement', 1,
sub
#line 590 "small.yp"
{;}
	],
	[#Rule 29
		 'statement', 2, undef
	],
	[#Rule 30
		 'statement', 1, undef
	],
	[#Rule 31
		 'statement', 1, undef
	],
	[#Rule 32
		 'statement', 2,
sub
#line 594 "small.yp"
{
							   bless {VAL => $_[2], CODE => "print $_[2]->{CODE}"}, 'PRINT'
							}
	],
	[#Rule 33
		 'statement', 5,
sub
#line 598 "small.yp"
{
							   $numlabel++;
							   $temp = createlabel("if",$numlabel);
							   bless {EXP => $_[3], STATEMENT => $_[5],
							   	  CODE => "if not $_[3]->{CODE} goto "
								  . $temp . "\n$_[5]->{CODE}\n ."
								  . $temp . ":\n" }, 'IF'

							}
	],
	[#Rule 34
		 'statement', 7,
sub
#line 610 "small.yp"
{
							   $numlabel++;
							   $temp = createlabel("if",$numlabel);
							   my $tmp = createlabel("continue",$numlabel);
							   bless {EXP => $_[3], STATEMENT => $_[5], ELSE => $_[7],
								CODE =>"if $_[3]->{CODE} goto "
								. $temp ."\n$_[7]->{CODE}\n"
								. "goto $tmp\n$temp:\n"
								. "$_[5]->{CODE}\n$tmp:\n"}, 
							   'IF'
							}
	],
	[#Rule 35
		 'statement', 5,
sub
#line 621 "small.yp"
{
							   $whilelabel++;
							   bless {EXP => $_[3], STATEMENT => $_[5],
							          CODE => "goto "
								  . createlabel("while",$whilelabel)
								  . "\n" . createlabel("cont",$whilelabel) . ":\n"
								  . "$_[5]->{CODE}"
								  . createlabel("while",$whilelabel)
								  . ":\n if $_[3]->{CODE} goto "
								  . createlabel("cont",$whilelabel) . "\n"}, 
							   'WHILE'
							}
	],
	[#Rule 36
		 'statement', 2,
sub
#line 633 "small.yp"
{bless {CODE => "return"}, 'RETURN'}
	],
	[#Rule 37
		 'statement', 3,
sub
#line 634 "small.yp"
{
							   bless {EXP => $_[2], CODE => "return ($_[2]->{CODE})"}, 
							   'RETURN'
							}
	],
	[#Rule 38
		 'constantexp', 1, undef
	],
	[#Rule 39
		 'exp', 3,
sub
#line 645 "small.yp"
{ 
							   bless {LEFT => $_[1], RIGHT => $_[3],
							          CODE => create_exp($_[1]->{CODE},$_[3],"=")},
							   'ASSIGN'
							}
	],
	[#Rule 40
		 'exp', 3,
sub
#line 650 "small.yp"
{ 
							   bless {LEFT => $_[1], RIGHT => $_[3],
							          CODE => create_exp($_[1]->{CODE},$_[3],"+=")},
						  	   'PLUSASSIGN'
							}
	],
	[#Rule 41
		 'exp', 3,
sub
#line 655 "small.yp"
{ 
							   bless {LEFT => $_[1], RIGHT => $_[3],
							          CODE => create_exp($_[1]->{CODE},$_[3],"-=")},
							   'MINUSASSIGN'
							}
	],
	[#Rule 42
		 'exp', 3,
sub
#line 660 "small.yp"
{ 
							   bless {LEFT => $_[1], RIGHT => $_[3],
							          CODE => create_exp($_[1]->{CODE},$_[3],"*=")},
							   'TIMESASSIGN'
							}
	],
	[#Rule 43
		 'exp', 3,
sub
#line 665 "small.yp"
{ 
							   bless {LEFT => $_[1], RIGHT => $_[3],
							          CODE => create_exp($_[1]->{CODE},$_[3],"/=")},
						           'DIVASSIGN'
							}
	],
	[#Rule 44
		 'exp', 3,
sub
#line 670 "small.yp"
{ 
							   bless {LEFT => $_[1], RIGHT => $_[3],
							          CODE => create_exp($_[1]->{CODE},$_[3],"%=")},
							   'MODASSIGN'
							}
	],
	[#Rule 45
		 'exp', 3,
sub
#line 675 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							   	  CODE => exp_code($_[1],$_[3],"&"),
								  OP => "&"}, 
							   'AND'
							}
	],
	[#Rule 46
		 'exp', 3,
sub
#line 681 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"|"),
								  OP => "|"}, 
							   'OR'
							}
	],
	[#Rule 47
		 'exp', 3,
sub
#line 687 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"=="),
								  OP => "=="}, 
							   'EQUAL'
							}
	],
	[#Rule 48
		 'exp', 3,
sub
#line 693 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"!="),
								  OP => "!="}, 
							   'NOTEQUAL'
							}
	],
	[#Rule 49
		 'exp', 3,
sub
#line 699 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"<"),
								  OP => "<"}, 
						    	   'LESS'
							}
	],
	[#Rule 50
		 'exp', 3,
sub
#line 705 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"<"),
								  OP => ">"}, 
							   'GREATER'
							}
	],
	[#Rule 51
		 'exp', 3,
sub
#line 711 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"<="),
								  OP => "<="}, 
							   'LESSTHAN'
							}
	],
	[#Rule 52
		 'exp', 3,
sub
#line 717 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],">="),
								  OP => ">="}, 
							   'GREATERTHAN'
							}
	],
	[#Rule 53
		 'exp', 3,
sub
#line 723 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"+"),
								  OP => "+"}, 
							   'PLUS'
							}
	],
	[#Rule 54
		 'exp', 3,
sub
#line 729 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"-"),
								  OP => "-"}, 
							   'MINUS'
							}
	],
	[#Rule 55
		 'exp', 3,
sub
#line 735 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"*"),
								  OP => "*"}, 
							   'MULT'}
	],
	[#Rule 56
		 'exp', 3,
sub
#line 740 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"/"),
								  OP => "/"}, 
							   'DIV'
							}
	],
	[#Rule 57
		 'exp', 3,
sub
#line 746 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"%"),
								  OP => "%"}, 
							   'MOD'
							}
	],
	[#Rule 58
		 'exp', 3,
sub
#line 752 "small.yp"
{ 
							   bless { TYPE => "OP", LEFT => $_[1], RIGHT => $_[3],
							          CODE => exp_code($_[1],$_[3],"**"),
								  OP => "**"}, 
							   'EXP'
							}
	],
	[#Rule 59
		 'exp', 1,
sub
#line 758 "small.yp"
{ $_[1] }
	],
	[#Rule 60
		 'unary', 2,
sub
#line 762 "small.yp"
{ bless { TYPE=> "OP", VAL => $_[2], CODE => "inc $_[2]->{CODE}"}, 'INC'}
	],
	[#Rule 61
		 'unary', 2,
sub
#line 763 "small.yp"
{ bless {VAL => $_[2], CODE => "dec $_[2]->{CODE}"}, 'DEC'}
	],
	[#Rule 62
		 'unary', 1,
sub
#line 764 "small.yp"
{ $_[1] }
	],
	[#Rule 63
		 'primary', 3,
sub
#line 768 "small.yp"
{$_[2]}
	],
	[#Rule 64
		 'primary', 3,
sub
#line 769 "small.yp"
{
							   &check_declared($_[1]->{VAL});
							   &check_params($_[1]->{VAL});
							   bless { 
							      TYPE => "VAL", ID => $_[1], CODE => "$_[1]->{VAL} ()"
							   }, 'primary'
							}
	],
	[#Rule 65
		 'primary', 4,
sub
#line 776 "small.yp"
{
							   &check_declared($_[1]->{VAL});
							   &check_params($_[1]->{VAL},$_[3]);
							   print "He pasado por aqui\n";
							   bless {
							      TYPE => "VAL",
							      ID => $_[1], ARGUMENTS => $_[3],
							      CODE => "$_[1]->{VAL} (" . concreteparamcode() . " )"
							   }, 'primary'
							}
	],
	[#Rule 66
		 'primary', 1, undef
	],
	[#Rule 67
		 'primary', 1,
sub
#line 787 "small.yp"
{ bless { TYPE => "VAL", CODE => "$_[1]->{VAL}"},'primary' }
	],
	[#Rule 68
		 'primary', 1,
sub
#line 788 "small.yp"
{ bless { TYPE => "VAL", CODE => "\"$_[1]->{VAL}\""},'primary' }
	],
	[#Rule 69
		 'lvalue', 2,
sub
#line 792 "small.yp"
{
							   my ($type,$table) = &check_declared($_[1]->{VAL});
							   my $generated = $_[1]->{VAL};
							   $generated = global($generated);
							   bless {
							      TYPE => "VAL", ID => $_[1],
							      P_TYPE => $type,
							      LIST => $_[2], CODE => $generated
							   }, 'lvalue'
							}
	],
	[#Rule 70
		 'explist', 0,
sub
#line 805 "small.yp"
{bless [],'explist'}
	],
	[#Rule 71
		 'explist', 4,
sub
#line 806 "small.yp"
{push @{$_[4]},$_[2];$_[4]}
	],
	[#Rule 72
		 'argumentlist', 1,
sub
#line 810 "small.yp"
{push @concreteparam,$_[1]->{CODE};bless [$_[1]], 'argumentlist'}
	],
	[#Rule 73
		 'argumentlist', 3,
sub
#line 811 "small.yp"
{push @{$_[3]}, $_[1]; push @concreteparam,$_[1]->{CODE};$_[3]}
	]
],
                                  @_);
    bless($self,$class);
}

#line 814 "small.yp"
	

sub _Error {
         exists $_[0]->YYData->{ERRMSG}
     and do {
         print $_[0]->YYData->{ERRMSG};
         delete $_[0]->YYData->{ERRMSG};
         return;
     };
		 $erro = 1;
     print "Syntax error en la linea $numlineas\n";
 }

sub _Lexer {
     my ($parser)=shift;
		 if ($entrado == 0) {
				if ($cadena and (-r $cadena)) {
    			$fhi = IO::File->new("< $cadena");
  			}
  			else { $fhi = 'STDIN'; }
				new_block;
				$entrado = 1;
		 }
		 local $/ = undef;
         $parser->YYData->{INPUT}
     or  $parser->YYData->{INPUT} = <$fhi>
     or  return('',undef);
	
     $parser->YYData->{INPUT}=~s/^[ \t]+//;


		 my $cnt;	
		 for ($parser->YYData->{INPUT}) {
				 s/^(\n)+// 
						and $cnt = $& =~ tr/\n/\n/
						and $numlineas += $cnt;
    		
				 s/^[ \t]+//;

		 		 s/^(\/\*.*?\*\/)//s
						and $cnt = $& =~ tr/\n/\n/
						and $numlineas += $cnt;
			
				 s/^(\n)+//
						and $cnt = $& =~ tr/\n/\n/
						and $numlineas += $cnt;

				 s/(^[ \t]+)?//;

				 s/^([0-9]+(?:\.[0-9]+)?)//
            					and return('NUM',(bless{VAL => $1, LINEA => $numlineas},'NUM'));
         
				 s/^([A-Za-z][A-Za-z0-9_]*)//
				    		and (defined $reserved->{uc($1)})? 
						return (uc($1),(bless{VAL => $1, LINEA => $numlineas},uc($1))):
            					return ('ID',(bless{VAL => $1, LINEA => $numlineas},'ID'));
			
				 s/^(\'[A-Za-z]\')//
						and return ('CHARACTER',(bless{VAL => $1, LINEA => $numlineas},'STR'));
	
				 s/^(==|\!=|\+=|\+\+|\-\-|&&|\|\||<=|>=)//s
						and return ($1,(bless{NOMBRE =>$lexema->{$1}, LINEA => $numlineas},'PUNT'));
		
				 s/^(=|\(|\)|\[|\]|\{|\}|\+|-|\*\*|\*|\/|,|;|<|>)//s
						and ($1 eq '{')? &new_block : print ""
						and ($1 eq '}')? &delete_block : print""
						and return ($1,(bless{NOMBRE =>$lexema->{$1}, LINEA => $numlineas},'PUNT'));
     }
 }


sub Run {
     my($self)=shift;
     ($cadena) = @_;
     $entrado = 0;
     $debug = 0;
     $self->YYParse( yylex => \&_Lexer, yyerror => \&_Error) #, yydebug => 0x10 );
     &delete_block;
 }



1;
