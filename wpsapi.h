/**
 * \mainpage
 *
 * \version \$Revision: 3405 $
 * \date \$Date: 2009-01-08 17:30:20 +0200 (Thu, 08 Jan 2009) $
 * \author Skyhook Wireless
 *
 * \section main-install Installation
 *
 * For installation instructions please read \ref installation.
 *
 * \section api API Summary
 *
 * \li \c WPS_location()
 * \li \c WPS_periodic_location()
 * \li \c WPS_tiling()
 *
 * For the full description of the API please read \ref API.
 *
 * \defgroup API API
 *
 * The API works in 2 major modes: \e network centric and \e device centric.
 * In addition the \e tiling mode is a mix of the two.
 *
 * \section network_model Network-centric mode
 * In the network-centric model the API issues calls to a remote server
 * to determine a location.
 *
 * This is the mode used by the \c WPS_location() call.
 *
 * If a path to a local file has been setup (See \c WPS_set_local_files_path()),
 * the API first tries to determine the location locally,
 * without calling the remote server. This is called the \e mixed-mode model.
 *
 * \section device_model Device-centric mode
 * In the device-centric model the API determines location
 * locally.
 *
 * This is the mode used by the \c WPS_periodic_location() call.
 *
 * This mode is activated by setting the path to a local
 * file. See \c WPS_set_local_files_path().
 *
 * \section tiling_model Tiling mode
 * The tiling mode is a mix of the network and device-centric mode.
 * It downloads from the server a small portion of the database so
 * the device can automonously determine its location, without further
 * need to contact the server.
 *
 * This mode is activated by calling \c WPS_tiling().
 * 
 * \page changelog Change Log
 *
 * \section v_3_0 Version 3.0
 *
 * \li Added \c WPS_tune_location()
 * \if symbian \li Added \c WPS_set_internet_access_point() \endif
 * \li Added \c WPS_ERROR_TIMEOUT
 *
 * \section v_2_7 Version 2.7
 *
 * \li Added \c WPS_set_user_agent()
 *
 * \section v_2_6_1 Version 2.6.1
 *
 * \li Changed return type from \c int to \c WPS_Continuation for \c   Callback
 *
 * \section v2_6 Version 2.6
 *
 * \li Added \c WPS_tiling()
 * \li Added \c WPS_set_tier2_area()
 *
 * \section v2_5 Version 2.5
 *
 * \li Official release.
 *
 * \section v2_4 Version 2.4
 *
 * \li Added \e mixed-mode -- local location determination if possible.
 * \li Added \c WPS_periodic_location()
 * \li Added \c WPS_set_local_files_path()
 * \li Changed returned code from \c WPS_set_proxy()
 *     and \c WPS_set_server_url() to void
 * \li Added \c speed, \c bearing and \c nap
 *     to \c WPS_Location
 * \li Removed \c hpe from \c WPS_IPLocation
 *
 * \section v2_3_1 Version 2.3.1
 *
 * \li Added \c WPS_register_user()
 *
 * \section v2_3 Version 2.3
 *
 * \li Faster scanning
 * \li Caching to allow for better response time
 * \li \c WPSScanner.dll is no longer needed
 *
 * \page installation Installation
 *
 * \section requirements Requirements
 *
 * \if winxp
 *   \li Windows XP Service Pack 2
 * \elseif vista
 *   \li Windows Vista
 * \elseif pocketpc
 *   \li Windows Mobile 2003, Windows CE 5.0, or Windows Mobile 5.0
 * \elseif linux
 *   \li Linux 2.6 with wireless-extension
 *   \li The user must have read-write access to \c /proc/net/wireless.
 *       \n
 *       On most desktop linux write access to \c /proc/net/wireless
 *       is restricted to \c root.
 * \elseif darwin
 *   \li Mac OS X 10.4
 * \elseif symbian
 *   \li Symbian/S60 3rd Edition Feature Pack 1 or Symbian/UIQ 3.1
 * \endif
 * \li Wifi network card for location based on wifi networks.
 * \li GSM radio for location based on cell networks.
 * \li Active Internet connection for the network-centric model.
 *
 * \ifnot symbian
 *   \section install Install
 *
 *   \if winxp
 *     \li Wi-Fi Service must be installed and running on the client device.
 *         Run:
 *         \code
 * bin/svcsetup.exe
 *         \endcode
 *     \li \c wpsapi.dll must be installed on the client's device.
 *   \elseif vista
 *     \li \c wpsapi.dll must be installed on the client's device.
 *   \elseif pocketpc
 *     \li \c wpsapi.dll must be installed on the client's device.
 *   \elseif linux
 *     \li \c libwpsapi.so must be installed on the client's device.
 *   \elseif darwin
 *     \li \c libwpsapi.dylib must be installed on the client's device.
 *   \endif
 * \endif
 *
 * \section sdkfiles Files
 *
 * \if winxp
 *   \verbatim
     bin/
         svcsetup.exe           Wi-Fi Service Installer
     documentation/
         html/                  documentation
         sdk.pdf                documentation
     example/
         wpsapitest.cpp         sample application (source code)
         wpsapitest.exe         sample application
         wpsapi.dll             copy of wpsapi.dll
     include/
         wpsapi.h               header file for wpsapi.dll
     lib/
         wpsapi.lib             library for wpsapi.dll
         wpsapi.dll             client library to the WPS server
     \endverbatim
 * \elseif vista
 *   \verbatim
     documentation/
         html/                  documentation
         sdk.pdf                documentation
     example/
         wpsapitest.cpp         sample application (source code)
         wpsapitest.exe         sample application
         wpsapi.dll             copy of wpsapi.dll
     include/
         wpsapi.h               header file for wpsapi.dll
     lib/
         wpsapi.lib             library for wpsapi.dll
         wpsapi.dll             WPS client library
     \endverbatim
 * \elseif pocketpc
 *   \verbatim
     documentation/
         html/                  documentation
         sdk.pdf                documentation
     example/
         wpsapitest.cpp         sample application (source code)
         wpsapitest.exe         sample application
         wpsapi.dll             copy of wpsapi.dll
     include/
         wpsapi.h               header file for wpsapi.dll
     lib/
         wpsapi.lib             library for wpsapi.dll
         wpsapi.dll             WPS client library
         SdkCerts.cab           Certificates for binaries
     \endverbatim
 * \elseif linux
 *   \verbatim
     bin/
         wpsd                   WPS daemon
     include/
         wpsapi.h               header file for libwpsapi.dylib
     lib/
         libwpsapi.3.0.0.so     WPS client library
         libwpsapi.3.so         WPS client library
         libwpsapi.a            library for libwpsapi.dylib
         libwpsapi.so           WPS client library
         libwpsapi.la           library for libwpsapi.dylib
     share/
         libwpsapi/
             wpslog.properties  sample wpslog.properties
             sdk.pdf            documentation
             html/              documentation
     src/
         libwpsapi/
             wpsapitest         sample application
             wpsapitest.cpp     sample application (source code)
     \endverbatim
 * \elseif darwin
 *   \verbatim
     bin/
         wpsd                   WPS daemon
     include/
         wpsapi.h               header file for libwpsapi.dylib
     lib/
         libwpsapi.3.0.0.dylib  WPS client library
         libwpsapi.3.dylib      WPS client library
         libwpsapi.a            library for libwpsapi.dylib
         libwpsapi.dylib        WPS client library
         libwpsapi.la           library for libwpsapi.dylib
     share/
         libwpsapi/
             wpslog.properties  sample wpslog.properties
             sdk.pdf            documentation
             html/              documentation
     src/
         libwpsapi/
             wpsapitest         sample application
             wpsapitest.cpp     sample application (source code)
     \endverbatim
 * \elseif symbian
 *   \verbatim
     documentation/
         html/                      documentation
         sdk.pdf                    documentation
     epoc32/
         include/
             wpsapi.h               header file for wpsapi.lib
         release/
             armv5/
                 urel/
                     wpsapi.lib     WPS client library
             winscw/
                 udeb/
                     wpsapi.lib     WPS client library (emulator build)
     samples/
         console/                   sample console application
         demo/                      sample UI application
     sis/
         wpsdemo.sis                sample application
     \endverbatim
 *   \note In order to build an application you must first
 *         copy \c \\epoc32 folder to the Symbian SDK folder
 * \endif
 *
 * \page logging Logging
 *
 * \section logginghowto How to turn on logging
 *
 * \if winxp
 *   On Windows XP either drop a file named \c wpslog.properties
 *   in the directory containing the executable that loads WPS,
 *   or define an environment variable named \c WPS_LOG_CONFIGURATION
 *   that contains the path to the \c wpslog.properties file.
 * \elseif vista
 *   On Windows Vista either drop a file named \c wpslog.properties
 *   in the directory containing the executable that loads WPS,
 *   or define an environment variable named \c WPS_LOG_CONFIGURATION
 *   that contains the path to the \c wpslog.properties file.
 * \elseif pocketpc
 *   On Windows Mobile/CE drop a file named \c wpslog.properties
 *   in the directory containing the executable that loads WPS.
 *   For the VirtualGPS this directory is \c \\Windows as
 *   WPS is loaded as a service by \c services.exe.
 * \elseif linux
 *   On Linux define an environment variable named \c WPS_LOG_CONFIGURATION
 *   that contains the path to the \c wpslog.properties file.
 * \elseif darwin
 *   On Mac OS X define an environment variable named \c WPS_LOG_CONFIGURATION
 *   that contains the path to the \c wpslog.properties file.
 * \elseif symbian
 *   On Symbian OS create a folder \c C:\\Logs\\WPSAPI in phone memory.
 *   The log file is written to \c C:\\Logs\\WPSAPI\\wpslog.txt if that folder exists.
 * \endif
 *
 * \ifnot symbian
 *   \section wpslog WPS log properties file
 *
 *   Here's an example of a \c wpslog.properties file:
 *   \if winxp
 *     \verbatim DEBUG,wpslog.txt \endverbatim
 *   \elseif vista
 *     \verbatim DEBUG,wpslog.txt \endverbatim
 *   \elseif pocketpc
 *     \verbatim DEBUG,\wpslog.txt \endverbatim
 *   \elseif linux
 *     \verbatim DEBUG,wpslog.txt \endverbatim
 *   \elseif darwin
 *     \verbatim DEBUG,wpslog.txt \endverbatim
 *   \endif
 * \endif
 *
 * \ifnot symbian
 *   You can also redirect logging to \c stdout or \c stderr:
 *     \verbatim DEBUG,stdout \endverbatim
 *
 *   The logging level can be one of the following:
 *
 *   \li FATAL
 *   \li INFO
 *   \li ALERT
 *   \li CRITICAL
 *   \li ERROR
 *   \li WARN
 *   \li NOTICE
 *   \li INFO
 *   \li DEBUG
 * \endif
 *
 * \page license Limited Use License
 *
 * Copyright 2005-2008 Skyhook Wireless, Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted subject to the following:
 *
 * * Use and redistribution is subject to the Software License and Development
 * Agreement, available at
 * <a href="http://www.skyhookwireless.com">www.skyhookwireless.com</a>
 *
 * * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * <br><hr>
 */
