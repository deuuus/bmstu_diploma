function focused_img = my_blind_deconvolution(original_img)
    import cepstrum.*
    import radius.*
    import psf.*

    function img = do_gray()
        img_cepstrum = cepstrum(original_img);
        focus_radius = radius(img_cepstrum);
        focus_psf = psf(focus_radius);
        med_img = deconvlucy(original_img, focus_psf, 100);

        if focus_radius - 1 > 0
            focus_radius = focus_radius - 1;
            focus_psf = psf(focus_radius);
        end
        sub_img = deconvlucy(original_img, focus_psf, 100);

        focus_radius = focus_radius + 2;
        focus_psf = psf(focus_radius);
        add_img = deconvlucy(original_img, focus_psf, 100);

        psnr_value_med = psnr(med_img, original_img);
        psnr_value_sub = psnr(sub_img, original_img);
        psnr_value_add = psnr(add_img, original_img);
    
        [max_v, max_index] = max([psnr_value_med psnr_value_sub psnr_value_add]);

        
        if max_index == 1
            img = med_img;
        elseif max_index == 2
            img = sub_img;
        else
            img = add_img;
        end
    end

    function channel_radius = get_radius(channel)
        channel_cepstrum = cepstrum(channel);
        channel_radius = radius(channel_cepstrum);
    end

    function focused_channel = apply_psf(channel, radius)
        chanel_focus_psf = psf(radius);
        focused_channel = deconvlucy(channel, chanel_focus_psf, 100);
    end

    function img = deconvolve_with_radiuses(red_channel_radius, green_channel_radius, blue_channel_radius)
        red_channel_focused = apply_psf(red_channel, red_channel_radius);
        green_channel_focused = apply_psf(green_channel, green_channel_radius);
        blue_channel_focused = apply_psf(blue_channel, blue_channel_radius);
        img = cat(3, red_channel_focused, green_channel_focused, blue_channel_focused);
    end

    function update_radiuses_neg()
        if (red_channel_radius - 1) ~= 0
            red_channel_radius = red_channel_radius - 1;
        end
        if (green_channel_radius - 1) ~= 0
            green_channel_radius = green_channel_radius - 1;
        end
        if (blue_channel_radius - 1) ~= 0
            blue_channel_radius = blue_channel_radius - 1;
        end
    end

    function update_radiuses_pos()
        red_channel_radius = red_channel_radius + 2;
        green_channel_radius = green_channel_radius + 2;
        blue_channel_radius = blue_channel_radius + 2;
    end
    
    if length(size(original_img)) == 2
        focused_img = do_gray();
    else
        red_channel = original_img(:, :, 1);
        green_channel = original_img(:, :, 2);
        blue_channel = original_img(:, :, 3);
        
        red_channel_radius = get_radius(red_channel);
        green_channel_radius = get_radius(green_channel);
        blue_channel_radius = get_radius(blue_channel);
        
        med_rgb_img = deconvolve_with_radiuses(red_channel_radius, green_channel_radius, blue_channel_radius);
        
        update_radiuses_neg();
        sub_rgb_img = deconvolve_with_radiuses(red_channel_radius, green_channel_radius, blue_channel_radius);
        
        update_radiuses_pos();
        add_rgb_img = deconvolve_with_radiuses(red_channel_radius, green_channel_radius, blue_channel_radius);
        
        rgb_psnr_value_med = psnr(med_rgb_img, original_img);
        rgb_psnr_value_sub = psnr(sub_rgb_img, original_img);
        rgb_psnr_value_add = psnr(add_rgb_img, original_img);
        
        [~, max_index] = max([rgb_psnr_value_med rgb_psnr_value_sub rgb_psnr_value_add]);

        if max_index == 1
            focused_img = med_rgb_img;
        elseif max_index == 2
            focused_img = sub_rgb_img;
        else
            focused_img = add_rgb_img;
        end
    end
end