import funkin.visuals.shaders.FXShader;

public var shader:FXShader = new FXShader('bloom');
shader.set({r: 1, g: 1, b: 1, bloom: 1});

function postCamerasInit()
    camGame.setShaders([shader]);

import funkin.visuals.shaders.FXShader;

public var shader:FXShader = new FXShader('grayscale');
shader.set({r: 1, g: 1, b: 1, bloom: 1});

function postCamerasInit()
    camGame.setShaders([shader]);