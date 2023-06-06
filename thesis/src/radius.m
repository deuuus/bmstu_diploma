function defocus_radius = radius(cepstrum)
    
    max_intensity = double(max(cepstrum(:)));
    cepstrum = max_intensity - double(cepstrum);
    cepstrum = medfilt2(cepstrum, [3 3]);

    x_c = idivide(int32(size(cepstrum, 1)), 2) + mod(size(cepstrum, 1), 2) + 1;
    central_row = cepstrum(x_c, :);

    half_central_row = central_row(1:size(central_row, 2) / 2);
    half_central_row = flip(half_central_row);
    
    [peaks, peaks_locations] = findpeaks(half_central_row);
    [~, new_peak_locations] = findpeaks(peaks, 'NPeaks', 1);

    defocus_radius = round(x_c / peaks_locations(new_peak_locations));
end