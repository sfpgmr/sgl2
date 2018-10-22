//===========================================================================
//
//  Parsing Expression Grammar of sgl2 
//
//---------------------------------------------------------------------------

{
      

}


//-------------------------------------------------------------------------
//  Declaration
//-------------------------------------------------------------------------

Declaration = DeclarationSpecifiers InitDeclaratorList? SEMI //{}

DeclarationSpecifiers
   = ((TypeQualifier
         / FunctionSpecifier
       )*
       TypeName
       ( TypeQualifier
         / FunctionSpecifier
       )*
      )     //{DeclarationSpecifiers}
      / ( TypeSpecifier
        / TypeQualifier
        / FunctionSpecifier
      )+    //{DeclarationSpecifiers}

InitDeclaratorList = InitDeclarator (COMMA InitDeclarator)* //{}

InitDeclarator = Declarator (EQU Initializer)? //{}


TypeSpecifier
   = VOID
      / I8
      / U8
      / I16
      / U16
      / I32
      / U32
      / I64
      / U64
      / F32
      / F64
      / BOOL
      / TypeSpecifier
      / EnumSpecifier

TypeSpecifier
   = 'type'
      ( Identifier? LWING TypeDeclaration* RWING
        / Identifier
      )


TypeDeclaration = ( SpecifierQualifierList TypeDeclaratorList? )? SEMI

SpecifierQualifierList
   = ( TypeQualifier*
        TypeName
        TypeQualifier*
      )
      / ( TypeSpecifier
        / TypeQualifier
      )+

TypeDeclaratorList = TypeDeclarator (COMMA TypeDeclarator)*

TypeDeclarator
   = Declarator? COLON ConstantExpression
      / Declarator

EnumSpecifier
    = ENUM
      ( Identifier? LWING EnumeratorList COMMA? RWING
        / Identifier
      )

EnumeratorList = Enumerator (COMMA Enumerator)*

Enumerator = EnumerationConstant (EQU ConstantExpression)?

TypeQualifier
   = CONST

FunctionSpecifier = EXPORT

Declarator = Pointer? DirectDeclarator //{}

DirectDeclarator
   = ( Identifier
        / LPAR Declarator RPAR
      )
      ( LBRK TypeQualifier* AssignmentExpression? RBRK
        / LBRK STATIC TypeQualifier* AssignmentExpression RBRK
        / LBRK TypeQualifier+ STATIC AssignmentExpression RBRK
        / LBRK TypeQualifier* STAR RBRK
        / LPAR ParameterTypeList RPAR
        / LPAR IdentifierList? RPAR
      )* //{}

Pointer = ( STAR TypeQualifier* )+

ParameterTypeList = ParameterList (COMMA ELLIPSIS)?

ParameterList = ParameterDeclaration (COMMA ParameterDeclaration)*

ParameterDeclaration
   = DeclarationSpecifiers
      ( Declarator
        / AbstractDeclarator
      )?

IdentifierList = Identifier (COMMA Identifier)*

TypeName = SpecifierQualifierList AbstractDeclarator?

AbstractDeclarator
   = Pointer? DirectAbstractDeclarator
      / Pointer

DirectAbstractDeclarator
   = ( LPAR AbstractDeclarator RPAR
        / LBRK (AssignmentExpression / STAR)? RBRK
        / LPAR ParameterTypeList? RPAR
      )
      ( LBRK (AssignmentExpression / STAR)? RBRK
        / LPAR ParameterTypeList? RPAR
      )*

TypeName =Identifier //{&TypeName}

Initializer
   = AssignmentExpression
      / LWING InitializerList COMMA? RWING

InitializerList = Designation? Initializer (COMMA Designation? Initializer)*

Designation = Designator+ EQU

Designator
   = LBRK ConstantExpression RBRK
      / DOT Identifier


//-------------------------------------------------------------------------
//  A.2.3  Statements
//-------------------------------------------------------------------------

Statement
   = LabeledStatement
      / CompoundStatement
      / ExpressionStatement
      / SelectionStatement
      / IterationStatement
      / JumpStatement

LabeledStatement
   = Identifier COLON Statement
      / CASE ConstantExpression COLON Statement
      / DEFAULT COLON Statement

CompoundStatement = LWING ( Declaration / Statement )* RWING

ExpressionStatement = Expression? SEMI

