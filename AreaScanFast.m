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
pixels      = int32(spectrometer.pixels);
wavelengths = spectrometer.wavelengths;
lines       = int32(spectrometer.eeprom.activePixelsVert);

% display summary
fprintf('Found %s %s with %d pixels (%.2f, %.2fnm)\n', ...
    char(spectrometer.model), char(spectrometer.serialNumber), pixels, wavelengths(1), wavelengths(wavelengths.Length));
fprintf('Spectrometer has FW %s and FPGA %s\n', spectrometer.firmwareRevision, spectrometer.fpgaRevision);

% load an area scan in "fast mode"
spectrometer.integrationTimeMS = 100;
spectrometer.fastAreaScan = true;
spectrometer.areaScanEnabled = true;
area_scan_data = int32(spectrometer.getSpectrum());
if isempty(area_scan_data)
    fprintf('area_scan_data is empty\n');
    return;
end

% deserialize area scan data into 2D image data
image = zeros(lines, pixels);
for line = 1:lines
    startPx = (line - 1) * pixels + 1;
    endPx = startPx + pixels - 1;
    spectrum = area_scan_data(startPx:endPx);
    index = spectrum(1) + 1;
    spectrum(1) = spectrum(2);
    image(index, :) = spectrum;
end

% display the area scan image
figure;
imshow(mat2gray(image));

% close the driver
driver.closeAllSpectrometers()