/**
 * ANTLR (v3) grammar for the Charj Language
 *
 * The other .g files are tree parsers that can read and modify an AST 
 * using the output of this grammar.
 */


grammar Charj;

options {
    backtrack = true; 
    memoize = true;
    output = AST;
    ASTLabelType = CommonTree;
}

tokens {

    // operators and other special chars
    
    AND                     = '&'               ;
    AND_ASSIGN              = '&='              ;
    ASSIGN                  = '='               ;
    AT                      = '@'               ;
    BIT_SHIFT_RIGHT         = '>>>'             ;
    BIT_SHIFT_RIGHT_ASSIGN  = '>>>='            ;
    COLON                   = ':'               ;
    COMMA                   = ','               ;
    DEC                     = '--'              ;
    DIV                     = '/'               ;
    DIV_ASSIGN              = '/='              ;
    DOT                     = '.'               ;
    DOTSTAR                 = '.*'              ;
    ELLIPSIS                = '...'             ;
    EQUAL                   = '=='              ;
    GREATER_OR_EQUAL        = '>='              ;
    GREATER_THAN            = '>'               ;
    INC                     = '++'              ;
    LBRACK                  = '['               ;
    LCURLY                  = '{'               ;
    LESS_OR_EQUAL           = '<='              ;
    LESS_THAN               = '<'               ;
    LOGICAL_AND             = '&&'              ;
    LOGICAL_NOT             = '!'               ;
    LOGICAL_OR              = '||'              ;
    LPAREN                  = '('               ;
    MINUS                   = '-'               ;
    MINUS_ASSIGN            = '-='              ;
    MOD                     = '%'               ;
    MOD_ASSIGN              = '%='              ;
    NOT                     = '~'               ;
    NOT_EQUAL               = '!='              ;
    OR                      = '|'               ;
    OR_ASSIGN               = '|='              ;
    PLUS                    = '+'               ;
    PLUS_ASSIGN             = '+='              ;
    QUESTION                = '?'               ;
    RBRACK                  = ']'               ;
    RCURLY                  = '}'               ;
    RPAREN                  = ')'               ;
    SEMI                    = ';'               ;
    SHIFT_LEFT              = '<<'              ;
    SHIFT_LEFT_ASSIGN       = '<<='             ;
    SHIFT_RIGHT             = '>>'              ;
    SHIFT_RIGHT_ASSIGN      = '>>='             ;
    STAR                    = '*'               ;
    STAR_ASSIGN             = '*='              ;
    XOR                     = '^'               ;
    XOR_ASSIGN              = '^='              ;

    // keywords
    
    ABSTRACT                = 'abstract'        ;
    ASSERT                  = 'assert'          ;
    BOOLEAN                 = 'boolean'         ;
    BREAK                   = 'break'           ;
    BYTE                    = 'byte'            ;
    CASE                    = 'case'            ;
    CATCH                   = 'catch'           ;
    CHAR                    = 'char'            ;
    CLASS                   = 'class'           ;
    CONTINUE                = 'continue'        ;
    DEFAULT                 = 'default'         ;
    DO                      = 'do'              ;
    DOUBLE                  = 'double'          ;
    ELSE                    = 'else'            ;
    ENUM                    = 'enum'            ;
    EXTENDS                 = 'extends'         ;
    FALSE                   = 'false'           ;
    FINAL                   = 'final'           ;
    FINALLY                 = 'finally'         ;
    FLOAT                   = 'float'           ;
    FOR                     = 'for'             ;
    IF                      = 'if'              ;
    IMPLEMENTS              = 'implements'      ;
    INSTANCEOF              = 'instanceof'      ;
    INTERFACE               = 'interface'       ;
    IMPORT                  = 'import'          ;
    INT                     = 'int'             ;
    LONG                    = 'long'            ;
    NATIVE                  = 'native'          ;
    NEW                     = 'new'             ;
    NULL                    = 'null'            ;
    PACKAGE                 = 'package'         ;
    PRIVATE                 = 'private'         ;
    PROTECTED               = 'protected'       ;
    PUBLIC                  = 'public'          ;
    ENTRY                   = 'entry'           ;
    RETURN                  = 'return'          ;
    SHORT                   = 'short'           ;
    STATIC                  = 'static'          ;
    SUPER                   = 'super'           ;
    SWITCH                  = 'switch'          ;
    SYNCHRONIZED            = 'synchronized'    ;
    THIS                    = 'this'            ;
    THROW                   = 'throw'           ;
    THROWS                  = 'throws'          ;
    TRANSIENT               = 'transient'       ;
    TRUE                    = 'true'            ;
    TRY                     = 'try'             ;
    VOID                    = 'void'            ;
    VOLATILE                = 'volatile'        ;
    WHILE                   = 'while'           ;
    
    // tokens for imaginary nodes
    
    ARGUMENT_LIST;
    ARRAY_DECLARATOR;
    ARRAY_DECLARATOR_LIST;
    ARRAY_ELEMENT_ACCESS;
    ARRAY_INITIALIZER;
    BLOCK_SCOPE;
    CAST_EXPR;
    CATCH_CLAUSE_LIST;
    CLASS_CONSTRUCTOR_CALL;
    CLASS_INSTANCE_INITIALIZER;
    CLASS_STATIC_INITIALIZER;
    CLASS_TOP_LEVEL_SCOPE;
    CONSTRUCTOR_DECL;
    ENUM_TOP_LEVEL_SCOPE;
    EXPR;
    EXTENDS_BOUND_LIST;
    EXTENDS_CLAUSE;
    FOR_CONDITION;
    FOR_EACH;
    FOR_INIT;
    FOR_UPDATE;
    FORMAL_PARAM_LIST;
    FORMAL_PARAM_STD_DECL;
    FORMAL_PARAM_VARARG_DECL;
    FUNCTION_METHOD_DECL;
    GENERIC_TYPE_ARG_LIST;
    GENERIC_TYPE_PARAM_LIST;
    INTERFACE_TOP_LEVEL_SCOPE;
    IMPLEMENTS_CLAUSE;
    LABELED_STATEMENT;
    LOCAL_MODIFIER_LIST;
    CHARJ_SOURCE;
    METHOD_CALL;
    MODIFIER_LIST;
    PARENTESIZED_EXPR;
    POST_DEC;
    POST_INC;
    PRE_DEC;
    PRE_INC;
    QUALIFIED_TYPE_IDENT;
    STATIC_ARRAY_CREATOR;
    SUPER_CONSTRUCTOR_CALL;
    SWITCH_BLOCK_LABEL_LIST;
    THIS_CONSTRUCTOR_CALL;
    THROWS_CLAUSE;
    TYPE;
    UNARY_MINUS;
    UNARY_PLUS;
    VAR_DECLARATION;
    VAR_DECLARATOR;
    VAR_DECLARATOR_LIST;
    VOID_METHOD_DECL;
}

