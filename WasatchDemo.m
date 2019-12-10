% load the DLL
if computer('arch') == 'win64'
    dll = NET.addAssembly('C:\Program Files\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');
else
    dll = NET.addAssembly('C:\Program Files (x86)\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');
end

% get a handle to the Driver Singleton
driver = WasatchNET.Driver.getInstance();
fprintf('Using %s from MATLAB %s\n', driver.version, version);

% enumerate any connected spectrometers
numberOfSpectrometers = driver.openAllSpectrometers();
fprintf('%d spectrometers found.\n', numberOfSpectrometers);
if numberOfSpectrometers <= 0
	return
end

% open the first spectrometer found
spectrometer = driver.getSpectrometer(0);

% access some key properties
pixels      = spectrometer.pixels;
modelName   = char(spectrometer.model);
serialNum   = char(spectrometer.serialNumber);
wavelengths = spectrometer.wavelengths;

% display summary
fprintf('Found %s %s with %d pixels (%.2f, %.2fnm)\n', modelName, serialNum, pixels, wavelengths(1), wavelengths(wavelengths.Length));

% get a spectrum
spectrometer.integrationTimeMS = 100;
spectrum = spectrometer.getSpectrum();

% graph the spectrum
plot(wavelengths, spectrum);

% close the driver (should shutdown laser, etc cleanly)
driver.closeAllSpectrometers()
