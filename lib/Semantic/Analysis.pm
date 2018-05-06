package Semantic::Analysis;
use 5.008005;
use strict;
use warnings;
use Carp;
use Data::Dumper;
use Error;
use Class::MakeMethods::Emulator::MethodMaker '-sugar';

require Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw ($symbol_table $numtablas @ST $int_type $err_type check_type_numeric_operator set_types check_declared new_block delete_block check_types);
our $VERSION =  '0.05';


package TYPE;
make methods
  get_set => ['NAME', 'LENGTH' ],
  new_hash_init => 'new';

package PROGRAM; # raíz del AAA
make methods
  get_set       => [ 'DECLS', 'STS' ],
  new_hash_init => 'new';

package INT; # tipo
make methods
  get_set       => [ 'TYPE', 'IDLIST' ],
  new_hash_init => 'new';
 
package LONG; #tipo
make methods
  get_set       => [ 'TYPE', 'IDLIST' ],
  new_hash_init => 'new';

package ASSIGN; #sentencia
make methods
  get_set       => [ 'LEFT', 'RIGHT' ],
  new_hash_init => 'new';

package PLUSASSIGN; #sentencia
make methods
  get_set       => [ 'LEFT', 'RIGHT' ],
  new_hash_init => 'new';

package MINUSASSIGN; #sentencia
make methods
  get_set       => [ 'LEFT', 'RIGHT' ],
  new_hash_init => 'new';

package TIMESASSIGN; #sentencia
make methods
  get_set       => [ 'LEFT', 'RIGHT' ],
  new_hash_init => 'new';

package DIVASSIGN; #sentencia
make methods
  get_set       => [ 'LEFT', 'RIGHT' ],
  new_hash_init => 'new';

package MODASSIGN; #sentencia
make methods
  get_set       => [ 'LEFT', 'RIGHT' ],
  new_hash_init => 'new';


package NUM; # para los números
make methods
  get_set       => [ 'VAL', 'TYPE' ],
  new_hash_init => 'new';

package ID; # Nodos identificador. Parte derecha
make methods
  get_set       => [ 'VAL', 'TYPE' ],
  new_hash_init => 'new';

package PLUS; # Nodo suma
make methods
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package MINUS; # Nodo resta
make methods
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package DIV; # Nodo division
make methods
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package TIMES; # Nodo multiplicacion
make methods
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';
 
package AND;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package OR;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package EXP;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package MOD;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package EQUAL;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package NOTEQUAL;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package GE;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package GT;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package LT;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package LE;
make methods   
  get_set       => [ 'LEFT', 'RIGHT', 'TYPE' ],
  new_hash_init => 'new';

package LEFTVALUE; # Identificador en la parte izquierda
make methods       # de una asignación
  get_set       => [ 'VAL', 'TYPE' ],
  new_hash_init => 'new';

package PL::Semantic::Analysis;

sub check_type_numeric_operator;
sub numeric_compatibility;
sub is_numeric;
sub set_types;
sub check_declared;
sub check_types;
sub new_block;
sub delete_block;
sub existe;

our $int_type = TYPE->new(NAME => 'INTEGER', LENGTH => 1);
our $string_type = TYPE->new(NAME => 'STRING', LENGTH => 2);
our $err_type = TYPE->new(NAME => 'ERROR', LENGTH => 0);
our $symbol_table;
our @ST = ();
our $numtablas = 0;

#==================================================================
# Comprueba que dos tipos son iguales
#================================================================== 

sub check_types {
	my ($type1,$type2) = @_;
	if ($type1 ne $type2) {
		Error::fatal("Asignando tipos distintos\n");
	}
}

#==================================================================
# Comprueba que los tipos de los operandos son numericos para la
# operacion $operator
#==================================================================

sub check_type_numeric_operator {
	my ($op1,$op2,$operator) = @_;
	
	my $type = numeric_compatibility($op1,$op2,$operator);
	if ($type == $err_type) {
		Error::fatal("Operandos incompatibles para el operador $operator");
	}
	else {
		return $type;
	}
}

#==================================================================
# Comprueba si el tipo de los operandos es igual o no y si son
# enteros
#==================================================================

sub numeric_compatibility {
	my ($op1,$op2,$operator) = @_;
	
	if (($op1->TYPE == $op2->TYPE) and is_numeric($op1->TYPE)) {
		return $op1->TYPE;
	}
	else {
		return $err_type;
	}
}

