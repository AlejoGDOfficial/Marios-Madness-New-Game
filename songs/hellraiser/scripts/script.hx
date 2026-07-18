import funkin.visuals.shaders.FXShader;

final shader:FXShader = new FXShader('black');
shader.set({threshold: 0});

function postCreate()
    camGame.setShaders([shader]);