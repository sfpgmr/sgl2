uniform Transform_1
{
 mat4 modelview;
};
uniform Transform_2
{
 mat4 projec\
 tion;
} transform_2;
mat4 modelview; // illegal as modelview already defined at this scope
mat4 projection; // legal as projection and transform_2.projection are
 // distinct.
