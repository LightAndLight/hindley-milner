{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Lambda.PHP.AST
  ( PHP(..)
  , PHPId
  , phpId
  , unPHPId
  , PHPDecl(..)
  , PHPClassMember(..)
  , Visibility(..)
  , PHPExpr(..)
  , PHPArg(..)
  , UnOp(..)
  , BinOp(..)
  , PHPStatement(..)
  , PHPSwitchCase (..)
  , PHPDefaultCase (..)
  , PHPLiteral(..)
  )
  where

import           Data.String

data PHP = PHP [PHPDecl]
newtype PHPId = PHPId { unPHPId :: String }
  deriving (Eq, Show, Ord)

phpId :: String -> PHPId
phpId input = PHPId $ go input
  where
    go "" = ""
    go ('\'':rest) = "Prime" ++ go rest
    go (c:rest) = c : go rest

instance IsString PHPId where
  fromString = phpId

data PHPDecl
  = PHPDeclFunc PHPId [PHPArg] [PHPStatement]
  | PHPDeclClass PHPId [PHPClassMember]
  | PHPDeclStatement PHPStatement
data PHPClassMember
  = PHPClassFunc Bool Visibility PHPId [PHPArg] [PHPStatement]
  | PHPClassVar Bool Visibility PHPId (Maybe PHPExpr)
data Visibility = Public | Protected | Private
data PHPArg
  = PHPArgValue PHPId
  | PHPArgReference PHPId
  deriving (Eq, Ord)
data PHPExpr
  = PHPExprVar PHPId
  | PHPExprNew PHPId [PHPExpr]
  | PHPExprLiteral PHPLiteral
  | PHPExprBinop BinOp PHPExpr PHPExpr
  | PHPExprUnop UnOp PHPExpr
  | PHPExprAssign PHPExpr PHPExpr
  | PHPExprFunction [PHPArg] [PHPArg] [PHPStatement]
  | PHPExprClassAccess PHPExpr PHPId (Maybe [PHPExpr])
  | PHPExprArrayAccess PHPExpr PHPExpr
  | PHPExprFunctionCall PHPExpr [PHPExpr]
  | PHPExprName PHPId
data UnOp
  = Negate
  | Not
data BinOp
  = Add
  | Subtract
  | Multiply
  | Divide
  | Mod
  | Exp
  | Equal
  | NotEqual
  | Less
  | Greater
  | LessEq
  | GreaterEq
  | And
  | Or
  | Concat
  | InstanceOf
data PHPStatement
  = PHPStatementReturn PHPExpr
  | PHPStatementSwitch PHPExpr [PHPSwitchCase] PHPDefaultCase
  | PHPStatementThrow PHPExpr
  | PHPStatementExpr PHPExpr
  | PHPStatementIfThenElse PHPExpr [PHPStatement] (Maybe [PHPStatement])
data PHPSwitchCase = PHPSwitchCase PHPLiteral [PHPStatement] Bool
data PHPDefaultCase = PHPDefaultCase [PHPStatement] Bool
data PHPLiteral
  = PHPBool Bool
  | PHPInt Int
  | PHPString String
  | PHPNull
  | PHPArray [PHPExpr]
