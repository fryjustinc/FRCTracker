classdef Image
    %IMAGE holder class for an image
    % Holds an image in its RGB form, as well as extract L and S bands
    % Always converts images to double format from 0 to 1
    properties
        img
        L
        S
    end
    methods
        function this = Image(I)
            if isfloat(I)
                this.img = I;
            elseif isinteger(I)
                this.img = double(I) / 255;
            else
                error('InvalidInputError: Input image must be double or uint8');
            end
            R = this.img(:,:,1);
            G = this.img(:,:,2);
            B = this.img(:,:,3);
            this.L = R + G + B;
            this.S = R - B;
        end
    end
end