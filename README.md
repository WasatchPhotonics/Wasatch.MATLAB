![sample view](https://github.com/WasatchPhotonics/Wasatch.MATLAB/raw/master/screenshots/sample.png "Sample IDE")

# Overview

MATLAB demos and solutions using Wasatch Photonics spectrometers.

# Application Notes

MATLAB has the interesting behavior that, after instantiating a 
WasatchNET.Spectrometer (or any .NET object, presumably), as soon as the CPU has 
some idle time (the user is not immediately running new commands, or ends the 
instantiation without a semicolon), the IDE appears to automatically traverse 
every Property "get" accessor in the order they are declared in the .NET Assembly 
(e.g., WasatchNET/Spectrometer.cs).  

You can see these Property gettor calls in the Wasatch.NET debug log.  They are 
mostly in alphabetical order, but a few unordered calls support the notion that 
they are called in source code declaration order.

# Dependencies

The MATLAB demo requires a current release of Wasatch.NET (2.1.4 or later), 
provided separately:

- https://github.com/WasatchPhotonics/Wasatch.NET

# Common Errors

## "Attempting to load FTD2XX.DLL from: C:\Program Files\Wasatch Photonics\Wasatch.NET"

The Wasatch.NET driver includes FTDI drivers for SPI-only "embedded" 
spectrometers.  WasatchNET.Driver.openAllSpectometers _should_ internally perform 
an encapsulated, temporary and non-invasive directory change when loading FTDI 
drivers to test for the presence of an Adafruit SPI-to-USB adapter.

However, if you see this error message in a pop-up dialog, you may need to 
manually 'cd' to C:\Program Files\Wasatch Photonics\Wasatch.NET or equivalent so 
that FTD2XX.dll and related files can be found.  (You're free to 'cd' back to 
wherever you want after openAllSpectrometers() completes.)

# History

- 2021-11-05
    - updated AreaScanSlow image line indexing
- 2021-11-01
    - added AreaScanSlow (SiG), tested with Wasatch.NET 2.3.37 and MATLAB 2021b
- 2021-11-01
    - added AreaScanFast (Hamamatsu), tested with Wasatch.NET 2.3.36 and MATLAB 2021b
- 2019-12-10
    - updated .m script
- 2019-12-09
    - resolved secondaryADC issues (Wasatch.NET 2.1.4)
- 2019-12-06
    - updated for Wasatch.NET 2.1.3 after testing with MATLAB 2019b Update 2 (64-bit)

![area scan](https://github.com/WasatchPhotonics/Wasatch.MATLAB/raw/master/screenshots/AreaScanFast.png "Area Scan Fast")