/** @{ */

#ifndef _WPSAPI_H_
#define _WPSAPI_H_

#if defined WPSAPI_EXTENSION && !WPSAPI_STATIC
#  error WPSAPI_EXTENSION can be used only with WPSAPI_STATIC
#endif

/**
 * \cond
 */

#if defined WPSAPI_STATIC && !defined WPSAPI_EXTENSION
#  define WPSAPI_EXPORT
#else
#  ifdef __SYMBIAN32__
#    include <e32def.h>
#    ifdef WPSAPI_INTERNAL
#      define WPSAPI_EXPORT EXPORT_C
#    else
#      define WPSAPI_EXPORT IMPORT_C
#    endif
#  elif defined _WIN32
#    ifdef WPSAPI_INTERNAL
#      define WPSAPI_EXPORT _declspec(dllexport)
#    else
#      define WPSAPI_EXPORT _declspec(dllimport)
#    endif
#  else
#    if __GNUC__ >= 4
#      define WPSAPI_EXPORT __attribute__((visibility("default")))
#    else
#      define WPSAPI_EXPORT
#    endif
#  endif
#endif

/**
 * \endcond
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * WPS return codes.
 */
typedef enum
{
    /**
     * The call was successful.
     */
    WPS_OK = 0,

    /**
     * The \c WPSScanner.dll was not found.
     *
     * \deprecated This error code is no longer relevant.
     */
    WPS_ERROR_SCANNER_NOT_FOUND = 1,

    /**
     * No Wifi adapter was detected.
     */
    WPS_ERROR_WIFI_NOT_AVAILABLE = 2,

    /**
     * No Wifi reference points in range.
     */
    WPS_ERROR_NO_WIFI_IN_RANGE = 3,

    /**
     * User authentication failed.
     */
    WPS_ERROR_UNAUTHORIZED = 4,

    /**
     * The server is unavailable.
     */
    WPS_ERROR_SERVER_UNAVAILABLE = 5,

    /**
     * A location couldn't be determined.
     */
    WPS_ERROR_LOCATION_CANNOT_BE_DETERMINED = 6,

    /**
     * Proxy authentication failed.
     */
    WPS_ERROR_PROXY_UNAUTHORIZED = 7,

    /**
     * A file IO error occurred while reading the local file.
     *
     * \since 2.4
     */
    WPS_ERROR_FILE_IO = 8,

    /**
     * The local file has an invalid format.
     *
     * \since 2.4
     */
    WPS_ERROR_INVALID_FILE_FORMAT = 9,

    /**
     * Network operation timed out.
     *
     * \since 3.0
     */
    WPS_ERROR_TIMEOUT = 10,

    /**
     * Cannot allocate memory.
     *
     * \since 2.6.1
     */
    WPS_NOMEM = 98,

    /**
     * Some other error occurred.
     */
    WPS_ERROR = 99
} WPS_ReturnCode;

