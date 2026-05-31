#include "timezone.h"
#import <Foundation/Foundation.h>
#include <string.h>
#include <stdlib.h>

// Duplicate a C string onto the heap. NULL-safe, since [nilString UTF8String]
// returns NULL. The caller owns the result and frees it with
// free_timezone_string().
static char* dup_str(const char* s) {
    if (!s) s = "";
    size_t n = strlen(s) + 1;
    char* p = (char*)malloc(n);
    if (p) memcpy(p, s, n);
    return p;
}

char* get_local_timezone(void) {
    @autoreleasepool {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        return dup_str([[timeZone name] UTF8String]);
    }
}

char* get_timezone_abbreviation(void) {
    @autoreleasepool {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        return dup_str([[timeZone abbreviation] UTF8String]);  // abbreviation may be nil
    }
}

int32_t get_utc_offset_seconds(void) {
    @autoreleasepool {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        return (int32_t)[timeZone secondsFromGMT];
    }
}

void free_timezone_string(char* str) {
    free(str);
}