@header {
package charj.translator;
}

@members {
    
    private boolean mMessageCollectionEnabled = false;
    private boolean mHasErrors = false;
    private List<String> mMessages;

    /**
     *  Switches error message collection on or of.
     *
     *  The standard destination for parser error messages is <code>System.err</code>.
     *  However, if <code>true</code> gets passed to this method this default
     *  behaviour will be switched off and all error messages will be collected
     *  instead of written to anywhere.
     *
     *  The default value is <code>false</code>.
     *
     *  @param pNewState  <code>true</code> if error messages should be collected.
     */
    public void enableErrorMessageCollection(boolean pNewState) {
        mMessageCollectionEnabled = pNewState;
        if (mMessages == null && mMessageCollectionEnabled) {
            mMessages = new ArrayList<String>();
        }
    }
    
    /**
     *  Collects an error message or passes the error message to <code>
     *  super.emitErrorMessage(...)</code>.
     *
     *  The actual behaviour depends on whether collecting error messages
     *  has been enabled or not.
     *
     *  @param pMessage  The error message.
     */
     @Override
    public void emitErrorMessage(String pMessage) {
        if (mMessageCollectionEnabled) {
            mMessages.add(pMessage);
        } else {
            super.emitErrorMessage(pMessage);
        }
    }
    
    /**
     *  Returns collected error messages.
     *
     *  @return  A list holding collected error messages or <code>null</code> if
     *           collecting error messages hasn't been enabled. Of course, this
     *           list may be empty if no error message has been emited.
     */
    public List<String> getMessages() {
        return mMessages;
    }
    
    /**
     *  Tells if parsing a Charj source has caused any error messages.
     *
     *  @return  <code>true</code> if parsing a Charj source has caused at least
     *           one error message.
     */
    public boolean hasErrors() {
        return mHasErrors;
    }
}

@lexer::header {
package charj.translator; 
}

@lexer::members {
/** 
 *  Determines if whitespaces and comments should be preserved or thrown away.
 *
 *  If <code>true</code> whitespaces and comments will be preserved within the
 *  hidden channel, otherwise the appropriate tokens will be skiped. This is
 *  a 'little bit' expensive.
 */
public boolean preserveWhitespacesAndComments = true;
}

// Starting point for parsing a Charj file.
charjSource
    :   compilationUnit
        ->  ^(CHARJ_SOURCE compilationUnit)
    ;

compilationUnit
    :   packageDeclaration? 
        importDeclaration* 
        typeDecls*
    ;

typeDecls
    :   typeDeclaration
    |   SEMI!
    ;

packageDeclaration
    :   PACKAGE^ qualifiedIdentifier SEMI!  
    ;
    
importDeclaration
    :   IMPORT^ STATIC? qualifiedIdentifier DOTSTAR? SEMI!
    ;
    
typeDeclaration
    :   modifierList!
        (   classTypeDeclaration[$modifierList.tree]
        |   interfaceTypeDeclaration[$modifierList.tree]
        |   enumTypeDeclaration[$modifierList.tree]
        )
    ;
    