/**
 * WPS_Continuation
 *
 * \since 2.6
 */
typedef enum
{
    WPS_STOP = 0,
    WPS_CONTINUE = 1
} WPS_Continuation;

/**
 * WPS_SimpleAuthentication is used to identify
 * the user with the server.
 */
typedef struct
{
    /**
     * the user's name, or unique identifier.
     */
    const char* username;

    /**
     * the authentication realm.
     */
    const char* realm;
} WPS_SimpleAuthentication;

/**
 * street address lookup.
 *
 * \note the server returns as much information as requested,
 *       but is not required to fill in all the requested fields.
 *       \n
 *       Only the fields the server could reverse geocode are returned.
 */
typedef enum
{
    /**
     * no street address lookup is performed.
     */
    WPS_NO_STREET_ADDRESS_LOOKUP,

    /**
     * a limited address lookup is performed
     * to return, at most, city information.
     */
    WPS_LIMITED_STREET_ADDRESS_LOOKUP,

    /**
     * a full street address lookup is performed
     * returning the most specific street address.
     */
    WPS_FULL_STREET_ADDRESS_LOOKUP
} WPS_StreetAddressLookup;

typedef struct
{
    char* name;
    char code[3];
} WPS_NameCode;

/**
 * Street Address
 */
typedef struct
{
    /**
     * street number
     */
    char* street_number;

    /**
     * A \c NULL terminated array of address line
     */
    char** address_line;

    /**
     * city
     */
    char* city;

    /**
     * postal code
     */
    char* postal_code;

    /**
     * county
     */
    char* county;

    /**
     * province
     */
    char* province;

    /**
     * state, includes state name and 2-letter code.
     */
    WPS_NameCode state;

    /**
     * region
     */
    char* region;

    /**
     * country, includes country name and 2-letter code.
     */
    WPS_NameCode country;
} WPS_StreetAddress;

