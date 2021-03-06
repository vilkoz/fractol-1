
__kernel void       computing_set(__global int *A, __constant double *meta_data)
{
    // Maximal depth
    int    MaxIterations = meta_data[0];

    // Imaginary and real dimensions
    double MinRe = meta_data[1];
    double MaxRe = meta_data[2];
    double MinIm = meta_data[3];
    double MaxIm = meta_data[4];

    // Pre-calculated range
    double Re_factor = meta_data[5];
    double Im_factor = meta_data[6];

    // Color
    int    base_color = meta_data[7];

    // Julias constant
    int    x_shift = meta_data[8];
    int    y_shift = meta_data[9];

    // Window dimensions
    uint x = get_global_id(0) % 1280;
    uint y = get_global_id(0) / 1280;

    double2  vec_c;
    double2  vec_Z;

    vec_Z.x = cos(x * Re_factor + MinRe);
    vec_Z.y = sin(y * Im_factor + MinIm);
    
    vec_c.x = x_shift;
    vec_c.y = y_shift;

    char     is_inside = 0;
    double2  vec_Z_2;

    int iter;
    for (iter = 0; iter < MaxIterations; ++iter)
    {
        vec_Z_2 = vec_Z * vec_Z;
        if ((vec_Z_2.x + vec_Z_2.y) > 4)
        {
            is_inside = 1;
            break ;
        }
        vec_Z.y = 2 * vec_Z.x * vec_Z.y + vec_c.y;
        vec_Z.x = vec_Z_2.x - vec_Z_2.y + vec_c.x;
    }
    if (is_inside == 0) {

        A [get_global_id(0)] = 0x82f2f2;
    }
    else {
        
        A [get_global_id(0)] = (iter * base_color) & 0x00ffffff;
    }
}