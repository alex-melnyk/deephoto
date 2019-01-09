import {NativeModules} from 'react-native';

const {RNARViewManager} = NativeModules;

/**
 * Proxy class for NativeARViewManager.
 */
class ARViewManager {
    /**
     * Adding image:video mapping to AR View Manager.
     *
     * @param {String} picturePath path of image file.
     * @param {String} videoPath path of video file.
     */
    static addARMapping(picturePath, videoPath) {
        RNARViewManager.addARMapping(picturePath, videoPath);
    }
}

export {ARViewManager};