/**
 * Geographic location
 */
typedef struct
{
    //@{
    /**
     * the calculated physical geographic location.
     */
    double latitude;
    double longitude;
    //@}

    /**
     * <em>horizontal positioning error</em> --
     * A calculated error estimate of the location result in meters.
     */
    double hpe;

    /**
     * The number of access-point used to calculate this location.
     *
     * \since 2.4
     */
    unsigned short nap;

    /**
     * A calculated estimate of speed in km/hr.
     *
     * A negative speed is used to indicate an unknown speed.
     *
     * \since 2.4
     */
    double speed;

    /**
     * A calculated estimate of bearing as degree from north
     * counterclockwise (+90 is West).
     *
     * \since 2.4
     */
    double bearing;

    /**
     * physical street address,
     * only returned in the network-centric model
     * when the \c street_address_lookup parameter
     * is set to \c limited or \c full.
     */
    WPS_StreetAddress* street_address;
} WPS_Location;

/**
 * Geographic location based on
 * the IP address of the client making the request.
 *
 * \note This information is likely not accurate,
 *       but may give some indication as to the general location
 *       of the request and may provide some hints for the client
 *       software to act and react appropriately.
 */
typedef struct
{
    /**
     * the IP address of the client as received by the server.
     */
    char* ip;

    //@{
    /**
     * the estimated physical geographic location.
     */
    double latitude;
    double longitude;
    //@}

    /**
     * physical street address,
     * only returned when the \c street_address_lookup parameter
     * is set to \c limited or \c full.
     */
    WPS_StreetAddress* street_address;
} WPS_IPLocation;

