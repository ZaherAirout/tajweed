package Tajweed;

import com.mathworks.engine.EngineException;
import com.mathworks.engine.MatlabEngine;


/**
 * Created by ITE ANJD on 7/2/2017.
 */

public class TrainingController {

    private MatlabEngine matlabEngine;

    private String paths[] = {
            "addpath('E:\\Project2\\The Project');",
            "addpath 'E:\\Project2\\The Project\\Output';",
            "addpath 'E:\\Project2\\The Project\\Segmentation';",
            "cd E:\\Project2\\The Project"
    };

    public TrainingController() throws Exception {
        this.matlabEngine = MatlabEngine.startMatlab();

        for (String path : paths)
            matlabEngine.eval(path);
    }

    public void Execute() throws Exception {

        matlabEngine.eval("tc = TajweedController();");
        matlabEngine.eval("tc.SetOriginal('4-1.wav');");

    }

    public void Close() throws EngineException {
        matlabEngine.close();
    }

}
