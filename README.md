Clarke
======

Clarke is a small OS X application which triangulates your location using [Skyhook's](http://www.skyhookwireless.com/) API, and uses that to update [Fire Eagle](http://fireeagle.yahoo.net/).

![Clarke screenshot](http://farm4.static.flickr.com/3552/3546261927_ba63dd4ffc_o.png)

The latest version of Clarke is always available from [tomtaylor.co.uk/projects/clarke](http://tomtaylor.co.uk/projects/clarke/).

Installation
------------

If you want to build your own version of Clarke, you need to know the following.

First, [Tom Taylor](http://tomtaylor.co.uk) has an agreement with Skyhook where he won't charge if they don't charge. Which is very nice of them.

Skyhook developer API keys can perform location updates without registration, for a small number of users. However because Clarke has been released to the wider world, it needs to perform individual user registration inside the application on first run. This will fail for you, because Skyhook restrict which API keys can register users.

To make it for development, get yourself an API key from Skyhook. Comment out the user registration process in LocationController.m. Create the file 'SkyhookApiKey.h' and set the following define statements:

    #define SKYHOOK_MASTER_USERNAME "username"
    #define SKYHOOK_MASTER_REALM "realm"
  
Note they are C strings, not NSString objects.

You should now be able to use your own Skyhook API keys without user registration occurring.

License
-------

Clarke is licensed under the BSD license.

    Copyright (c) 2009, Tom Taylor
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

        * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
        * Neither the name of Tom Taylor nor the names of Clarke's contributors may be used to endorse or promote products derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Some code is used under license from elsewhere:

* wpsapi.h & libwpsapi.dylib are used under license from Skyhook Wireless.
* RHSystemIdleTimer is licensed under LGPL from Ryan Homer.
* DSClickableURLTextField is from Night Productions.