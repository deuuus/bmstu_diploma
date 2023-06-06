function img_cepstrum = cepstrum(img)
    spectrum = fftshift(fft2(img));
    img_cepstrum = log(1+abs(spectrum .* spectrum));
end