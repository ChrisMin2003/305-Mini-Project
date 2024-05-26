from PIL import Image

def reduce_color_depth(color, bits):
    """Reduces the color depth to the specified number of bits."""
    return color >> (8 - bits)

def image_to_mif(image_path, mif_path, width, height):
    image = Image.open(image_path).convert('RGB')
    image = image.resize((width, height))
    
    with open(mif_path, 'w') as mif_file:
        # Write MIF file header
        mif_file.write("WIDTH=12;\n")
        mif_file.write(f"DEPTH={width * height};\n")
        mif_file.write("ADDRESS_RADIX=HEX;\n")
        mif_file.write("DATA_RADIX=HEX;\n")
        mif_file.write("CONTENT BEGIN\n")
        
        # Iterate over pixels and write the RGB values to the MIF file
        pixel_num = 0
        for y in range(height):
            for x in range(width):
                r, g, b = image.getpixel((x, y))
                r = reduce_color_depth(r, 4)
                g = reduce_color_depth(g, 4)
                b = reduce_color_depth(b, 4)
                rgb_value = (r << 8) | (g << 4) | b
                mif_file.write(f"    {pixel_num:04X} : {rgb_value:03X};\n")
                pixel_num += 1
        
        mif_file.write("END;\n")

# Example usage
image_path = 'pixil-frame-0.png'
mif_path = 'output.mif'
width, height = 16, 16  # Desired dimensions
image_to_mif(image_path, mif_path, width, height)