classTypeDeclaration[CommonTree modifiers]
    :   CLASS IDENT genericTypeParameterList? classExtendsClause? implementsClause? classBody
        ->  ^(CLASS {$modifiers} IDENT genericTypeParameterList? classExtendsClause? implementsClause? classBody)
    ;
    
classExtendsClause
    :   EXTENDS type
        ->  ^(EXTENDS_CLAUSE[$EXTENDS, "EXTENDS_CLAUSE"] type)
    ;   
    
interfaceExtendsClause
    :   EXTENDS typeList
        ->  ^(EXTENDS_CLAUSE[$EXTENDS, "EXTENDS_CLAUSE"] typeList)
    ;   
    
implementsClause
    :   IMPLEMENTS typeList
        ->  ^(IMPLEMENTS_CLAUSE[$IMPLEMENTS, "IMPLEMENTS_CLAUSE"] typeList)
    ;
        
genericTypeParameterList
    :   LESS_THAN genericTypeParameter (COMMA genericTypeParameter)* genericTypeListClosing
        ->  ^(GENERIC_TYPE_PARAM_LIST[$LESS_THAN, "GENERIC_TYPE_PARAM_LIST"] genericTypeParameter+)
    ;

genericTypeListClosing  // This 'trick' is fairly dirty - if there's some time a better solution should 
                        // be found to resolve the problem with nested generic type parameter lists 
                        // (i.e. <T1 extends AnyType<T2>> for generic type parameters or <T1<T2>> for 
                        // generic type arguments etc). 
    :   GREATER_THAN
    |   SHIFT_RIGHT
    |   BIT_SHIFT_RIGHT
    |   // nothing
    ;

genericTypeParameter
    :   IDENT bound?
        ->  ^(IDENT bound?)
    ;
        
bound
    :   EXTENDS type (AND type)*
        ->  ^(EXTENDS_BOUND_LIST[$EXTENDS, "EXTENDS_BOUND_LIST"] type+)
    ;

enumTypeDeclaration[CommonTree modifiers]
    :   ENUM IDENT implementsClause? enumBody
        ->  ^(ENUM {$modifiers} IDENT implementsClause? enumBody)
    ;
    
enumBody
    :   LCURLY enumScopeDeclarations RCURLY
        ->  ^(ENUM_TOP_LEVEL_SCOPE[$LCURLY, "ENUM_TOP_LEVEL_SCOPE"] enumScopeDeclarations)
    ;

enumScopeDeclarations
    :   enumConstants (COMMA!)? enumClassScopeDeclarations?
    ;

enumClassScopeDeclarations
    :   SEMI classScopeDeclarations*
        ->  ^(CLASS_TOP_LEVEL_SCOPE[$SEMI, "CLASS_TOP_LEVEL_SCOPE"] classScopeDeclarations*)
    ;

enumConstants
    :   enumConstant (COMMA! enumConstant)*
    ;
    
enumConstant
    :   IDENT^ arguments? classBody?
    ;
    
interfaceTypeDeclaration[CommonTree modifiers]
    :   INTERFACE IDENT genericTypeParameterList? interfaceExtendsClause? interfaceBody
        ->  ^(INTERFACE {$modifiers} IDENT genericTypeParameterList? interfaceExtendsClause? interfaceBody)
    ;
    
typeList
    :   type (COMMA! type)*
    ;
    
classBody
    :   LCURLY classScopeDeclarations* RCURLY
        ->  ^(CLASS_TOP_LEVEL_SCOPE[$LCURLY, "CLASS_TOP_LEVEL_SCOPE"] classScopeDeclarations*)
    ;
    
interfaceBody
    :   LCURLY interfaceScopeDeclarations* RCURLY
        ->  ^(INTERFACE_TOP_LEVEL_SCOPE[$LCURLY, "CLASS_TOP_LEVEL_SCOPE"] interfaceScopeDeclarations*)
    ;

classScopeDeclarations
    :   block           ->  ^(CLASS_INSTANCE_INITIALIZER block)
    |   STATIC block    ->  ^(CLASS_STATIC_INITIALIZER[$STATIC, "CLASS_STATIC_INITIALIZER"] block)
    |   modifierList
        (   genericTypeParameterList?
            (   type IDENT formalParameterList arrayDeclaratorList? throwsClause? (block | SEMI)
                ->  ^(FUNCTION_METHOD_DECL modifierList genericTypeParameterList? type IDENT formalParameterList arrayDeclaratorList? throwsClause? block?)
            |   VOID IDENT formalParameterList throwsClause? (block | SEMI)
                ->  ^(VOID_METHOD_DECL modifierList genericTypeParameterList? IDENT formalParameterList throwsClause? block?)
            |   ident=IDENT formalParameterList throwsClause? block
                ->  ^(CONSTRUCTOR_DECL[$ident, "CONSTRUCTOR_DECL"] modifierList genericTypeParameterList? IDENT formalParameterList throwsClause? block)
                //->  ^(CONSTRUCTOR_DECL[$ident, $ident.text] modifierList genericTypeParameterList? formalParameterList throwsClause? block)
            )
        |   type classFieldDeclaratorList SEMI
            ->  ^(VAR_DECLARATION modifierList type classFieldDeclaratorList)
        )
    |   typeDeclaration
    |   SEMI!
    ;
            
