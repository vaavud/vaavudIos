import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    Button,
    NativeEventEmitter,
    NativeModules
} from 'react-native'

const {ReactBridge} = NativeModules

// 2
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'green',
    },
    welcome: {
        fontSize: 20,
        color: 'white',
    },
});

// 3
class AddRatingApp extends Component {
    state = {
        swift: ''
    }

    componentDidMount = () => {
        const myModuleEvt = new NativeEventEmitter(ReactBridge)
        this._subscription = myModuleEvt.addListener('TestEvent',this.testEvent)
    }

    // componentWillUnmount = () => {
    //     this._subscription.remove()
    // }

    testEvent = (data) => {
        this.setState({swift:data.hello})
    }


    // <Button onPress={() => { ReactBridge.testEvent('Hi from React native') }} title='Say hello to Swift' />

    render = () => {
        return (
            <View style={styles.container}>
                <Text>Hello from the React Native! </Text>
                <Text>{this.props.content}</Text>
                <Text>Swift says...</Text>
                <Text>{this.state.swift}</Text>
                <Button onPress={() => { ReactBridge.show('Hi from React native',1) }} title='Say hello to Android' />
                
            </View>
        )
    }
}

// 4
AppRegistry.registerComponent('AddRatingApp', () => AddRatingApp)