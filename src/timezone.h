#ifndef TIMEZONE_H
#define TIMEZONE_H

#include <stdint.h>

#include "flutter_timezone_ffi.h"

#if defined(__cplusplus)
extern "C" {
#endif

// The string-returning functions allocate a NUL-terminated UTF-8 buffer on the
// heap and hand ownership to the caller, who must release it with
// free_timezone_string(). They return NULL if allocation fails. Each call uses
// its own buffer, so the functions are reentrant.

// Get the local timezone identifier (e.g. "America/New_York").
FFI_PLUGIN_EXPORT char* get_local_timezone(void);

// Get the timezone abbreviation (e.g. "EST", "PST").
FFI_PLUGIN_EXPORT char* get_timezone_abbreviation(void);

// Get the UTC offset in seconds (east of UTC is positive). DST-aware.
FFI_PLUGIN_EXPORT int32_t get_utc_offset_seconds(void);

// Release a string returned by the functions above. Safe to call with NULL.
FFI_PLUGIN_EXPORT void free_timezone_string(char* str);

#if defined(__cplusplus)
}
#endif

#endif // TIMEZONE_H