interfaceScopeDeclarations
    :   modifierList
        (   genericTypeParameterList?
            (   type IDENT formalParameterList arrayDeclaratorList? throwsClause? SEMI
                ->  ^(FUNCTION_METHOD_DECL modifierList genericTypeParameterList? type IDENT formalParameterList arrayDeclaratorList? throwsClause?)
            |   VOID IDENT formalParameterList throwsClause? SEMI
                ->  ^(VOID_METHOD_DECL modifierList genericTypeParameterList? IDENT formalParameterList throwsClause?)
            )
        |   type interfaceFieldDeclaratorList SEMI
            ->  ^(VAR_DECLARATION modifierList type interfaceFieldDeclaratorList)
        )
    |   typeDeclaration
    |   SEMI!
    ;

classFieldDeclaratorList
    :   classFieldDeclarator (COMMA classFieldDeclarator)*
        ->  ^(VAR_DECLARATOR_LIST classFieldDeclarator+)
    ;

classFieldDeclarator
    :   variableDeclaratorId (ASSIGN variableInitializer)?
        ->  ^(VAR_DECLARATOR variableDeclaratorId variableInitializer?)
    ;
    
interfaceFieldDeclaratorList
    :   interfaceFieldDeclarator (COMMA interfaceFieldDeclarator)*
        ->  ^(VAR_DECLARATOR_LIST interfaceFieldDeclarator+)
    ;

interfaceFieldDeclarator
    :   variableDeclaratorId ASSIGN variableInitializer
        ->  ^(VAR_DECLARATOR variableDeclaratorId variableInitializer)
    ;
    
variableDeclaratorId
    :   IDENT^ arrayDeclaratorList?
    ;

variableInitializer
    :   arrayInitializer
    |   expression
    ;

arrayDeclarator
    :   LBRACK RBRACK
        ->  ^(ARRAY_DECLARATOR)
    ;

arrayDeclaratorList
    :   arrayDeclarator+
        ->  ^(ARRAY_DECLARATOR_LIST arrayDeclarator+)   
    ;
    
arrayInitializer
    :   LCURLY (variableInitializer (COMMA variableInitializer)* COMMA?)? RCURLY
        ->  ^(ARRAY_INITIALIZER[$LCURLY, "ARRAY_INITIALIZER"] variableInitializer*)
    ;

throwsClause
    :   THROWS qualifiedIdentList
        ->  ^(THROWS_CLAUSE[$THROWS, "THROWS_CLAUSE"] qualifiedIdentList)
    ;

modifierList
    :   modifier*   
        ->  ^(MODIFIER_LIST modifier*)
    ;

modifier
    :   PUBLIC
    |   PROTECTED
    |   ENTRY
    |   PRIVATE
    |   STATIC
    |   ABSTRACT
    |   NATIVE
    |   SYNCHRONIZED
    |   TRANSIENT
    |   VOLATILE
    |   localModifier
    ;

localModifierList
    :   localModifier*
        -> ^(LOCAL_MODIFIER_LIST localModifier*)
    ;
    
localModifier
    :   FINAL
    ;

type
    :   simpleType
    |   objectType
    ;

simpleType // including static arrays of simple type elements
    :   primitiveType arrayDeclaratorList?
        ->  ^(TYPE primitiveType arrayDeclaratorList?)  
    ;
    
objectType // including static arrays of object type reference elements
    :   qualifiedTypeIdent arrayDeclaratorList?
        ->  ^(TYPE qualifiedTypeIdent arrayDeclaratorList?)
    ;

objectTypeSimplified
    :   qualifiedTypeIdentSimplified arrayDeclaratorList?
        ->  ^(TYPE qualifiedTypeIdentSimplified arrayDeclaratorList?)
    ;

qualifiedTypeIdent
    :   typeIdent (DOT typeIdent)*
        ->  ^(QUALIFIED_TYPE_IDENT typeIdent+) 
    ;

qualifiedTypeIdentSimplified
    :   typeIdentSimplified (DOT typeIdentSimplified)*
        ->  ^(QUALIFIED_TYPE_IDENT typeIdentSimplified+) 
    ;

typeIdent
    :   IDENT^ genericTypeArgumentList?
    ;

typeIdentSimplified
    :   IDENT^ genericTypeArgumentListSimplified?
    ;

primitiveType
    :   BOOLEAN
    |   CHAR
    |   BYTE
    |   SHORT
    |   INT
    |   LONG
    |   FLOAT
    |   DOUBLE
    ;

genericTypeArgumentList
    :   LESS_THAN genericTypeArgument (COMMA genericTypeArgument)* genericTypeListClosing
        ->  ^(GENERIC_TYPE_ARG_LIST[$LESS_THAN, "GENERIC_TYPE_ARG_LIST"] genericTypeArgument+)
    ;

