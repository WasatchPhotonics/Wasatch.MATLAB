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
spectrometer.integrationTimeMS = 100;

% access some key properties
pixels      = spectrometer.pixels;
modelName   = char(spectrometer.model);
serialNum   = char(spectrometer.serialNumber);
wavenumbers = spectrometer.wavenumbers;

% display summary
fprintf('Found %s %s with %d pixels (%.2f, %.2fcm⁻¹)\n', modelName, serialNum, pixels, wavenumbers(1), wavenumbers(pixels));

disp("Press any key to fire the laser");
pause;

spectrometer.laserEnabled = true;

while true
    spectrum = spectrometer.getSpectrum();
    plot(wavenumbers, spectrum);
    response = input("Continue? (y/n)", "s");
    if contains(response, "n", IgnoreCase=true)
        break;
    end
    
end

spectrometer.laserEnabled = false;
driver.closeAllSpectrometers()