/**
 * Requests geographic location based on observed wifi access points,
 * cell towers, and GPS signals.
 *
 * \param authentication the user's authentication information.
 * \param street_address_lookup request street address lookup
 *                              in addition to latitude/longitude lookup.
 * \param location pointer to return a \c WPS_Location struct.
 *                 \n
 *                 This pointer should be freed by calling \c WPS_free_location().
 *
 * \return a \c WPS_ReturnCode
 *
 * \par Sample Code:
 * \code
WPS_SimpleAuthentication authentication;
authentication.username = "myusername";
authentication.realm = "myrealm";

WPS_Location* location;
WPS_ReturnCode rc = WPS_location(&authentication,
                                 WPS_NO_STREET_ADDRESS_LOOKUP,
                                 &location);
if (rc != WPS_OK)
{
    fprintf(stderr, "*** WPS_location failed (%d)!\n", rc);
}
else
{
    print_location(location);
    WPS_free_location(location);
}
 * \endcode
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_location(const WPS_SimpleAuthentication* authentication,
             WPS_StreetAddressLookup street_address_lookup,
             WPS_Location** location);


/**
 * Callback routine for \c WPS_periodic_location().
 *
 * \param arg the \c arg passed to \c WPS_periodic_location().
 * \param code the \c WPS_ReturnCode of the last request.
 * \param location If \c code is \c WPS_OK points to a \c WPS_Location
 *                 \n
 *                 This pointer does \e not need to be freed.
 *
 * \return \e WPS_CONTINUE if \c WPS_periodic_location() is to continue,
 *         \e WPS_STOP if \c WPS_periodic_location() should stop.
 *
 * \since 2.4
 *
 * \par Sample Code:
 * \code
WPS_Continuation
periodic_callback(void*,
                  WPS_ReturnCode code,
                  const WPS_Location* location)
{
    if (code != WPS_OK)
    {
        fprintf(stderr, "*** failure (%d)!\n", code);
    }
    else
    {
        print_location(location);  
    }

    return WPS_CONTINUE;
}
 * \endcode
 */
