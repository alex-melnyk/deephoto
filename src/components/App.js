import React, {Component} from 'react';
import {NativeModules, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import ImagePicker from 'react-native-image-picker';

const {ARViewManager} = NativeModules;

class App extends Component {
    actionPressed = () => {
        ImagePicker.showImagePicker({
            title: 'Take a photo of the target',
            mediaType: 'photo',
            noData: true,
            takePhotoButtonTitle: 'Take photo...',
            storageOptions: {
                skipBackup: true,
                waitUntilSaved: true
            }
        }, (imageResponse) => {
            if (!imageResponse.didCancel && !imageResponse.error) {
                const imagePath = imageResponse.uri.replace('file://', '');

                ImagePicker.showImagePicker({
                    title: 'Take a video for the target',
                    mediaType: 'video',
                    takePhotoButtonTitle: 'Take video...',
                    noData: true,
                    storageOptions: {
                        skipBackup: true,
                        waitUntilSaved: true
                    }
                }, (videoResponse) => {
                    if (!videoResponse.didCancel && !videoResponse.error) {
                        const videoPath = videoResponse.uri.replace('file://', '');
                        ARViewManager.setARMapping(imagePath, videoPath);
                    }
                });
            }
        });
    };

    render() {
        return (
            <View style={styles.container}>
                <TouchableOpacity onPress={this.actionPressed}>
                    <Text style={styles.instructions}>
                        Press this text to map target picture and video.
                    </Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    instructions: {
        textAlign: 'center',
        color: '#FFFFFF',
        marginBottom: 5
    },
});

export {App};