genericTypeArgument
    :   type
    |   QUESTION genericWildcardBoundType?
        ->  ^(QUESTION genericWildcardBoundType?)
    ;
    
genericWildcardBoundType
    :   (EXTENDS | SUPER)^ type
    ;

genericTypeArgumentListSimplified
    :   LESS_THAN genericTypeArgumentSimplified (COMMA genericTypeArgumentSimplified)* genericTypeListClosing
        ->  ^(GENERIC_TYPE_ARG_LIST[$LESS_THAN, "GENERIC_TYPE_ARG_LIST"] genericTypeArgumentSimplified+)
    ;
    
genericTypeArgumentSimplified
    :   type
    |   QUESTION
    ;
    
qualifiedIdentList
    :   qualifiedIdentifier (COMMA! qualifiedIdentifier)*
    ;
    
formalParameterList
    :   LPAREN 
        (   // Contains at least one standard argument declaration and optionally a variable argument declaration.
            formalParameterStandardDecl (COMMA formalParameterStandardDecl)* (COMMA formalParameterVarArgDecl)? 
            ->  ^(FORMAL_PARAM_LIST[$LPAREN, "FORMAL_PARAM_LIST"] formalParameterStandardDecl+ formalParameterVarArgDecl?) 
            // Contains a variable argument declaration only.
        |   formalParameterVarArgDecl
            ->  ^(FORMAL_PARAM_LIST[$LPAREN, "FORMAL_PARAM_LIST"] formalParameterVarArgDecl) 
            // Contains nothing.
        |   ->  ^(FORMAL_PARAM_LIST[$LPAREN, "FORMAL_PARAM_LIST"]) 
        )
        RPAREN
    ;
    
formalParameterStandardDecl
    :   localModifierList type variableDeclaratorId
        ->  ^(FORMAL_PARAM_STD_DECL localModifierList type variableDeclaratorId)
    ;
    
formalParameterVarArgDecl
    :   localModifierList type ELLIPSIS variableDeclaratorId
        ->  ^(FORMAL_PARAM_VARARG_DECL localModifierList type variableDeclaratorId)
    ;
    
qualifiedIdentifier
    :   (   IDENT               ->  IDENT
        )
        (   DOT ident=IDENT     ->  ^(DOT $qualifiedIdentifier $ident)
        )*
    ;
    
block
    :   LCURLY blockStatement* RCURLY
        ->  ^(BLOCK_SCOPE[$LCURLY, "BLOCK_SCOPE"] blockStatement*)
    ;

blockStatement
    :   localVariableDeclaration SEMI!
    |   typeDeclaration
    |   statement
    ;
    
localVariableDeclaration
    :   localModifierList type classFieldDeclaratorList
        ->  ^(VAR_DECLARATION localModifierList type classFieldDeclaratorList)
    ;
    
        
statement
    :   block
    |   ASSERT expr1=expression 
        (   COLON expr2=expression SEMI                                     ->  ^(ASSERT $expr1 $expr2)
        |   SEMI                                                            ->  ^(ASSERT $expr1)
        )
    |   IF parenthesizedExpression ifStat=statement 
        (   ELSE elseStat=statement                                         ->  ^(IF parenthesizedExpression $ifStat $elseStat)
        |                                                                   ->  ^(IF parenthesizedExpression $ifStat)
        )   
    |   FOR LPAREN 
        (   forInit SEMI forCondition SEMI forUpdater RPAREN statement      ->  ^(FOR forInit forCondition forUpdater statement) 
        |   localModifierList type IDENT COLON expression RPAREN statement
                                                                            ->  ^(FOR_EACH[$FOR, "FOR_EACH"] localModifierList type IDENT expression statement)
        ) 
    |   WHILE parenthesizedExpression statement                             ->  ^(WHILE parenthesizedExpression statement)
    |   DO statement WHILE parenthesizedExpression SEMI                     ->  ^(DO statement parenthesizedExpression)
    |   TRY block (catches finallyClause? | finallyClause)                  ->  ^(TRY block catches? finallyClause?)
    |   SWITCH parenthesizedExpression LCURLY switchBlockLabels RCURLY      ->  ^(SWITCH parenthesizedExpression switchBlockLabels)
    |   SYNCHRONIZED parenthesizedExpression block                          ->  ^(SYNCHRONIZED parenthesizedExpression block)
    |   RETURN expression? SEMI                                             ->  ^(RETURN expression?)
    |   THROW expression SEMI                                               ->  ^(THROW expression)
    |   BREAK IDENT? SEMI                                                   ->  ^(BREAK IDENT?)
    |   CONTINUE IDENT? SEMI                                                ->  ^(CONTINUE IDENT?)
    |   IDENT COLON statement                                               ->  ^(LABELED_STATEMENT IDENT statement)
    |   expression SEMI!
    |   SEMI // Preserve empty statements.
    ;           
        
catches
    :   catchClause+
        ->  ^(CATCH_CLAUSE_LIST catchClause+)
    ;
    
catchClause
    :   CATCH^ LPAREN! formalParameterStandardDecl RPAREN! block
    ;

