#include "timezone.h"
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

// Use the NDK system property API instead of JNI. JNI_OnLoad only runs for
// System.loadLibrary(), not for the dlopen behind DynamicLibrary.open(), so a
// pure FFI library never gets a JavaVM handle.
#include <sys/system_properties.h>

// Duplicate a C string onto the heap (NULL-safe). The caller owns the result
// and frees it with free_timezone_string().
static char* dup_str(const char* s) {
    if (!s) s = "";
    size_t n = strlen(s) + 1;
    char* p = (char*)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}

char* get_local_timezone(void) {
    // persist.sys.timezone holds the IANA id, e.g. "Asia/Kolkata".
    char prop[PROP_VALUE_MAX] = {0};
    int len = __system_property_get("persist.sys.timezone", prop);
    if (len > 0) {
        return dup_str(prop);
    }
    return dup_str("UTC");
}

char* get_timezone_abbreviation(void) {
    // bionic's tzset()/localtime_r() pick up persist.sys.timezone when TZ is
    // unset, so no need to touch the environment.
    tzset();
    time_t now = time(NULL);
    struct tm tm_info;
    if (localtime_r(&now, &tm_info) == NULL) {
        return dup_str("");
    }
    char buf[64];
    strftime(buf, sizeof(buf), "%Z", &tm_info);
    return dup_str(buf);
}

int32_t get_utc_offset_seconds(void) {
    tzset();
    time_t now = time(NULL);
    struct tm tm_info;
    if (localtime_r(&now, &tm_info) == NULL) {
        return 0;
    }
    // tm_gmtoff is seconds east of UTC, already adjusted for DST.
    return (int32_t)tm_info.tm_gmtoff;
}

void free_timezone_string(char* str) {
    free(str);
}
