import bpy
import packaging

class ObjectMoveX(bpy.types.Operator):
    """My Object Moving Script"""
    bl_idname = "object.move_x"
    bl_label = "Move X by a few steps"
    bl_options = {'REGISTER', 'UNDO'}

    total: bpy.props.IntProperty(name="Steps", default=1, min=1, max=10)

    def execute(self, context):
        scene = context.scene
        for obj in scene.objects:
            obj.location.x += self.total

        return {'FINISHED'}

def menu_func(self, context):
    self.layout.operator(ObjectMoveX.bl_idname)

def register():
    print(packaging.__file__)
    bpy.utils.register_class(ObjectMoveX)
    bpy.types.VIEW3D_MT_object.append(menu_func)

def unregister():
    bpy.utils.unregister_class(ObjectMoveX)