SelectionStatement
   = IF LPAR Expression RPAR Statement (ELSE Statement)?
      / SWITCH LPAR Expression RPAR Statement

IterationStatement
   = WHILE LPAR Expression RPAR Statement
      / DO Statement WHILE LPAR Expression RPAR SEMI
      / FOR LPAR Expression? SEMI Expression? SEMI Expression? RPAR Statement
      / FOR LPAR Declaration Expression? SEMI Expression? RPAR Statement

JumpStatement
   = GOTO Identifier SEMI
      / CONTINUE SEMI
      / BREAK SEMI
      / RETURN Expression? SEMI


//-------------------------------------------------------------------------
// Expressions
//-------------------------------------------------------------------------

PrimaryExpression
   = Identifier
      / Constant
      / StringLiteral
      / LPAR Expression RPAR

PostfixExpression
   = ( PrimaryExpression
        / LPAR TypeName RPAR LWING InitializerList COMMA? RWING
      )
      ( LBRK Expression RBRK
        / LPAR ArgumentExpressionList? RPAR
        / DOT Identifier
        / PTR Identifier
        / INC
        / DEC
      )*

ArgumentExpressionList = AssignmentExpression (COMMA AssignmentExpression)*

UnaryExpression
   = PostfixExpression
      / INC UnaryExpression
      / DEC UnaryExpression
      / UnaryOperator CastExpression
      / SIZEOF (UnaryExpression / LPAR TypeName RPAR )

UnaryOperator
   = AND
      / STAR
      / PLUS
      / MINUS
      / TILDA
      / BANG

CastExpression = (LPAR TypeName RPAR CastExpression) / UnaryExpression

MultiplicativeExpression = CastExpression ((STAR / DIV / MOD) CastExpression)*

AdditiveExpression = MultiplicativeExpression ((PLUS / MINUS) MultiplicativeExpression)*

ShiftExpression = AdditiveExpression ((LEFT / RIGHT) AdditiveExpression)*

RelationalExpression = ShiftExpression ((LE / GE / LT / GT) ShiftExpression)*

EqualityExpression = RelationalExpression ((EQUEQU / BANGEQU) RelationalExpression)*

ANDExpression = EqualityExpression (AND EqualityExpression)*

ExclusiveORExpression = ANDExpression (HAT ANDExpression)*

InclusiveORExpression = ExclusiveORExpression (OR ExclusiveORExpression)*

LogicalANDExpression = InclusiveORExpression (ANDAND InclusiveORExpression)*

LogicalORExpression = LogicalANDExpression (OROR LogicalANDExpression)*

ConditionalExpression = LogicalORExpression (QUERY Expression COLON LogicalORExpression)*

AssignmentExpression
   = UnaryExpression AssignmentOperator AssignmentExpression
      / ConditionalExpression

AssignmentOperator
   = EQU
      / STAREQU
      / DIVEQU
      / MODEQU
      / PLUSEQU
      / MINUSEQU
      / LEFTEQU
      / RIGHTEQU
      / ANDEQU
      / HATEQU
      / OREQU

Expression = AssignmentExpression (COMMA AssignmentExpression)*

ConstantExpression = ConditionalExpression


//-------------------------------------------------------------------------
//  Lexical elements
//  Tokens are: Keyword, Identifier, Constant, StringLiteral, Punctuator.
//  Tokens are separated by Spacing.
//-------------------------------------------------------------------------

Spacing
   = ( WhiteSpace
        / LongComment
        / LineComment
        / Pragma
      )*

WhiteSpace  = [ \n\r\t]             // 7.4.1.10 [\u000B\u000C]

LongComment = '/*' (!'*/'.)* '*/'   // 6.4.9

LineComment = '//' (!'\n' .)*       // 6.4.9

Pragma      = '//'  (!'\n' .)*       // Treat pragma as comment


//-------------------------------------------------------------------------
//  Keywords
//-------------------------------------------------------------------------

