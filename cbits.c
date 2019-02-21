#include <stdio.h>

int * debug_current_stack_address() {
#ifdef __clang__
  int local_variable;
  return &local_variable;
#else
  return __builtin_return_address(0);
#endif
}

int * report_stack_base() {
  int * base = debug_current_stack_address();
  printf("stack base from C = %p\n", base);
  return base;
}

typedef int * (*callback_t)();

int * call_func(callback_t f) {
  report_stack_base();
  int * base = (*f)();
  report_stack_base();
  return base;
}
