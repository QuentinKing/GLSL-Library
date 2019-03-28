This project is an implementation of Gouraud shading using the Phong reflection model.

Gouraud shading works by computing the lighting calculations on each vertice of a mesh during the vertex shader stage (vertex.glsl). In the fragment shader stage, the pixel onscreen calculates it's corresponding color by linerally interpolating the vertex color of it's triangle through barycentric coordinates. This method is generally faster when a mesh has less vertices than pixels it occupies on screen, however you get pretty gross specular highlights.
