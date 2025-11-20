#ifndef HOOKS_H
#define HOOKS_H
#include "FreeRTOS.h"
#include "task.h"

/* Standard FreeRTOS callback/hook functions for platform */

__attribute__((weak)) void vApplicationMallocFailedHook(void) {
  /* Called if a call to pvPortMalloc() fails because there is insufficient
  free memory available in the FreeRTOS heap.  pvPortMalloc() is called
  internally by FreeRTOS API functions that create tasks, queues, software
  timers, and semaphores.  The size of the FreeRTOS heap is set by the
  configTOTAL_HEAP_SIZE configuration constant in FreeRTOSConfig.h. */

  /* Hang here - can be overridden by user */
  for (;;) {
  }
}

__attribute__((weak)) void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName) {
  (void)pcTaskName;
  (void)pxTask;

  /* Run time stack overflow checking is performed if
  configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
  function is called if a stack overflow is detected. */

  /* Hang here - can be overridden by user */
  for (;;) {
  }
}

__attribute__((weak)) void vApplicationIdleHook(void) {
  volatile size_t xFreeHeapSpace;

  /* This is just a trivial example of an idle hook.  It is called on each
  cycle of the idle task.  It must *NOT* attempt to block.  In this case the
  idle task just queries the amount of FreeRTOS heap that remains.  See the
  memory management section on the http://www.FreeRTOS.org web site for memory
  management options.  If there is a lot of heap memory free then the
  configTOTAL_HEAP_SIZE value in FreeRTOSConfig.h can be reduced to free up
  RAM. */
  xFreeHeapSpace = xPortGetFreeHeapSize();

  /* Remove compiler warning about xFreeHeapSpace being set but never used. */
  (void)xFreeHeapSpace;
}

__attribute__((weak)) void vApplicationTickHook(void) {
  /* This function will be called by each tick interrupt if
  configUSE_TICK_HOOK is set to 1 in FreeRTOSConfig.h.  User code can be
  added here, but the tick hook is called from an interrupt context, so
  code must not attempt to block, and only the interrupt safe FreeRTOS API
  functions can be used (those that end in FromISR()). */
}

#endif // HOOKS_H
