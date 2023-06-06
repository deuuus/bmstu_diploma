function main()

    import my_blind_deconvolution.*

    fig = uifigure("Position", [450 300 750 525]);

    original_img = double(ones(1, 1, 3));
    original_axes = axes('Parent', fig, 'Position', [0.07 0.27 0.4 0.8]);
    imshow(original_img, 'Parent', original_axes);

    focused_img = double(ones(1, 1, 3));%imread('lena_r7.bmp');
    focused_axes = axes('Parent', fig, 'Position', [0.53 0.27 0.4 0.8]);
    imshow(focused_img, 'Parent', focused_axes);
    
    load_btn = uibutton(fig, ...
                      "text", "Загрузить изображение", ...
                      "Position",[50 125 300 50], ...
                      "ButtonPushedFcn", @(src,event)load_file());
    
    save_btn = uibutton(fig, "push", ...
                      "text", "Сохранить изображение", ...
                      "Position",[400 50 300 50], ...
                      "ButtonPushedFcn", @(src,event)save_file());

    focus_btn = uibutton(fig, "push", ...
                      "text", "Восстановить изображение", ...
                      "Position",[400 125 300 50], ...
                      "ButtonPushedFcn", @(src,event)focus());
    
    exit_btn = uibutton(fig, "push", ...
                      "text", "Выйти", ...
                      "Position",[50 50 300 50], ...
                      "ButtonPushedFcn", @(src,event)exit());

    function load_file()
         [file, path] = uigetfile({'*.jpg;*.png;', 'Изображения (*.jpg, *.png)'},...
                          'Select file');
         filepath = fullfile(path, file);

         if filepath
            original_img = imread(filepath);
            imshow(original_img, 'Parent', original_axes);
         end
    end

    function save_file()
         [file,path] = uiputfile('result.png','Save File');
         filepath = fullfile(path, file);
         imwrite(focused_img, filepath);
    end

    function focus()
        if original_img == double(ones(1, 1, 3))
            msg = msgbox('Для выполнения операции восстановления необходимо загрузить исходное изображение.', 'Сообщение');
        else
            msg = msgbox('Изображение обрабатывается...Обработка может занят несколько секунд, пожалуйста, подождите.', 'Сообщение');
            focused_img = my_blind_deconvolution(original_img);
            close(msg);
            imshow(focused_img, 'Parent', focused_axes);
        end
    end

    function exit()
        close(fig)
    end
end