AS        = 'as'        !IdChar Spacing
BOOL      = 'bool'      !IdChar Spacing
BREAK     = 'break'     !IdChar Spacing
CASE      = 'case'      !IdChar Spacing
CONST     = 'const'     !IdChar Spacing
CONTINUE  = 'continue'  !IdChar Spacing
COROUTINE = 'coroutine' !IdChar Spacing
DEFAULT   = 'default'   !IdChar Spacing
DO        = 'do'        !IdChar Spacing
ELSE      = 'else'      !IdChar Spacing
ENUM      = 'enum'      !IdChar Spacing
EXPORT    = 'export'    !IdChar Spacing
F32       = 'f32'       !IdChar Spacing
F64       = 'f64'       !IdChar Spacing
GOTO      = 'goto'      !IdChar Spacing
I8        = 'i8'        !IdChar Spacing
I16       = 'i16'       !IdChar Spacing
I32       = 'i32'       !IdChar Spacing
I64       = 'i64'       !IdChar Spacing
IMPORT    = 'import'    !IdChar Spacing
IF        = 'if'        !IdChar Spacing
INLINE    = 'inline'    !IdChar Spacing
MATRIX    = 'mat'       !IdChar Spacing
PUBLIC    = 'public'    !IdChar Spacing
PRIVATE   = 'private'   !IdChar Spacing
PROTECTED = 'protected' !IdChar Spacing
RETURN    = 'return'    !IdChar Spacing
SIZEOF    = 'sizeof'    !IdChar Spacing
STATIC    = 'static'    !IdChar Spacing
STRING    = 'string'    !IdChar Spacing
SWITCH    = 'switch'    !IdChar Spacing
U8        = 'u8'        !IdChar Spacing
U16       = 'u16'       !IdChar Spacing
U32       = 'u32'       !IdChar Spacing
U64       = 'u64'       !IdChar Spacing
VECTOR    = 'vec'       !IdChar Spacing
VOID      = 'void'      !IdChar Spacing
WHILE     = 'while'     !IdChar Spacing

Keyword
   = ( 
        'as'
        / 'bool'
        / 'break'
        / 'case'
        / 'const'
        / 'continue'
        / 'default'
        / 'do'
        / 'else'
        / 'enum'
        / 'export'
        / 'f32'
        / 'f64'
        / 'for'
        / 'from'
        / 'goto'
        / 'i8'
        / 'i16'
        / 'i32'
        / 'i64'
        / 'if'
        / 'import'
        / 'inline'
        / 'mat'
        / 'public'
        / 'protected'
        / 'private'
        / 'return'
        / 'sizeof'
        / 'string'
        / 'switch'
        / 'u8'
        / 'u16'
        / 'u32'
        / 'u64'
        / 'type'
        / 'vec'
        / 'void'
        / 'while'
      )
    !IdChar


//-------------------------------------------------------------------------
//  Identifiers (識別子)
//-------------------------------------------------------------------------

Identifier = !Keyword IdNondigit IdChar* Spacing //{}

IdNondigit
   = [a-z] / [A-Z] / [_] / [$]
      / UniversalCharacter

IdChar
   = [a-z] / [A-Z] / [0-9] / [_] / [$]
      / UniversalCharacter


//-------------------------------------------------------------------------
//  Universal character names
//-------------------------------------------------------------------------

UniversalCharacter
   = '\\u' HexQuad
      / '\\U' HexQuad HexQuad

HexQuad = HexDigit HexDigit HexDigit HexDigit


//-------------------------------------------------------------------------
//  Constants (定数)
//-------------------------------------------------------------------------

Constant
   = FloatConstant
      / IntegerConstant       // Note: can be a prefix of Float Constant!
      / EnumerationConstant
      / CharacterConstant

IntegerConstant
   = ( DecimalIntegerConstant
        / HexIntegerConstant
        / OctalIntegerConstant
        / BinaryIntegerConstant
      )

DecimalIntegerConstant = [1-9][0-9]* IntegerSuffix?

OctalConstant = OctalIntegerConstant /  OctalFloatConstant
OctalIntegerConstant = OctalPrefix OctalDetail* IntegerSuffix? OctalSuffix
OctalFloatConstant = OctalPrefix OctalDetail* FloatSuffix OctalSuffix
OctalDetail  = OctalDigit / [ ]
OctalDigit   =  [0-7]
OctalPrefix  =  '0o'
OctalSuffix  =  'o'

HexIntegerConstant  = HexPrefix HexDetail+ HexSuffix IntegerSuffix?
HexDetail = HexDigit / '%0020'
HexPrefix       = '0x'
HexSuffix       = 'x'
HexDigit        = [a-f] / [A-F] / [0-9]


