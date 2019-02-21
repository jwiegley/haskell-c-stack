{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module Wrapper where

#strict_import

#include <bindings.dsl.h>
#include "cbits.c"

#ccall debug_current_stack_address , IO (Ptr CInt)

#ccall report_stack_base , IO (Ptr CInt)

type Callback = IO (Ptr CInt)

foreign import ccall "wrapper"
  mkCallback :: Callback -> IO (FunPtr Callback)

#ccall call_func , FunPtr Callback -> IO (Ptr CInt)