finallyClause
    :   FINALLY block
        ->  block
    ;

switchBlockLabels
    :   switchCaseLabels switchDefaultLabel? switchCaseLabels
        ->  ^(SWITCH_BLOCK_LABEL_LIST switchCaseLabels switchDefaultLabel? switchCaseLabels)
    ;
    
switchCaseLabels
    :   switchCaseLabel*
    ;
        
switchCaseLabel
    :   CASE^ expression COLON! blockStatement*
    ;
    
switchDefaultLabel
    :   DEFAULT^ COLON! blockStatement*
    ;
    
forInit
    :   localVariableDeclaration    ->  ^(FOR_INIT localVariableDeclaration)
    |   expressionList              ->  ^(FOR_INIT expressionList)
    |                               ->  ^(FOR_INIT)
    ;
    
forCondition
    :   expression?
        ->  ^(FOR_CONDITION expression?)
    ;
    
forUpdater
    :   expressionList?
        ->  ^(FOR_UPDATE expressionList?)
    ;

// EXPRESSIONS

parenthesizedExpression
    :   LPAREN expression RPAREN
        ->  ^(PARENTESIZED_EXPR[$LPAREN, "PARENTESIZED_EXPR"] expression)
    ;
    
expressionList
    :   expression (COMMA! expression)*
    ;

expression
    :   assignmentExpression
        ->  ^(EXPR assignmentExpression)
    ;

assignmentExpression
    :   conditionalExpression 
        (   (   ASSIGN^
            |   PLUS_ASSIGN^
            |   MINUS_ASSIGN^
            |   STAR_ASSIGN^
            |   DIV_ASSIGN^
            |   AND_ASSIGN^
            |   OR_ASSIGN^
            |   XOR_ASSIGN^
            |   MOD_ASSIGN^
            |   SHIFT_LEFT_ASSIGN^
            |   SHIFT_RIGHT_ASSIGN^
            |   BIT_SHIFT_RIGHT_ASSIGN^
        ) 
        assignmentExpression)?
    ;
    
conditionalExpression
    :   logicalOrExpression (QUESTION^ assignmentExpression COLON! conditionalExpression)?
    ;

logicalOrExpression
    :   logicalAndExpression (LOGICAL_OR^ logicalAndExpression)*
    ;

logicalAndExpression
    :   inclusiveOrExpression (LOGICAL_AND^ inclusiveOrExpression)*
    ;

inclusiveOrExpression
    :   exclusiveOrExpression (OR^ exclusiveOrExpression)*
    ;

exclusiveOrExpression
    :   andExpression (XOR^ andExpression)*
    ;

andExpression
    :   equalityExpression (AND^ equalityExpression)*
    ;

equalityExpression
    :   instanceOfExpression 
        (   (   EQUAL^
            |   NOT_EQUAL^
            ) 
            instanceOfExpression
        )*
    ;

instanceOfExpression
    :   relationalExpression (INSTANCEOF^ type)?
    ;

relationalExpression
    :   shiftExpression 
        (   (   LESS_OR_EQUAL^
            |   GREATER_OR_EQUAL^
            |   LESS_THAN^
            |   GREATER_THAN^
            )
            shiftExpression
        )*
    ;
    
shiftExpression
    :   additiveExpression
        (   (   BIT_SHIFT_RIGHT^
            |   SHIFT_RIGHT^
            |   SHIFT_LEFT^
            )
            additiveExpression
        )*
    ;

additiveExpression
    :   multiplicativeExpression
        (   (   PLUS^
            |   MINUS^
            )
            multiplicativeExpression
        )*
    ;

multiplicativeExpression
    :   unaryExpression 
        (   (   STAR^
            |   DIV^
            |   MOD^
            )
            unaryExpression
        )*
    ;
    
unaryExpression
    :   PLUS unaryExpression        ->  ^(UNARY_PLUS[$PLUS, "UNARY_PLUS"] unaryExpression)
    |   MINUS unaryExpression       ->  ^(UNARY_MINUS[$MINUS, "UNARY_MINUS"] unaryExpression)
    |   INC postfixedExpression     ->  ^(PRE_INC[$INC, "PRE_INC"] postfixedExpression)
    |   DEC postfixedExpression     ->  ^(PRE_DEC[$DEC, "PRE_DEC"] postfixedExpression)
    |   unaryExpressionNotPlusMinus
    ;

unaryExpressionNotPlusMinus
    :   NOT unaryExpression                             ->  ^(NOT unaryExpression)
    |   LOGICAL_NOT unaryExpression                     ->  ^(LOGICAL_NOT unaryExpression)
    |   LPAREN type RPAREN unaryExpression              ->  ^(CAST_EXPR[$LPAREN, "CAST_EXPR"] type unaryExpression)
    |   postfixedExpression
    ;
    