BinaryIntegerConstant  = BinaryPrefix BinaryDetail+ BinarySuffix IntegerSuffix?
BinaryDetail = BinaryDigit / [ ]
BinaryDigit = [0-1]

IntegerSuffix
   = UnsignedSuffix? ByteSizeSuffix;

ByteSizeSuffix = ByteSuffix / WordSuffix / LongSuffix;

ByteSuffix      = 's'
WordSuffix      = 'w'
LongSuffix      = 'l'
UnsignedSuffix  = 'u'


FloatConstant
   = ( DecimalFloatConstant
        / HexFloatConstant
        / BinaryFloatConstant 
        / FloatConstant
      )
    FloatSuffix? Spacing

DecimalFloatConstant
   = Fraction Exponent?
      / [0-9]+ Exponent

BinaryFloatConstant  = BinaryPrefix BinaryDetail+ BinarySuffix FloatSuffix?
HexFloatConstant    = HexPrefix HexDetail+ HexSuffix FloatSuffix?

HexFloatConstant2
   = HexPrefix HexFraction BinaryExponent?
      / HexPrefix HexDigit+ BinaryExponent

Fraction
   = [0-9]+ '.' [0-9]+
      

HexFraction
   = HexDigit* '.' HexDigit+
      / HexDigit+ '.'

Exponent = [eE][+\-]? [0-9]+

BinaryExponent = [pP][+\-]? [0-9]+

FloatSuffix = LongSuffix? 'f'  

EnumerationConstant = Identifier

CharConstant =  ['] Char* [']

Char = Escape / !['\n\\] .

Escape
   = SimpleEscape
      / OctalEscape
      / HexEscape
      / UniversalCharacter

SimpleEscape = '\\' ['\"?\\%abfnrtv]
OctalEscape  = '\\' [0-7][0-7]?[0-7]?
HexEscape    = '\\x' HexDigit+


//-------------------------------------------------------------------------
//  String Literals
//-------------------------------------------------------------------------

StringLiteral =  (["] StringChar* ["] Spacing)+
StringChar = Escape / ![\"\n\\] .


//-------------------------------------------------------------------------
//  Punctuators
//-------------------------------------------------------------------------

LBRK      =  '['         Spacing
RBRK      =  ']'         Spacing
LPAR      =  '('         Spacing
RPAR      =  ')'         Spacing
LWING     =  '{'         Spacing
RWING     =  '}'         Spacing
DOT       =  '.'         Spacing
PTR       =  '->'        Spacing
INC       =  '++'        Spacing
DEC       =  '--'        Spacing
AND       =  '&'  ![&]   Spacing
STAR      =  '*'  ![=]   Spacing
PLUS      =  '+'  ![+=]  Spacing
MINUS     =  '-'  ![\-=>] Spacing
TILDA     =  '~'         Spacing
BANG      =  '!'  ![=]   Spacing
DIV       =  '/'  ![=]   Spacing
MOD       =  '%'  ![=>]  Spacing
LEFT      =  '<<' ![=]   Spacing
RIGHT     =  '>>' ![=]   Spacing
LT        =  '<'  ![=]   Spacing
GT        =  '>'  ![=]   Spacing
LE        =  '<='        Spacing
GE        =  '>='        Spacing
EQUEQU    =  '=='        Spacing
BANGEQU   =  '!='        Spacing
HAT       =  '^'  ![=]   Spacing
OR        =  '|'  ![=]   Spacing
ANDAND    =  '&&'        Spacing
OROR      =  '||'        Spacing
QUERY     =  '?'         Spacing
COLON     =  ':'  ![>]   Spacing
SEMI      =  ';'         Spacing
ELLIPSIS  =  '...'       Spacing
EQU       =  '='  !"="   Spacing
STAREQU   =  '*='        Spacing
DIVEQU    =  '/='        Spacing
MODEQU    =  '%='        Spacing
PLUSEQU   =  '+='        Spacing
MINUSEQU  =  '-='        Spacing
LEFTEQU   =  '<<='       Spacing
RIGHTEQU  =  '>>='       Spacing
ANDEQU    =  '&='        Spacing
HATEQU    =  '^='        Spacing
OREQU     =  '|='        Spacing
COMMA     =  ','         Spacing

EOT       =  !.