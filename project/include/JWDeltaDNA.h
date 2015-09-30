#ifndef JWDELTADNA_H
#define JWDELTADNA_H


namespace jwdeltadna {
    extern "C"
    {	
        void jwddInit(const char * sEnvKey, const char * sCHostname, const char * sEHostname, const char * sUserId);
        void jwddRecordEvent(const char * sName, const char * sParams);
    }
}


#endif
