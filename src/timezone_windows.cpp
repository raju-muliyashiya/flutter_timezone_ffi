#include "timezone.h"
#include <windows.h>
// icu.h ships with the Windows 10 SDK and exposes the ICU C API with
// unversioned symbol names (icu.dll is present on Windows 10 1703 and later).
#include <icu.h>
#include <stdlib.h>
#include <string.h>

// Duplicate a C string onto the heap (NULL-safe). The caller owns the result
// and frees it with free_timezone_string().
static char* dup_str(const char* s) {
    if (!s) s = "";
    size_t n = strlen(s) + 1;
    char* p = static_cast<char*>(malloc(n));
    if (p) memcpy(p, s, n);
    return p;
}

// Convert a NUL-terminated UTF-16 (UChar) string to a freshly malloc'd UTF-8
// string. Returns an empty string on conversion failure.
static char* utf16_to_utf8_dup(const UChar* src) {
    const wchar_t* w = reinterpret_cast<const wchar_t*>(src);
    int needed = WideCharToMultiByte(CP_UTF8, 0, w, -1, nullptr, 0, nullptr, nullptr);
    if (needed <= 0) return dup_str("");
    char* out = static_cast<char*>(malloc(needed));  // includes the NUL
    if (!out) return nullptr;
    int n = WideCharToMultiByte(CP_UTF8, 0, w, -1, out, needed, nullptr, nullptr);
    if (n <= 0) out[0] = '\0';
    return out;
}

// Open a calendar in the system's default timezone, positioned at "now".
static UCalendar* open_now_calendar(UErrorCode* status) {
    UCalendar* cal = ucal_open(nullptr, -1, nullptr, UCAL_DEFAULT, status);
    if (U_FAILURE(*status)) return nullptr;
    ucal_setMillis(cal, ucal_getNow(), status);
    if (U_FAILURE(*status)) {
        ucal_close(cal);
        return nullptr;
    }
    return cal;
}

// The OS reports a Windows zone key like "Pacific Standard Time"; ICU maps it
// to the IANA id (e.g. "America/New_York"). Falls back to the key name, then UTC.
char* get_local_timezone(void) {
    DYNAMIC_TIME_ZONE_INFORMATION dtzi;
    if (GetDynamicTimeZoneInformation(&dtzi) == TIME_ZONE_ID_INVALID) {
        return dup_str("UTC");
    }

    // WCHAR and UChar are both 16-bit; TimeZoneKeyName is NUL-terminated.
    UChar iana[128];
    UErrorCode status = U_ZERO_ERROR;
    int32_t cap = static_cast<int32_t>(sizeof(iana) / sizeof(UChar)) - 1;
    int32_t len = ucal_getTimeZoneIDForWindowsID(
        reinterpret_cast<const UChar*>(dtzi.TimeZoneKeyName), -1, nullptr,
        iana, cap, &status);

    if (U_SUCCESS(status) && len > 0) {
        iana[len] = 0;  // ensure NUL-termination before converting
        return utf16_to_utf8_dup(iana);
    }
    // Fall back to the (non-localized) Windows key name.
    return utf16_to_utf8_dup(reinterpret_cast<const UChar*>(dtzi.TimeZoneKeyName));
}

// Short timezone name for the current DST state, e.g. "PST"/"PDT" (ICU returns
// forms like "GMT+5:30" for zones that have no short code).
char* get_timezone_abbreviation(void) {
    UErrorCode status = U_ZERO_ERROR;
    UCalendar* cal = open_now_calendar(&status);
    if (!cal) return dup_str("");

    UBool in_dst = ucal_inDaylightTime(cal, &status);
    UChar name[64];
    int32_t cap = static_cast<int32_t>(sizeof(name) / sizeof(UChar)) - 1;
    int32_t len = ucal_getTimeZoneDisplayName(
        cal, in_dst ? UCAL_SHORT_DST : UCAL_SHORT_STANDARD, "en", name, cap, &status);
    ucal_close(cal);

    if (U_SUCCESS(status) && len > 0) {
        name[len] = 0;
        return utf16_to_utf8_dup(name);
    }
    return dup_str("");
}

// Raw zone offset plus the current DST offset, so it stays correct year-round.
int32_t get_utc_offset_seconds(void) {
    UErrorCode status = U_ZERO_ERROR;
    UCalendar* cal = open_now_calendar(&status);
    if (!cal) return 0;

    int32_t zone_ms = ucal_get(cal, UCAL_ZONE_OFFSET, &status);  // milliseconds
    int32_t dst_ms = ucal_get(cal, UCAL_DST_OFFSET, &status);    // milliseconds
    ucal_close(cal);
    if (U_FAILURE(status)) return 0;

    return (zone_ms + dst_ms) / 1000;
}

void free_timezone_string(char* str) {
    free(str);
}
