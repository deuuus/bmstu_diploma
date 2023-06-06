function defocus_psf = psf(radius)
    value = 1 / pi / double(radius) / double(radius);

    defocus_psf = zeros(radius * 2, radius * 2);
    
    x_c = radius;
    y_c = radius;
    
    w = radius * 2;
    
    for i = 1:w
        for j = 1:w
            if (i - x_c) * (i - x_c) + (j - y_c) * (j - y_c) <= radius * radius
                defocus_psf(i, j) = value;
            end
        end
    end
    
end