typedef WPS_Continuation (*WPS_LocationCallback)(void* arg,
                                                 WPS_ReturnCode code,
                                                 const WPS_Location* location);

/**
 * Requests periodic geographic location based on observed wifi access points,
 * cell towers, and GPS signals.
 *
 * \param authentication the user's authentication information.
 * \param street_address_lookup request street address lookup
 *                              in addition to latitude/longitude lookup
 *                              \n
 *                              Note that street address lookup is only
 *                              performed when the location is determined
 *                              by the remote server (network-centric model),
 *                              not when the location is determined locally.
 * \param period time in milliseconds between location reports.
 *               \n
 *               Note this time is \e approximate,
 *               particularly when the location is calculated remotely.
 * \param iterations number of time a location is to be reported.
 *                   \n
 *                   A value of zero indicates an unlimited number of
 *                   iterations.
 * \param callback the callback routine to report locations to.
 * \param arg an opaque parameter passed to the callback routine.
 *
 * \pre \c period must be strictly greater than 0.
 *
 * \since 2.4
 *
 * \par Sample Code:
 * \code
WPS_SimpleAuthentication authentication;
authentication.username = "myusername";
authentication.realm = "myrealm";

WPS_Location* location;
WPS_ReturnCode rc = WPS_periodic_location(&authentication,
                                          WPS_NO_STREET_ADDRESS_LOOKUP,
                                          1000,
                                          0,
                                          periodic_callback,
                                          NULL);
if (rc != WPS_OK)
{
    fprintf(stderr, "*** WPS_periodic_location failed (%d)!\n", rc);
}
 * \endcode
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_periodic_location(const WPS_SimpleAuthentication* authentication,
                      WPS_StreetAddressLookup street_address_lookup,
                      unsigned long period,
                      unsigned iterations,
                      WPS_LocationCallback callback,
                      void* arg);

/**
 * Request geographic location information based on
 * the IP address of the client making the request.
 *
 * \note  This information is likely not accurate,
 *        but may give some indication as to the general location
 *        of the request and may provide some hints for the client
 *        software to act and react appropriately.
 *
 * \note  \c WPS_ip_location() only works in the network-centric model.
 *
 * \param authentication the user's authentication information.
 * \param street_address_lookup request street address lookup
 *                              in addition to lat/long lookup.
 * \param location pointer to return a \c WPS_IPLocation struct.
 *                 \n
 *                 This pointer should be freed by calling \c WPS_free_ip_location()
 *
 * \return a \c WPS_ReturnCode
 *
 * \par Sample Code:
 * \code
WPS_SimpleAuthentication authentication;
authentication.username = "myusername";
authentication.realm = "myrealm";

WPS_IPLocation* location;
WPS_ReturnCode rc = WPS_ip_location(&authentication,
                                    WPS_NO_STREET_ADDRESS_LOOKUP,
                                    &location);
if (rc != WPS_OK)
{
    fprintf(stderr, "*** WPS_ip_location failed (%d)!\n", rc);
}
else
{
    print_ip_location(location);
    WPS_free_ip_location(location);
}
 * \endcode
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_ip_location(const WPS_SimpleAuthentication* authentication,
                WPS_StreetAddressLookup street_address_lookup,
                WPS_IPLocation** location);

/**
 * Free a WPS_Location struct returned by \c WPS_location().
 */
WPSAPI_EXPORT void
WPS_free_location(WPS_Location*);

/**
 * Free a WPS_Location struct returned by \c WPS_ip_location().
 */
