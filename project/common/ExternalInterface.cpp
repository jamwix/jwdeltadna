#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <stdio.h>
#include "JWDeltaDNA.h"


using namespace jwdeltadna;



static value jwdeltadna_init (value envKey, value cHostname, value eHostname, value userId) {
	
	#ifdef IPHONE
    jwddInit(val_string(envKey), val_string(cHostname), val_string(eHostname), val_string(userId));
	#endif
	return alloc_null();
	
}
DEFINE_PRIM (jwdeltadna_init, 4);

static value jwdeltadna_record_event (value name, value params) {
	
	#ifdef IPHONE
    jwddRecordEvent(val_string(name), val_string(params));
	#endif
	return alloc_null();
	
}
DEFINE_PRIM (jwdeltadna_record_event, 2);

extern "C" void jwdeltadna_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (jwdeltadna_main);

extern "C" int jwdeltadna_register_prims () { return 0; }