#==================================================================
# Subrutina que devuelve true si $type es integer o false si
# no lo es
#==================================================================

sub is_numeric {
	my $type = shift;
	
	return ($type == $int_type);
}
	
#==================================================================
# Subrutina que crea una entrada en la tabla de simbolos para
# cada identificador en @vars con tipo $type
#==================================================================

sub set_types {
	my $type = shift;
	my @vars = @_;
	
	foreach my $var (@vars) {
		if (!exists($symbol_table->{$var})) { $symbol_table->{$var}->{TYPE} = $type; }
		else { Error::fatal("$var se ha declarado dos veces en el mismo ambito\n"); }
	}
}

#==================================================================
# Subrutina que crea una nueva tabla de simbolos, y la establece
# como predefinida
#==================================================================

sub new_block {
	my %tabla;
	push @ST,\%tabla;
	$numtablas = @ST;
	$symbol_table = $ST[$numtablas - 1];
	return $numtablas;
}

#==================================================================
# Subrutina que elimina la ultima tabla de simbolos, y establece
# como predefinida la tabla anterior
#==================================================================

sub delete_block {
	pop @ST;
	$numtablas = @ST;
	$symbol_table = $ST[$numtablas - 1];
	return $numtablas;
}

#==================================================================
# Subrutina que comprueba que un identificador ha sido declarado
# en este ambito o en uno de los anteriores
#==================================================================

sub existe {
	my $id = shift;
	my @TS;
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
			while (0 < @TS) {
				push @ST,pop @TS;
			}
			$numtablas = @ST;
			$symbol_table = $ST[$numtablas - 1];
			return (1,$type);
		}
	}
}	

#======================================================================
# Comprueba que un identificador este o no declarado
#======================================================================

sub check_declared {
	my $id = shift;
	
	my($existe,$type) = existe($id);
#	if (!exists($symbol_table->{$id})) {
	if ($existe == 0) {
		Error::fatal("$id no ha sido declarado\n");
		set_types($err_type, ($id));
	}
	return $type;
}
1;

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NOMBRE

PL::Semantic::Analysis
 - Modulo en el que se apoya el PL::Syntax::Analysis para realizar las funciones
   de comprobacion de tipo y de ambito

=head1 SINOPSIS

  use PL::Semantic::Analysis;
  my $type = check_declared ($id);
  ...
  $numbloques = new_block;
  ...
  $numbloques = delete_block;
  ...
  check_types($type1,$type2);
  ...
  $type = check_type_numeric_operator($oper1,$oper2,$operacion);
  ...
  set_types($type,@vars);

=head1 DESCRIPCION

  Las funciones importantes son las siguientes:
  
  - check_declared ($id): Comprueba que el identificador $id ha sido declarado
    previamente, y devuelve su tipo. Si no esta declarado canta error y termina
    la ejecucion

  - new_block: Introduce una tabla de simbolos nueva en la pila de tablas de simbolos
    y la establece como predefinida. Esto se hace cada vez que creamos un nuevo bloque

  - delete_block: Quita de la pila de tablas de simbolos la ultima tabla, y establece
    como predefinida la anterior. Esto se hace cada vez que se borra un bloque

  - checktypes($type1,$type2): Comprueba si $type1 == $type2. Si no lo es canta un error
    y finaliza la ejecucion

  - check_type_numeric_operator($oper1,$oper2,$operacion): Comprueba si los tipos de
    ambos operandos son numericamente compatibles. Si no, canta un error y finaliza la
    ejecucion. Si son compatibles, devuelve el tipo de la operacion. 

  - set_types($type,@vars): comprueba si las variables en @vars estan declaradas en la
    tabla de simbolos. Si no lo estan las introduce en la tabla de simbolos con el
    tipo $type.

=head1 EXPORT

  Se exporta las funciones:
  
  check_type_numeric_operator 
  set_types 
  check_declared 
  new_block 
  delete_block 
  check_types

  Se exportan las variables

  $int_type 
  $string_type 
  $err_type

=head1 SEE ALSO

        L<perl>.

=head1 AUTHOR

        Fernandez Barreiro Claudio Manuel, E<lt>alu2791@localdomainE<gt>

=head1 COPYRIGHT AND LICENSE

        Copyright (C) 2005 by Fernandez Barreiro Claudio Manuel

        This library is free software; you can redistribute it and/or modify
        it under the same terms as Perl itself, either Perl version 5.8.5 or,
        at your option, any later version of Perl 5 you may have available.


=cut

