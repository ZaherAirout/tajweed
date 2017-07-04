package Tajweed;

import com.mathworks.engine.EngineException;
import com.mathworks.engine.MatlabEngine;


/**
 * Created by ITE ANJD on 7/2/2017.
 */

public class TajweedController {

    private MatlabEngine matlabEngine;

    private String directory = System.getProperty("user.dir") + "\\src\\Tajweed";


    private String paths[] = {
            "addpath('" + directory + "');",
            "addpath '" + directory + "\\Output';",
            "addpath '" + directory + "\\Segmentation';",
            "cd ('" + directory + "')"
    };

    public TajweedController() throws Exception {
        this.matlabEngine = MatlabEngine.startMatlab();

        for (String path : paths)
            matlabEngine.eval(path);
    }

    public void Execute() throws Exception {

        System.out.println(directory);
        matlabEngine.eval("tc = TajweedController();");
        matlabEngine.eval("tc.SetOriginal('4-1.wav');");

    }

    public void Close() throws EngineException {
        matlabEngine.close();
    }

}