WPSAPI_EXPORT void
WPS_free_ip_location(WPS_IPLocation*);

/**
 * Setup a proxy server.
 *
 * \param address the IP address of the proxy server.
 * \param port the TCP port number to connect to.
 * \param user the username to authenticate with the proxy server.
 * \param password the password to authentication with the proxy server.
 *
 * \return a \c WPS_ReturnCode
 */
WPSAPI_EXPORT void
WPS_set_proxy(const char* address,
              int port,
              const char* user,
              const char* password);

/**
 * Overwrite the WPS server's url from its default value.
 *
 * \param url the url to the server.
 *            \n
 *            A value of \c NULL turns off remote determination of location.
 */
WPSAPI_EXPORT void
WPS_set_server_url(const char* url);

/**
 * Overwrite the default user agent of the requests going to the server.
 *
 * \param ua the user agent string.
 *
 * \since 2.7
 */
WPSAPI_EXPORT void
WPS_set_user_agent(const char* ua);

/**
 * Set the path to local files so location determination can be performed.
 * locally.
 *
 * \param paths an array (terminated by \c NULL) of complete path to local files.
 *              \n
 *              This array replaces all previous values.
 *              \n
 *              Use \c NULL to clear and release local files.
 *
 * \return a \c WPS_ReturnCode
 *
 * \since 2.4
 *
 * \par Sample Code:
 * \code
const char* paths[] = { "myfile1", "myfile2", NULL };
WPS_ReturnCode rc = WPS_set_local_files_path(paths);
if (rc != WPS_OK)
{
    fprintf(stderr, "*** WPS_set_local_files_path failed (%d)!\n", rc);
}
 * \endcode
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_set_local_files_path(const char** paths);

/**
 * Setup the tier2 area.
 *
 * \param dirpath the path to a directory to store the tier2 files.
 * \param size the approximate max total size of the tier2 files,
 *             in kilobytes.
 *
 * \return a \c WPS_ReturnCode
 *
 * \since 2.6
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_set_tier2_area(const char* dirpath, unsigned size);

/**
 * Callback routine for \c WPS_tiling().
 *
 * \param arg the \c arg passed to \c WPS_tiling().
 * \param tileNumber the number of the tile to be downloaded next.
 * \param tileTotal the total number of tiles to be downlaoded
 *                  (in this session).
 *
 * \return \c WPS_CONTINUE if \c WPS should continue downloading tiles,
 *         \e WPS_STOP if \c WPS should stop downloading tiles.
 *
 * \since 2.6
 *
 * \par Sample Code:
 * \code
WPS_Continuation
tiling_callback(void*,
                unsigned tileNumber,
                unsigned tileTotal)
{
    printf("downloading tile %d/%d...\n", tileNumber, tileTotal);
    return WPS_CONTINUE;
}
 * \endcode
 */
typedef WPS_Continuation (*WPS_TilingCallback)(void* arg,
                                               unsigned tileNumber,
                                               unsigned tileTotal);

