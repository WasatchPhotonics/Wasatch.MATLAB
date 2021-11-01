% load the DLL
if computer('arch') == 'win64'
    dll = NET.addAssembly('C:\Program Files\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');
else
    dll = NET.addAssembly('C:\Program Files (x86)\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');
end

% get a handle to the Driver Singleton
driver = WasatchNET.Driver.getInstance();
fprintf('Using %s from MATLAB %s\n', driver.version, version);

% configure logging
driver.logger.setPathname('C:\temp\matlab.log');
driver.logger.level = WasatchNET.LogLevel.DEBUG;

% enumerate any connected spectrometers
numberOfSpectrometers = driver.openAllSpectrometers();
fprintf('%d spectrometers found.\n', numberOfSpectrometers);
if numberOfSpectrometers <= 0
	return
end

% open the first spectrometer found
spectrometer = driver.getSpectrometer(0);

% grab some key properties
pixels      = int32(spectrometer.pixels);
wavelengths = spectrometer.wavelengths;

% display summary
fprintf('Found %s %s with %d pixels (%.2f, %.2fnm)\n', ...
    char(spectrometer.model), char(spectrometer.serialNumber), pixels, wavelengths(1), wavelengths(wavelengths.Length));
fprintf('Spectrometer has FW %s and FPGA %s\n', spectrometer.firmwareRevision, spectrometer.fpgaRevision);

% configure 2D ROI
spectrometer.integrationTimeMS = 100;
spectrometer.detectorGain = 30;
spectrometer.fastAreaScan = false;
spectrometer.detectorStartLine = 100;
spectrometer.detectorStopLine = 1001;
spectrometer.areaScanEnabled = true;

lines = spectrometer.detectorStopLine - spectrometer.detectorStartLine - 1;
image = zeros(lines, pixels);
pause('on');
for line = spectrometer.detectorStartLine:(spectrometer.detectorStopLine - 1)
    spectrum = int32(spectrometer.getSpectrum());
    if length(spectrum) == 0
        fprintf('read zero pixels on line %d of (%d, %d)\n', ...
            line, spectrometer.detectorStartLine, spectrometer.detectorStopLine);
        break;
    end

    index = spectrum(1) + 1;
    spectrum(1) = spectrum(2);
    if mod(line, 10) == 0
        fprintf('read line %d (received index %d)\n', line, index);
    end
    
    image(index, :) = spectrum;
end

% display the area scan image
figure;
imshow(mat2gray(image));

% close the driver
driver.closeAllSpectrometers()