/* Include files */

#include "DigitalChannel_cgxe.h"
#include "m_yxoyDbRtc1w1uCNvrOl7eB.h"

unsigned int cgxe_DigitalChannel_method_dispatcher(SimStruct* S, int_T method,
  void* data)
{
  if (ssGetChecksum0(S) == 4200917229 &&
      ssGetChecksum1(S) == 2528359365 &&
      ssGetChecksum2(S) == 217927703 &&
      ssGetChecksum3(S) == 2520702521) {
    method_dispatcher_yxoyDbRtc1w1uCNvrOl7eB(S, method, data);
    return 1;
  }

  return 0;
}