/**
 * Setup tiling so location determination can be performed
 * locally.
 *
 * \param dirpath the path to a directory to store tiles.
 *        \n
 *        \c dirpath must end with a directory separator character.
 *        (i.e. '\' on Windows platforms and '/' on Unix platforms)
 * \param maxDataSizePerSession the maximum size of data downloaded
 *                              per session, in bytes.
 *                              \n
 *                              A value of 0 disables
 *                              any further tile downloads.
 * \param maxDataSizeTotal the maximum size of all stored tiles, in bytes.
 *                         \n
 *                         A value of 0 causes all stored tiles to be deleted.
 * \param callback the callback function to control the tile download.
 *                 By default, all tiles are downloaded.
 * \param param the opaque parameter to pass to the callback function.
 *
 * \note Tiles are typically less then 50KB in size, so to download an area
 *       of 3x3 tiles for each session you would set \c maxDataSizePerSession
 *       to 450KB, i.e. 460,800.
 * \note It is recommended that \c maxDataSizePerSession be
 *       a factor of 2 - 10 smaller than \c maxDataSizeTotal,
 *       so that tiles from several areas can be cached.
 *
 * \return a \c WPS_ReturnCode
 *
 * \since 2.6
 *
 * \par Sample Code:
 * \code
WPS_ReturnCode rc = WPS_tiling("/tiles/",
                               450 * 1024, // 450KB
                               2 * 1024 * 1024, // 2MB
                               NULL,
                               NULL);
if (rc != WPS_OK)
{
    fprintf(stderr, "*** WPS_tiling failed (%d)!\n", rc);
}
 * \endcode
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_tiling(const char* dirpath,
           unsigned maxDataSizePerSession,
           unsigned maxDataSizeTotal,
           WPS_TilingCallback callback,
           void* param);

/**
 * Register a new user.
 *
 * \param authentication an existing user's authentication information.
 * \param new_authentication the new user's authentication information.
 *
 * \return a \c WPS_ReturnCode
 *
 * \since 2.3.1
 *
 * \par Sample Code:
 * \code
WPS_SimpleAuthentication authentication;
authentication.username = "myusername";
authentication.realm = "myrealm";

WPS_SimpleAuthentication newAuthentication;
newAuthentication.username = "mynewusername";
newAuthentication.realm = authentication.realm;

WPS_ReturnCode rc = WPS_register_user(&authentication, &newAuthentication);
if (rc != WPS_OK)
{
    fprintf(stderr, "*** WPS_register_user failed (%d)!\n", rc);
}
else
{
    printf("user %s registered\n", newAuthentication.username);
}
 * \endcode
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_register_user(const WPS_SimpleAuthentication* authentication,
                  const WPS_SimpleAuthentication* new_authentication);

/**
 * Tune the last location returned.
 *
 * \param authentication an existing user's authentication information.
 * \param location the tuned location.
 *
 * \return a \c WPS_ReturnCode
 *
 * \note Only locations calculated by the server can be tuned.
 *       \n
 *       Locations calculated locally, either through local files or tiles,
 *       will not reflect any tuning.
 *
 * \since 3.0
 */
WPSAPI_EXPORT WPS_ReturnCode
WPS_tune_location(const WPS_SimpleAuthentication* authentication,
                  const WPS_Location* location);

/**
 * \cond symbian
 *
 * Setup internet access point to use for network connection
 * on Symbian phones.
 *
 * \param iap internet access point ID or -1 to always show a prompt.
 *
 * \since 3.0
 */

#ifdef __SYMBIAN32__

WPSAPI_EXPORT void
WPS_set_internet_access_point(int iap);

#endif

/**
 * \endcond
 */

#ifdef __cplusplus
}
#endif

/** @} */

/**
 * \example wpsapitest.cpp
 *
 * This sample application, located in the \c example directory, is a
 * simple console based application.
 *
 * When run, it first issues an
 * ip location (\c WPS_ip_location()) request to locate itself
 * based on the ip address of the device.
 * It prints the latitude and longitude returned
 * from the server.
 *
 * Second it requests a geographic location (\c WPS_location()), with street
 * address reverse lookup.
 * It prints the latitude, longitude and address returned.
 *
 * Finally, it requests a series of locations (\c WPS_periodic_location()).
 *
 * Here's a sample output:
 * \verbatim
     66.228.70.195: 42.342500, -71.067700

     42.350950, -71.049709
     328 Congress St
     Boston, MA 02210
   \endverbatim
 *
 * \note  The sample application needs a direct connection to the internet
 *        in order for all functions to operate successfully.
 *
 * \if pocketpc
 *   \note  In order to build the sample application you must have
 *          enabled "Smart Device Programmability" option when installing
 *          Visual Studio 2005.
 * \endif
 * <hr>
 */

#endif // _WPSAPI_H_
