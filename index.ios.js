import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    Button,
    NativeEventEmitter,
    NativeModules,
    Linking,
    Image,
    Dimensions,
    TouchableOpacity
} from 'react-native'
import { IndicatorViewPager, PagerDotIndicator } from 'rn-viewpager'


const { height, width } = Dimensions.get('window')

const page = require('./assets/mapForecastVaavud.png')
const page1 = require('./assets/page1.jpg')
const page2 = require('./assets/kitesurf.jpg')


class MyApp extends Component {

    _renderDotIndicator = () => {
        return <PagerDotIndicator pageCount={3} />;
    }

    _open(link) {
        Linking.canOpenURL(link).then(
            Linking.openURL(link),
            //TODO handle reject
        ).catch((error) => {
            //TODO error handling
        })
    }

    render = () => {
        return (
            <View style={{ flex: 1 }}>
                <IndicatorViewPager
                    style={{ flex: 1 }}
                    indicator={this._renderDotIndicator()} >
                    <View style={{ justifyContent: 'center', alignItems: 'center', backgroundColor: '#00a1e1' }}>
                        <View style={{ width, height, position: 'absolute', top: 0, left: 0, backgroundColor: '#00000066' }} />
                        <Image source={page} resizeMode={'contain'} style={{ width, height: 300 }} />
                        <Text style={{ backgroundColor: 'transparent', color: 'white', fontSize: 18, fontWeight: 'bold', marginBottom: 20 }}> Vaavud Forecast </Text>
                        <Text style={{ backgroundColor: 'transparent', textAlign: 'center', color: 'white' }}> Vaavud launches world’s first autonomous, smartphone connected, ultrasonic wind meter </Text>

                        <TouchableOpacity
                            style={{ width: width - 40, height: 40, backgroundColor: 'white', justifyContent: 'center', alignItems: 'center', marginTop: 40 }}
                            onPress={() => this._open('https://vaavud.com/map')}>
                            <Text style={{ color: '#00a1e1', backgroundColor: 'transparent', fontSize: 16, fontWeight: 'bold' }}> Show me more </Text>
                        </TouchableOpacity>


                    </View>
                    <View style={{ justifyContent: 'center', alignItems: 'center', }}>
                        <Image source={page1} resizeMode={'cover'} style={{ width, height, position: 'absolute', top: 0, left: 0 }} />
                        <View style={{ width, height, position: 'absolute', top: 0, left: 0, backgroundColor: '#00000066' }} />

                        <Text style={{ textAlign: 'center', backgroundColor: 'transparent', color: 'white', fontSize: 18, fontWeight: 'bold', marginBottom: 20 }}> Now you can take measurements without logging in! </Text>
                        <Text style={{ textAlign: 'center', width: 150, color: 'white', backgroundColor: 'transparent' }}> if you wish to log in go to map or history </Text>

                    </View>
                    <View style={{ justifyContent: 'center', alignItems: 'center', }}>
                        <Image source={page2} resizeMode={'cover'} style={{ width, height, position: 'absolute', top: 0, left: 0 }} />
                        <View style={{ width, height, position: 'absolute', top: 0, left: 0, backgroundColor: '#00000066' }} />
                        <Text style={{ textAlign: 'center', backgroundColor: 'transparent', color: 'white', fontSize: 18, fontWeight: 'bold', marginBottom: 20 }}> Are you a kitesurfer? </Text>
                        <Text style={{ textAlign: 'center', width: 150, color: 'white', backgroundColor: 'transparent' }}> Checkout the kitesurf wind app by Vaavud </Text>


                        <TouchableOpacity
                            style={{ width: width - 40, height: 40, backgroundColor: 'white', justifyContent: 'center', alignItems: 'center', marginTop: 40 }}
                            onPress={() => this._open('https://itunes.apple.com/us/app/kitesurf-wind-forecast/id1103698916?mt=8')}>
                            <Text style={{ color: '#00a1e1', backgroundColor: 'transparent', fontSize: 16, fontWeight: 'bold' }}> Show me more </Text>
                        </TouchableOpacity>

                    </View>
                </IndicatorViewPager>

            </View>
        )
    }
}

// 4
AppRegistry.registerComponent('AddRatingApp', () => MyApp)
// AppRegistry.registerComponent('AddRatingApp', () => CodePush(MyApp));