postfixedExpression
        // At first resolve the primary expression ...
    :   (   primaryExpression                       ->  primaryExpression
        )
        // ... and than the optional things that may follow a primary expression 0 or more times.
        (   outerDot=DOT                            
            (   (   genericTypeArgumentListSimplified?  // Note: generic type arguments are only valid for method calls, i.e. if there
                                                        //       is an argument list.
                    IDENT                           ->  ^(DOT $postfixedExpression IDENT)
                ) 
                (   arguments                       ->  ^(METHOD_CALL $postfixedExpression genericTypeArgumentListSimplified? arguments)
                )?
            |   THIS                                ->  ^(DOT $postfixedExpression THIS)
            |   Super=SUPER arguments                   ->  ^(SUPER_CONSTRUCTOR_CALL[$Super, "SUPER_CONSTRUCTOR_CALL"] $postfixedExpression arguments)
            |   (   SUPER innerDot=DOT IDENT        ->  ^($innerDot ^($outerDot $postfixedExpression SUPER) IDENT)
                )
                (   arguments                       ->  ^(METHOD_CALL $postfixedExpression arguments)
                )?
            |   innerNewExpression                  ->  ^(DOT $postfixedExpression innerNewExpression)
            )
        |   LBRACK expression RBRACK                ->  ^(ARRAY_ELEMENT_ACCESS $postfixedExpression expression)
        )*
        // At the end there may follow a post increment/decrement.
        (   INC -> ^(POST_INC[$INC, "POST_INC"] $postfixedExpression)
        |   DEC -> ^(POST_DEC[$DEC, "POST_DEC"] $postfixedExpression)
        )?
    ;    
    
primaryExpression
    :   parenthesizedExpression
    |   literal
    |   newExpression
    |   qualifiedIdentExpression
    |   genericTypeArgumentListSimplified 
        (   SUPER
            (   arguments                               ->  ^(SUPER_CONSTRUCTOR_CALL[$SUPER, "SUPER_CONSTRUCTOR_CALL"] genericTypeArgumentListSimplified arguments)
            |   DOT IDENT arguments                     ->  ^(METHOD_CALL ^(DOT SUPER IDENT) genericTypeArgumentListSimplified arguments)
            )
        |   IDENT arguments                             ->  ^(METHOD_CALL IDENT genericTypeArgumentListSimplified arguments)
        |   THIS arguments                              ->  ^(THIS_CONSTRUCTOR_CALL[$THIS, "THIS_CONSTRUCTOR_CALL"] genericTypeArgumentListSimplified arguments)
        )
    |   (   THIS                                        ->  THIS
        )
        (   arguments                                   ->  ^(THIS_CONSTRUCTOR_CALL[$THIS, "THIS_CONSTRUCTOR_CALL"] arguments)
        )?
    |   SUPER arguments                                 ->  ^(SUPER_CONSTRUCTOR_CALL[$SUPER, "SUPER_CONSTRUCTOR_CALL"] arguments)
    |   (   SUPER DOT IDENT
        )
        (   arguments                                   ->  ^(METHOD_CALL ^(DOT SUPER IDENT) arguments)
        |                                               ->  ^(DOT SUPER IDENT)
        )
    |   (   primitiveType                               ->  primitiveType
        )
        (   arrayDeclarator                             ->  ^(arrayDeclarator $primaryExpression)   
        )* 
        DOT CLASS                                       ->  ^(DOT $primaryExpression CLASS)
    |   VOID DOT CLASS                                  ->  ^(DOT VOID CLASS)
    ;
    
qualifiedIdentExpression
        // The qualified identifier itself is the starting point for this rule.
    :   (   qualifiedIdentifier                             ->  qualifiedIdentifier
        )
        // And now comes the stuff that may follow the qualified identifier.
        (   (   arrayDeclarator                         ->  ^(arrayDeclarator $qualifiedIdentExpression)
            )+ 
            (   DOT CLASS                               ->  ^(DOT $qualifiedIdentExpression CLASS)
            )
        |   arguments                                   ->  ^(METHOD_CALL qualifiedIdentifier arguments)
        |   outerDot=DOT
            (   CLASS                                   ->  ^(DOT qualifiedIdentifier CLASS)
            |   genericTypeArgumentListSimplified 
                (   Super=SUPER arguments               ->  ^(SUPER_CONSTRUCTOR_CALL[$Super, "SUPER_CONSTRUCTOR_CALL"] qualifiedIdentifier genericTypeArgumentListSimplified arguments)
                |   SUPER innerDot=DOT IDENT arguments  ->  ^(METHOD_CALL ^($innerDot ^($outerDot qualifiedIdentifier SUPER) IDENT) genericTypeArgumentListSimplified arguments)
                |   IDENT arguments                     ->  ^(METHOD_CALL ^(DOT qualifiedIdentifier IDENT) genericTypeArgumentListSimplified arguments)
                )
            |   THIS                                    ->  ^(DOT qualifiedIdentifier THIS)
            |   Super=SUPER arguments                   ->  ^(SUPER_CONSTRUCTOR_CALL[$Super, "SUPER_CONSTRUCTOR_CALL"] qualifiedIdentifier arguments)
            |   innerNewExpression                      ->  ^(DOT qualifiedIdentifier innerNewExpression)
            )
        )?
    ;

newExpression
    :   NEW  
        (   primitiveType newArrayConstruction      // new static array of primitive type elements
            ->  ^(STATIC_ARRAY_CREATOR[$NEW, "STATIC_ARRAY_CREATOR"] primitiveType newArrayConstruction)
        |   genericTypeArgumentListSimplified? qualifiedTypeIdentSimplified
            (   newArrayConstruction                // new static array of object type reference elements
                ->  ^(STATIC_ARRAY_CREATOR[$NEW, "STATIC_ARRAY_CREATOR"] genericTypeArgumentListSimplified? qualifiedTypeIdentSimplified newArrayConstruction)
            |   arguments classBody?                // new object type via constructor invocation
                ->  ^(CLASS_CONSTRUCTOR_CALL[$NEW, "STATIC_ARRAY_CREATOR"] genericTypeArgumentListSimplified? qualifiedTypeIdentSimplified arguments classBody?)
            )
        )
    ;
    
innerNewExpression // something like 'InnerType innerType = outer.new InnerType();'
    :   NEW genericTypeArgumentListSimplified? IDENT arguments classBody?
        ->  ^(CLASS_CONSTRUCTOR_CALL[$NEW, "STATIC_ARRAY_CREATOR"] genericTypeArgumentListSimplified? IDENT arguments classBody?)
    ;

newArrayConstruction
    :   arrayDeclaratorList arrayInitializer
    |   LBRACK! expression RBRACK! (LBRACK! expression RBRACK!)* arrayDeclaratorList?
    ;

arguments
    :   LPAREN expressionList? RPAREN
        ->  ^(ARGUMENT_LIST[$LPAREN, "ARGUMENT_LIST"] expressionList?)
    ;

literal 
    :   HEX_LITERAL
    |   OCTAL_LITERAL
    |   DECIMAL_LITERAL
    |   FLOATING_POINT_LITERAL
    |   CHARACTER_LITERAL
    |   STRING_LITERAL
    |   TRUE
    |   FALSE
    |   NULL
    ;

// LEXER

HEX_LITERAL : '0' ('x'|'X') HEX_DIGIT+ INTEGER_TYPE_SUFFIX? ;

DECIMAL_LITERAL : ('0' | '1'..'9' '0'..'9'*) INTEGER_TYPE_SUFFIX? ;

OCTAL_LITERAL : '0' ('0'..'7')+ INTEGER_TYPE_SUFFIX? ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
INTEGER_TYPE_SUFFIX : ('l'|'L') ;

FLOATING_POINT_LITERAL
    :   ('0'..'9')+ 
        (
            DOT ('0'..'9')* EXPONENT? FLOAT_TYPE_SUFFIX?
        |   EXPONENT FLOAT_TYPE_SUFFIX?
        |   FLOAT_TYPE_SUFFIX
        )
    |   DOT ('0'..'9')+ EXPONENT? FLOAT_TYPE_SUFFIX?
    ;

fragment
EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

fragment
FLOAT_TYPE_SUFFIX : ('f'|'F'|'d'|'D') ;

CHARACTER_LITERAL
    :   '\'' ( ESCAPE_SEQUENCE | ~('\''|'\\') ) '\''
    ;

STRING_LITERAL
    :  '"' ( ESCAPE_SEQUENCE | ~('\\'|'"') )* '"'
    ;

fragment
ESCAPE_SEQUENCE
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESCAPE
    |   OCTAL_ESCAPE
    ;

fragment
OCTAL_ESCAPE
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESCAPE
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;

IDENT
    :   CHARJ_ID_START (CHARJ_ID_PART)*
    ;

fragment
CHARJ_ID_START
    :  '\u0024'
    |  '\u0041'..'\u005a'
    |  '\u005f'
    |  '\u0061'..'\u007a'
    |  '\u00c0'..'\u00d6'
    |  '\u00d8'..'\u00f6'
    |  '\u00f8'..'\u00ff'
    |  '\u0100'..'\u1fff'
    |  '\u3040'..'\u318f'
    |  '\u3300'..'\u337f'
    |  '\u3400'..'\u3d2d'
    |  '\u4e00'..'\u9fff'
    |  '\uf900'..'\ufaff'
    ;

fragment
CHARJ_ID_PART
    :  CHARJ_ID_START
    |  '\u0030'..'\u0039'
    ;

WS  :  (' '|'\r'|'\t'|'\u000C'|'\n') 
    {   
        if (!preserveWhitespacesAndComments) {
            skip();
        } else {
            $channel = HIDDEN;
        }
    }
    ;

COMMENT
    :   '/*' ( options {greedy=false;} : . )* '*/'
    {   
        if (!preserveWhitespacesAndComments) {
            skip();
        } else {
            $channel = HIDDEN;
        }
    }
    ;

LINE_COMMENT
    : '//' ~('\n'|'\r')* '\r'? '\n'
    {   
        if (!preserveWhitespacesAndComments) {
            skip();
        } else {
            $channel = HIDDEN;
        }
    }
    ;
